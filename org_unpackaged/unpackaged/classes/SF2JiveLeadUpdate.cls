global class SF2JiveLeadUpdate implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
    global Set<Id> leadIds = new Set<Id>();
    
   	global SF2JiveLeadUpdate(Set<Id> leadIds) {
        this.leadIds = leadIds;
    }

   	global Database.QueryLocator start(Database.BatchableContext BC) {
      	return Database.getQueryLocator([SELECT Id, FirstName, LastName, UserName__c, Email, Title, fs_skills__c, fs_overview__c, fs_facebook__c, fs_twitter__c, fs_linkedin__c 
                                         FROM Lead WHERE Id in :this.leadIds]);
   	}

   	global void execute(Database.BatchableContext BC, List<Lead> scope) {
        
        String JIVEPersonURL;
        String JiveURL = JiveSettings__c.getValues('JiveURL').Value__c;
        String personJSON;
        
        for(Lead leadRec : scope ) {
            String jiveResponse = '';
                     	
            JIVEPersonURL = JiveURL + '/people/username/'+ leadRec.UserName__c ;
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
                system.debug('req: ' + req);
                HTTPResponse res;
                if (!Test.isRunningTest()) {
                	res = http.send(req);
                    jiveResponse = res.getBody();
                    system.debug('res:' + jiveResponse);
                    
                }
                else {
                	jiveResponse = '{  \"name\" : {    \"givenName\" : \"Api01\",    \"familyName\" : \"User01\",    \"formatted\" : \"Api01 User01\"  },  \"type\" : \"person\",  \"tags\" : [ \"testing\", \"developing\" ],  \"jive\" : {    \"username\" : \"stevej\",    \"profile\" : [ {      \"value\" : \"I work with the MBO as a salesforce developer.\",      \"jive_label\" : \"What do you do?\"    } ]  },  \"emails\" : [ {    \"value\" : \"webmaster@mbopartners.com\",    \"type\" : \"work\",    \"jive_label\" : \"Email\",    \"primary\" : true  } ],  \"id\" : \"12856\"}';
                }
                
                JSON2Apex personRecord = SF2JiveLeadHelper.generatePersonJSON(jiveResponse, leadRec);
                
                system.debug('PersonRecord New: ' + personRecord);
                if(personRecord != Null) {
					personJSON = SF2JiveLeadHelper.serializePersonRecord(personRecord);
                    system.debug('personJsonL:' + personJSON);
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