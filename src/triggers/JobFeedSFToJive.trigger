trigger JobFeedSFToJive on Feed__c (after insert) {
    Set<Id> accountIds = new Set<Id>();
    Set<Id> leadIds = new Set<Id>();
    Set<Id> feedIds = new Set<Id>();
    
    Map<Id, Account> accountMap = new Map<Id, Account>();
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    
    for(Feed__c feed : Trigger.New) {
        if(feed.rs_recipientAccount__c != Null) {
            accountIds.add(feed.rs_recipientAccount__c);
        }
        else if(feed.rs_recipientLead__c != Null) {
            leadIds.add(feed.rs_recipientLead__c);
        }
        System.debug('feed.rs_recipientLead__c: ' + feed.rs_recipientLead__c);
    }
    
    System.debug('accountIds: ' + accountIds);
    System.debug('leadIds: ' + leadIds);
    
    for(Account acct : [SELECT Id, MBOAccess__c, fs_userName__pc FROM Account WHERE MBOAccess__c != false AND fs_userName__pc != Null and Id in : accountIds]) {
        accountMap.put(acct.Id, acct);    
    }
    
    for(Lead lead : [SELECT Id, MBOAccess__c, Username__c FROM Lead WHERE MBOAccess__c != false AND Username__c != null and Id in :leadIds]) {
        leadMap.put(lead.Id, lead);    
    }
    
    for(Feed__c feed : Trigger.New) {
        if(feed.rs_recipientAccount__c != Null && accountMap.get(feed.rs_recipientAccount__c) != Null) {
            feedIds.add(feed.Id);
        }
        else if(feed.rs_recipientLead__c != Null && leadMap.get(feed.rs_recipientLead__c) != Null) {
            feedIds.add(feed.Id);
        }   
    }
    System.debug('feedIds: ' + feedIds);
    
    if(feedIds.size() > 0) {
        // Initiate Batch Apex    
        JobFeedSFtoJiveBatchable jobFeedBatch = new JobFeedSFtoJiveBatchable(feedIds);
        ID batchprocessid = Database.executeBatch(jobFeedBatch, 5);

    }
}