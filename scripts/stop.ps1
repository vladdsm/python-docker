docker stop python-lab 2>$null
docker rm python-lab 2>$null
Write-Host "Stopped and removed container 'python-lab'."