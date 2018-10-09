try {
    System.debug('--- SET APPLICABLE OBJECTS ON ATTRIBUTES ---');
    List<vlocity_cmt__ObjectFieldAttribute__c> fieldAttrsToInsert = new List<vlocity_cmt__ObjectFieldAttribute__c>();
    Id product2ObjId = [select Id from vlocity_cmt__ObjectClass__c where Name = 'Product2 Object'].get(0).Id;
    List<vlocity_cmt__Attribute__c> attrs = [select Id, vlocity_cmt__AttributeCategoryId__c from vlocity_cmt__Attribute__c];
    //List<vlocity_cmt__Attribute__c> attrs = [select Id, vlocity_cmt__AttributeCategoryId__c from vlocity_cmt__Attribute__c where Name = 'testAttrAssigment'];
    System.debug('total attributes found: '+attrs.size());
    vlocity_cmt__ObjectFieldAttribute__c objFieldAttr;
    List<vlocity_cmt__ObjectFieldAttribute__c> existingObjFieldAttrs = [select Id, vlocity_cmt__AttributeId__c from vlocity_cmt__ObjectFieldAttribute__c where vlocity_cmt__AttributeCategoryId__c != null and vlocity_cmt__ObjectType__c = 'vlocity_cmt__ObjectClass__c' and vlocity_cmt__ObjectClassId__c =: product2ObjId];
    Set<Id> alreadyAssociatedAttrCodes = new Set<Id>();
    for (vlocity_cmt__ObjectFieldAttribute__c obj: existingObjFieldAttrs) {
        alreadyAssociatedAttrCodes.add(obj.vlocity_cmt__AttributeId__c);
    }

    for (vlocity_cmt__Attribute__c attr: attrs) {
        //System.debug('curr id: '+attr.Id);
        if (!alreadyAssociatedAttrCodes.contains(attr.Id)) {
            objFieldAttr = new vlocity_cmt__ObjectFieldAttribute__c();
            //objFieldAttr.vlocity_cmt__AttributeCategoryId__c = attr.vlocity_cmt__AttributeCategoryId__c;
            objFieldAttr.vlocity_cmt__AttributeId__c = attr.Id;
            objFieldAttr.vlocity_cmt__IsActive__c = true;
            objFieldAttr.vlocity_cmt__ObjectClassId__c = product2ObjId;
            objFieldAttr.vlocity_cmt__ObjectType__c = 'vlocity_cmt__ObjectClass__c';
            fieldAttrsToInsert.add( objFieldAttr );
        }
    }
    if (!fieldAttrsToInsert.isEmpty()) {
        System.debug('attributes to update: '+fieldAttrsToInsert.size());
        insert fieldAttrsToInsert;
    } else {
        System.debug('No attributes to update');
    }
} catch(Exception e) {
    System.debug(e.getMessage());
}
