@echo off

REM Run Anonymous apex to update the SourceOrgProductId field
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_updateSourceOrgProductId.cls runApex

REM Run Anonymous apex to update the ProductHierarchyPath for the Override Definitions
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_overrideDefinition_updateProductHierarchyPath.cls runApex

REM Run Anonymous apex to set applicable objects on attributes (Batch)
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_setApplicableObjectsOnAttribute.cls runApex

REM Run Anonymous apex to regenerate/fix JSONAttribute fields
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_fixJSONAttributes.cls runApex


REM Make a copy of the folder for versioning control
set /P _saveVersion=If you want to save your a version of your deploy, please type 'Save' to continue (only in case of no Errors):
if /I "%_saveVersion%" EQU "Save" goto :saveversion
if /I "%_saveVersion%" EQU "save" goto :saveversion

echo You did not type 'Save', so we didn't save a version of your deploy.
goto :end

:saveversion
call robocopy /s vlocityExtractBuild vlocityExtractVersioning\vlocityExtractBuild_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%


:end 

cmd /k