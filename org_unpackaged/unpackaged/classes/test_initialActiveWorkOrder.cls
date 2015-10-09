@isTest (seeAllData=false)
public class test_initialActiveWorkOrder {
    /* 
     * * *** Single Test Methods *** 
     */
    
    //// Opportunity inserted to meet criteria
    static testMethod void insertMeetsCriteria(){
        //// Build test data
        // Instantiate Account
        Account acct = new Account(LastName = 'Test Account', Phone = '1234567890', recordTypeId = util.getRecordTypeId('Account', 'Partners_Associate'));
        // Create Account
        insert acct;
        // Instantiate Opportunity
        Opportunity op = new Opportunity(Name = 'Test Opportunity', StageName = 'Active', CloseDate = system.date.today(), recordTypeId = util.getRecordTypeId('Opportunity', 'Work_Order'), AccountId = acct.Id);
        
        //// Execute tests
        // start test
        test.startTest();
        // Insert Opportunity
        insert op;
        // end test
        test.stopTest();
        
        //// Confirm tests
        // Confirm the active work order is set as the Initial Work Order for the parent account
        Id iniWO = [SELECT Id, Initial_Work_Order__c FROM Account a WHERE a.Id = :acct.Id].Initial_Work_Order__c;
        System.assert(iniWO == op.Id);
    }
    
    //// Opportunity updated to meet criteria
    static testMethod void updateMeetsCriteria(){
        //// Build test data
        // Get MBO Admin User
        User mboAdmin = [SELECT Id FROM User WHERE UserName LIKE 'mboadmin@mbopartners.com%'];
        // Instantiate Account
        Account acct = new Account(LastName = 'Test Account', Phone = '1234567890', recordTypeId = util.getRecordTypeId('Account', 'Partners_Associate'));
        // Create Account
        insert acct;
        // Instantiate Opportunity
        Opportunity op = new Opportunity(Name = 'Test Opportunity', StageName = 'Pending', CloseDate = system.date.today(), recordTypeId = util.getRecordTypeId('Opportunity', 'Work_Order'), AccountId = acct.Id);
        // Create Opportunity
        insert op;
        // Change StageName to Active
        op.StageName = 'Active';
        
        //// Execute tests
        // start test
        test.startTest();
        // Act as admin
        System.runAs(mboAdmin){
            // Insert Opportunity
            update op;
        }
        // end test
        test.stopTest();
        
        //// Confirm tests
        // Confirm the active work order is set as the Initial Work Order for the parent account
        Id iniWO = [SELECT Id, Initial_Work_Order__c FROM Account a WHERE a.Id = :acct.Id].Initial_Work_Order__c;
        System.assert(iniWO == op.Id);
    }
    
    //// Opportunity doesn't meet criteria
    static testMethod void notMeetsCriteria(){
        //// Build test data
        // Instantiate Account
        Account acct = new Account (LastName = 'Test Account', Phone = '1234567890', recordTypeID = util.getRecordTypeId('Account', 'Partners_Associate'));
        // Instantiate Account with Initial Work Order already set
        Account acct2 = new Account (LastName = 'Test Account 2', Phone = '1234567890', recordTypeId = util.getRecordTypeId('Account', 'Partners_Associate'));
        // Create Accounts
        insert acct;
        insert acct2;
        // Instantiate Opportunity of wrong stage
        Opportunity opStage = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Pending', CloseDate = system.date.today(), recordTypeId = util.getRecordTypeId('Opportunity', 'Work_Order'), AccountId = acct.Id);
        // Instantiate Opportunity of wrong record type
        Opportunity opRT = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Active', CloseDate = system.date.today(), recordTypeId = util.getRecordTypeId('Opportunity', 'Client_Contract'), AccountId = acct.Id);
        // Instantiate Opportunity with account already set
        Opportunity opAcct = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Active', CloseDate = system.date.today(), recordTypeId = util.getRecordTypeId('Opportunity', 'Work_Order'), AccountId = acct2.Id);
        
        //// Begin Tests
        // start test
        test.startTest();
        // Test Opportunity with incorrect stage
        insert opStage;
        // Test Opportunity with incorrect record type
        insert opRT;
        // Set a prior Opportunity in the Initial_Work_Order__c field so it doesn't set overwritten
        acct2.Initial_Work_Order__c = opStage.Id;
        Update acct2;
        // Test Opportunity with parent account already set
        insert opAcct;
        // end test
        test.stopTest();
        
        //// Confirm tests
        // confirm the account did not set the opportunity with the wrong stage nor with the wrong record type
        Integer acctSize = [SELECT count() FROM Account WHERE Id = :acct.Id AND Initial_Work_Order__c IN (:opStage.Id, :opRT.Id)];
        system.assert( acctSize == 0);
        // confirm the opportunity with an account that is already set did not get set
        Integer acct2Size = [SELECT count() FROM Account WHERE Id = :acct2.Id AND Initial_Work_Order__c = :opAcct.Id];
        system.assert (acct2Size == 0);
    }
    
    /*
     * * *** Batch Test Methods ***
     */
    
    //// Opportunities inserted meet criteria
    static testMethod void insertBatchMeetsCriteria(){
        //// Build test data
        // Instantiate Account List and single account
        Account acct = new Account (LastName = 'test account', Phone = '1234567890', recordTypeId = util.getRecordTypeId('Account', 'Partners_Associate'));
        List<Account> acctList = DataWarehouse.assocAccount(250);
        // Create Account List and single account
        insert acctList;
        insert acct;
        // Instantiate Opportunity Lists
        List<Opportunity> singleOpList = DataWarehouse.workOrderOpportunity(250);
        List<Opportunity> opList = DataWarehouse.workOrderOpportunity(250);
        // Set the account for all singleOpList opportunities to each account
        for (Opportunity o :singleOpList){
            o.accountId = acct.Id;
            o.stageName = 'Active';
        }
        // Set the opList opportunities account to one from acctList
        for (integer i = 0; i < 250; i++){
            opList[i].accountId = acctList[i].Id;
            opList[i].stageName = 'Active';
        }
        
        //// Begin tests
        // start test
        test.startTest();
        // test inserting 200+ opportunities to 1 account sets the account appropriately
        insert singleOpList;
        // test inserting 200+ opportunities to 200+ accounts sets the account appropriately
        insert opList;
        // end test
        test.stopTest();
        
        //// Begin Assertions
        // Assert that inserting 200+ opportunities to 1 account set the account appropriately
        Set<ID> opSet = new Set<Id>();
        for (Opportunity o :singleOpList){
            opSet.add(o.Id);
        }
        Integer acctSize = [SELECT count() FROM Account WHERE Id = :acct.Id AND Initial_Work_Order__c IN :opSet];
        system.assert(acctSize== 1);
        // Assert that inserting 200+ opportunities to 200+ accounts sets each account appropriately
        Map<Id, Opportunity> opMap = new Map<Id,Opportunity>(opList);
        for (Account a :[SELECT Id, Initial_Work_Order__c FROM Account WHERE Id IN :acctList]){
            System.assert(opMap.get(a.Initial_Work_Order__c).AccountId == a.Id);
        }
    }
    
    //// Opportunities updated to meet criteria
    static testMethod void updateBatchMeetsCriteria() {
        //// Build test data
        // Get MBO Admin User
        User mboAdmin = [SELECT Id FROM User WHERE UserName LIKE 'mboadmin@mbopartners.com%'];
        // Instantiate Account List and single account
        Account acct = new Account (LastName = 'test account', Phone = '1234567890', recordTypeId = util.getRecordTypeId('Account', 'Partners_Associate'));
        List<Account> acctList = DataWarehouse.assocAccount(250);
        // Create Account List and single account
        insert acctList;
        insert acct;
        // Instantiate Opportunity Lists
        List<Opportunity> singleOpList = DataWarehouse.workOrderOpportunity(250);
        List<Opportunity> opList = DataWarehouse.workOrderOpportunity(250);
        // Set the account for all singleOpList opportunities to each account
        for (Opportunity o :singleOpList){
            o.accountId = acct.Id;
        }
        // Create singleOpList
        insert singleOpList;
        // Set the stageName to active on singleOpList
        for (Opportunity o :singleOpList){
            o.stageName = 'Active';
        }
        // Set the opList opportunities account to one from acctList
        for (integer i = 0; i < 250; i++){
            opList[i].accountId = acctList[i].Id;
        }
        // Create opList
        insert opList;
        // Set the stageName to active on opList
        for (Opportunity o :opList){
            o.stageName = 'Active';
        }
        
        //// Begin tests
        // start test
        test.startTest();
        // Run as MBO Admin
        system.runAs(mboAdmin){
            // test updating 200+ opportunities to 1 account sets the account appropriately
            update singleOpList;
            // test updating 200+ opportunities to 200+ accounts sets the account appropriately
            update opList;
        }
        // end test
        test.stopTest();
        
        //// Begin Assertions
        // Assert that inserting 200+ opportunities to 1 account set the account appropriately
        Integer acctSize = [SELECT count() FROM Account WHERE Id = :acct.Id AND Initial_Work_Order__c = :singleOpList[0].id];
        system.assert(acctSize == 1);
        // Assert that inserting 200+ opportunities to 200+ accounts sets each account appropriately
        Map<Id, Opportunity> opMap = new Map<Id,Opportunity>(opList);
        for (Account a :[SELECT Id, Initial_Work_Order__c FROM Account WHERE Id IN :acctList]){
            System.assert(opMap.get(a.Initial_Work_Order__c).AccountId == a.Id);
        }
    }
    
}