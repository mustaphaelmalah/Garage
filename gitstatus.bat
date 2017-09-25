@echo off
for /f "tokens=*" %%a in ('dir /ad /b') do (
    echo --------
    echo %%a
    echo --------
    git --git-dir=%%a/.git --work-tree=%%a status
    echo.
)
pause