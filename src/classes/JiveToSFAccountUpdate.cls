global class JiveToSFAccountUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts{
	global final String Query;
   	global final String Entity;
 
   	global JiveToSFAccountUpdate() {
      	Query='SELECT Id, FirstName, LastName, fs_userName__pc, PersonEmail, PersonTitle, fs_industryExpertise__pc,  fs_skills__pc, fs_overview__pc, fs_facebook__pc, fs_twitter__pc, fs_linkedin__pc ' +
              'FROM Account WHERE fs_userName__pc != Null'; 
        Entity= 'Account';
   	}

   	global Database.QueryLocator start(Database.BatchableContext BC) {
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        jivesetting.Value__c = 'true';
        update jivesetting;
        
      	return Database.getQueryLocator(query);
   	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
        
        List<Account> accountsToUpdate = new List<Account>();
        String JIVEPersonURL ;
        String JiveURL = JiveSettings__c.getValues('JiveURL').Value__c;
        
        System.debug('scope: ' + scope);
         
        for(Account accRec : scope ) {   
            String jiveResponse = '';
            //JivePersonList deserialPersonList = new JivePersonList();
        
            JIVEPersonURL = JiveURL + '/people/username/'+ accRec.fs_userName__pc;
            JIVEPersonURL +='?fields=ID,name,emails,tags,jive.profile.Title,';
            JIVEPersonURL +='jive.profile.Facebook,jive.profile.Twitter,jive.profile.LinkedIn,jive.profile.What%20do%20you%20do?,jive.username&filter=search()';
            
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
                
                if (!Test.isRunningTest()) { 
                    HTTPResponse res = http.send(req);
                    if(res.getStatus() == 'OK') {
                        jiveResponse = res.getBody();
                        System.debug('jiveResponse: ' + jiveResponse);
                        Account acctResult = JiveToSFAccountHelper.processJiveResponse(accRec, jiveResponse);
                            
                        if(acctResult != Null) {
                            accountsToUpdate.add(acctResult); 
                        }
                    }
                }
            }
            catch(Exception ex) {
                System.debug('Exception: ' + ex);   
            }
        }
        System.debug('accountsToUpdate: ' + accountsToUpdate);
        update accountsToUpdate;
    }
        
   	global void finish(Database.BatchableContext BC){ 
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        jivesetting.Value__c = 'false';
        update jivesetting;
   	}
}