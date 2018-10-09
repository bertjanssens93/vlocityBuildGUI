@echo off

set /P _env=What environment do you want to export data from [Dev/Cit/]?
if "%_env%" EQU "Dev" goto :envChoice
if "%_env%" EQU "Cit" goto :envChoice

echo Invalid environment name, please restart the process by double clicking the BAT file.
goto :end

:envChoice

SET _propertyfile=build_%_env%.properties
SET _projectPath=../Environments/LatestExtract/%_env%/CDLOT

REM Delete everything that is in the extract folder
rmdir /s /q ..\Environments\LatestExtract\%_env%\CDLOT
mkdir ..\Environments\LatestExtract\%_env%\CDLOT


:execute

REM Create the required Job Files for the specified query
@echo projectPath: %_projectPath% >  ..\programfiles\jobfiles\%_env%\extract.yaml
type query.yaml >> ..\programfiles\jobfiles\%_env%\extract.yaml

REM ################### EXECUTE THE EXTRACT ######################## 

REM Uncomment packUpdateSettings when it is the FIRST TIME YOU EXTRACT
REM Call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml packUpdateSettings

REM Clean the data in the source org and add global keys to SObjects missing them
call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml runJavaScript -js cleanData.js

REM Refresh the offline data to the latest format for this tool
call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml refreshProject

REM Run anonymous apex in the source org
REM The default apex path is C:\Users\bejanssens\AppData\Roaming\npm\node_modules\vlocity\apex
REM You can have a relative path by putting ../../../../../../Documents/VlocityBuild/OBE_Offline/apex/sourceOrg_updateSourceOrgProductId.cls
REM Run Anonymous apex to update the SourceOrgProductId field
call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/sourceOrg_updateSourceOrgProductId.cls runApex

REM Exports the vlocity components as Datapacks
call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml packExport

REM Check in th extracted data for missing global keys
call vlocity -propertyfile buildfiles/%_propertyfile%.properties -job jobfiles/extract.yaml validateLocalData


cmd /k


:end 
