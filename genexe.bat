@ECHO OFF
CD "%~dp0"

SET racketdir=%~dp0Racket

@REM File to be deleted
SET FileToDelete="%~dp0src\main.exe%"
@REM Try to delete the file only if it exists
IF EXIST "%~dp0dist\windows" rmdir /s /q "%~dp0dist\windows"
@REM If the file wasn't deleted for some reason, stop and error
IF EXIST "%~dp0dist\windows" exit 1
ECHO "Running Tests..."
"%racketdir%\Racket.exe" "%~dp0src\test.rkt"
IF NOT ERRORLEVEL 0 GOTO testfail
ECHO "Compiling..."
"%racketdir%\raco.exe" exe "%~dp0src\main.rkt"
ECHO "Creating distro..."
mkdir "%~dp0dist\windows"
"%racketdir%\raco.exe" distribute "%~dp0dist\windows" "%~dp0src\main.exe"
del /F %FileToDelete%
ECHO "Zipping package..."
"%~dp0Racket\Racket.exe" "compress.rkt"
echo "Done. Running program."
cd "%~dp0dist\windows"
"%~dp0dist\windows\main.exe"
cd ../..

:testfail
ECHO "Tests Failed."
exit /b 255
