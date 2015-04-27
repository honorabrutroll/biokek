CD "%~dp0"

SET racketdir=""

@REM File to be deleted
SET FileToDelete="%~dp0\main.exe%"
@Try to delete the file only if it exists
IF EXIST %FileToDelete% del /F %FileToDelete%
@REM If the file wasn't deleted for some reason, stop and error
IF EXIST %FileToDelete% exit 1
ECHO "Compiling..."
"%~dp0\Racket\raco.exe" exe "%~dp0\src\main.rkt"
ECHo "Creating distro..."
"%~dp0\Racket\raco.exe" distribute "%~dp0\dist\windows" %FileToDelete%
del %FileToDelete%
echo "Done. Running program."
"%~dp0\dist\windows\main.exe"