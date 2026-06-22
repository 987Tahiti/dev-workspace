<#
Bootstrap du workspace de développement dans C:\Dev.
Usage:
  .\setup.ps1
  .\setup.ps1 -InstallTools
#>
param(
    [switch]$InstallTools
)

$root = "C:\Dev"
$folders = @(
    "projects\Android",
    "projects\Web",
    "projects\Windows",
    "agents",
    "brain"
)

foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory | Out-Null
    }
}

$log = Join-Path $root "setup.log"
function Write-Log {
    param($message)
    $line = "[$(Get-Date -Format o)] $message"
    $line | Tee-Object -FilePath $log -Append | Out-Null
}

Write-Log "Démarrage du bootstrap du workspace Dev"
Write-Log "Création des dossiers de base terminée"

$tools = @(
    @{ Name = 'git'; Command = 'git'; Installed = (Get-Command git -ErrorAction SilentlyContinue) -ne $null },
    @{ Name = 'GitHub CLI'; Command = 'gh'; Installed = (Get-Command gh -ErrorAction SilentlyContinue) -ne $null; PackageId = 'GitHub.cli' },
    @{ Name = 'VS Code'; Command = 'code'; Installed = (Get-Command code -ErrorAction SilentlyContinue) -ne $null; PackageId = 'Microsoft.VisualStudioCode' },
    @{ Name = 'Android Studio'; Command = 'studio64.exe'; Installed = (Get-Command studio64.exe -ErrorAction SilentlyContinue) -ne $null; PackageId = 'Google.AndroidStudio' },
    @{ Name = '.NET SDK'; Command = 'dotnet'; Installed = (Get-Command dotnet -ErrorAction SilentlyContinue) -ne $null },
    @{ Name = 'Node.js'; Command = 'node'; Installed = (Get-Command node -ErrorAction SilentlyContinue) -ne $null }
)

foreach ($tool in $tools) {
    Write-Log "Vérification: $($tool.Name) installé=$($tool.Installed)"
}

$winget = Get-Command winget -ErrorAction SilentlyContinue
if ($InstallTools) {
    if (-not $winget) {
        Write-Log "Winget introuvable. Impossible d'installer automatiquement les outils."
        Write-Host "Winget n'est pas disponible. Installez Winget ou utilisez manuellement le script setup.ps1." -ForegroundColor Yellow
    }
    else {
        foreach ($tool in $tools | Where-Object { $_.PackageId -and (-not $_.Installed) }) {
            Write-Log "Installation de $($tool.Name) via winget"
            try {
                winget install --id $tool.PackageId --silent --accept-source-agreements --accept-package-agreements | Out-String | ForEach-Object { Write-Log $_ }
                Write-Log "Installation terminée pour $($tool.Name)"
            }
            catch {
                Write-Log "Erreur lors de l'installation de $($tool.Name): $_"
            }
        }
    }
}

Write-Log "Bootstrap terminé"
$noteFile = Join-Path $root "brain\instructions.txt"
"Exécutez `.\setup.ps1 -InstallTools` pour installer GitHub CLI, VS Code et Android Studio si nécessaire." | Set-Content -Path $noteFile -Encoding UTF8
Write-Log "Fichier d'instructions créé : $noteFile"
Write-Host "Workspace Dev prêt. Voir C:\Dev\README.md pour les instructions d'utilisation." -ForegroundColor Green
