<#
Agent orchestration et sélection pour IA multiple.
Utilisation exemple :
  .\ai-manager.ps1 -TaskRole "Code Synthesizer" -Tokens 120 -Sessions 1
  .\ai-manager.ps1 -ListAgents
  .\ai-manager.ps1 -Reset
#>

param(
    [string]$TaskRole,
    [int]$Tokens = 100,
    [int]$Sessions = 1,
    [switch]$ListAgents,
    [switch]$Reset,
    [string]$PreferredAI
)

$stateFile = "C:\Dev\agents\ai-state.json"
$registryFile = "C:\Dev\agents\agents.json"

function Load-Json {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        return $null
    }
    Get-Content $Path -Raw | ConvertFrom-Json
}

function Save-Json {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)]$Path
    )
    $Object | ConvertTo-Json -Depth 10 | Set-Content -Path $Path -Encoding UTF8
}

function Get-ReadyIAs {
    param($State)
    $State.ias | Where-Object { $_.enabled -and $_.status -eq 'ready' -and $_.usedSessions -lt $_.sessionLimit }
}

function Filter-AgentsByAI {
    param(
        $Agents,
        [string]$AiName
    )
    $Agents | Where-Object { $_.active -and $_.ai -ieq $AiName }
}

function Find-AgentByRole {
    param(
        $Agents,
        [string]$Role
    )
    $Agents | Where-Object { $_.active -and $_.role -ieq $Role }
}

function Choose-ActiveAI {
    param(
        $State,
        $Agents
    )

    $ready = Get-ReadyIAs $State
    if ($PreferredAI) {
        $preferred = $ready | Where-Object { $_.name -ieq $PreferredAI }
        if ($preferred) { return $preferred }
    }

    if ($TaskRole) {
        $candidateAgents = Find-AgentByRole $Agents $TaskRole
        if ($candidateAgents.Count -gt 0) {
            $candidate = $candidateAgents | Select-Object -First 1
            $match = $ready | Where-Object { $_.name -ieq $candidate.ai }
            if ($match) { return $match }
        }
    }

    if ($ready.Count -gt 0) { return $ready[0] }
    return $null
}

function Use-AI {
    param(
        $State,
        [string]$AiName,
        [int]$Tokens,
        [int]$Sessions
    )

    $ai = $State.ias | Where-Object { $_.name -ieq $AiName }
    if (-not $ai) { throw "IA introuvable: $AiName" }

    $ai.usedTokens += $Tokens
    $ai.usedSessions += $Sessions
    if ($ai.usedTokens -ge $ai.maxTokens -or $ai.usedSessions -ge $ai.sessionLimit) {
        $ai.status = 'paused'
        Write-Host "IA $AiName a atteint une limite et est mise en pause." -ForegroundColor Yellow
    }

    return $ai
}

function Reset-State {
    param($State)
    foreach ($ai in $State.ias) {
        $ai.usedTokens = 0
        $ai.usedSessions = 0
        $ai.status = 'ready'
    }
    $State.lastChecked = (Get-Date).ToString('o')
    Save-Json $State $stateFile
    Write-Host 'Réinitialisation complète de l’état IA.' -ForegroundColor Green
}

function Show-Agents {
    param($Agents)
    $Agents | Sort-Object ai, role | ForEach-Object {
        [PSCustomObject]@{
            AI = $_.ai
            Name = $_.name
            Role = $_.role
            Active = $_.active
            PreferredModel = $_.preferredModel
            Tags = ($_.tags -join ', ')
        }
    } | Format-Table -AutoSize
}

$state = Load-Json $stateFile
$agents = Load-Json $registryFile

if (-not $state) {
    Write-Host "Le fichier d'état IA est manquant ou invalide : $stateFile" -ForegroundColor Red
    return
}

if (-not $agents) {
    Write-Host "Le registre d'agents est manquant ou invalide : $registryFile" -ForegroundColor Red
    return
}

if ($Reset) {
    Reset-State $state
    return
}

if ($ListAgents) {
    Show-Agents $agents
    return
}

$activeAI = Choose-ActiveAI $state $agents
if (-not $activeAI) {
    Write-Host 'Aucune IA prête n’est disponible pour le moment.' -ForegroundColor Yellow
    return
}

Write-Host "IA active sélectionnée : $($activeAI.name)"
Write-Host "Agents actifs pour cette IA :"
Filter-AgentsByAI $agents $activeAI.name | Show-Agents

if ($TaskRole) {
    $agent = Find-AgentByRole $agents $TaskRole
    if ($agent) {
        Write-Host "Agent choisi par rôle : $($agent.name) ($($agent.role))"
    }
    else {
        Write-Host "Aucun agent correspondant au rôle '$TaskRole' n’a été trouvé." -ForegroundColor Yellow
    }
}

$updatedAI = Use-AI $state $activeAI.name $Tokens $Sessions
$state.lastChecked = (Get-Date).ToString('o')
Save-Json $state $stateFile
Write-Host "État IA mis à jour. IA active = $($updatedAI.name), Tokens utilisés = $($updatedAI.usedTokens), Sessions utilisées = $($updatedAI.usedSessions)"
