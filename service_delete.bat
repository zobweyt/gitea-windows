@echo off
title Gitea - Delete Service

echo This script should be run with administrator privileges.
echo Press any key if you're running it as administrator.
pause

set GITEA_SC_NAME="Gitea"

sc stop %GITEA_SC_NAME%
sc delete %GITEA_SC_NAME%
