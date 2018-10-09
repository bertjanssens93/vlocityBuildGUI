System.debug('BJ: run updateSourceOrgProductId.cls');
List<Product2> itemsToUpdate = new List<Product2>(); 
for(Product2 productSO : [SELECT Id FROM Product2]) { 
	productSO.SourceOrgProductId__c = ':' + productSO.Id + ':';
	itemsToUpdate.add(productSO); 
} 
upsert itemsToUpdate;