# This script is designed to be run remotely via SSH by GitHub Actions.
# It handles the Nginx deployment on your server.

# --- NGINX DEPLOYMENT SECTION ---

# Stop Nginx to prevent file lock issues
Write-Host "Stopping Nginx..."
Get-Process nginx -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Nginx stopped."

# Wait for the process to fully terminate
Start-Sleep -Seconds 2

# Ensure the Nginx web directory exists
Write-Host "Creating Nginx web directory..."
New-Item -Path "C:\TestApp\web" -ItemType Directory -Force
Write-Host "Nginx web directory created."

# Change the working directory to the Nginx folder before starting the process
Write-Host "Changing directory to Nginx installation folder..."
cd "C:\nginx"

# Start a fresh Nginx process in the background
Write-Host "Starting a new Nginx process..."
Start-Process -FilePath "C:\nginx\nginx.exe" -NoNewWindow
Write-Host "Nginx started. Deployment complete!"
