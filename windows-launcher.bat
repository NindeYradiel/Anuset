@echo off
title Anuset89 Launcher - Windows

echo Iniciando Anuset89...
cd /d %~dp0

:: Abrir navegador por defecto en http://localhost
start http://localhost

:: Levantar el entorno Docker
docker-compose up --build

echo.
echo Apagando Anuset89...
docker-compose down

pause
