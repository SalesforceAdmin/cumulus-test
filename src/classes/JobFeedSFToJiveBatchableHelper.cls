public class JobFeedSFToJiveBatchableHelper{
	public static JiveAction generateJiveAction(String jiveResponse, Feed__c feed, String JiveURL) {
    	// invalid jason response... https://developers.jivesoftware.com/community/thread/2153  
        jiveResponse = jiveResponse.Replace('throw \'allowIllegalResourceCall is false.\';', '');    
        
        JSONParser parser = JSON.createParser(jiveResponse);
        JivePersonObject personRecord = (JivePersonObject) System.JSON.deserialize(jiveResponse, JivePersonObject.class);
        
        if(personRecord.id != Null) {
            System.debug('personRecord has an ID');
            
            JiveAction jiveAction = new JiveAction();
            jiveAction.content = 'New Work Assignment';
            jiveAction.title = feed.fs_description__c;
            
            jiveAction.OpenSocial = new JiveAction.openSocial();                   
            jiveAction.OpenSocial.deliverTo = new List<String>();
            String deliverTo = JiveURL + '/people/' + personRecord.id;
            jiveAction.OpenSocial.deliverTo.add(deliverTo);					       
            
            jiveAction.Objectd = new JiveAction.Objectd();
            
            jiveAction.Objectd.summary = 'See the posting <a href=\'' + feed.fs_url__c + '\' target=\'_blank\'>here</a>.';
            
            jiveAction.verb = 'announced';   
            
            return jiveAction;
        }
        
        return null;
    }
    
    public static String serializeJiveAction(JiveAction jiveAction) {
        String jiveActionJSON = System.JSON.serialize(jiveAction);                    
                    
        jiveActionJSON = jiveActionJSON.Replace('True', 'true');//bug in Jive API fix the tense otherwise Jive will return a 500
        jiveActionJSON = jiveActionJSON.Replace('objectd', 'object');//serializer sets value as null instead of empty string, adjust string
        
        return jiveActionJSON;
    }
}