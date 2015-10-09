trigger SF2JiveFieldUpdateAccountsTrigger on Account (before insert, before update) {
    
    Set<Id> accountsToSync = new Set<Id>();
    
    for (Account account : Trigger.new){
        if( account.RecordTypeId == '012C0000000Q8Ey' || account.RecordTypeId == '012C0000000Q8Ex' ){
            
            if( account.MBOAccess__c == true && account.FirstName != null && account.LastName != null && account.fs_userName__pc != null && account.PersonEmail  != null){
                if(Trigger.isInsert){
                    accountsToSync.add(account.Id);
                }
                else if( Trigger.isUpdate){
                    if(account.MBOAccess__c != Trigger.OldMap.get(account.Id).MBOAccess__c ||
                       account.PersonTitle  != Trigger.OldMap.get(account.Id).PersonTitle || 
                       account.fs_skills__pc != Trigger.OldMap.get(account.Id).fs_skills__pc ||
                       account.fs_overview__pc != Trigger.OldMap.get(account.Id).fs_overview__pc ||
                       account.fs_facebook__pc != Trigger.OldMap.get(account.Id).fs_facebook__pc ||
                       account.fs_linkedin__pc != Trigger.OldMap.get(account.Id).fs_linkedin__pc ||
                       account.fs_twitter__pc != Trigger.OldMap.get(account.Id).fs_twitter__pc ){
                       
                        accountsToSync.add(account.Id);
                    }
                }
            }
        }
    }
    
    if(accountsToSync.size() > 0) {
        JiveSettings__c jivesetting = JiveSettings__c.getValues('Lock Trigger Batchable');
        
        if(jivesetting.Value__c == 'false') {
            SF2JiveAccountsUpdate accountSFToJiveBatchable = new SF2JiveAccountsUpdate(accountsToSync);
            ID batchprocessid = Database.executeBatch(accountSFToJiveBatchable, 5);    
        }
    }
}