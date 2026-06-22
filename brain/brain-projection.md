# Projection du cerveau

## Vision générale

Le cerveau central se trouve dans `C:\Dev`. Il coordonne trois axes principaux :
- Application Android
- Application Web
- Application Windows

Il gère également des agents IA indépendants et un mécanisme de rotation en cas de limite de session/token.

## Structure du workspace

- `C:\Dev\projects\Android` : code mobile Android
- `C:\Dev\projects\Web` : code web frontend/backend
- `C:\Dev\projects\Windows` : applications Windows (.NET, WinUI, WPF, etc.)
- `C:\Dev\agents` : scripts d’agents IA, surveillance des limites, orchestration
- `C:\Dev\brain` : notes, stratégie, projection et suivi

## Etat actuel

- Dossiers créés
- Git initialisé dans `C:\Dev`
- `GitHub CLI` installé
- `VS Code` installé
- `Node.js` et `.NET SDK` disponibles
- `C:\Dev\agents\ai-monitor.ps1` créé
- Etat IA initialisé avec 3 IA : OpenAI, Claude, Gemini

## Priorités immédiates

1. Authentifier GitHub CLI : `gh auth login`
2. Créer ou lier un dépôt GitHub dans `C:\Dev`
3. Compléter `C:\Dev\agents\ai-monitor.ps1` avec des appels API réels
4. Définir un script de bascule automatique entre IA lors de dépassement de token/session
5. Documenter les limites de chaque IA et les règles de rotation

## Plan du cerveau

### 1. Coordination

- Le chef reste l’IA principale dans ce workspace.
- Les autres IA sont des binômes de travail qui prennent le relais selon les limites de session.
- Le gestionnaire de transfert doit :
  - détecter le dépassement de limite
  - marquer l’IA comme `paused`
  - sélectionner l’IA suivante `ready`
  - reprendre automatiquement quand une IA redevient disponible

### 2. Surveillance

- Garder un état `ai-state.json` des IA suivantes :
  - `OpenAI`
  - `Claude`
  - `Gemini`
- Stocker : `usedTokens`, `usedSessions`, `maxTokens`, `sessionLimit`, `status`
- Exposer un script de contrôle pour :
  - afficher l’IA active
  - forcer la rotation
  - réinitialiser l’état quand la session est remise à zéro

### 3. Développement

- Android : structurer un projet Gradle/Android Studio
- Web : choisir un framework léger (React/Next.js + Node.js / Express)
- Windows : choix .NET SDK 8, application WinUI ou console + UI selon besoin

## Règles du cerveau

- Toujours stocker tout dans `C:\Dev`
- Garder une trace de chaque action dans `brain` et `agents`
- Ne pas toucher aux dossiers système ou personnels
- Prioriser l’automatisation et la reprise après interruption

## Fichier de référence

- `C:\Dev\brain\agent-notes.md`
- `C:\Dev\brain\brain-projection.md`
- `C:\Dev\agents\ai-monitor.ps1`
- `C:\Dev\README.md`

## Next move

Créer un workflow GitHub + IA :
- `c:\Dev\setup.ps1` pour bootstrap
- `c:\Dev\agents\ai-monitor.ps1` pour surveillance
- `c:\Dev\brain\brain-projection.md` comme plan directeur
