List<vlocity_cmt__AttributeAssignment__c> attributeAssignments = [SELECT Id FROM vlocity_cmt__AttributeAssignment__c];
List<vlocity_cmt__ProductChildItem__c> productChildItems = [SELECT Id FROM vlocity_cmt__ProductChildItem__c];

delete attributeAssignments;
delete productChildItems;