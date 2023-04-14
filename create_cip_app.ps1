$url = ""
$iconUrl = ""
$shortcutPath = "$env:USERPROFILE\Desktop\Website.lnk"
$iconPath = "C:\Documents_NoBackup\scripts\Website.ico"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($iconUrl, $iconPath)

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $url
$Shortcut.IconLocation = $iconPath
$Shortcut.Save()

$shell = New-Object -ComObject Shell.Application
$desktopPath = [Environment]::GetFolderPath("Desktop")
$desktopFolder = $shell.Namespace($desktopPath)
$desktopItem = $desktopFolder.ParseName("Website.lnk")
$taskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
$taskbarFolder = $shell.Namespace($taskbarPath)
$taskbarItem = $taskbarFolder.ParseName("Website.lnk")
$startMenuPath = [Environment]::GetFolderPath("CommonStartMenu") + "\Programs"
$startMenuFolder = $shell.Namespace($startMenuPath)
$startMenuItem = $startMenuFolder.ParseName("Website.lnk")

$desktopItem.InvokeVerb("Pin to StartMenu")
$taskbarItem.InvokeVerb("Pin to Taskbar")
$startMenuItem.InvokeVerb("Pin to StartMenu")