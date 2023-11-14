@echo off

set UE_Version=5.3
set Project_Name=BRG
rem for 4.x
rem set UBT_Path=\Engine\Binaries\DotNET\UnrealBuildTool
rem for 5.x
set UBT_Path=\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool
set UE_Rebuild=\Engine\Build\BatchFiles\Rebuild.bat

echo /////////////////////////
echo Clean and compile project
echo /////////////////////////
echo.
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
echo Serching for Unreal Build Tools....

set UBT_Path="%UE_Path%%UBT_Path%"
set UE_Rebuild="%UE_Path%%UE_Rebuild%"

if not exist %UBT_Path%.exe (
	echo [Error] Invalid UnrealBuildTool Path:
	echo %UBT_Path%.exe
	pause
	exit /b
)

if not exist %UBT_Path%.dll (
	echo [Error] Invalid UnrealBuildTool Path:
	echo %UBT_Path%.dll
	pause
	exit /b
)

if not exist %UE_Rebuild% (
	echo [Error] Invalid Rebuild BatchFile Path:
	echo %UE_Rebuild%
	pause
	exit /b
)

echo UnrealBuildTool Path: %UBT_Path%.exe
echo UnrealBuildTool Path: %UBT_Path%.dll
echo Rebuild BatchFile Path: %UE_Rebuild%
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

%UBT_Path%.exe -projectfiles -project=%UE_Project_Path% -game -rocket -progress

set VS_Project_Path="%cd%\%Project_Name%.sln"

if not exist %VS_Project_Path% (
	echo [Error] Invalid VS Project Path:
	echo %VS_Project_Path%
	pause
	exit /b
)

echo Done
echo.
echo Compiling Project....

dotnet %UBT_Path%.dll %Project_Name%Editor Win64 Development -Project=%UE_Project_Path% -WaitMutex -FromMsBuild -Rebuild

echo Done
echo.