If WScript.Arguments.Named.Exists("elevated") = False Then
  CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevated", "", "runas", 1
  WScript.Quit
Else
  Set oShell = CreateObject("WScript.Shell")
  oShell.CurrentDirectory = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
  Set wshShell = WScript.CreateObject ("wscript.shell")
  
  On Error Resume Next
    wshShell.Run "git version", 1, True
  If Err.Number <> 0 Then
    WScript.Echo "Install Git for Windows (http://git-scm.com/download/win) to enable automatic updates."
    'WScript.Quit
  End If
  On Error Goto 0
  
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  If objFSO.FolderExists(".git") Then
    'WScript.Echo "Folder exists."
    wshShell.Run "%comspec% /k git stash & " &_
                              "git pull --rebase & " &_
                              "git stash pop & pause & exit", 1, True
  Else
    'WScript.Echo "Folder does not exist."
    wshShell.Run "%comspec% /k git init . & " &_
                              "git remote add -f origin https://bitbucket.org/BigWorldSetup/BigWorldSetup & " &_
                              "git branch --track master origin/master & " &_
                              "git reset --hard origin/master & pause & exit", 1, True
  End If
  wshShell.Run "git rev-parse HEAD > ""BiG World Setup Version.txt""", 7, True
  'wshShell.run """BiG World Setup\Tools\AutoIt3.exe""" &" " & """BiG World Setup\BiG World Setup.au3""", 6, True
  Set wshShell = nothing
End If