public class MyClosedWonEcommItems {
      @future (callout=true) public static void sendEcomm(String cid,String orderID,String amt,
                  String tax, String total,String opName,String oppID, String shipping) {

List<Id> oppIds = new List<Id>();
oppIds.add(oppID);
 
List<OpportunityLineItem> oppProds = [SELECT Quantity, UnitPrice, PricebookEntry.Brand__c, PricebookEntry.Category__c, TotalPrice, PricebookEntry.Name, 
PricebookEntry.ProductCode FROM OpportunityLineItem WHERE Opportunity.Id = :oppId];

system.debug('SELECT Quantity, UnitPrice, PricebookEntry.Brand__c, PricebookEntry.Category__c, TotalPrice, PricebookEntry.Name, PricebookEntry.ProductCode FROM OpportunityLineItem WHERE Opportunity.Id = '+oppId);

String hit='v=1&tid=UA-834138-17&cid='+cid+'&t=event&pa=purchase';
        hit=hit+'&ti='+orderID+'&tr='+total+'&tt='+tax+'&ts='+shipping;
        hit=hit+'&ec=Offline&ni=1&ta=Offline&ea=Transaction&el='+orderID;   

system.debug('partial hit');
system.debug(hit);


	if (oppProds.size()>0)
	{
	system.debug('before loop - line 37');
	            Integer i=1;
	    for (OpportunityLineItem li: oppProds ) 
	    {
	
	        String sku = EncodingUtil.urlEncode(li.PricebookEntry.ProductCode, 'UTF-8');
	        String prod_brand = EncodingUtil.urlEncode(li.PricebookEntry.Brand__c, 'UTF-8');
	        String prod_category = EncodingUtil.urlEncode(li.PricebookEntry.Category__c, 'UTF-8');
	        
	        String prod_name = EncodingUtil.urlEncode(li.PricebookEntry.Name, 'UTF-8');
	
	        system.debug('name='+prod_name);
	        
			String item='&pr'+i+'id='+sku+'&'+
	            'pr'+i+'nm='+prod_name+'&'+
	            'pr'+i+'br='+prod_brand+'&'+
	            'pr'+i+'ca='+prod_category+'&'+
	            'pr'+i+'pr='+li.UnitPrice+'&'+
	            'pr'+i+'qt='+li.Quantity;
	            system.debug('item='+item);
	        hit=hit+item;
	
	        i++;
	
	    }
	
	}
	System.debug(hit);
	 HttpRequest reqI = new HttpRequest();
	 reqI.setEndpoint('http://www.google-analytics.com/collect');
	 reqI.setMethod('POST');
	 reqI.setBody(hit);
	 Http httpI = new Http();
	 HTTPResponse resI = httpI.send(reqI);


}

}