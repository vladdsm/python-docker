param(
    [string]$Tag = "python-lab:latest"
)

Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)
docker build -t $Tag ..