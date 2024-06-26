public with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        List<Product2> products = new List<Product2>();

        if (response.getStatusCode() == 200) {
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            for(Object eq : results){
                Map<String,Object> mapJson = (Map<String,Object>)eq;
                Product2 myEq = new Product2();
                myEq.Replacement_Part__c = (Boolean)mapJson.get('replacement');
                myEq.Name = (String)mapJson.get('name');    
                myEq.Maintenance_Cycle__c = (Integer)mapJson.get('maintenanceperiod');
                myEq.Lifespan_Months__c = (Integer)mapJson.get('lifespan');
                myEq.Cost__c = (Decimal)mapJson.get('cost');
                myEq.Warehouse_SKU__c = (String) mapJson.get('sku');
                myEq.Current_Inventory__c = (Double) mapJson.get('quantity');
                myEq.ProductCode = (String) mapJson.get('_id');
                products.add(myEq);
            }
        }


        if(products.size() > 0){
            upsert products;
            System.debug('Your equipment was synced with the warehouse one');
        }
        
    }

    public static void execute (QueueableContext context){
        runWarehouseEquipmentSync();
    }
}