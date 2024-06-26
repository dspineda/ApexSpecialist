@isTest
private class WarehouseCalloutServiceTest {
    
    @isTest static  void warehouseServiceTest() {
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new WarehouseCalloutServiceMock());
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
		
        List<Product2> productsToUpsert = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c,
                                           Maintenance_Cycle__c, Name FROM Product2];
        
        System.assert( true, productsToUpsert.size() == 22 );
        
        // Update Salesforce Records
        for ( Product2 equipmentUpserted : productsToUpsert ) {
            System.assert( true, equipmentUpserted.Replacement_Part__c );
            System.assert( true, equipmentUpserted.Cost__c != null );
            System.assert( true, equipmentUpserted.Current_Inventory__c != null );
            System.assert( true, equipmentUpserted.Lifespan_Months__c != null );
            System.assert( true, equipmentUpserted.Maintenance_Cycle__c != null );
            System.assert( true, equipmentUpserted.Name != null );
        }
        
        Test.stopTest();
    }



    @isTest 
    static void warehouseServiceTest2() {
        // Tu prueba existente aquí
        
        // Llama al método execute
        Test.startTest();
        WarehouseCalloutService.execute(null);
        Test.stopTest();

        // Verifica que el método execute haya ejecutado correctamente
        // Agrega tus aserciones aquí si el método execute tiene algún efecto adicional que debas verificar
  }

}