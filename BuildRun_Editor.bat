@echo off

set Project_Name=Insurgency

echo Deleting sln...
if exist UE.sln (
	del /s /q UE.sln 1>nul
)
echo Done

echo Deleting .vs...
if exist .vs rmdir /s /q .vs
echo Done

echo Deleting Binaries, Intermediate, Saved, DerivedDataCache...
rem Project
rem if exist %Project_Name%\Binaries rmdir /s /q %Project_Name%\Binaries
if exist %Project_Name%\Intermediate rmdir /s /q %Project_Name%\Intermediate
if exist %Project_Name%\Saved rmdir /s /q %Project_Name%\Saved
if exist %Project_Name%\DerivedDataCache rmdir /s /q %Project_Name%\DerivedDataCache
rem ENgine
rem if exist Engine\Intermediate rmdir /s /q Engine\Intermediate
rem if exist Engine\Saved rmdir /s /q Engine\Saved
echo Done

echo.
echo GenerateProjectFiles....
call GenerateProjectFiles.bat
echo Done

echo.
echo Running UAT....
call Engine\Build\BatchFiles\RunUAT BuildEditor -Project=%Project_Name% -targetplatform=Win64 -clientconfig=Development -timestamps -utf8output
echo Done

echo.
echo Running Editor....
call Engine\Binaries\Win64\UE4Editor.exe %Project_Name%\%Project_Name%.uproject
echo Done

echo.
pause
