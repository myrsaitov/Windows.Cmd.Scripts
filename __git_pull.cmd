@echo off
REM Выполняет команду PULL для текущего репозитория

REM Запоминает корневую папку
set ROOT_PATH=%cd%

REM Переходит в рабочую папку
cd ./../__Git.Scripts/__private

REM Выполняет команду PULL
call __git_CMD.cmd %ROOT_PATH% "git pull"

pause
