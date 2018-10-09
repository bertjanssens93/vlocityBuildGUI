@echo off

set /P _sure=Are you sure you want to Deploy Data to the target Org [Y/N]?
if /I "%_sure%" EQU "Y" goto :execute

echo You decided to stop the process by not type 'Y' in the window.
goto :end

:execute

REM ################### EXECUTE THE DEPLOY ######################## 

REM Uncomment packUpdateSettings when it is the FIRST TIME YOU EXTRACT
REM vlocity -propertyfile buildfiles/build_buildcheck.properties -job jobfiles/deploy.yaml packUpdateSettings

REM Clean the data in the target org and add global keys to SObjects missing them
REM call vlocity -propertyfile buildfiles/build_buildcheck.properties -job jobfiles/deploy.yaml runJavaScript -js cleanData.js

REM Deploy the vlocity components 
call vlocity -propertyfile buildfiles/build_buildcheck.properties -job jobfiles/deploy.yaml packDeploy


REM Make a copy of the folder for versioning control
set /P _saveVersion=If you want to save your a version of your deploy, please type 'Save' to continue (only in case of no Errors):
if /I "%_saveVersion%" EQU "Save" goto :saveversion
if /I "%_saveVersion%" EQU "save" goto :saveversion

echo You did not type 'Save', so we didn't save a version of your deploy.
goto :end

:saveversion
call robocopy /s ..\Environments\LatestExtract\%_env%\Other ..\Environments\Deploys\%__env%\Other\%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%


:end 

cmd /k
