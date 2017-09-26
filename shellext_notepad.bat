@echo off

set NOTEPAD="Notepad.exe"

rem Add the "Edit with Notepad" menu with all files
reg add "HKEY_CLASSES_ROOT\*\shell\Notepad" /f /ve /d "Edit with Notepad"
reg add "HKEY_CLASSES_ROOT\*\shell\Notepad" /f /v "Icon" /d "\"%NOTEPAD%\""
reg add "HKEY_CLASSES_ROOT\*\shell\Notepad\command" /f /ve /d "\"%NOTEPAD%\" \"%%1\""

rem Associate with unknown files
rem reg add "HKEY_CLASSES_ROOT\Unknown\shell" /f /ve /d "Notepad"
rem reg add "HKEY_CLASSES_ROOT\Unknown\shell\Notepad\command" /f /ve /d "\"%NOTEPAD%\" \"%%1\""
pause