/**********************************************************
* Description      : Account Helper class 
* @author          : Kiran Kurella
* @date            : April 17, 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

public with sharing class AccountHelper {
    
    //// When an Account's alumni referral value is set make sure a campaign member is created referencing the client
    public static void alumniReferral (List<Account> acctList){
        // Check if acctList is populated
        if(!acctList.isEmpty() && acctList != null){
            //// Create utility lists
            // Create Campaign Member List for Upsert
            List<CampaignMember> cm = new List<CampaignMember>();
            // Create variable for the campaign the campaign members are assigned to
            Campaign cmp = new Campaign();
            // Create a map of account ID and alumni ID
            Set<Id> acctCheck = new Set<Id>();
            Set<Id> acctConf = new Set<Id>();
            Map<Id, Id> acct_ref = new Map<Id ,Id>();
            // Create a Map of Contacts that reference Accounts in acctList to the Parent Account
            Map<Id,Id> con_acct = new Map<Id,Id>();
            // Create a Map of Accounts in acctList that reference the child contact
            Map<Id,Id> acct_con = new Map<Id,Id>();
            // Identify the contact list, iterate through, populate maps
            for(Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :acctList]){
                con_acct.put(con.Id,con.AccountId);
                acct_con.put(con.AccountId,con.Id);
            }
            
            //// Build a list of IDs to confirm
            // Itearte through the acctList
            for (Account acct : acctList){
                // See if the list of Accounts has the Alumni Referral Id set
                if (acct.Alumni_Referrer__pc!=null && acct.Alumni_Referrer__pc!=''){
                    // Populate the set
                    acctCheck.add(Id.valueOf(acct.Alumni_Referrer__pc));
                }
            }
            
            //// Iterate through the set and confirm the account exists
            for (Account acct : [SELECT Id FROM Account WHERE Id IN :acctCheck]){
                // Add to the confirmed account list
                acctConf.add(acct.Id);
            }
            
            //// Iterate through the list of accounts, now with the confirmed accounts, and build the map for campaign members
            for (Account acct :acctList){
                if(acct.Alumni_Referrer__pc!=null && acct.Alumni_Referrer__pc!=''){
                    if(acctConf.contains(Id.valueOf(acct.Alumni_Referrer__pc))){
                        // If the alumni value is in the confirmed accounts set, put the account and alumni value to the map
                        acct_ref.put(acct.Id, Id.valueOf(acct.Alumni_Referrer__pc));
                    } else {
                        // If the alumni value is not in the identified accounts set, put the account and a null value to the map
                        acct_ref.put(acct.Id, null);
                    }
                }
            }
            
            //// Does a campaign member exist and is it accurate
            if(acct_ref!=null&&!acct_ref.isEmpty()){
                // Send a message letting me know no campaign exists and end the process
                IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY] == 0){
                    // Build the message
                    Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
                    sem.setToAddresses(new String[] {'garrettz@mbopartners.com'});
                    sem.setSubject('Client Alumni Referral Program Issue');
                    String messageBody = 'The following list of accounts were attempting to create campaign members for the Client Alumni Referral program, but there wasn\'t a capmaign for them to relate to:'+acct_ref.keySet();
                    sem.setPlainTextBody(messageBody);
                    // Send the message stating the campaign members cannot be inserted because a campaign doesn't exist
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
                }  else {
                    // Find the active Campaign
                    cmp = [SELECT Id, OwnerId FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY LIMIT 1];
                    // Map any existing Campaign Members to the Account and Referral map
                    for (CampaignMember c : [SELECT Id, Associated_Account__c, ContactId FROM CampaignMember WHERE CampaignId=:cmp.Id AND ContactId IN :con_acct.keySet()]) {
                        // Check if Campaign Member's Associated Account matches the identified Account
                        if(c.Associated_Account__c!=acct_ref.get(con_acct.get(c.ContactId))){
                            c.Associated_Account__c=acct_ref.get(con_acct.get(c.ContactId));
                            cm.add(c);
                        }
                        // Remove the Account from the Account and Referral Map
                        acct_ref.remove(con_acct.get(c.ContactId));
                    }
                }
            }
            
            // For any remaining Account create a campaign member
            if(acct_ref!=null&&!acct_ref.isEmpty()&&cmp!=null){
                // Iterate through the map
                for (Id acctId : acct_ref.keySet()){
                    if(acct_ref.get(acctId)==null){
                        // If the map has a null value, set a null value for the associated account
                        CampaignMember c = new CampaignMember(CampaignId=cmp.Id, ContactId=acct_con.get(acctId), Status='Inserted');
                        cm.add(c);
                    } else {
                        // If the map has a value, set the value for the associated account
                        CampaignMember c = new CampaignMember(Associated_Account__c=acct_ref.get(acctId), CampaignId=cmp.Id, ContactId=acct_con.get(acctId), Status='Inserted');
                        cm.add(c);
                    }
                }
            }
            
            //// Upsert the list of CampaignMembers
            Upsert cm;
        }
    }

    
    public static void assignPersonAccountOwner(list<Account> accounts, map<Id, Account> mapOldAccounts) {
        if (accounts != null && !accounts.isEmpty()) {
            
            set<String> BM_AssociateStatuses = new set<String>{'Active', 'Non Billing', 'Probation'};
                list<Account> BM_Accounts_To_Process = new list<Account>{};
                    
                    set<String> EM_AssociateStatuses = new set<String>{'Pending', 'Enrolled'};
                        list<Account> EM_Accounts_To_Process = new list<Account>{};
                            map<Id, My_Biz_Office_User__c> mapMBOUsers = new map<Id, My_Biz_Office_User__c>();
            
            for (Account a : accounts) {
                if ( (trigger.isInsert || a.Business_Manager__pc != mapOldAccounts.get(a.Id).Business_Manager__pc || a.RecordTypeId != mapOldAccounts.get(a.Id).RecordTypeId || a.fn_associateStatusAge__pc != mapOldAccounts.get(a.Id).fn_associateStatusAge__pc || a.Associate_Status__pc != mapOldAccounts.get(a.Id).Associate_Status__pc) &&
                    a.Business_Manager__pc != null && String.isNotBlank(a.Associate_Status__pc) &&
                    (a.RecordTypeId == Util.getRecordTypeId('Account', 'Partners_Associate') || a.RecordTypeId == Util.getRecordTypeId('Account', 'Client_Referred_Associate')) &&
                    (BM_AssociateStatuses.contains(a.Associate_Status__pc) || (a.Associate_Status__pc == 'Terminated' && a.fn_associateStatusAge__pc <= 90) ) 
                   ) {
                       BM_Accounts_To_Process.add(a);
                       mapMBOUsers.put(a.Business_Manager__pc, null);
                   }
                
                if ( (trigger.isInsert || a.Enrollment_Manager__pc != mapOldAccounts.get(a.Id).Enrollment_Manager__pc || a.RecordTypeId != mapOldAccounts.get(a.Id).RecordTypeId || a.fn_associateStatusAge__pc != mapOldAccounts.get(a.Id).fn_associateStatusAge__pc || a.Associate_Status__pc != mapOldAccounts.get(a.Id).Associate_Status__pc) &&
                    a.Enrollment_Manager__pc != null && String.isNotBlank(a.Associate_Status__pc) &&
                    (a.RecordTypeId == Util.getRecordTypeId('Account', 'Partners_Associate') || a.RecordTypeId == Util.getRecordTypeId('Account', 'Client_Referred_Associate')) &&
                    (EM_AssociateStatuses.contains(a.Associate_Status__pc) || (a.Associate_Status__pc == 'Terminated' && a.fn_associateStatusAge__pc > 90) ) 
                   ) {
                       EM_Accounts_To_Process.add(a);
                       mapMBOUsers.put(a.Enrollment_Manager__pc, null);
                   }
            }
            
            system.debug('\n ### mapMBOUsers ' + mapMBOUsers.size() + ' => ' + mapMBOUsers);
            if (!mapMBOUsers.isEmpty()) {
                mapMBOUsers.putAll([select Id, Salesforce_User__c from My_Biz_Office_User__c where Id in : mapMBOUsers.keySet() and Salesforce_User__c != null]);
                
                for (Account a : BM_Accounts_To_Process) {
                    if (mapMBOUsers.get(a.Business_Manager__pc) != null) a.OwnerId = mapMBOUsers.get(a.Business_Manager__pc).Salesforce_User__c;
                }
                system.debug('\n ### BM_Accounts_To_Process ' + BM_Accounts_To_Process.size() + ' => ' + BM_Accounts_To_Process);
                
                for (Account a : EM_Accounts_To_Process) {
                    if (mapMBOUsers.get(a.Enrollment_Manager__pc) != null) a.OwnerId = mapMBOUsers.get(a.Enrollment_Manager__pc).Salesforce_User__c;
                }
                system.debug('\n ### EM_Accounts_To_Process ' + EM_Accounts_To_Process.size() + ' => ' + EM_Accounts_To_Process);
            }
        }
    }
    
    public static list<Account> AccountAlumniAssignment(list<Account> accounts, map<Id, Account> mapOldAccounts) {
        if (accounts != null && !accounts.isEmpty()) {
            //select Id, fd_bcStatusChange__pc, OwnerId, Enrollment_Manager__pr.Salesforce_User__c from Account where (RecordType.DeveloperName = 'Partners_Associate' OR RecordType.DeveloperName = 'Client_Referred_Associate') and Associate_Status__pc = 'Terminated' and ((fb_pracOwn__pc = true and fd_bcStatusChange__pc <= :dtNoTimeMinus6Months) OR (fb_pracOwn__pc != true and fd_bcStatusChange__pc <= :dtNoTimeMinus12Months))
            
            date dtNoTimeMinus6Months = system.today().addMonths(-6);
            date dtNoTimeMinus12Months = system.today().addMonths(-12);
            map<Id, My_Biz_Office_User__c> mapMBOUsers = new map<Id, My_Biz_Office_User__c>();
            
            for (Account a : accounts) {
                system.debug('\n ### fd_bcStatusChange__pc ' + a.fd_bcStatusChange__pc + ' dtNoTimeMinus6Months ' + dtNoTimeMinus6Months + ' dtNoTimeMinus12Months ' + dtNoTimeMinus12Months);
                
                if (a.Enrollment_Manager__pc != null && a.Associate_Status__pc == 'Terminated' && 
                    (trigger.isInsert || a.Associate_Status__pc != mapOldAccounts.get(a.Id).Associate_Status__pc || a.fb_pracOwn__pc != mapOldAccounts.get(a.Id).fb_pracOwn__pc || a.fd_bcStatusChange__pc != mapOldAccounts.get(a.Id).fd_bcStatusChange__pc || a.RecordTypeId != mapOldAccounts.get(a.Id).RecordTypeId) && 
                    ((a.fb_pracOwn__pc && a.fd_bcStatusChange__pc <= dtNoTimeMinus6Months) || (!a.fb_pracOwn__pc && a.fd_bcStatusChange__pc <= dtNoTimeMinus12Months)) && 
                    (a.RecordTypeId == Util.getRecordTypeId('Account', 'Partners_Associate') || a.RecordTypeId == Util.getRecordTypeId('Account', 'Client_Referred_Associate')) ) {
                        
                        //a.OwnerId = a.Enrollment_Manager__pr.Salesforce_User__c;
                        mapMBOUsers.put(a.Enrollment_Manager__pc, null);
                    }
            }
            
            system.debug('\n ### mapMBOUsers ' + mapMBOUsers.size() + ' => ' + mapMBOUsers);
            if (!mapMBOUsers.isEmpty()) {
                mapMBOUsers = new  map<Id, My_Biz_Office_User__c>([select Id, Salesforce_User__c from My_Biz_Office_User__c where Id in : mapMBOUsers.keySet() and Salesforce_User__c != null]);
                
                for (Account a : accounts) {
                    if (a.Enrollment_Manager__pc != null && a.Associate_Status__pc == 'Terminated' && 
                        (trigger.isInsert || a.Associate_Status__pc != mapOldAccounts.get(a.Id).Associate_Status__pc || a.fb_pracOwn__pc != mapOldAccounts.get(a.Id).fb_pracOwn__pc || a.fd_bcStatusChange__pc != mapOldAccounts.get(a.Id).fd_bcStatusChange__pc || a.RecordTypeId != mapOldAccounts.get(a.Id).RecordTypeId) && 
                        ((a.fb_pracOwn__pc && a.fd_bcStatusChange__pc <= dtNoTimeMinus6Months) || (!a.fb_pracOwn__pc && a.fd_bcStatusChange__pc <= dtNoTimeMinus12Months)) && 
                        (a.RecordTypeId == Util.getRecordTypeId('Account', 'Partners_Associate') || a.RecordTypeId == Util.getRecordTypeId('Account', 'Client_Referred_Associate')) ) {
                            
                            system.debug('\n ### changing the Account owner to ' + mapMBOUsers.get(a.Enrollment_Manager__pc).Salesforce_User__c + ' fd_bcStatusChange__pc ' + a.fd_bcStatusChange__pc + ' dtNoTimeMinus6Months ' + dtNoTimeMinus6Months + ' dtNoTimeMinus12Months ' + dtNoTimeMinus12Months);
                            if (mapMBOUsers.containsKey(a.Enrollment_Manager__pc)) a.OwnerId = mapMBOUsers.get(a.Enrollment_Manager__pc).Salesforce_User__c;
                        }
                }
            }
        }
        
        return accounts;
    }
    
    public static Account WorkMarketClient {
        get {
            if (WorkMarketClient == null) {
                try {
                    WorkMarketClient = [SELECT Id, Name FROM Account where fs_wmCompanyId__c = '1' Limit 1];
                } catch (Exception ex) {
                    WorkMarketClient = new Account();
                }
            }
            return WorkMarketClient;
        }
        private set;
    }
    
    /*@author: Garrett Zaino, @date: November 5, 2014, Description: Get Leads to update Owner, Update Owner*/    
    public static void companyAccountOwnerChange (list<Account> accounts, map<Id,Account> mapOldAccounts) {
        Map<Id,Account> mapAccount = new Map<Id,Account>();
        Id rtClient = Util.getRecordTypeId('Account','ES_Client');
        
        for(Account a : accounts) {
            if(a.ownerId != mapOldAccounts.get(a.Id).ownerId &&
               a.recordTypeId == rtClient ) {
                   mapAccount.put(a.Id,a);
               }
        }
        
        List<Lead> mapLeadOwner = new List<Lead>();
        If(mapAccount.size()>0){
            Id rtId = Util.getRecordTypeId('Lead', 'Client');
            mapLeadOwner = [SELECT Id, Account__c, recordTypeId, isConverted 
                            FROM Lead 
                            WHERE account__c IN :mapAccount.keySet() 
                            AND isConverted = FALSE 
                            AND recordTypeId = :rtId];
        }
        
        If (mapLeadOwner.size() >0){
            LeadHelper.companyOwnerUpdateAccountChange(mapAccount, mapLeadOwner, TRUE);
        }
    }
    
    // Changed Class from v26 to v33
    public static void enrollmentActivation (List<Account> accounts, Map<Id, Account> oldMap) {
        IF(accounts!=null && !accounts.isEmpty()){
            List<Account> filteredAccounts = new List<Account>();
            Map<Id,Date> contactMap = new Map<Id,Date>();
            List<Enrollment__c> enrollList = new List<Enrollment__c>();

            for (Account a :accounts){
                IF(a.Associate_Status__pc=='Active'&&oldMap.get(a.Id).Associate_Status__pc!='Active'&&a.fd_bcStatusChange__pc!=null&&a.IsPersonAccount==TRUE){
                    filteredAccounts.add(a);
                }
            }
            
            If(filteredAccounts!=null && !filteredAccounts.isEmpty()){
                for (Contact c :[SELECT Id, fd_bcStatusChange__c FROM Contact WHERE AccountId IN :filteredAccounts]) {
                    contactMap.put(c.Id,c.fd_bcStatusChange__c);
                }
                
                for (Enrollment__c e :[SELECT Id, Activation_Date__c, Contact__c FROM Enrollment__c WHERE Contact__c IN :contactMap.keySet() AND Activation_Date__c = null]){
                    e.Activation_Date__c=Date.valueOf(contactMap.get(e.Contact__c));
                    enrollList.add(e);
                }
                
                Update enrollList;
            }
        }
    }
    
    //// Set the Account with the first active work order
    Public static void initialActiveWorkOrder (list<Opportunity> woList){
        //// Build utilities
        // Get record type
        Id woRT = util.getRecordTypeId('Opportunity', 'Work_Order');
        // Instantiate Opportunity list to update
        List<Opportunity> woUpdates = new List<Opportunity>();
        // Instantiate the set of accounts we will retrieve
        Set<Id> acctSet = new Set<Id>();
        // Instantiate the list of accounts to update
        List<Account> acctList = new List<Account>();
        
        //// Check the opportunities are inscope
        if(!woList.isEmpty() && woList!=null){
            for (Opportunity o :woList){
                // check the opportunity meets the criteria
                if (o.RecordTypeId == woRT && o.stageName == 'Active' && o.AccountId != null) {
                    // add to the update list
                    woUpdates.add(o);
                    acctSet.add(o.AccountId);
                }
            }
        }
        
        //// Check if the accounts on the inscope opportunities have an initial work order
        if (!acctSet.isEmpty() && acctSet != null){
            // populate the acctList with the accounts in scope
            System.debug(loggingLevel.ERROR, 'acctSet: '+acctSet);
            System.debug(loggingLevel.ERROR, 'SOQL: '+[SELECT Id, Initial_Work_Order__c FROM Account WHERE Id IN :acctSet]);
            Map<Id,Account> acctMap = new Map<Id,Account>([SELECT Id, Initial_Work_Order__c FROM Account WHERE Id IN :acctSet]);
            System.debug(loggingLevel.ERROR, 'woUpdates: '+woUpdates);
            System.debug(loggingLevel.ERROR, 'acctMap: '+acctMap);
            //// Check the utility list are populate and update the account
            if (!woUpdates.isEmpty() && woUpdates != null && acctMap != null && !acctMap.isEmpty()){
                System.debug(loggingLevel.ERROR, 'woUpdates and acctMap is not null');
                for (Opportunity o :woUpdates){
                    // Check if the Opportunities parent account doesn't have an initial work order
                    if (acctMap.get(o.AccountId).initial_Work_Order__c == null){
                        // Set the initial work order of the opportunities parent account
                        acctMap.get(o.AccountId).initial_Work_Order__c = o.Id;
                        // Add the account to he update list
                        acctList.add(acctMap.get(o.AccountId));
                        System.debug(loggingLevel.ERROR, 'acctMap updated and added to acctList');
                    }
                }
            }
        }
        
        //// Update the accounts if there is a list
        if (!acctList.isEmpty() && acctList != null){
            // update list
            System.debug(loggingLevel.ERROR, 'acctList: '+ acctList);
            update acctList;
        }
    }
    
}