String query = ' SELECT Id , '; 
query += ' vlocity_cmt__ProductHierarchyPath__c '; 
query += ' FROM vlocity_cmt__OverrideDefinition__c WHERE vlocity_cmt__ProductHierarchyPath__c != null'; 
updateProductHierarchyPathBatchJob updateProductHierarchyPath = new updateProductHierarchyPathBatchJob(query); 
Database.executeBatch(updateProductHierarchyPath,2000); 
query = ' SELECT Id , '; 
query += ' vlocity_cmt__ProductHierarchyPath__c '; 
query += ' FROM vlocity_cmt__PromotionItem__c WHERE vlocity_cmt__ProductHierarchyPath__c != null'; 
updateProductHierarchyPath = new updateProductHierarchyPathBatchJob(query); 
Database.executeBatch(updateProductHierarchyPath,2000);
