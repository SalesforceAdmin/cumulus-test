global class JiveToSFLeadUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts{
	global final String Query;
   	global final String Entity;
 
   	global JiveToSFLeadUpdate() {
      	Query='SELECT Id, FirstName, LastName, UserName__c, Email, Title, fs_industryExpertise__c, fs_skills__c, fs_overview__c, fs_facebook__c, fs_twitter__c, fs_linkedin__c ' +
              'FROM Lead WHERE UserName__c != Null';  
        Entity= 'Lead';
   	} 

   	global Database.QueryLocator start(Database.BatchableContext BC) {
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        jivesetting.Value__c = 'true';
        update jivesetting;
        
      	return Database.getQueryLocator(query);
   	}
   
   	global void execute(Database.BatchableContext BC, List<Lead> scope) {
        system.debug('scope:' + scope);
        
        List<Lead> leadsToUpdate = new List<Lead>();
        String JIVEPersonURL ;

        String JiveURL = JiveSettings__c.getValues('JiveURL').Value__c;
		system.debug('JiveURL:' + JiveURL);
        System.debug('scope: ' + scope);
        
        for(Lead leadRec : scope ) {   
            String jiveResponse = '';
     	
            JIVEPersonURL = JiveURL + '/people/username/'+ leadRec.UserName__c ;
            JIVEPersonURL +='?fields=ID,name,emails,tags,jive.profile.Title,';
            JIVEPersonURL +='jive.profile.Facebook,jive.profile.Twitter,jive.profile.LinkedIn,jive.profile.What%20do%20you%20do?,jive.username&filter=search()';
            
            system.debug('username:' + leadRec.UserName__c );
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
                        system.debug('body:' + jiveResponse);
                        
                        Lead leadResult = JiveToSFLeadUpdateHelper.processJiveResponse(leadRec, jiveResponse);
                        
                        if(leadResult != Null) {
                            leadsToUpdate.add(leadResult); 
                        }
                       
                    }
                 }
            }

            catch(Exception ex) {
                System.debug('Exception: ' + ex);   
            }
        }
        System.debug('leadsToUpdate: ' + leadsToUpdate);
        update leadsToUpdate;
    }
        
   	global void finish(Database.BatchableContext BC){ 
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        jivesetting.Value__c = 'false';
        update jivesetting;
   	}
    

        
    
    
}