$a = '1'
$Python = "C:\Program Files\Python311\python.exe"
$Argument = '"C:\Documents_NoBackup\scripts\nfc.py"'

while ($a -eq '1') {

    $pythonProcess = Get-Process | Where Processname -Like 'Python'

    if($pythonProcess -eq $null) {
        $StartProcess = Start-Process -FilePath $Python -ArgumentList $Argument -WindowStyle Hidden
        Start-Job -ScriptBlock {$StartProcess}
        sleep (2)
        }
}
