#If the file does not exist, create it.
if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
    try {
            if (!(Test-Path -Path ($env:userprofile + "\Documents\WindowsPowerShell"))) {
                New-Item -Path ($env:userprofile + "\Documents\WindowsPowerShell") -ItemType "directory"
        }

        Invoke-RestMethod https://github.com/Meyu-Sys/win-sys/raw/main/Microsoft.PowerShell_profile.ps1 -o $PROFILE
        Write-Host "The profile @ [$PROFILE] has been created."
    }
    catch {
        throw $_.Exception.Message
    }
}
# If the file already exists, show the message and do nothing.
 else {
		 Get-Item -Path $PROFILE | Move-Item -Destination oldprofile.ps1
		 Invoke-RestMethod https://github.com/Meyu-Sys/win-sys/raw/main/Microsoft.PowerShell_profile.ps1 -o $PROFILE
		 Write-Host "The profile @ [$PROFILE] has been created and old profile removed."
 }
& $profile

# Import configs
Move-Item .\.config $env:userprofile

# wsl install
wsl --install

# Winget Install
Invoke-RestMethod  "https://github.com/asheroto/winget-installer/raw/master/winget-install.ps1" | Invoke-Expression

# App install
winget import --accept-source-agreements --accept-package-agreements -i .\winget-export.json

# Uninstall ubuntu
wsl --unregister Ubuntu

# Clink
Invoke-RestMethod https://github.com/Meyu-Sys/win-sys/raw/main/starship.lua -o %LocalAppData%\clink\

# Choco Install
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Terminal Config
 
 # Variable for terminal config
$term = "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

 # if settings.json doesn't exists
if (!(Test-Path -Path $term -PathType Leaf)) {
    Invoke-RestMethod https://github.com/Meyu-Sys/win-sys/raw/main/settings.json -o $term
        Write-Host "The settings.json @ [$term] has been created."
}
 # If settings.json already exists
else {
    Get-Item -Path $term | Move-Item -Destination oldsettings.json
    Invoke-RestMethod https://github.com/Meyu-Sys/win-sys/raw/main/settings.json -o $term
    Write-Host "The settings.json @ [$term] has been created and old profile removed."    
}

# Font install
choco install nerd-fonts-firacode

# Terminal Icons Install
Install-Module -Name Terminal-Icons -Repository PSGallery
