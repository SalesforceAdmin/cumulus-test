@isTest (seeAllData = false)
public class testAlumniReferral {

    static testMethod void singleLeadInsert() {
        //// Create Test Data
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        // Get Associate Record Type
        Id assocRTID = util.getRecordTypeId('Lead', 'Direct_Associate');
        // Build single lead with the correct code for insert
        Lead ldA = new Lead (LastName='TestA', email='testA@mbopartners.com',Alumni_Referrer__c=acct.Id, Status='New', RecordTypeId=assocRTID);
        // Build a single lead with the incorrect code for insert
        Lead ldB = new Lead (LastName='TestB', email='testB@mbopartners.com',Alumni_Referrer__c='001M000000jKlomp04', Status='New', RecordTypeId=assocRTID);
        // Build a single lead with no code for insert
        Lead ldC = new Lead (LastName='TestC', email='testC@mbopartners.com', Status='New', RecordTypeId=assocRTID);
        // Add leads to list for insert
        List<Lead> ldList = new List<Lead>();
        ldList.add(ldA);
        ldList.add(ldB);
        ldList.add(ldC);
        
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-60, EndDate=System.today()-30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        //// Run Tests
        // Initiate test class
        test.startTest();
        // Insert Leads
        insert ldList;
        // End Test
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[0].Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==1);
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[1].Id AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==1);
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[2].Id AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId IN (:ldList[0].Id, :ldList[1].Id, :ldList[2].Id) AND CampaignId=:oldCmp.Id]==0);
    }
    
    static testMethod void singleLeadUpdate() {
        //// Create Test Data
        // Get Associate Record Type
        Id assocRTID = util.getRecordTypeId('Lead', 'Direct_Associate');
        // Build single lead with the correct code for insert
        Lead ldA = new Lead (LastName='TestA', email='testA@mbopartners.com', RecordTypeId=assocRTID);
        // Build a single lead with the incorrect code for insert
        Lead ldB = new Lead (LastName='TestB', email='testB@mbopartners.com', RecordTypeId=assocRTID);
        // Build a single lead with no code for insert
        Lead ldC = new Lead (LastName='TestC', email='testC@mbopartners.com', RecordTypeId=assocRTID);
        // Add leads to list for insert
        List<Lead> ldList = new List<Lead>();
        ldList.add(ldA);
        ldList.add(ldB);
        ldList.add(ldC);
        
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        // Create Leads to test
        Insert ldList;
        // Set New Values for Leads
        ldList[0].Alumni_Referrer__c=acct.Id;
        ldList[1].Alumni_Referrer__c='001M000000jKlomp04';
        ldList[2].Alumni_Referrer__c='';
        
        //// Run Tests
        // Initiate test class
        test.startTest();
        // Update the leads
        Update ldList;
        // End test class
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[0].Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==1);
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[1].Id AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==1);
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId=:ldList[2].Id AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId IN (:ldList[0].Id, :ldList[1].Id, :ldList[2].Id) AND CampaignId=:oldCmp.Id]==0);
    }
    
    static testMethod void singleAccountUpdate() {
        //// Create Test Data
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        
        // Get Associate Record Type
        Id assocRTID = util.getRecordTypeId('Account', 'Partners_Associate');
        // Build single account with the correct code for insert
        Account acctA = new Account (LastName='TestA', personemail='testA@mbopartners.com', Contact_Status__pc='Associate', RecordTypeId=assocRTID);
        // Build a single account with the incorrect code for insert
        Account acctB = new Account (LastName='TestB', personemail='testB@mbopartners.com', Contact_Status__pc='Associate', RecordTypeId=assocRTID);
        // Build a single account with no code for insert
        Account acctC = new Account (LastName='TestC', personemail='testC@mbopartners.com', Contact_Status__pc='Associate', RecordTypeId=assocRTID);
        // Add Accounts to list for insert
        List<Account> acctList = new List<Account>();
        acctList.add(acctA);
        acctList.add(acctB);
        acctList.add(acctC);
        // Create Accounts
        insert acctList;
        // Set new values for accounts
        acctList[0].Alumni_Referrer__pc=acct.Id;
        acctList[1].Alumni_Referrer__pc='001M000000jKlomp04';
        acctList[2].Alumni_Referrer__pc='';
        
        //// Run Tests
        // Initiate Test Class
        test.startTest();
        // Update Account List
        update acctList;
        // End Test Class
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.AccountId=:acctList[0].Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==1);
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.AccountId=:acctList[1].Id AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==1);
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.AccountId=:acctList[2].Id AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.AccountId IN (:acctList[0].Id, :acctList[1].Id, :acctList[2].Id) AND CampaignId=:oldCmp.Id]==0);
    }
    
    /*
     * *** Batch Tests *** *
     */
    
    static testMethod void batchLeadInsert() {
        //// Create Test Data
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        
        // Generate a list of Leads
        List<Lead> ldList = DataWarehouse.assocLeads(250);
        List<Lead> ldList2 = new List<Lead>();
        // Create lists of leads by referral code
        List<Lead> ldListCorrect = new List<Lead>();
        List<Lead> ldListIncorrect = new List<Lead>();
        // Loop through the list
        for (Lead ld : ldList){
            if(math.mod(Integer.valueOf(ld.LastName.right(ld.LastName.length()-4)), 3) == 0) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 0
                ld.Alumni_Referrer__c=acct.Id;
                ldList2.add(ld);
                ldListCorrect.add(ld);
            } else if (math.mod(Integer.valueOf(ld.LastName.right(ld.LastName.length()-4)), 3) == 1) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 1
                ld.Alumni_Referrer__c='001M000000jKlomp04';
                ldList2.add(ld);
                ldListIncorrect.add(ld);
            } else {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 2
                ld.Alumni_Referrer__c='';
                ldList2.add(ld);
            }
        }
        
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        //// Run Tests
        // Initiate test class
        test.startTest();
        // Insert Leads
        insert ldList2;
        // End Test
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.Debug(LoggingLevel.Error,'Query Size: '+[SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c=:acct.Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]);
        System.Debug(LoggingLevel.Error,'List Size: '+ldListCorrect.size());
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c=:acct.Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==ldListCorrect.size());
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c='001M000000jKlomp04' AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==ldListIncorrect.size());
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c='' AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId IN :ldList2 AND CampaignId=:oldCmp.Id]==0);
    }
    
    static testMethod void batchLeadUpdate() {
        //// Create Test Data
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        
        // Generate a list of Leads
        List<Lead> ldList = DataWarehouse.assocLeads(250);
        Set<Id> ldID = new Set<Id> ();
        // Insert Lead List
        Insert ldList;
        // Create ldList by referrer code
        set<id> ldListCorrect = new Set<Id>();
        set<id> ldListIncorrect = new Set<Id>();
        // Loop through the list
        for (Lead ld : ldList){
            if(math.mod(Integer.valueOf(ld.LastName.right(ld.LastName.length()-4)), 3) == 0) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 0
                ld.Alumni_Referrer__c=acct.Id;
                ldID.add(ld.Id);
                ldListCorrect.add(ld.Id);
            } else if (math.mod(Integer.valueOf(ld.LastName.right(ld.LastName.length()-4)), 3) == 1) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 1
                ld.Alumni_Referrer__c='001M000000jKlomp04';
                ldID.add(ld.Id);
                ldListIncorrect.add(ld.Id);
            } else {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 2
                ld.Alumni_Referrer__c='';
                ldID.add(ld.Id);
            }
        }
        
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        //// Run Tests
        // Initiate test class
        test.startTest();
        // update Leads
        update ldList;
        // End Test
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c=:acct.Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==ldListCorrect.size());
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c='001M000000jKlomp04' AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==ldListIncorrect.size());
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE Lead.Alumni_Referrer__c='' AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE LeadId IN :ldID AND CampaignId=:oldCmp.Id]==0);
    }
    
    static testMethod void batchAccountUpdate() {
        //// Create Test Data
        // Get Company Record Type
        Id compRTID = util.getRecordTypeId('Account', 'ES_Client');
        // Build and insert account with Referrer ID
        Account acct = new Account (Name='Account', RecordTypeId=compRTID, Activity_Status__c='New', Type='Large Corporate', Tier__c='5');
        insert acct;
        // Generate a list of Accounts
        List<Account> acctList = DataWarehouse.assocAccount(250);
        Set<Id> acctID = new Set<Id> ();
        // Insert Account List
        Insert acctList;
        // Create acctList by referrer code
        set<id> acctListCorrect = new Set<id>();
        set<id> acctListIncorrect = new Set<Id>();
        // Loop through the list
        for (Account a: acctList){
            if(math.mod(Integer.valueOf(a.LastName.right(a.LastName.length()-4)), 3) == 0) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 0
                a.Alumni_Referrer__pc=acct.Id;
                acctId.add(a.Id);
                acctListCorrect.add(a.Id);
            } else if (math.mod(Integer.valueOf(a.LastName.right(a.LastName.length()-4)), 3) == 1) {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 1
                a.Alumni_Referrer__pc='001M000000jKlomp04';
                acctID.add(a.Id);
                acctListIncorrect.add(a.Id);
            } else {
                // Set the Alumni Referrer value for those divided by 3 with a remainder of 2
                a.Alumni_Referrer__pc='';
                acctID.add(a.Id);
            }
        }
        
        // Retrieve a Current Referral Campaign to associate with
        Campaign curCmp = DataWarehouse.childCampaign('Client Alumni Referral Program', 'Referral Programs');
        // Create Member Statuses for curCmp
        CampaignMemberStatus curCMS = new CampaignMemberStatus(CampaignId=curCmp.Id,Label='Inserted',IsDefault=TRUE,SortOrder=0);
        Insert curCMS;
        
        // Retrieve an Old Referral Campaign not to associate with
        Campaign oldCmp;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY LIMIT 1]==1){
            // If one exists use that one
            oldCmp = [SELECT Id FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate < TODAY AND EndDate < TODAY ORDER BY CreatedDate Asc LIMIT 1];
        } ELSE {
            // Else create one
            oldCmp = new Campaign (Name = 'Client Alumni Referral Program ('+system.string.valueOf(system.today().year()-1)+')', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), 
                                   IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs', parentId=DataWarehouse.parentCampaign().Id);
            Insert oldCmp;
        }
        // Create Members Status for oldCmp
        CampaignMemberStatus oldCMS = new CampaignMemberStatus(CampaignId=oldCmp.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
        Insert oldCMS;
        
        //// Run Tests
        // Initiate test class
        test.startTest();
        // update Leads
        update acctList;
        // End Test
        test.stopTest();
        
        //// Check Assertions
        // For correct code was a campaign member created with the account
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.Alumni_Referrer__c=:acct.Id AND Associated_Account__c=:acct.Id AND CampaignId=:curCmp.Id]==acctListCorrect.size());
        // For incorrect code was a campaign member created with no account
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.Alumni_Referrer__c='001M000000jKlomp04' AND Associated_Account__c=null AND CampaignId=:curCmp.Id]==acctListIncorrect.size());
        // For no code was no campaign member created
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.Alumni_Referrer__c='' AND CampaignId=:curCmp.Id]==0);
        // No Campaign Members were created under the old Campaign
        System.assert([SELECT count() FROM CampaignMember WHERE Contact.AccountId IN :acctID AND CampaignId=:oldCmp.Id]==0);
    }
    
}