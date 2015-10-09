trigger WorkMarketWorkOrderInsert on Opportunity (before insert) {

	set<String> wmCompanyIds = new set<String>{};
	list<Opportunity> opps = new list<Opportunity>{};

    //Get Work_Order Record Type Id
    Id woRtId = Util.getRecordTypeId('Opportunity', 'Work_Order');

    for (Opportunity wo : trigger.new) {
    	if (wo.recordTypeId == woRtId && wo.rs_client__c == null && wo.fs_mboRecordId__c == null) {
    		if (wo.fs_wmCompanyId__c == null) {
    			wo.rs_client__c = AccountHelper.WorkMarketClient.Id;
    		} else {
    			opps.add(wo);
    			wmCompanyIds.add(wo.fs_wmCompanyId__c);
    		}
    	}
    }

    if (!wmCompanyIds.isEmpty()) {
	    //Build map of Account Ids which have any of the wmCompany Ids from the insert
	    map<String, Account> mapWMCompanyId_To_Account = new map<String, Account>();

	    for (Account acct : [SELECT Id, fs_wmCompanyId__c FROM Account WHERE fs_wmCompanyId__c IN : wmCompanyIds]) {
	    	mapWMCompanyId_To_Account.put(acct.fs_wmCompanyId__c, acct);
	    }

	    for (Opportunity wo : opps) {
	    	if (mapWMCompanyId_To_Account.containsKey(wo.fs_wmCompanyId__c)) {
	    		wo.rs_client__c = mapWMCompanyId_To_Account.get(wo.fs_wmCompanyId__c).Id;
	    	} else {
	    		wo.rs_client__c = AccountHelper.WorkMarketClient.Id;	
	    	}
	    }
    }

/*
    //Set WM Client to Variable
    sObject sobj = [SELECT Id, Name FROM Account where fs_wmCompanyId__c = '1'];
    Account wm = (Account)sobj;
    
    //Get Work_Order Record Type Id
    Id woRtId = Util.getRecordTypeId('Opportunity', 'Work_Order');
    
    //Build list of wmCompany Ids inserted
    List<string> woIdList = new List<String>();
    List<Opportunity> woList = new List<Opportunity>();
    for(Opportunity wo : trigger.new){
        if(wo.recordTypeId == woRtId && wo.rs_client__c == null && wo.fs_wmCompanyId__c != null && wo.fs_mboRecordId__c == null){
            woIdList.add(wo.fs_wmCompanyId__c);
            woList.add(wo);
        }
        //If WMCompanyId is missing then set the Work Market account ID
        else if(wo.recordTypeId == woRtId && wo.rs_client__c == null && wo.fs_wmCompanyId__c == null && wo.fs_mboRecordId__c == null){
            System.debug('Matching ' + wm.Name + ' to ' + wo.Name + ' because there is no value for fs_wmCompanyId__c');
            wo.rs_client__c = wm.Id;
            System.debug('Opportunity Client: '+wo.rs_client__c);
        }
    }
    
    //Build map of Account Ids which have any of the wmCompany Ids from the insert
    Map<String, Account> acctMap = new Map<String, Account>();
    for(Account a : [SELECT Id, Name, fs_wmCompanyId__c 
                     FROM Account
                     WHERE fs_wmCompanyId__c 
                     IN : woIdList]){
                         acctMap.put(a.fs_wmCompanyId__c, a);
                     }
    
    //Set the identified Account Id on the inserted opportunity
    for(Opportunity wo : woList){
        if(acctMap.containsKey(wo.fs_wmCompanyId__c)){
            Account a = acctMap.get(wo.fs_wmCompanyId__c);
            System.debug('Matching ' + a.Name + ' to ' + wo.Name + ' on ' + wo.fs_wmCompanyId__c);
            wo.rs_client__c = a.Id;
            System.debug('Opportunity Client: '+wo.rs_client__c);
        }else{
            System.debug('Matching ' + wm.Name + ' to ' + wo.Name + ' on ' + wo.fs_wmCompanyId__c);
            wo.rs_client__c = wm.Id;
            System.debug('Opportunity Client: '+wo.rs_client__c);
        }
    }
*/    
}