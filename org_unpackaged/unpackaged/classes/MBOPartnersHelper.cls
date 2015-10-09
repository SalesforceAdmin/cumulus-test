/**********************************************************
* Description      : MBO Partners Helper class
* @author          : Kiran Kurella
* @date            : May 26, 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

public with sharing class MBOPartnersHelper {
    
    @TestVisible private static boolean allowAssociateSuppressionUpdate = false;
    private static set<Id> completedWMAssignments = new set<Id>{};
        
        public static User MBOAdminUser {
            get {
                if (MBOAdminUser == null) {
                    try {
                        MBOAdminUser = [Select Id from User where FirstName = 'MBO' and LastName = 'Admin' and IsActive = true];
                    } catch (exception ex) {
                        
                    }
                }
                return MBOAdminUser;
            }
        }
    
    public static void CompleteWorkMarketAssignment(map<Id, Opportunity> newOppMap, map<Id, Opportunity> oldOppMap) {
        
        set<Id> oppIds = new set<Id>{};
            
            for (Opportunity opp : newOppMap.values()) {
                
                if (!completedWMAssignments.contains(opp.Id) && opp.rs_client__c != null && opp.fs_wMAssignmentID__c != null && opp.StageName == 'Inactive' && opp.RecordTypeId == Util.getRecordTypeId('Opportunity', 'Work_Order') && 
                    (	trigger.isInsert ||
                     (opp.StageName != oldOppMap.get(opp.Id).StageName || opp.fs_wMAssignmentID__c != oldOppMap.get(opp.Id).fs_wMAssignmentID__c || opp.RecordTypeId != oldOppMap.get(opp.Id).RecordTypeId)
                    )) {
                        oppIds.add(opp.Id);
                        completedWMAssignments.add(opp.Id);
                    }
            }
        
        // kick off a batch process to close Work Market assignments.
        if (!oppIds.isEmpty()) {
            MBOPartnersBatcher.startJob(MBOPartnersBatcher.BatchType.CompleteWorkMarketAssignment, oppIds, 10);
        }
    }
    
    public static String getSettingsValue(String param) {
        String paramValue = '';
        if (param != null) {
            MBOSettings__c setting = MBOSettings__c.getvalues(param);
            if (setting != null) paramValue = setting.SettingsValue__c;    		
        }
        
        return paramValue;
    }
    
    public static String WorkMarketEndPoint {
        get {
            if (WorkMarketEndPoint == null) {
                WorkMarketEndPoint = getSettingsValue('WorkMarket API EndPoint');
                // assign sandbox url, if the settings url is blank.
                if (WorkMarketEndPoint == null) WorkMarketEndPoint = 'https://test-mbo.dev.workmarket.com';
            }
            return WorkMarketEndPoint;
        }
        private set;
    }
    
    /*****************************************************************************************************************************************
Enterprise Associate Suppression methods 
*****************************************************************************************************************************************/
/*    
    private static set<Id> leadIds = new set<Id>{};
        private static set<Id> associateIds = new set<Id>{};
            private static set<String> woStages = new set<String> {'Pending', 'Active'};
                private static set<String> paRecordTypes = new set<String> {'Client_Referred_Associate', 'Partners_Associate'};
                    
                    
                    /**
* restricts a user from updating Associate's Enterprise_Associate_Suppression__pc field manually.  
*/
 /*                   public static void restrictAssociateSuppressionUpdate(list<Account> accounts, map<Id, Account> mapOldAccounts) {
                        if (accounts != null && !accounts.isEmpty()) {
                            for (Account a : accounts) {
                                System.debug(LoggingLevel.INFO,'a: '+a);
                                System.debug(LoggingLevel.INFO,'old a: '+mapOldAccounts.get(a.Id));
                                if (!allowAssociateSuppressionUpdate && a.Enterprise_Associate_Suppression__pc != mapOldAccounts.get(a.Id).Enterprise_Associate_Suppression__pc) {
                                    a.Enterprise_Associate_Suppression__pc.addError('You can\'t update Enterprise Associate Suppression field.');
                                }
                            }
                        }
                    }
    
    /**
* restricts a user from updating Associate's Enterprise_Associate_Suppression__c field manually.  
*/
/*    public static void restrictAssociateSuppressionUpdate(list<Lead> leads, map<Id, Lead> mapOldLeads) {
        if (leads != null && !leads.isEmpty()) {
            for (Lead ld : leads) {
                System.debug(LoggingLevel.INFO,'ld: '+ld);
                System.debug(LoggingLevel.INFO,'old ld: '+mapOldLeads.get(ld.Id));
                if (!allowAssociateSuppressionUpdate && ld.Enterprise_Associate_Suppression__c != mapOldLeads.get(ld.Id).Enterprise_Associate_Suppression__c) {
                    ld.Enterprise_Associate_Suppression__c.addError('You can\'t update Enterprise Associate Suppression field.');
                }
            }
        }
    }
    
    /**
* gathers various clients and updates their corresponding Associate's Suppression field.   
*/
 /*   public static void updateClientAssociateSuppression(list<Account> accounts, map<Id, Account> mapOldAccounts) {
        if (accounts != null && !accounts.isEmpty()) {
            
            set<Id> clientIds = new set<Id>{};
                for (Account a : accounts) {
                    if ( (trigger.isdelete || trigger.isUndelete || a.RecordTypeId != mapOldAccounts.get(a.Id).RecordTypeId || a.Enterprise_Suppression__c != mapOldAccounts.get(a.Id).Enterprise_Suppression__c) && a.RecordTypeId == Util.getRecordTypeId('Account', 'ES_Client')) {
                        clientIds.add(a.Id);
                    }
                }
            
            updateClientAssociateSuppression(clientIds);
        }
    }
    
    /**
* gathers various Associate's and updates their Suppression field.   
*/
 /*   public static void updateClientAssociateSuppression(list<Opportunity> opps, map<Id, Opportunity> mapOldOpps) {
        if (opps != null && !opps.isEmpty()) {
            
            for (Opportunity opp : opps) {
                
                if (
                    ( ( (trigger.isInsert || trigger.isUndelete || trigger.isDelete) && (opp.StageName == 'Pending' || opp.StageName == 'Active') && opp.RecordTypeId == Util.getRecordTypeId('Opportunity', 'Work_Order') ) 
                     ||
                     ( trigger.isUpdate && (opp.RecordTypeId != mapOldOpps.get(opp.Id).RecordTypeId || opp.StageName != mapOldOpps.get(opp.Id).StageName ||
                                            opp.rs_client__c != mapOldOpps.get(opp.Id).rs_client__c || opp.AccountId != mapOldOpps.get(opp.Id).AccountId || opp.rs_leadAssociate__c != mapOldOpps.get(opp.Id).rs_leadAssociate__c) )
                    )	 
                ) {
                    
                    if (opp.AccountId != null) associateIds.add(opp.AccountId);
                    if (mapOldOpps != null && mapOldOpps.get(opp.Id).AccountId != null) associateIds.add(mapOldOpps.get(opp.Id).AccountId);
                    
                    if (opp.rs_leadAssociate__c != null) leadIds.add(opp.rs_leadAssociate__c);
                    if (mapOldOpps != null && mapOldOpps.get(opp.Id).rs_leadAssociate__c != null) leadIds.add(mapOldOpps.get(opp.Id).rs_leadAssociate__c);
                }
            }
            
            if (!(trigger.isBefore && trigger.isDelete)) {
                updateLeadSuppression();
                updateAssociateSuppression();
            }
        }
    }
    
    /**
* gathers various Client Associate's and updates their Suppression field.   
*/
/*    public static void updateClientAssociateSuppression(set<Id> clientIds) {
        
        system.debug(' ### clientIds in updateClientAssociateSuppression ' + clientIds.size() + ' => ' + clientIds);
        if (clientIds != null && !clientIds.isEmpty()) {
            
            // gather all Assoicates (Person Accounts and Leads) linked to the Client for re-evaluation
            for (Opportunity wo : [Select rs_client__c, AccountId, rs_leadAssociate__c from Opportunity where rs_client__c in :clientIds and RecordType.DeveloperName = 'Work_Order' and StageName in :woStages and ( (AccountId != null and Account.RecordType.DeveloperName in : paRecordTypes) OR (rs_leadAssociate__c != null and rs_leadAssociate__r.isConverted = false) ) ]) {
                if (wo.AccountId != null) associateIds.add(wo.AccountId);
                if (wo.rs_leadAssociate__c != null) leadIds.add(wo.rs_leadAssociate__c);
            }
            
            // gather all Leads with Referring Clients
            for (Lead ld : [Select Id, Referring_Client__c from Lead where Referring_Client__c in :clientIds]) {
                leadIds.add(ld.Id);
            }
            
            updateLeadSuppression();
            updateAssociateSuppression();
        }
    }
    
    /**
* gathers various Lead Associate's and updates their Suppression field.   
*/
 /*   public static void updateLeadSuppression(list<Lead> leads, map<Id, Lead> mapOldLeads) {
        
        if (leads != null && !leads.isEmpty()) {
            
            map<Id, Account> mapClients = new map<Id, Account>{};
                
                for (Lead ld : leads) {
                    if (trigger.isInsert) {
                        
                        if (ld.Referring_Client__c != null) mapClients.put(ld.Referring_Client__c, null);
                        
                    } else if (trigger.isUndelete || ld.Referring_Client__c != mapOldLeads.get(ld.Id).Referring_Client__c) {
                        leadIds.add(ld.Id);
                    }
                }
            
            if (!mapClients.isEmpty()) {
                mapClients.putAll([Select Id, Enterprise_Suppression__c from Account where Id in :mapClients.keySet()]);
                system.debug(' ### mapClients in updateLeadSuppression ' + mapClients.size() + ' => ' + mapClients);
                
                for (Lead ld : leads) {
                    if (trigger.isInsert && ld.Referring_Client__c != null) {
                        system.debug(' ### updating Lead Suppression field ' + ld.Name + ' to ' + mapClients.get(ld.Referring_Client__c).Enterprise_Suppression__c);
                        ld.Enterprise_Associate_Suppression__c = mapClients.get(ld.Referring_Client__c).Enterprise_Suppression__c;
                    }
                }
            }
            
            System.debug(LoggingLevel.Error,'SOQL Statements: '+Limits.getQueries());
            updateLeadSuppression();
            System.debug(LoggingLevel.Error,'SOQL Statements: '+Limits.getQueries());
        }
    }
    
    /**
* updates Lead's Associate Suppression field.
*/
/*    public static void updateLeadSuppression() {
        
        system.debug(' ### leadIds in updateLeadSuppression ' + leadIds.size() + ' => ' + leadIds);
        if (leadIds != null && !leadIds.isEmpty()) {
            
            map<Id, boolean> mapAssociateSuppressionOld = new map<Id, boolean>{};
                map<Id, boolean> mapAssociateSuppressionNew = new map<Id, boolean>{};
                    
                    // gather all Associate's Pending or Active work orders
                    for (Opportunity wo : [Select rs_leadAssociate__c, rs_leadAssociate__r.Enterprise_Associate_Suppression__c, rs_client__r.Enterprise_Suppression__c from Opportunity where rs_leadAssociate__c in :leadIds and rs_leadAssociate__r.IsConverted = false and RecordType.DeveloperName = 'Work_Order' and StageName in :woStages]) {
                        
                        mapAssociateSuppressionOld.put(wo.rs_leadAssociate__c, wo.rs_leadAssociate__r.Enterprise_Associate_Suppression__c);
                        
                        if (!mapAssociateSuppressionNew.containsKey(wo.rs_leadAssociate__c)) mapAssociateSuppressionNew.put(wo.rs_leadAssociate__c, false);
                        if (wo.rs_client__r.Enterprise_Suppression__c) mapAssociateSuppressionNew.put(wo.rs_leadAssociate__c, true);
                    }
            
            set<Id> associatesWithoutWOs = new set<Id>{};
                list<Lead> associates_To_Update = new list<Lead>{};
                    
                    for (Id lid : leadIds) {
                        if (!mapAssociateSuppressionNew.containsKey(lid)) associatesWithoutWOs.add(lid);
                        if (mapAssociateSuppressionNew.containsKey(lid) && mapAssociateSuppressionNew.get(lid) != mapAssociateSuppressionOld.get(lid)) associates_To_Update.add(new Lead(Id=lid, Enterprise_Associate_Suppression__c=mapAssociateSuppressionNew.get(lid)));
                    }
            
            // reset Associate's suppression field based upon Referring Client suppression field
            system.debug(' ### associatesWithoutWOs in updateLeadSuppression ' + associatesWithoutWOs.size() + ' => ' + associatesWithoutWOs);
            for (Lead ld : [Select Id, Name, Enterprise_Associate_Suppression__c, Referring_Client__c, Referring_Client__r.Name, Referring_Client__r.Enterprise_Suppression__c from Lead where Id in :associatesWithoutWOs]) {
                boolean newSuppression = ld.Referring_Client__c != null ? ld.Referring_Client__r.Enterprise_Suppression__c : false;
                system.debug(' ### Lead ' + ld.Name + ' newSuppression ' + newSuppression + ' Referring_Client__r.Name ' + ld.Referring_Client__r.Name + ' Referring_Client__r.Enterprise_Suppression__c ' + ld.Referring_Client__r.Enterprise_Suppression__c);
                
                if (newSuppression != ld.Enterprise_Associate_Suppression__c) associates_To_Update.add(new Lead(Id=ld.Id, Enterprise_Associate_Suppression__c=newSuppression));
            }
            
            system.debug(' ### associates_To_Update in updateLeadSuppression ' + associates_To_Update.size() + ' => ' + associates_To_Update);
            allowAssociateSuppressionUpdate = true;
            if (!associates_To_Update.isEmpty()) update associates_To_Update;
            //allowAssociateSuppressionUpdate = false;
        }
    }    
    
    /**
* updates Person Account's Enterprise Associate Suppression field.   
*/
/*    public static void updateAssociateSuppression() {
        
        system.debug(' ### associateIds in updateAssociateSuppression ' + associateIds.size() + ' => ' + associateIds);
        if (associateIds != null && !associateIds.isEmpty()) {
            
            map<Id, boolean> mapAssociateSuppressionOld = new map<Id, boolean>{};
                map<Id, boolean> mapAssociateSuppressionNew = new map<Id, boolean>{};
                    
                    // gather all Associate's Pending or Active work orders
                    for (Opportunity wo : [Select AccountId, Account.Enterprise_Associate_Suppression__pc, rs_client__r.Enterprise_Suppression__c from Opportunity where AccountId in :associateIds and RecordType.DeveloperName = 'Work_Order' and StageName in :woStages]) {
                        
                        mapAssociateSuppressionOld.put(wo.AccountId, wo.Account.Enterprise_Associate_Suppression__pc);
                        
                        if (!mapAssociateSuppressionNew.containsKey(wo.AccountId)) mapAssociateSuppressionNew.put(wo.AccountId, false);
                        if (wo.rs_client__r.Enterprise_Suppression__c) mapAssociateSuppressionNew.put(wo.AccountId, true);
                    }
            
            set<Id> associatesWithoutWOs = new set<Id>{};
                list<Account> associates_To_Update = new list<Account>{};
                    
                    for (Id aid : associateIds) {
                        if (!mapAssociateSuppressionNew.containsKey(aid)) associatesWithoutWOs.add(aid);
                        if (mapAssociateSuppressionNew.containsKey(aid) && mapAssociateSuppressionNew.get(aid) != mapAssociateSuppressionOld.get(aid)) associates_To_Update.add(new Account(Id=aid, Enterprise_Associate_Suppression__pc=mapAssociateSuppressionNew.get(aid)));
                    }
            
            // reset Associate's suppression to false, if there are no Pending or Active Work Orders.
            system.debug(' ### associatesWithoutWOs in updateAssociateSuppression ' + associatesWithoutWOs.size() + ' => ' + associatesWithoutWOs);
            for (Account a : [Select Id from Account where Id in :associatesWithoutWOs and Enterprise_Associate_Suppression__pc = true]) {
                associates_To_Update.add(new Account(Id=a.Id, Enterprise_Associate_Suppression__pc=false));
            }
            
            system.debug(' ### associates_To_Update in updateAssociateSuppression ' + associates_To_Update.size() + ' => ' + associates_To_Update);
            allowAssociateSuppressionUpdate = true;
            if (!associates_To_Update.isEmpty()) update associates_To_Update;
            //allowAssociateSuppressionUpdate = false;
        }
    }
    
    /**
* Update DD254 WO Joint records to kick off the work flow rule to update Work Order Expired field, when an Opportunity Stage is updated.
*/
    public static void updateDD254WorkOrderExpired(list<Opportunity> opps, map<Id, Opportunity> mapOldOpps) {
        
        if (opps != null && !opps.isEmpty()) {
            
            set<Id> oppIds = new set<Id>{};
                for (Opportunity opp : opps) {
                    if ( opp.StageName != mapOldOpps.get(opp.Id).StageName && (opp.StageName == 'Inactive' || mapOldOpps.get(opp.Id).StageName == 'Inactive') ) {
                        oppIds.add(opp.Id);
                    }
                }
            
            system.debug(' ### oppIds in updateDD254WorkOrderExpired ' + oppIds.size() + ' => ' + oppIds);
            if (!oppIds.isEmpty()) {
                list<DD_254_WO_Joint__c> woJoints_To_Update = [Select Id from DD_254_WO_Joint__c where Work_Order__c in : oppIds];
                
                system.debug(' ### woJoints_To_Update in updateDD254WorkOrderExpired ' + woJoints_To_Update.size() + ' => ' + woJoints_To_Update);
                update woJoints_To_Update;
            }
        }
    }
}