@echo off

echo Please first run the following two jobs in the target environment (Vlocity CMT Administration tab):
echo 
echo 1. Product Hierarchy Maintenance
echo 2. Refresh Pricebook 
echo  
set /P _maintenanceJobs=If you ran the above maintenance job, please type 'Done' to continue:
if /I "%_maintenanceJobs%" EQU "Done" goto :execute
if /I "%_maintenanceJobs%" EQU "done" goto :execute

echo You did not type 'Done', so we stopped the process.
goto :end


:execute
REM Run Anonymous apex to update the SourceOrgProductId field
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_updateSourceOrgProductId.cls runApex

REM Run Anonymous apex to update the ProductHierarchyPath for the Override Definitions
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_overrideDefinition_updateProductHierarchyPath.cls runApex

REM Run Anonymous apex to set applicable objects on attributes (Batch)
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_setApplicableObjectsOnAttribute.cls runApex

REM Run Anonymous apex to regenerate/fix JSONAttribute fields
call vlocity -propertyfile buildfiles/build_cit.properties -job jobfiles/extract.yaml -apex ../../../../../../Documents/VlocityBuild/OBE_Offline/CIT/DeployEPC/apex/targetOrg_fixJSONAttributes.cls runApex


cmd /k

:end 