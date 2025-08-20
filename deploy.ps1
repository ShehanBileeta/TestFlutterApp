# This script is designed to be run remotely via SSH by GitHub Actions.
# It handles the Nginx deployment on your server.

# --- REPOSITORY MANAGEMENT ---

# NOTE: This line is for local execution. In GitHub Actions, the variable is set automatically.
$env:GITHUB_WORKSPACE = "C:\MyFlutterApp\login_app"

# Set the GitHub Token for authentication
$gitToken = $env:GITHUB_TOKEN

# Navigate to the project directory using the GITHUB_WORKSPACE environment variable
Write-Host "Navigating to the project directory..."
cd $env:GITHUB_WORKSPACE

# This is the crucial step to fix the 'Permission denied' error.
# It grants read and write permissions to the 'Network Service' account on the project directory.
Write-Host "Setting folder permissions for the GitHub Actions runner..."
icacls "$env:GITHUB_WORKSPACE" /grant "NT AUTHORITY\NETWORK SERVICE":(OI)(CI)F
Write-Host "Permissions set successfully."

# Forcefully stop any processes that might be holding file locks from previous builds
Write-Host "Stopping any lingering build processes..."
Get-Process -Name "dart", "flutter" -ErrorAction SilentlyContinue | Stop-Process -Force
Write-Host "Lingering processes stopped."

# Add a short delay to ensure process termination is complete
Start-Sleep -Seconds 2

# Fetch the latest changes from the remote repository
Write-Host "Fetching latest changes from Git..."
git fetch "https://$gitToken@github.com/ShehanBileeta/login_app.git"
Write-Host "Git fetch completed."

# Reset the local branch to match the remote branch, discarding any local changes
Write-Host "Forcefully syncing local branch to remote..."
git reset --hard origin/main
Write-Host "Git reset completed."

# Clean up any untracked files
Write-Host "Cleaning up untracked files..."
git clean -fd
Write-Host "Git cleanup completed."

# --- FLUTTER BUILD SECTION ---

# Accept Flutter licenses non-interactively to prevent the build from hanging.
Write-Host "Accepting Flutter licenses..."
cmd /c "echo y | flutter doctor --android-licenses"

# Build the Flutter web project
Write-Host "Building Flutter web project..."
flutter build web

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

# Remove old files from the Nginx root directory
Write-Host "Removing old files from the Nginx web directory..."
Remove-Item -Path "C:\TestApp\web\*" -Recurse -Force
Write-Host "Old files removed."

# Copy new files to the Nginx root directory
Write-Host "Copying new files to the Nginx web directory..."
Copy-Item -Path ".\build\web\*" -Destination "C:\TestApp\web" -Recurse -Force
Write-Host "New files copied."

# Change the working directory back to the Nginx installation path
Write-Host "Changing directory to Nginx installation folder..."
cd "C:\nginx"

# Start a fresh Nginx process in the background
Write-Host "Starting a new Nginx process..."
Start-Process -FilePath "C:\nginx\nginx.exe" -NoNewWindow
Write-Host "Nginx started. Deployment complete!"
