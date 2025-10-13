param(
    [string]$Tag = "python-lab:latest",
    [int]$Port = 8888
)

# Get script and repo paths
$scriptRoot = $PSScriptRoot
$repoRoot = (Split-Path -Parent $scriptRoot)
Set-Location -Path $repoRoot

# Load .env from scripts/.env
$envPath = Join-Path $scriptRoot ".env"
if (-Not (Test-Path $envPath)) {
    Write-Error "Missing .env file at $envPath"
    exit 1
}

# Parse .env
$envVars = @{}
Get-Content $envPath | Where-Object { $_ -match "=" -and $_ -notmatch "^\s*#" } | ForEach-Object {
    $parts = $_ -split "=", 2
    $envVars[$parts[0].Trim()] = $parts[1].Trim()
}

# Resolve workspace and GitHub paths
$workspaceHost = Join-Path $repoRoot $envVars["WORKSPACE"]
if (-Not (Test-Path $workspaceHost)) {
    New-Item -ItemType Directory -Path $workspaceHost | Out-Null
}
$githubHost = Join-Path $env:USERPROFILE "Documents\GitHub"

# Stop and remove any existing container
docker stop python-lab 2>$null | Out-Null
docker rm python-lab 2>$null | Out-Null

docker run `
  --name python-lab `
  -d `
  -p ${Port}:8888 `
  -e JUPYTER_PASSWORD=$($envVars["JUPYTER_PASSWORD"]) `
  -v "${workspaceHost}:/home/jovyan/workspace" `
  -v "${githubHost}:/home/jovyan/github" `
  --restart unless-stopped `
  $Tag `
  jupyter lab --NotebookApp.password='' --NotebookApp.token=''

# Open browser to JupyterLab
$url = "http://localhost:$Port"
Start-Sleep -Seconds 8
Start-Process $url