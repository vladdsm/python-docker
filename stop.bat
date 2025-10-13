@echo off
REM Stop and remove the Python Jupyter container using PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\stop.ps1"