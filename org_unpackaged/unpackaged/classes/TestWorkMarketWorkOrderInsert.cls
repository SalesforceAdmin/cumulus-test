@isTest
private class TestWorkMarketWorkOrderInsert {
    
    //Begin Helper Methods
    
    private static My_Biz_Office_User__c createMBOUser (){
        My_Biz_Office_User__c mboUser = new My_Biz_Office_User__c(
            Name = 'Sara Conde',
            Email__c = 'sconde@mbopartners.com',
            First_Name__c = 'Sara',
            Last_Name__c = 'Conde');
        insert mboUser;
        return mboUser;
    }
    
    private static Account createWMClient (String clientName, Id acctRtId, String companyId){
        Account wm = new Account(
            name = clientName,
            RecordTypeId = acctRtId,
            Type = 'Large Corporate',
            fb_MBO__c = TRUE,
            fs_wMProjId__c = string.valueOf(math.round(math.random()*(99999-11111))+11111),
            billingStreet = '123 Left Ln',
            billingCity = 'New York',
            billingState = 'NY',
            billingPostalCode = '10001',
            billingCountry = 'USA',
            Company_Number__c = string.valueOf(math.round(math.random()*(99999-11111))+11111),
            Activity_Status__c = 'Client',
            fs_wmCompanyId__c = companyId);
        insert wm;
        return wm;
    }   

    private static Account createWMAssociate (String fName, String lName, Id acctRtId, Id mboUser){
        Account assoc = new Account(
            firstName = fName,
            lastName = lName,
            RecordTypeId = acctRtId,
            personEmail = fName + '.' + lName+'@mbopartners.com',
            Phone = '7037936000',
            personMailingStreet = '123 Left Ln',
            personMailingCity = 'New York',
            personMailingState = 'NY',
            personMailingPostalCode = '10001',
            personMailingCountry = 'USA',
            Contact_Status__pc = 'Associate',
            Enrollment_Manager__pc = mboUser,
            Associate_Number__pc = string.valueOf(math.round(math.random()*(99999-11111))+11111),
            Associate_Status__pc = 'Active',
            Business_Manager__pc = mboUser);
        insert assoc;
        return assoc;
    }   

    private static Opportunity createOpportunity(String opName, Id assocId, String wmId, Id rtId, boolean b){
        System.debug('Associate Id: '+assocId);
        System.debug('wmId: '+wmId);
        Opportunity o = new Opportunity(
            name = opName,
            AccountId = assocId,
            fn_pUnitCost__c = 50.00,
            fs_woStart__c = Date.today(),
            fs_woEnd__c = Date.today()+5,
            CloseDate = Date.today()+5,
            StageName = 'Pending',
            fs_wmAssignmentId__c = '123456789',
            fs_pricingType__c = 'Flat Fee',
            fs_wmCompanyId__c = wmId,
            RecordTypeId = rtId, rs_client__c=null);

	        System.debug('Opportunity Id: '+o.Id);
	        System.debug('Opportunity Name: '+o.name);
	        System.debug('Opportunity Company Id: '+o.fs_wmCompanyId__c);
	        System.debug('Opportunity Account: '+o.accountId);
	        System.debug('Before Insert - Opportunity Client: '+o.rs_client__c);
        if(b){
            insert o;
            o = [select Id, Name, AccountId, fn_pUnitCost__c, fs_woStart__c, fs_woEnd__c, CloseDate, StageName, fs_wmAssignmentId__c, fs_pricingType__c, fs_wmCompanyId__c, RecordTypeId, rs_client__c from Opportunity where Id = :o.Id];
            System.debug('After Insert - Opportunity Client: '+o.rs_client__c);
            return o;
        }else{
            return o;
        }
    }

    //End Helper Methods
    
    
    //Create single opportunity and assign a client
    static testmethod void testClientAssignment(){
        test.startTest();
        //Populate any required data
        Id woId = util.getRecordTypeId('Opportunity','Work_Order');
        Id coId = util.getRecordTypeId('Account','ES_Client');
        Id assocId = util.getRecordTypeId('Account','Partners_Associate');
        My_Biz_Office_User__c mboUser = createMBOUser();
        System.debug('MBO User Id: '+mboUser.Id);
        Account wm = createWMClient('Work Market',coId,'1');
        System.Debug('Work Market Id: '+wm.Id);
        Account client = createWMClient('Client a',coId,'987654321');
        System.debug('Client Id: '+client.Id);
        Account assoc = createWMAssociate('John','Smith',assocId,mboUser.Id);
        System.Debug('Associate Id: '+assoc.Id);

        //Test to ensure the correct client is set
        Opportunity match = createOpportunity('New Job',assoc.Id, '987654321',woId,TRUE);
        System.debug('Opportunity Id: '+match.Id);
        System.debug('Opportunity Name: '+match.name);
        System.debug('Opportunity Company Id: '+match.fs_wmCompanyId__c);
        System.debug('Opportunity Account: '+match.accountId);
        System.debug('Opportunity Client: '+match.rs_client__c);
        test.stopTest();
        system.assertEquals(client.Id, match.rs_client__c);
    }

/*
    //Create single opportunity and assign Work Market
    static testmethod void testWorkMarketAssignment(){
        //Build test accounts and opportunities
        Account wm = createWMClient('Work Market','1');
        Account client = createWMClient('Client a','987654321');
        Opportunity mismatch = createOpportunity('New Job2', null, true);

        //Debug
        system.debug(wm);
        system.debug(client);
        system.debug(mismatch);
        
        //Test to ensure the correct client is set
        test.startTest();
        System.assertEquals(mismatch.rs_client__c, client.Id);
        test.stopTest();
    }
    
    //Create batch of opportunities with client or Work Market as client
    static testmethod void testBatchAssignment(){
        //Build test accounts
        Account wm = createWMClient('Work Market','1');
        Account client = createWMClient('Client a','987654321');
      
        //Build batch of opportunities
        List<Opportunity> opList = new List<Opportunity>();
        for(integer i =1;i<=250;i++){
            Opportunity opp = new Opportunity();
            if(math.mod(i,2)>0){
                opp = createOpportunity('Opportunity' + i, '987654321', false);
            }else{
                opp = createOpportunity('Opportunity' + i, null, false);
            }
            opList.add(opp);
        }
        insert opList;

        //Debug
        system.debug(wm);
        system.debug(client);
        system.debug(opList.size());
        system.debug(opList[10]);
                
        //Test that all opportunities have the right client set
        for(Opportunity o: opList){
            Test.startTest();
            system.assert(o.rs_client__c == client.Id || o.rs_client__c == wm.Id);
            Test.stopTest();
        }
    }
*/
}