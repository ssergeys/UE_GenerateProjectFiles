@echo off

set UE_Version=5.2
set Project_Name=MyProjectName
rem for 4.x
rem set UBT_Path=\Engine\Binaries\DotNET\UnrealBuildTool.exe
rem for 5.x
set UBT_Path=\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.exe

echo Deleting....

if exist %Project_Name%.sln (
	del /s /q %Project_Name%.sln 1>nul
)
if exist .vs rmdir /s /q .vs
if exist Binaries rmdir /s /q Binaries
if exist Intermediate rmdir /s /q Intermediate
if exist Saved rmdir /s /q Saved
if exist DerivedDataCache rmdir /s /q DerivedDataCache

echo Done
echo.
echo Serching for Unreal Engine %UE_Version%....

powershell -command "& { (Get-ItemProperty 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\EpicGames\Unreal Engine\%UE_Version%' -Name 'InstalledDirectory' ).'InstalledDirectory' }" > ue_path.txt
set /p UE_Path=<ue_path.txt
del ue_path.txt

if not exist "%UE_Path%" (
	echo [Error] Invalid Unreal Engine %UE_Version% Path:
	echo %UE_Path%
	pause
	exit /b
)

echo Done
echo.
echo Serching for UnrealBuildTool....

set UBT_Path="%UE_Path%%UBT_Path%"

if not exist %UBT_Path% (
	echo [Error] Invalid UnrealBuildTool Path:
	echo %UBT_Path%
	pause
	exit /b
)

echo UnrealBuildTool Path: %UBT_Path%
echo Done
echo.
echo Serching for Project....

set UE_Project_Path="%cd%\%Project_Name%.uproject"

if not exist %UE_Project_Path% (
	echo [Error] Invalid UE Project Path:
	echo %UE_Project_Path%
	pause
	exit /b
)

echo Project Path: %UE_Project_Path%
echo Done
echo.
echo Generate Project Files....

%UBT_Path% -projectfiles -project=%UE_Project_Path% -game -rocket -progress

set VS_Project_Path="%cd%\%Project_Name%.sln"

if not exist %VS_Project_Path% (
	echo [Error] Invalid VS Project Path:
	echo %VS_Project_Path%
	pause
	exit /b
)

echo Done
echo.

echo Starting Visual Studio....

%VS_Project_Path%

echo Done
echo.
echo Don't forget to commit and push Your work.
echo Have a nice day!
echo.
pause