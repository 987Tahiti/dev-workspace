# Workspace Dev

Ce workspace est destiné à stocker les projets et outils pour :
- Application Android
- Application Web
- Application Windows
- Agents IA et scripts de coordination

## Structure

- `projects/Android` - code et projets Android
- `projects/Web` - projets web frontend et backend
- `projects/Windows` - applications Windows et dotnet
- `agents` - configuration des agents et scripts d'intégration
- `brain` - instructions, notes et suivi intelligence artificielle

## Installation

Ouvrir PowerShell en administrateur et exécuter :

```powershell
cd C:\Dev
.\setup.ps1 -InstallTools
```

Si `winget` n'est pas disponible, installez-le depuis le Microsoft Store ou manuellement.

## Scripts utiles

- `C:\Dev\setup.ps1` - crée la structure des dossiers et peut installer les outils si winget est disponible.
- `C:\Dev\agents\ai-monitor.ps1` - script de suivi des sessions IA

## Notes IA

- Vérifier la limite de session/token de chaque IA
- Automatiser la bascule vers un autre modèle si une session arrive à expiration
- Relancer le travail dès que la session redevient disponible
