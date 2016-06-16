# Step by Step Guide for natively integrating Salesforce.com with Google Analytics

Once this demo is setup, you will be able to use Google Analytics Measurement Protocol to send data from Opportunity and Contact objects into Google Analytics to track an event when an opportunity is closed. This event will also use Enhanced E-Commerce to track products associated with an opportunity and store both enhanced e-commerce transaction and enhanced e-commerce product line items in GA. 

Step 1 - Enable outbound calls from Salesforce

Setup->Security Controls->Remote Site Settings

add http://www.google-analytics.com address

Step 2 - add cid field to Contact object

Setup->Customize->Contacts->Fields->New

Add 30 character text field named 'cid'

Step 3 - add cid field to lead object

Setup->Customize->Leads->Fields->New

Add 30 character text field named 'cid'

Step 4 - You need to customize all your lead gen forms and processes, including marketing automation platforms such as Hubspot, Marketo, Eloqua, etc... to store Google Analytics visitor CID field in lead object.

landing_page.html file contains simple web2lead form along with sample code for extracting visitor ID from Google Analytics. 

Step 5 - map Lead.cid field to Contact.cid for lead conversion into a contact

Setup->Customize->Leads->Lead Custom Field Mapping

map cid to Contact.cid and click Save

Note: Most Salesforce environments are heavily customized so for the purposes of this code we made a few simplifications and assumptions. You can use this guide for reference and work with your Salesforce administrator/developer to make customizations if the object/field model does not match. For this demo we made the following assumptions/simplifications:

Assumption 1 - all e-commerce transaction data is stored in Opportunity object in the following fields:

- Order Number (Text)
- Sales Tax (Currency) - field name Sales_Tax__c
- Shipping (Currency) - field name shipping__c
- Order Total (Currency) - field name Order_Total__c - this field is a formula defined like this "Amount + Sales_Tax__c+shipping__c"

Assumption 2 - We are going to send an event to Google Analytics using Salesforce trigger when Opportunity Stage becomes "Closed Won"

The code for this trigger is defined in OpportunityStatus.tgr file.

Assumption 3 - We are going to use Products object to represent GA Transaction line items. 
To demonstrate how to send product Brand and product Category to Google Analytics we are going to create two custom fields
- Brand (Text) - field name Brand__c
- Category (Text) - field name Category__c

Assumption 4 - This is a very important assumption that most likely will need to be customized in production. The assumption is that we can grab cid (Google Analytics Visitor ID) from the first Contact Object associated with an Account Object associated with the Opportunity. For real production environment it may make sense to have a field on the Opportunity object that would allow us to track which Contact from the Account was the first person to initiate contact with the seller and should therefore get the credit if we want to attribute the sale to the first person whoever contacted seller's organization. Once you are comfortable with the setup, we encourage you to explore other scenarious for figuring out who should get the credit.

Step 6 - create Apex class to take data from Opportunity and Product Object and send to Google Analytics

Setup->Develop->Apex Classes->New
Copy from MyClosedWonEcommItems.cls

Step 7 - create trigger on Opportunity object when Stage is 'Closed Won' to load MyClosedWonEcommItems class that in turn will send the data to GA

Setup->Customize->Opportunities-Triggers
The code for this trigger is provided in OpportunityStatus.tgr file.

Step 8 - Right now UA number is hardcoded in MyClosedWonEcommItems.cls but you should replace this UA number with your GA UA Number. Assuming that you have 2 different UA numbers - production and staging, you can leverage the following code to dynamically switch where the data should be sent:

String ua='';
public static Boolean runningInASandbox() {
return [SELECT Id, IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }    
    
if (runningInASandbox()) 
{
  ua='<staging GA Account>';
}
else
{
  ua='<production GA Account>';
}

Now sit back and enjoy the ride. Any questions - contact InfoTrust Consulting team at salesforce@infotrustllc.com. We would love to hear from you - send us an email and share your implementation success stories
