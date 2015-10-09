global class JobFeedSFtoJiveBatchable implements Database.Batchable<sObject>, Database.AllowsCallouts{
	    
    global Set<Id> feedIds = new Set<Id>();
    
    global JobFeedSFtoJiveBatchable(Set<Id> feedIds) {
        this.feedIds = feedIds;
    }

   	global Database.QueryLocator start(Database.BatchableContext BC) {
      	return Database.getQueryLocator([SELECT Id, Name, fs_description__c, fs_url__c, rs_recipientAccount__c, rs_recipientLead__c FROM Feed__c WHERE Id IN :feedIds]);
    }

   	global void execute(Database.BatchableContext BC, List<Feed__c> scope) {
        Set<Id> accountIds = new Set<Id>();
    	Set<Id> leadIds = new Set<Id>();
        
        Map<Id, Account> accountMap = new Map<Id, Account>();
    	Map<Id, Lead> leadMap = new Map<Id, Lead>();
        String jiveActionJSON;
        
        for(Feed__c feed : scope) {
            if(feed.rs_recipientAccount__c != Null) {
                accountIds.add(feed.rs_recipientAccount__c);
            }
            else if(feed.rs_recipientLead__c != Null) {
                leadIds.add(feed.rs_recipientLead__c);
            }
        }
        
        if(accountIds.size() > 0) {
            for(Account acct : [SELECT Id, MBOAccess__c, fs_userName__pc FROM Account WHERE MBOAccess__c != false AND fs_userName__pc != Null and Id in : accountIds]) {
                accountMap.put(acct.Id, acct);
            }
        }
        
        if(leadIds.size() > 0) {
            for(Lead lead : [SELECT Id, MBOAccess__c, Username__c FROM Lead WHERE MBOAccess__c != false AND Username__c != null and Id in :leadIds]) {
                System.debug('Lead: ' + lead);
                leadMap.put(lead.Id, lead); 
            }
        }
         
//        List<Feed__c> feedToDelete = new List<Feed__c>();
        
        String JiveURL = JiveSettings__c.getValues('JiveURL').Value__c;
        
        for(Feed__c feed : scope) {
            
            String personUserName;
           
            if(feed.rs_recipientAccount__c != Null) {
                personUserName = accountMap.get(feed.rs_recipientAccount__c).fs_userName__pc;
            }
            else if(feed.rs_recipientLead__c != Null) {
                personUserName = leadMap.get(feed.rs_recipientLead__c).Username__c;
            }
            
            String JIVEPersonURL;
            String jiveResponse = '';
            
            JIVEPersonURL = JiveURL + '/people/username/'+ personUserName ;
            JIVEPersonURL +='?fields=ID,name.givenName,name.familyName,emails,tags,jive.profile.Title,';
            JIVEPersonURL +='jive.username&filter=search()';

            try {
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                String username = JiveSettings__c.getValues('Jive Username').Value__c; //'api01';
                String password = JiveSettings__c.getValues('Jive Password').Value__c;//'r8*&!$4*g40XpRsYUw0I';
                Blob headerValue = Blob.valueOf(username + ':' + password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Accept', 'application/json');
                req.setEndPoint(JIVEPersonURL);
                
                Http http = new Http();
                
                HTTPResponse res;
                
                if (!Test.isRunningTest()) { 
                	res = http.send(req);
                
                	jiveResponse = res.getBody();                    
                }
				else {
                	jiveResponse = '{  \"name\" : {    \"givenName\" : \"Api01\",    \"familyName\" : \"User01\",    \"formatted\" : \"Api01 User01\"  },  \"type\" : \"person\",  \"tags\" : [ \"testing\", \"developing\" ],  \"jive\" : {    \"username\" : \"stevej\",    \"profile\" : [ {      \"value\" : \"I work with the MBO as a salesforce developer.\",      \"jive_label\" : \"What do you do?\"    } ]  },  \"emails\" : [ {    \"value\" : \"webmaster@mbopartners.com\",    \"type\" : \"work\",    \"jive_label\" : \"Email\",    \"primary\" : true  } ],  \"id\" : \"12856\"}';
                }
                
                system.debug('jiveres: ' + jiveResponse);
                system.debug('feed: ' + feed);
                system.debug('URL: ' + JiveURL);
                JiveAction jiveAction = JobFeedSFToJiveBatchableHelper.generateJiveAction(jiveResponse, feed, JiveURL);
                
                if(jiveAction != Null) {
					jiveActionJSON = JobFeedSFToJiveBatchableHelper.serializeJiveAction(jiveAction);
                }
                
                system.debug('jiveActionJSON: '+ jiveActionJSON);
                
                if(jiveActionJSON != '') {
                    JIVEPersonURL = JiveURL + '/activities';
                    
                    HttpRequest req2 = new HttpRequest();
                    req2.setMethod('POST');
                    
                    req2.setHeader('Authorization', authorizationHeader);
                    req2.setHeader('Accept', 'application/json');
                    req2.setHeader('Content-Type', 'application/json');
                    req2.setEndPoint(JIVEPersonURL);
                    req2.setBody(jiveActionJSON);
                    
                    Http http2 = new Http();
                    HTTPResponse res2;
                    if (!Test.isRunningTest()) { 
                    	res2 = http2.send(req2);
                        jiveResponse = res2.getBody();
                        
                        system.debug('jiveResponse:' + jiveResponse);
                    	if(res2.getStatus() == 'Created') {
//							feedToDelete.add(feed);  
                    	}    
                    }
                    else {
//                    	feedToDelete.add(feed);    
                    }
                }
            }
            catch(Exception ex) {
                System.debug('Exception: ' + ex);   
            }
        }
        
//        if(feedToDelete.size() > 0) {
//        	delete feedToDelete;    
//        }
    }
        
   	global void finish(Database.BatchableContext BC){ 
   	}
}