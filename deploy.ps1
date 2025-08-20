# Navigate to your project directory


cd C:\MyFlutterApp\login_app

# This is a temporary fix to make sure git config --global works
& "C:\Program Files\Git\bin\git.exe" config --global --add safe.directory C:/MyFlutterApp/login_app

# Pull the latest changes from GitHub
& "C:\Program Files\Git\bin\git.exe" pull

# Accept Flutter licenses to prevent the build from hanging.

# This is a one-time setup, but it's harmless to leave in the script.

flutter doctor --android-licenses

# Build the Flutter web project


flutter build web

# --- NGINX DEPLOYMENT SECTION ---


# Switch to the Nginx directory

cd C:\nginx

# Kill any existing Nginx processes to ensure a clean start

Get-Process nginx -ErrorAction SilentlyContinue | Stop-Process -Force

# Wait a moment for the process to fully terminate

Start-Sleep -Seconds 2

# Start a fresh Nginx process

start .\nginx.exe

# Switch back to the project directory before copying files

cd C:\MyFlutterApp\login_app

# Remove old files from the Nginx root directory


Remove-Item -Path "C:\TestApp\web\*" -Recurse -Force

# Copy new files to the Nginx root directory
Copy-Item -Path ".\build\web\*" -Destination "C:\TestApp\web" -Recurse -Force