Write-Output "Uninstalling Python..."

#Stop python and uninstall
$getPythonProcessGet = Get-Process -Name "python"

if ($getPythonProcessGet -ne $null) {
    Stop-Process -Name "python.exe"
}

$uninstallString = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*Python*"}).UninstallString
if ($uninstallString) {
    cmd /c $uninstallString /quiet
}

#Remove swig 
Write-Output "Removing SWIG..."
Remove-Item -Recurse -Force "C:\swigwin-4.1.1"



#Remove Build Tools
Write-Output "Uninstalling Build Tools..."
$uninstallString = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*Build Tools*"}).UninstallString
if ($uninstallString) {
    cmd /c $uninstallString /norestart /passive
}


#Remove script folder
Write-Output "Deleting scripts..."
Remove-Item -Recurse -Force "C:\Documents_NoBackup\scripts"


#Remove autostart cmd
Write-Output "Deleting autostart script..."
$autostartPath = Join-Path "${env:ProgramData}\Microsoft\Windows\Start Menu\Programs\StartUp" "start_checkifcrashed.lnk"
Remove-Item -Force $autostartPath

#Remove system variables
$python_path = "C:\Program Files\Python311\"
$pythonscripts_path = "C:\Program Files\Python311\Scripts\"
$swig_path = "C:\swigwin-4.1.1"
$current_path = [Environment]::GetEnvironmentVariable("Path", "Machine")

Write-Output "Resetting environment variables..."

$path_items = $current_path -split ';'
$path_items = $path_items | Where-Object { $_ -ne $python_path -and $_ -ne $swig_path -and $_ -ne $pythonscripts_path }
$new_path = $path_items -join ';'

[Environment]::SetEnvironmentVariable("Path", $new_path, "Machine")


#Remove Desktop Icon
Write-Output "Deleting shortcut"
$dir = [Environment]::GetFolderPath("Desktop")
Remove-Item "$dir\KVP App.lnk"


Write-Output "UNINSTALLED - SUCCESSFULLY"