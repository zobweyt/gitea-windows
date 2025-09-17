# Gitea for Windows

A simple setup to run [Gitea](https://about.gitea.com) as a Windows service.

## Features

- **Privacy**: keep your private code secure on your own machine.
- **Offline**: work offline with full Git capabilities.
- **Archive**: maintain a personal archive of your projects.
- **Mirroring**: create local copies of projects from GitHub, GitLab, etc.

## Quick Setup

1. Search for "cmd".

2. Run as administrator (all scripts require administrator privileges).

3. Navigate to the directory where you want to install Gitea.

5. Clone the repository into that directory:

   ```bat
   git clone git@github.com:zobweyt/gitea-windows.git .
   ```

5. Install Gitea as Windows service:

   ```bat
   service_install.bat
   ```

   Open http://localhost:3000 in your browser to continue configuration.

## Additional Resources

- Based on the official [Gitea Windows Service installation guide](https://docs.gitea.com/installation/windows-service).
- For advanced configuration, see the [Gitea configuration cheat sheet](https://docs.gitea.com/administration/config-cheat-sheet).
