trigger SF2JiveFieldUpdatelLeadTrigger on Lead (after insert, after update) {
    
    Set<Id> leadsToSync = new Set<Id>();
    
    for (Lead lead : Trigger.new){
        if( lead.RecordTypeId == '012C0000000Q7rk' || lead.RecordTypeId == '012C0000000Q7rm' ){
            
            if( lead.MBOAccess__c == true && lead.FirstName != null && lead.LastName != null && lead.UserName__c != null && lead.Email != null){
                if(Trigger.isInsert){
                    leadsToSync.add(lead.Id);
                }
                else if( Trigger.isUpdate){
                    if(lead.MBOAccess__c != Trigger.OldMap.get(lead.Id).MBOAccess__c ||
                       lead.Title != Trigger.OldMap.get(lead.Id).Title || 
                       lead.fs_skills__c != Trigger.OldMap.get(lead.Id).fs_skills__c ||
                       lead.fs_overview__c != Trigger.OldMap.get(lead.Id).fs_overview__c ||
                       lead.fs_facebook__c != Trigger.OldMap.get(lead.Id).fs_facebook__c ||
                       lead.fs_linkedin__c != Trigger.OldMap.get(lead.Id).fs_linkedin__c ||
                       lead.fs_twitter__c != Trigger.OldMap.get(lead.Id).fs_twitter__c ||
                       lead.fs_industryExpertise__c != Trigger.OldMap.get(lead.Id).fs_industryExpertise__c){
                       
                        leadsToSync.add(lead.Id);
                    }
                }
            }
        }
    }    
    
    if(leadsToSync.size() > 0) {
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        system.debug('leadstosyncID' + leadsToSync);
        if(jivesetting.Value__c == 'false') {
           
            SF2JiveLeadUpdate leadSFToJiveBatchable = new SF2JiveLeadUpdate(leadsToSync);
            ID batchprocessid = Database.executeBatch(leadSFToJiveBatchable, 5);    
        }
    }
}