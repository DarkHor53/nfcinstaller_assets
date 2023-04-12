Write-Output "Uninstalling Python..."
$uninstallString = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*Python*"}).UninstallString
if ($uninstallString) {
    cmd /c $uninstallString /quiet
}

Write-Output "Removing SWIG..."
Remove-Item -Recurse -Force "C:\swigwin-4.1.1"

Write-Output "Uninstalling Build Tools..."
$uninstallString = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*Build Tools*"}).UninstallString
if ($uninstallString) {
    cmd /c $uninstallString /norestart /passive
}

Write-Output "Deleting scripts..."
Remove-Item -Recurse -Force "C:\Documents_NoBackup\scripts"

Write-Output "Deleting shortcut..."
$shortcutPath = Join-Path "${env:ProgramData}\Microsoft\Windows\Start Menu\Programs\StartUp" "start_checkifcrashed.lnk"
Remove-Item -Force $shortcutPath

Write-Output "UNINSTALLED - SUCCESSFULLY"