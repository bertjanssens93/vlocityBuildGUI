@echo off

set /P _env=To which environment do you want to deploy data [Cit/Buildcheck/Dryrun/Playground/Training]?
if "%_env%" EQU "Cit" goto :envChoice
if "%_env%" EQU "Buildcheck" goto :envChoice
if "%_env%" EQU "Dryrun" goto :envChoice
if "%_env%" EQU "Playground" goto :envChoice
if "%_env%" EQU "Training" goto :envChoice

echo Invalid environment name, please restart the process by double clicking the BAT file.
goto :end

:envChoice

SET _propertyfile=build_%_env%.properties
SET _projectPath=../Environments/LatestExtract/%_env%/CDLOT


:execute

@echo projectPath: %_projectPath% > ..\programfiles\jobfiles\%_env%\deploy.yaml
type query.yaml >> ..\programfiles\jobfiles\%_env%\deploy.yaml

REM ################### EXECUTE THE DEPLOY ######################## 

REM Uncomment packUpdateSettings when it is the FIRST TIME YOU EXTRACT
REM vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/deploy.yaml packUpdateSettings

REM Clean the data in the target org and add global keys to SObjects missing them
REM call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/deploy.yaml runJavaScript -js cleanData.js

REM Deploy the vlocity components 
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/deploy.yaml packDeploy


REM Make a copy of the folder for versioning control
set /P _saveVersion=If you want to save your a version of your deploy, please type 'Save' to continue (only in case of no Errors):
if /I "%_saveVersion%" EQU "Save" goto :saveversion
if /I "%_saveVersion%" EQU "save" goto :saveversion

echo You did not type 'Save', so we didn't save a version of your deploy.
goto :end

:saveversion
call robocopy /s ..\Environments\LatestExtract\%_env%\CDLOT ..\Environments\Deploys\%__env%\CDLOT\%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%


:end 

cmd /k
