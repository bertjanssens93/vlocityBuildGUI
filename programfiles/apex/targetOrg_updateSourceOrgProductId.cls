List<Product2> itemsToUpdate = new List<Product2>(); 
for(Product2 productSO : [SELECT Id,SourceOrgProductId__c FROM Product2]) { 
	if(productSO.SourceOrgProductId__c != null) { 
		productSO.SourceOrgProductId__c = productSO.SourceOrgProductId__c.split(':')[1]; 
		itemsToUpdate.add(productSO); 
	} 
} 
upsert itemsToUpdate; 
