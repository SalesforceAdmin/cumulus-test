public class JiveToSFLeadUpdateHelper{

    public static Lead processJiveResponse(Lead leadRec, String jiveResponse) {
    	// invalid jason response... https://developers.jivesoftware.com/community/thread/2153  
        jiveResponse = jiveResponse.Replace('throw \'allowIllegalResourceCall is false.\';', '');    
        jiveResponse = jiveResponse.Replace('null', '');
        //jiveResponse = jiveResponse.Replace('Contract Talent management, Entrepreneurship, General Business Consulting, Management and Finance.', '');
        
       
        System.debug('Request Body: ' + jiveResponse);
        
        //JSONParser parser = JSON.createParser(jiveResponse);
        json2apex personRecord=json2apex.parse(jiveResponse);
        //JivePersonObject2 personRecord = (JivePersonObject2) System.JSON.deserialize(jiveResponse, JivePersonObject2.class);
        System.debug('personRecord: ' + personRecord);
        
        //String IndustryExpertise = personRecord.JIVE.getProfileByName('Industries').replace('(', '').replace(')', '').replace(',', ';').replaceAll('\\s+', '');
        //String IndustryExpertise = personRecord.JIVE.getProfileByName('Industries').replace('(', '').trim().replace(')', '').replace(',', ';').trim();
        //system.debug('industriesex: ' + IndustryExpertise);
        
        String Tags = String.valueof(personRecord.tags);
        system.debug('Tags: ' + Tags);
        if( Tags != null ){
            system.debug('NOT:');
            Tags = Tags.replace('(', '').replace(')','').trim(); 
        }
        
        
        if(leadRec.Title != personRecord.JIVE.getProfileByName('Title') ||
           leadRec.fs_skills__c != Tags ||
           leadRec.fs_overview__c != personRecord.JIVE.getProfileByName('What do you do?') ||
           leadRec.fs_facebook__c != personRecord.JIVE.getProfileByName('Facebook') ||
           leadRec.fs_twitter__c != personRecord.JIVE.getProfileByName('Twitter') ||
           //leadRec.fs_industryExpertise__c != IndustryExpertise ||
           leadRec.fs_linkedin__c != personRecord.JIVE.getProfileByName('Linkedin')) {
               
			leadRec.Title = personRecord.JIVE.getProfileByName('Title');
            leadRec.fs_skills__c = Tags;       
			leadRec.fs_overview__c = personRecord.JIVE.getProfileByName('What do you do?');
			leadRec.fs_facebook__c = personRecord.JIVE.getProfileByName('Facebook');
			leadRec.fs_twitter__c = personRecord.JIVE.getProfileByName('Twitter');
			leadRec.fs_linkedin__c = personRecord.JIVE.getProfileByName('Linkedin');
               
            //leadRec.fs_industryExpertise__c = IndustryExpertise;
            //system.debug('testindustries: ' + leadRec.fs_industryExpertise__c);
			return leadRec;
		}
        
        return null;
    }
}