@isTest (seeAllData=False)
public class DataWarehouse {
    /*
     * *** Lead Warehouse ***
     */
    //// Create a collection of Leads
    public static List<Lead> assocLeads (Integer count) {
        // Instantiate list of leads
        List<Lead> ldList = new List<Lead>();
        // Get Associate RTID
        Id assocRTID = util.getRecordTypeId('Lead', 'Direct_Associate');
        // Iterate through the count variable
        for (Integer i = 0; i < count; i++){
            // Instantiate Lead
            Lead ld = new Lead (LastName='test'+i, Email='test'+i+'@mbopartners.com', recordTypeId=assocRTID);
            // Add to list
            ldList.add(ld);
        }
        // Return the list
        return ldList;
    }
    
    /*
     * *** Account Warehouse ***
     */
    //// Create a collection of Company Accounts
    public static List<Account> compAccount (Integer count) {
        // Instantiate list of accounts
        List<Account> acctList = new List<Account>();
        // Get Company RTID
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Iterate through the count variable
        for (Integer i = 0; i < count; i++){
            // Instantiate Account
            Account acct = new Account (Name='testAccount'+i, Activity_Status__c = 'New', Type = 'Large Corporate', Tier__c='5', RecordTypeId=compRTID);
            // Add account to account List
            acctList.add(acct);
        }
        // Return the account list
        return acctList;
    }
    
    //// Create a collection of Associate Accounts
    public static List<Account> assocAccount (Integer count) {
        // Instantiate a list of accounts
        List<Account> acctList = new List<Account>();
        // Get the Associate RTID
        Id assocRTID = util.getRecordTypeId('Account', 'Partners_Associate');
        // Iterate through the count variable
        for (Integer i = 0; i < count; i++){
            // Instantiate an Account
            Account acct = new Account (LastName='test'+i, RecordTypeId=assocRTID, PersonEmail='test'+i+'@mbopartners.com', Contact_Status__pc='Associate');
            // Add account to the account list
            acctList.add(acct);
        }
        // Return the account list
        return acctList;
    }
    
    /*
     * *** Opportunity Warehouse ***
     */
    //// Create a work order
    public static list<Opportunity> workOrderOpportunity (Integer count) {
        // Find record type
        Id woRT = util.getRecordTypeId('Opportunity', 'Work_Order');
        // Get today's date
        Date close = System.date.today();
        // Instantiate list
        List<opportunity> opList = new List<opportunity>();
        // Iterate through the count variable
        for (Integer i = 0; i < count; i++){
            // Instantiate an opportunity
            Opportunity op = new Opportunity (Name='test'+i, RecordTypeId = woRT, StageName = 'Pending', CloseDate = close);
            // Add Opportunity to list
            opList.add(op);
        }
        // Return the opportunity list
        Return opList;
    }
        
    /*
     * *** Campaign Warehouse ***
     */
    
    //// Create a parent Campaign
    public static Campaign parentCampaign () {
        Campaign c = new Campaign();
        // See if a parent campaign exists
        IF([SELECT count() FROM Campaign WHERE Name LIKE 'MBO-Hosted Campaigns' LIMIT 1]==1 ){
            // Take ID of existing parent campaign
            c=[SELECT Id, Name, Type, Status, RecordTypeId FROM Campaign WHERE Name LIKE 'MBO-Hosted Campaigns' LIMIT 1];
        } else {
            // Assign values to the parent campaign
            c.Name='MBO-Hosted Campaigns';
            c.Type='MBO Independent';
            c.Status='In Progress';
            c.RecordTypeId=Util.getRecordTypeId('Campaign','Child');
            // Create the parent campaign
            insert c;
        }
        // Return Parent Campaign
        return c;
    }

    //// Create a child Campaign
    public static Campaign childCampaign (String cmpName, String cmpType) {
        Campaign curCmp;
        // See if a child campaign exists
        IF([SELECT Count() FROM Campaign WHERE Name LIKE :cmpName+'%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY LIMIT 1]==1){
            // Set current campaign to variable
            curCmp = [SELECT Id FROM Campaign WHERE Name LIKE :cmpName AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY ORDER BY CreatedDate Desc LIMIT 1];
        } ELSE {
            // Create new current campaign
            curCmp = new Campaign (Name = cmpName+'('+system.string.valueOf(system.today().year())+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type=cmpType);
            // Create a parent campaign and set it as current campaign's parent
            curCmp.parentId = parentCampaign().Id;
            // Create the current campaign
            insert curCmp;
        }
        // return the current campaign
        return curCmp;
    }
    
    //// Create a number of MBO Hosted Campaigns
    public static List<Campaign> childCampaign (Integer count) {
        // Setup the Parent Campaign
        Campaign cmpParent = parentCampaign();
        // Get Child Record Type
        Id cmpChild = Util.getRecordTypeId('Campaign','Child');
        // Create List of new Campaigns
        List<Campaign> cList = new List<Campaign>();
        for (Integer i=0; i<count; i++){
            Campaign c = new Campaign(Name='Campaign '+i, Type='MBO Email', Status='In Progress', RecordTypeId=cmpChild, parentId=cmpParent.Id);
            cList.add(c);
        }
        // Return list of Campaigns
        return cList;
    }
}