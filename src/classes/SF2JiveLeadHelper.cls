public class SF2JiveLeadHelper{

    public static JSON2Apex generatePersonJSON(String jiveResponse, Lead leadRec) {
        // invalid jason response... https://developers.jivesoftware.com/community/thread/2153  
        jiveResponse = jiveResponse.Replace('throw \'allowIllegalResourceCall is false.\';', '');    
        System.debug('Request Body: ' + jiveResponse);
        
        JSONParser parser = JSON.createParser(jiveResponse);
        //JivePersonObject personRecord = (JivePersonObject) System.JSON.deserialize(jiveResponse, JivePersonObject.class);
        json2apex personRecord=json2apex.parse(jiveResponse);
        system.debug('test00:' + personRecord);
        if(personRecord.id != Null) {
            System.debug('personRecord: ' + personRecord);
            system.debug('personRecord.Name: ' + personRecord.Name);
            if( personRecord.Name == null ){
                personRecord.Name = new JSON2Apex.Name();                
            }
            personRecord.Name.givenName = leadRec.FirstName;
            personRecord.Name.familyName = leadRec.LastName;
            personRecord.Jive.username = leadRec.UserName__c;
            
            if( personRecord.Emails == Null ){
                personRecord.Emails = new List<JSON2Apex.Emails>();
                JSON2Apex.Emails email = new JSON2Apex.Emails();
                personRecord.emails.add(email); 
            }
            personRecord.Emails[0].value = leadRec.Email;
            personRecord.Emails[0].jive_label = 'Email';
            
            system.debug('personRecordJIVE: ' + personRecord.JIVE);
            if(personRecord.JIVE == Null ){
                personRecord.JIVE = new JSON2Apex.JIVE();
            }
            
            system.debug('facebook: '+ leadRec.fs_facebook__c);
            system.debug('title: + ' + leadRec.Title);
            system.debug('what do: '+ leadRec.fs_overview__c);
            system.debug('Linkedin: + ' + leadRec.fs_linkedin__c);
            system.debug('twitter: '+ leadRec.fs_twitter__c);
            system.debug('tags: + ' + leadRec.fs_skills__c);
            
            
            personRecord.JIVE.putJiveLabel('Title', leadRec.Title);
            personRecord.JIVE.putJiveLabel('What do you do?',leadRec.fs_overview__c );
            personRecord.JIVE.putJiveLabel('Facebook', leadRec.fs_facebook__c);
            system.debug('personrecordjive: ' + personRecord.Jive);
            personRecord.JIVE.putJiveLabel('LinkedIn', leadRec.fs_linkedin__c);
            personRecord.JIVE.putJiveLabel('Twitter', leadRec.fs_twitter__c);
            
			/*personRecord.JIVE.putProfileByName('Title', leadRec.Title);
            personRecord.JIVE.putProfileByName('What do you do?', leadRec.fs_overview__c);
            personRecord.JIVE.putProfileByName('Facebook', leadRec.fs_facebook__c);
            personRecord.JIVE.putProfileByName('LinkedIn', leadRec.fs_linkedin__c);
            personRecord.JIVE.putProfilebyName('Twitter', leadRec.fs_twitter__c);*/
            
            
            if( personRecord.tags == null ){
                personRecord.tags = new List<String>();  
                
            }
            String fs_skills = leadRec.fs_skills__c;
            if(leadRec.fs_skills__c != null ){
            	fs_skills = leadRec.fs_skills__c.replace('(', '').replace(')', '').trim();
                personRecord.tags = fs_skills.split(',');
            }
            else{
                personRecord.tags = new List<String>(); 
            }
              
            system.debug('personrec1:'+ personRecord.Jive.profile);
            system.debug('personrec:' + personRecord);

            return personRecord;
        }
         
        return Null;
    }
    
    public static String serializePersonRecord(JSON2Apex personRecord) {
        //String Industry = personRecord.Jive.getProfileByName('Industries');
        
        String personJSON = System.JSON.serialize(personRecord);
        
        //personJSON = personJSON.replace('\\"', '"'); 
        
        //personJSON = personJSON.replace('\"' + Industry + '\"', Industry);
		
        personJSON = personJSON.Replace('True', 'true');//bug in Jive API fix the tense otherwise Jive will return a 500
        //personJSON = personJSON.Replace('null', '\'\'');//serializer sets value as null instead of empty string, adjust string
        System.debug('personJSON: ' + personJSON);
        
        return personJSON;
    }
}