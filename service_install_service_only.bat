@echo off
title Gitea - Install Service
setlocal EnableDelayedExpansion

echo This script should be run with administrator privileges.
echo Press any key if you are running it as administrator.
pause

set GITEA_EXE_FILE_URL="https://dl.gitea.com/gitea/1.24.6/gitea-1.24.6-gogit-windows-4.0-amd64.exe"
set GITEA_EXE_FILE_PATH="%cd%\gitea.exe"
set GITEA_WORK_PATH="%cd%\gitea"
set GITEA_CONFIG_FILE_PATH="%GITEA_WORK_PATH%\custom\conf\app.ini"

set GITEA_SC_NAME="Gitea"
set GITEA_SC_DESCRIPTION="Gitea: Git with a cup of tea"
set GITEA_SC_BIN="%GITEA_EXE_FILE_PATH% web --config %GITEA_CONFIG_FILE_PATH%"

sc stop %GITEA_SC_NAME%
sc delete %GITEA_SC_NAME%
sc create %GITEA_SC_NAME% binPath= %GITEA_SC_BIN% start= auto
sc description %GITEA_SC_NAME% %GITEA_SC_DESCRIPTION%
sc start %GITEA_SC_NAME%

echo.
echo Successfully installed Gitea as Windows service.

echo.
echo Open http://localhost:3000 in your browser to continue configuration

endlocal
