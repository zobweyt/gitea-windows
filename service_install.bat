@echo off
title Gitea - Install Service
setlocal EnableDelayedExpansion

echo This script should be run with administrator privileges.
echo Press any key if you are running it as administrator.
pause

set GITEA_EXE_FILE_URL="https://dl.gitea.com/gitea/1.24.5/gitea-1.24.5-gogit-windows-4.0-amd64.exe"
set GITEA_EXE_FILE_PATH="%cd%\gitea.exe"
set GITEA_WORK_PATH="%cd%\gitea"
set GITEA_CONFIG_FILE_PATH="%GITEA_WORK_PATH%\custom\conf\app.ini"

set GITEA_SC_NAME="Gitea"
set GITEA_SC_DESCRIPTION="Gitea: Git with a cup of tea"
set GITEA_SC_BIN="%GITEA_EXE_FILE_PATH% web --config %GITEA_CONFIG_FILE_PATH%"

if not exist %GITEA_EXE_FILE_PATH% (
  echo.
  echo Downloading Gitea executable from $GITEA_EXE_FILE_URL$

  curl -L -o %GITEA_EXE_FILE_PATH% %GITEA_EXE_FILE_URL%

  echo.
  echo Successfully downloaded Gitea executable to $GITEA_EXE_FILE_PATH$
)

echo.
echo Creating configuration file...

for /f "delims=" %%i in ('%GITEA_EXE_FILE_PATH% generate secret INTERNAL_TOKEN') do set GITEA_INTERNAL_TOKEN=%%i
for /f "delims=" %%i in ('%GITEA_EXE_FILE_PATH% generate secret JWT_SECRET') do set GITEA_JWT_SECRET=%%i

if not exist "!GITEA_WORK_PATH!" mkdir "!GITEA_WORK_PATH!"
if not exist "!GITEA_WORK_PATH!\custom" mkdir "!GITEA_WORK_PATH!\custom"
if not exist "!GITEA_WORK_PATH!\custom\conf" mkdir "!GITEA_WORK_PATH!\custom\conf"

(
echo RUN_MODE = prod
echo RUN_USER = %COMPUTERNAME%
echo WORK_PATH = %GITEA_WORK_PATH%
echo.
echo [repository]
echo DISABLED_REPO_UNITS = repo.wiki,repo.ext_wiki,repo.projects,repo.packages,repo.actions
echo.
echo [repository.signing]
echo DEFAULT_TRUST_MODEL = committer
echo.
echo [ui]
echo FILE_ICON_THEME = basic
echo AMBIGUOUS_UNICODE_DETECTION = false
echo DEFAULT_SHOW_FULL_NAME = true
echo.
echo [server]
echo PROTOCOL = http
echo START_SSH_SERVER = true
echo OFFLINE_MODE = true
echo ENABLE_GZIP = true
echo.
echo [database]
echo DB_TYPE = sqlite3
echo.
echo [security]
echo INSTALL_LOCK = false
echo COOKIE_REMEMBER_NAME = gitea_auth_token
echo INTERNAL_TOKEN = %GITEA_INTERNAL_TOKEN%
echo.
echo [openid]
echo ENABLE_OPENID_SIGNIN = false
echo ENABLE_OPENID_SIGNUP = false
echo.
echo [service]
echo DISABLE_REGISTRATION = true
echo.
echo [service.explore]
echo REQUIRE_SIGNIN_VIEW = true
echo.
echo [cron.update_mirrors]
echo SCHEDULE = "@every 24h"
echo.
echo [session]
echo COOKIE_NAME = gitea_session_id
echo.
echo [oauth2]
echo JWT_SECRET = %GITEA_JWT_SECRET%
echo.
echo [packages]
echo ENABLED = false
echo.
echo [actions]
echo ENABLED = false
echo.
echo [other]
echo SHOW_FOOTER_VERSION = false
echo SHOW_FOOTER_TEMPLATE_LOAD_TIME = false
echo SHOW_FOOTER_POWERED_BY = true
echo ENABLE_FEED = false
) > %GITEA_CONFIG_FILE_PATH%

echo.
echo Successfully created configuration file.

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
