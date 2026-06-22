<#
Script de surveillance simple des limites de session/token pour plusieurs IA.
Il utilise un fichier JSON local pour stocker l'état. En production, adaptez-le à vos API.
#>

$stateFile = "C:\Dev\agents\ai-state.json"
$ias = @(
    @{ name = 'OpenAI'; enabled = $true; maxTokens = 16000; usedTokens = 0; sessionLimit = 1000; usedSessions = 0; status = 'ready' },
    @{ name = 'Claude'; enabled = $true; maxTokens = 32000; usedTokens = 0; sessionLimit = 500; usedSessions = 0; status = 'ready' },
    @{ name = 'Gemini'; enabled = $true; maxTokens = 25600; usedTokens = 0; sessionLimit = 500; usedSessions = 0; status = 'ready' },
    @{ name = 'Blackbox'; enabled = $true; maxTokens = 20000; usedTokens = 0; sessionLimit = 1000; usedSessions = 0; status = 'ready' }
)

function Load-State {
    if (Test-Path $stateFile) {
        try {
            return Get-Content $stateFile -Raw | ConvertFrom-Json
        }
        catch {
            return $null
        }
    }
    return $null
}

function Save-State($state) {
    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $stateFile -Encoding UTF8
}

function Get-AvailableAI {
    param($state)
    $state.ias | Where-Object { $_.enabled -and $_.status -eq 'ready' -and $_.usedSessions -lt $_.sessionLimit }
}

function RotateAI {
    param($state)
    $ready = Get-AvailableAI -state $state
    if ($ready.Count -gt 0) {
        return $ready[0]
    }
    return $null
}

$state = Load-State
if (-not $state) {
    $state = @{ ias = $ias; lastChecked = (Get-Date).ToString('o') }
    Save-State $state
}

Write-Host "État IA chargé depuis $stateFile"

$activeAI = RotateAI -state $state
if (-not $activeAI) {
    Write-Host "Aucune IA disponible actuellement. Réessayez plus tard." -ForegroundColor Yellow
    return
}

Write-Host "IA active: $($activeAI.name)"

# Exemple de simulation d'utilisation
$activeAI.usedTokens += 100
$activeAI.usedSessions += 1
if ($activeAI.usedTokens -ge $activeAI.maxTokens -or $activeAI.usedSessions -ge $activeAI.sessionLimit) {
    $activeAI.status = 'paused'
    Write-Host "Limite atteinte pour $($activeAI.name) ; passage en pause." -ForegroundColor Yellow
}

$state.lastChecked = (Get-Date).ToString('o')
Save-State $state
Write-Host "État mis à jour."