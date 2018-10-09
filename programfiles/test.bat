@echo off

set /P _env=What environment do you want to export data from [Dev/Cit/]?
if "%_env%" EQU "Dev" goto :envChoice
if "%_env%" EQU "Cit" goto :envChoice

echo Invalid environment name, please restart the process by double clicking the BAT file.
goto :end

:envChoice
if "%_env%" EQU "Dev" (
	SET _propertyfile=build_dev.properties
	SET _projectPath=../Environments/LatestExtract/%_env%/CDLOT
	
	REM Delete everything that is in the extract folder
	REM rmdir /s /q ..\Environments\LatestExtract\%_env%\CDLOT
	mkdir ..\Environments\LatestExtract\%_env%\CDLOT
) 

echo %_propertyfile%
echo %_projectPath%


cmd /k

:end

cmd /k