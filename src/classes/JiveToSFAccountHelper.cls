public class JiveToSFAccountHelper{
	
    public static Account processJiveResponse(Account acctRec, String jiveResponse) {
    	// invalid jason response... https://developers.jivesoftware.com/community/thread/2153  
        jiveResponse = jiveResponse.Replace('throw \'allowIllegalResourceCall is false.\';', '');    
        //System.debug('Request Body: ' + jiveResponse);
        
        JSONParser parser = JSON.createParser(jiveResponse);
        //JivePersonObject personRecord = (JivePersonObject) System.JSON.deserialize(jiveResponse, JivePersonObject.class);
        json2apex personRecord=json2apex.parse(jiveResponse);
       
        System.debug('personRecord: ' + personRecord);
        
        //String IndustryExpertise = personRecord.JIVE.getProfileByName('Industries').replace('(', '').replace(')', '').replace(',', ';').replaceAll('\\s+', '');
        //String IndustryExpertise = personRecord.JIVE.getProfileByName('Industries').replace('(', '').trim().replace(')', '').replace(',', ';').trim();
        
        String Tags = String.valueof(personRecord.tags);
        system.debug('Tags: ' + Tags);
        if( Tags != null ){
            system.debug('NOT:');
            Tags = Tags.replace('(', '').replace(')','').trim(); 
        }
        
        if(acctRec.PersonTitle != personRecord.jive.getProfileByName('Title') ||
           acctRec.fs_skills__pc != Tags ||
           acctRec.fs_overview__pc != personRecord.JIVE.getProfileByName('What do you do?') ||
           acctRec.fs_facebook__pc != personRecord.JIVE.getProfileByName('Facebook') ||
           acctRec.fs_twitter__pc != personRecord.JIVE.getProfileByName('Twitter') ||
           //acctRec.fs_industryExpertise__pc != IndustryExpertise ||
           acctRec.fs_linkedin__pc != personRecord.JIVE.getProfileByName('Linkedin')) {
               
			acctRec.PersonTitle = personRecord.JIVE.getProfileByName('Title');
			acctRec.fs_skills__pc = Tags;
			acctRec.fs_overview__pc = personRecord.JIVE.getProfileByName('What do you do?');
			acctRec.fs_facebook__pc = personRecord.JIVE.getProfileByName('Facebook');
			acctRec.fs_twitter__pc = personRecord.JIVE.getProfileByName('Twitter');
			acctRec.fs_linkedin__pc = personRecord.JIVE.getProfileByName('Linkedin');
			//acctRec.fs_industryExpertise__pc = IndustryExpertise;
            //system.debug('testindustries: ' + acctRec.fs_industryExpertise__pc);               
			return acctRec;               
		}
        
        return null;
    }
}