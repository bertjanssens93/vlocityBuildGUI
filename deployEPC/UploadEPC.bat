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
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/deploy.yaml runJavaScript -js cleanData.js

REM Run anonymous apex in the source org
REM The default apex path is C:\Users\bejanssens\AppData\Roaming\npm\node_modules\vlocity\apex
REM You can have a relative path by putting ../../../../../../Documents/VlocityBuild/OBE_Offline/apex/namOfClass.cls
REM Remove the ProductChildItems and AttributeAssignments from the Target Org
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline2/programfiles/apex/targetOrg_delete_ProductChildItemsANDAttributeAssignements.cls runApex

REM Deploy the vlocity components 
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/deploy.yaml packDeploy

REM Run the Product Hierarchy Maintenance Job
REM Here you should post the anonymous apex for the Product Hierarchy Maitance Job (ResolveProductHierarchyBatchJob)
REM Run the Refresh Pricebook Maintenance Job
REM Here you should post the anonymous apex for the Refresh Pricebook Maintenance Job (ProductHierarchyBatchProcessor + ProductAttributesBatchProcessor)

echo Please run the following two jobs in the target environment (Vlocity CMT Administration tab):
echo 1. Product Hierarchy Maintenance
echo 2. Refresh Pricebook 
echo  
set /P _maintenanceJobs=If you ran the above maintenance job, please type 'Done' to continue:
if /I "%_maintenanceJobs%" EQU "Done" goto :continue
if /I "%_maintenanceJobs%" EQU "done" goto :continue

echo You did not type 'Done', so we stopped the process.
goto :end


:continue
REM Run Anonymous apex to update the SourceOrgProductId field
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_updateSourceOrgProductId.cls runApex

REM Run Anonymous apex to update the ProductHierarchyPath for the Override Definitions
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_overrideDefinition_updateProductHierarchyPath.cls runApex

REM Run Anonymous apex to set applicable objects on attributes (Batch)
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_setApplicableObjectsOnAttribute.cls runApex

REM Run Anonymous apex to regenerate/fix JSONAttribute fields
call vlocity -propertyfile ../programfiles/buildfiles/%_propertyfile%.properties -job ../programfiles/jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_fixJSONAttributes.cls runApex


REM Make a copy of the folder for versioning control
set /P _saveVersion=If you want to save your a version of your deploy, please type 'Save' to continue (only in case of no Errors):
if /I "%_saveVersion%" EQU "Save" goto :saveversion
if /I "%_saveVersion%" EQU "save" goto :saveversion

echo You did not type 'Save', so we didn't save a version of your deploy.
goto :end

:saveversion
call robocopy /s ..\Environments\LatestExtract\%_env%\EPC ..\Environments\Deploys\%__env%\EPC\%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%


:end 

cmd /k
