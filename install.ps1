Write-Output "Creating 'C:\Documents_NoBackup' directory..."
New-Item -ItemType Directory -Force -Path "C:\Documents_NoBackup"
New-Item -ItemType Directory -Force -Path "C:\Documents_NoBackup\scripts"


# Define the download URLs and output paths
$python_exe = "https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe"
$python_outpath = "C:\Documents_NoBackup\python.exe"
$swig_zip = "https://kumisystems.dl.sourceforge.net/project/swig/swigwin/swigwin-4.1.1/swigwin-4.1.1.zip"
$swig_outpath = "C:\Documents_NoBackup\swig.zip"
$swig_destination = "C:\"

Write-Output "Downloading and installing Python..."
Invoke-WebRequest $python_exe -OutFile $python_outpath
Start-Process -Wait -FilePath $python_outpath -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1"

Write-Output "Downloading and extracting SWIG..."
Invoke-WebRequest $swig_zip -OutFile $swig_outpath
Expand-Archive -Path $swig_outpath -DestinationPath $swig_destination -Force

$python_path = "C:\Program Files\Python311"
$swig_path = "C:\swigwin-4.1.1"
$current_path = [Environment]::GetEnvironmentVariable("Path", "Machine")

Write-Output "Setting environment variables..."
if ($current_path -notlike "*$python_path*") {
    $new_path = "$python_path;$current_path"
    [Environment]::SetEnvironmentVariable("Path", $new_path, "Machine")
}

if ($current_path -notlike "*$swig_path*") {
    $new_path = "$swig_path;$current_path"
    [Environment]::SetEnvironmentVariable("Path", $new_path, "Machine")
}

if ($current_path -notlike "*$swig_destination*") {
    $new_path = "$swig_destination;$current_path"
    [Environment]::SetEnvironmentVariable("Path", $new_path, "Machine")
}

$url = "https://aka.ms/vs/17/release/vs_buildtools.exe"
$outpath = "C:\Documents_NoBackup\vs_buildtools.exe"
$params = "--add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended --quiet"

Write-Output "Downloading and installing Build Tools..."
Invoke-WebRequest $url -OutFile $outpath
Start-Process -FilePath $outpath -ArgumentList $params -Wait

if (Test-Path -Path "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC") {
    Write-Output "BUILD TOOLS = INSTALLED SUCCESSFULLY"
} else {
    Write-Output "ERROR: Build Tools installation failed."
}



# Define the path to the Python executable
$python_path = "C:\Program Files\Python311\python.exe"

# Upgrade pip using the Python executable
& $python_path -m pip install --upgrade pip
if ($LASTEXITCODE -eq 0) {
    Write-Output "Python and pip have been updated successfully."
} else {
    Write-Output "ERROR: Failed to update Python and pip."
}

# Define the list of required Python modules
$python_modules = @("pyscard", "pyperclip", "keyboard")

# Loop through the list and install the modules
foreach ($module in $python_modules) {
    Write-Output "Installing $module..."
    & $python_path -m pip install $module
    if ($LASTEXITCODE -eq 0) {
        Write-Output "$module installed successfully."
    } else {
        Write-Output "ERROR: $module installation failed."
    }
}


# download python script from GitHub
$url = "https://raw.githubusercontent.com/DarkHor53/nfcinstaller_assets/main/assets/nfc.py"
$outputPath = "C:\Documents_NoBackup\scripts\nfc.py"
Invoke-WebRequest $url -OutFile $outputPath


$url = "https://raw.githubusercontent.com/DarkHor53/nfcinstaller_assets/main/assets/start_checkifcrashed.ps1"
$output = "C:\Documents_NoBackup\scripts\start_checkifcrashed.ps1"
Invoke-WebRequest $url -OutFile $output



$scriptsFolder = "C:\Documents_NoBackup\scripts"
$batchFile = Join-Path $scriptsFolder "start_checkifcrashed.bat"
$psScript = Join-Path $scriptsFolder "start_checkifcrashed.ps1"

# Create the batch file to run the PowerShell script in hidden mode
@"
@echo off
powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "$psScript"
"@ | Set-Content -Path $batchFile -Encoding ASCII

# Create a shortcut to the batch file in the Startup folder for all users
$shortcutPath = Join-Path "${env:ProgramData}\Microsoft\Windows\Start Menu\Programs\StartUp" "start_checkifcrashed.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $batchFile
$Shortcut.Save()

#

# INSTALLED - SUCCESSFULLY
Write-Output "INSTALLED - SUCCESSFULLY"

Write-Output "Creating KVP App"

# Define variables
$url = "https://sigacover.sharepoint.com/sites/ACIP/Lists/CIPs/NewForm.aspx"
$iconUrl = "https://github.com/DarkHor53/nfcinstaller_assets/raw/main/assets/cip.ico"
$shortcutPath = "KVP App.lnk"
$iconPath = "C:\Documents_NoBackup\scripts\Website.ico"

# Download the icon from the URL
Invoke-WebRequest $iconUrl -OutFile $iconPath

# Create the shortcut for all users
<#$users = Get-ChildItem -Path C:\Users -Exclude "Public", "Default", "Default User" | Where-Object { $_.PSIsContainer }
foreach ($user in $users) {
    $desktopPath = Join-Path $user.FullName "Desktop"
    $shortcutFullPath = Join-Path $desktopPath $shortcutPath

    # Create the shortcut for the current user
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutFullPath)
    $Shortcut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    $Shortcut.Arguments = "--app=$url"
    $Shortcut.IconLocation = $iconPath
    $Shortcut.Save()
    Write-Output "Shortcut created for user $($user.Name)"
}
#>

Remove-Item -Path $python_outpath
Remove-Item -Path $swig_outpath
Remove-Item -Path $outpath


write-host "KVP App created successfully"
