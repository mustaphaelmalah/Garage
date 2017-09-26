@echo off

set VIM="C:\Program Files (x86)\Vim\vim80\vim.exe"

rem Add the "Edit with Notepad" menu with all files
rem reg add "HKEY_CLASSES_ROOT\*\shell\Notepad" /f /ve /d "Edit with Notepad"
rem reg add "HKEY_CLASSES_ROOT\*\shell\Notepad" /f /v "Icon" /d "\"%NOTEPAD%\""
rem reg add "HKEY_CLASSES_ROOT\*\shell\Notepad\command" /f /ve /d "\"%NOTEPAD%\" \"%%1\""

rem Associate with unknown files
reg add "HKEY_CLASSES_ROOT\Unknown\shell" /f /ve /d "vim"
reg add "HKEY_CLASSES_ROOT\Unknown\shell\vim\command" /f /ve /d "\"%VIM%\" \"%%1\""
pause