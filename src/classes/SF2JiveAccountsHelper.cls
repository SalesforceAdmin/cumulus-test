public class SF2JiveAccountsHelper{
	public static JSON2Apex generatePersonJSON(String jiveResponse, Account acctRec) {
        // invalid jason response... https://developers.jivesoftware.com/community/thread/2153  
        jiveResponse = jiveResponse.Replace('throw \'allowIllegalResourceCall is false.\';', '');    
        System.debug('Request Body: ' + jiveResponse);
        
        JSONParser parser = JSON.createParser(jiveResponse);
        //JivePersonObject personRecord = (JivePersonObject) System.JSON.deserialize(jiveResponse, JivePersonObject.class);
        json2apex personRecord=json2apex.parse(jiveResponse);
        
        if(personRecord.id != Null) {
            System.debug('personRecord: ' + personRecord);
            if( personRecord.Name == null ){
                personRecord.Name = new JSON2Apex.Name();                
            }
            personRecord.Name.givenName = acctRec.FirstName;
            personRecord.Name.familyName = acctRec.LastName;
            personRecord.Jive.username = acctRec.fs_userName__pc;
            if( personRecord.Emails == Null ){
                personRecord.Emails = new List<JSON2Apex.Emails>();
                JSON2Apex.Emails email = new JSON2Apex.Emails();
                personRecord.emails.add(email); 
            }
            personRecord.Emails[0].value = acctRec.PersonEmail;
            personRecord.Emails[0].jive_label = 'Email';
            
            personRecord.JIVE.putJiveLabel('Title', acctRec.PersonTitle);
            personRecord.JIVE.putJiveLabel('What do you do?', acctRec.fs_overview__pc);
            personRecord.JIVE.putJiveLabel('Facebook', acctRec.fs_facebook__pc);
            personRecord.JIVE.putJiveLabel('LinkedIn', acctRec.fs_linkedin__pc);
            personRecord.JIVE.putJiveLabel('Twitter', acctRec.fs_twitter__pc);
            
            
            /*personRecord.JIVE.putProfileByName('Title', acctRec.PersonTitle);
            personRecord.JIVE.putProfileByName('What do you do?', acctRec.fs_overview__pc);
            personRecord.JIVE.putProfileByName('Facebook', acctRec.fs_facebook__pc);
            personRecord.JIVE.putProfileByName('Linkedin', acctRec.fs_linkedin__pc);
            personRecord.JIVE.putProfilebyName('Twitter', acctRec.fs_twitter__pc);*/
            
            
            if( personRecord.tags == null ){
                personRecord.tags = new List<String>();  
                
            }
            String fs_skills = acctRec.fs_skills__pc;
            if(acctRec.fs_skills__pc != null ){
            	fs_skills = acctRec.fs_skills__pc.replace('(', '').replace(')', '').trim();
                personRecord.tags = fs_skills.split(',');
            }
            else{
                personRecord.tags = new List<String>(); 
            }
            //String fs_skills = acctRec.fs_skills__pc.replace('(', '').replace(')', '').trim();
            //personRecord.tags = fs_skills.split(',');            
            
            system.debug('personrec:' + personRecord);
            return personRecord;
        }
        
        return Null;
    }
    
    public static String serializePersonRecord(JSON2Apex personRecord) {
        String personJSON = System.JSON.serialize(personRecord);            
            
        personJSON = personJSON.Replace('True', 'true');//bug in Jive API fix the tense otherwise Jive will return a 500
        //personJSON = personJSON.Replace('null', '\'\'');//serializer sets value as null instead of empty string, adjust string
        System.debug('personJSON: ' + personJSON);
        
        return personJSON;
    }
}