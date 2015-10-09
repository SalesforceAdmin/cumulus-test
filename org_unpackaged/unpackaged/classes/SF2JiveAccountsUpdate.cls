global class SF2JiveAccountsUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts{

    global Set<Id> accountIds = new Set<Id>();
   	
   	global SF2JiveAccountsUpdate(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

   	global Database.QueryLocator start(Database.BatchableContext BC) {
      	return Database.getQueryLocator([SELECT Id, FirstName, LastName, fs_userName__pc, PersonEmail, PersonTitle, fs_skills__pc, fs_overview__pc, fs_facebook__pc, 
                                         		fs_twitter__pc, fs_linkedin__pc
                                         FROM Account WHERE Id in: accountIds]);
   	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {
        
        String JiveURL = JiveSettings__c.getValues('JiveURL').Value__c;
        String JIVEPersonURL;
        String personJSON;
        System.debug('scope: ' + scope);
        
        for(Account accRec : scope ) {   
            String jiveResponse = '';
            
            JIVEPersonURL = JiveURL + '/people/username/'+ accRec.fs_userName__pc;
            JIVEPersonURL +='?fields=ID,name.givenName,name.familyName,emails,tags,jive.profile.Title,';
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
                HTTPResponse res;
                
                if (!Test.isRunningTest()) { 
                	res = http.send(req);
                
                	jiveResponse = res.getBody();                    
                }
				else {
                	jiveResponse = '{  \"name\" : {    \"givenName\" : \"Api01\",    \"familyName\" : \"User01\",    \"formatted\" : \"Api01 User01\"  },  \"type\" : \"person\",  \"tags\" : [ \"testing\", \"developing\" ],  \"jive\" : {    \"username\" : \"stevej\",    \"profile\" : [ {      \"value\" : \"I work with the MBO as a salesforce developer.\",      \"jive_label\" : \"What do you do?\"    } ]  },  \"emails\" : [ {    \"value\" : \"webmaster@mbopartners.com\",    \"type\" : \"work\",    \"jive_label\" : \"Email\",    \"primary\" : true  } ],  \"id\" : \"12856\"}';
                }
                
                JSON2Apex personRecord = SF2JiveAccountsHelper.generatePersonJSON(jiveResponse, accRec);
                
                if(personRecord != Null) {
					personJSON = SF2JiveAccountsHelper.serializePersonRecord(personRecord);
                }
                
                if(personJSON != '') {
                	JIVEPersonURL = JiveURL + '/people/'+ personRecord.id ;
                    
                    HttpRequest req2 = new HttpRequest();
                    req2.setMethod('PUT');
                    
                    req2.setHeader('Authorization', authorizationHeader);
                    req2.setHeader('Accept', 'application/json');
                    req2.setHeader('Content-Type', 'application/json');
                    req2.setEndPoint(JIVEPersonURL);
                    req2.setBody(personJSON);
                    
                    Http http2 = new Http();
                    HTTPResponse res2;
                    if (!Test.isRunningTest()) { 
                    	res2 = http2.send(req2);
                        jiveResponse = res2.getBody();
                    }

                    System.debug('JiveRespose2: ' + jiveResponse);    
                }

                
            }
            catch(Exception ex) {
                System.debug('Exception: ' + ex);   
            }
        }
    }
        
   	global void finish(Database.BatchableContext BC){ 
   	}
}