@echo off

echo ----------------------------------
echo A script for automatically archiving backups to facilitate
echo the process without requiring any user intervention.
echo.
echo 2016-01-04 - Mustapha ElMalah
echo Written for Life International Hospital
echo.
echo USAGE: 
echo 	- Modify the file in the "USER SETTINGS" section 
echo			to provide the locations and required credentials
echo		- Execute the batch job
echo		- Type 'PERFORM' to start execusion.
echo.
echo USER SETTINGS:
echo 	-backup_location: the upper level directory containing the backup folder, 
echo 		e.g. if backup folder is located in 'D:\backup' put 'd:'
echo 	-backup_dir_name: the name of the backup directory, 
echo			e.g. 'backup' in the above example
echo		-archive_location: this is where the backup will be moved
echo		-archive_username: Fully qualified username, including domain 
echo			e.g. "ALHAYAT\ADMINISTRATOR", you will be prompted for password, 
echo			if no credentials required in the target archive location, set username to empty
echo.
echo NOTES: 
echo 	- Do not add leading slashes to paths e.g. d:\backup not d:\backup\
echo		- If the target archive folder is shared and is on the same computer, and the share 
echo			name is used, connection from same computer containing archive_location
echo			cannot be made using supplied username, use local path instead.
echo		- The script will try to close any existing connections to archive_location in case
echo			credentials are supplied, if none found, an error message is displayed and
echo			can be ignored safely.
echo.
echo PROCEDURE:
echo		- Folder is renamed to current date and time
echo		- Folder is moved to backup archive
echo ----------------------------------

set /p ANS="Enter "PERFORM" to confirm:  "

if not %ANS%==PERFORM goto :cancelled

if "%ANS%"=="" goto :perform-archive

:perform-archive
REM construct backup folder name from timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%%MM%%DD%%HH%%Min%%Sec%"

echo %datestamp%
echo %fullstamp%

set timestamp=%fullstamp%

REM ---------------------------------
REM USER SETTINGS
REM ---------------------------------
set backup_location=D:
set backup_dir_name=backup
set archive_location=\\server0\backup_archive
set archive_username=server0\backup_archive
REM ---------------------------------
REM end of USER SETTINGS
REM ---------------------------------

set source_dir=%backup_location%\%timestamp%
set target_dir=%archive_location%\%timestamp%

REM use share credentials, prompt for password, removing any existing connections first
if not %archive_username%.==. (
	net use "%archive_location%" /delete
	net use "%archive_location%" /user:%archive_username% *
)

REM rename backup folder, to keep current folder state so that no more backups are added to the path as we move
move "%backup_location%\%backup_dir_name%" "%source_dir%"

REM Perform move
robocopy /MOVE /E "%source_dir%" "%target_dir%"

REM disconnect
if not %archive_username%.==. (
	net use "%archive_location%" /delete
)

goto :EOF

:cancelled
echo Archiving has been cancelled.

pause