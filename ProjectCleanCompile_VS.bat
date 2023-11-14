@echo off

call ProjectCleanCompile.bat

echo Starting Visual Studio....

%VS_Project_Path%

echo Done
echo.
echo Don't forget to commit and push Your work.
echo Have a nice day!
echo.
pause