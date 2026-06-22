# Configuration VS Code optimisée

## Extensions recommandées

### Développement Android (Java)
- `redhat.java` - Language Server
- `vscjava.vscode-java-pack` - Extension Pack for Java
- `vscjava.vscode-gradle` - Gradle for Java
- `vscjava.vscode-maven` - Maven for Java
- `ms-android-studio.MobileStudio` - Android Studio intégration

### Développement Web (JavaScript/TypeScript/Node.js)
- `esbenp.prettier-vscode` - Code Formatter
- `dbaeumer.vscode-eslint` - Linter
- `msjsdiag.debugger-for-chrome` - Chrome Debugger
- `ritwickdey.LiveServer` - Live Server for HTML/CSS
- `bradlc.vscode-tailwindcss` - Tailwind CSS IntelliSense

### Développement Windows (.NET)
- `ms-dotnettools.csharp` - C# support
- `ms-dotnettools.vscode-dotnet-runtime` - .NET Runtime
- `ms-vscode.cpptools` - C++ support (optionnel)

### IA et Coding
- `github.copilot` - GitHub Copilot
- `GitHub.copilot-chat` - Copilot Chat
- `Blackboxapp.blackbox` - Blackbox AI

### Outils communs
- `eamodio.gitlens` - Git History & Blame
- `github.vscode-pull-request-github` - GitHub Pull Requests
- `ms-python.python` - Python support
- `ms-python.vscode-pylance` - Python Language Server
- `redhat.vscode-yaml` - YAML support
- `visualstudioexptteam.vscodeintellicode` - IntelliCode
- `ms-vscode.powershell` - PowerShell support
- `ms-vscode.makefile-tools` - Makefile tools

## Configuration automatique

Ouvrir `C:\Dev` dans VS Code et installer les extensions recommandées via :
- Panneau Extensions > Recommended

## Tasks disponibles

- `build-dotnet` : Compiler le projet Windows (.NET)
- `build-android` : Builder le projet Android (Gradle)
- `start-web` : Démarrer le serveur Web (Node.js)
- `npm-install-web` : Installer dépendances Web
- `gradle-sync` : Synchroniser Gradle
- `run-python-tests` : Exécuter les tests Python
- `lint-code` : Linter le code JavaScript

## Débogages disponibles

- `.NET Core (Windows)` : Débogage .NET 8
- `Node.js (Web)` : Débogage serveur Node.js
- `Node.js (Debug Web)` : Débogage client Chrome
- `Python` : Débogage Python
- `Android (Java Debug)` : Débogage Android

## Raccourcis clés

- `Ctrl+Shift+B` : Exécuter la tâche de build par défaut
- `F5` : Démarrer le débogage
- `Ctrl+Shift+D` : Vue Déboguer
- `Ctrl+Shift+G` : Vue Git
- `Ctrl+Shift+X` : Vue Extensions
