/**********************************************************
* Description      : Lead Helper class 
* @author          : Kiran Kurella
* @date            : April 16, 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

public with sharing class LeadHelper {
    
    private static boolean disableWFRules = false;
    
    //// When a lead's alumni referral value is set make sure a campaign member is created referencing the client
    public static void alumniReferral (List<lead> ldList){
        // Check if ldList is populated
        if(!ldList.isEmpty() && ldList != null){
            //// Create utility lists
            // Create Campaign Member List for Upsert
            List<CampaignMember> cm = new List<CampaignMember>();
            // Create varaible for campaign that campaign members will belong to
            Campaign cmp = new Campaign();
            // Create a map of lead ID and alumni ID
            Set<Id> acctCheck = new Set<Id>();
            Set<Id> acctConf = new Set<Id>();
            Map<Id, Id> ld_acct = new Map<Id ,Id>();
            
            //// Build a list of IDs to confirm
            // Itearte through the ldList
            for (Lead ld : ldList){
                // See if the list of leads has the Alumni Referral Id set
                if (ld.Alumni_Referrer__c!=null && ld.Alumni_Referrer__c!=''){
                    // Populate the set
                    acctCheck.add(Id.valueOf(ld.Alumni_Referrer__c));
                }
            }
            
            //// Iterate through the set and confirm the account exists
            for (Account acct : [SELECT Id FROM Account WHERE Id IN :acctCheck]){
                // Add to the confirmed account list
                acctConf.add(acct.Id);
            }
            
            //// Iterate through the list of leads, now with the confirmed accounts, and build the map for campaign members
            for (lead ld : ldList){
                if(ld.Alumni_Referrer__c!=null && ld.Alumni_Referrer__c!=''){
                    if(acctConf.contains(Id.valueOf(ld.Alumni_Referrer__c))){
                        // If the alumni value is in the confirmed accounts set, put the lead and alumni value to the map
                        ld_acct.put(ld.Id, Id.valueOf(ld.Alumni_Referrer__c));
                    } else {
                        // If the alumni value is not in the identified accounts set, put the lead and a null value to the map
                        ld_acct.put(ld.Id, null);
                    }
                }
            }
            
            //// Does a campaign member exist and is it accurate
            if(ld_acct!=null&&!ld_acct.isEmpty()){
                // Send a message letting me know no campaign exists and end the process
                IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY] == 0){
                    // Build the message
                    Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
                    sem.setToAddresses(new String[] {'garrettz@mbopartners.com'});
                    sem.setSubject('Client Alumni Referral Program Issue');
                    String messageBody = 'The following list of leads were attempting to create campaign members for the Client Alumni Referral program, but there wasn\'t a capmaign for them to relate to:'+ld_acct.keySet();
                    sem.setPlainTextBody(messageBody);
                    // Send the message stating the campaign members cannot be inserted because a campaign doesn't exist
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { sem });
                }  else {
                    // Find the active Campaign
                    cmp = [SELECT Id, OwnerId FROM Campaign WHERE Name LIKE 'Client Alumni Referral Program%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY LIMIT 1];
                    // Map any existing Campaign Members to the Lead and Account map
                    for (CampaignMember c : [SELECT Id, Associated_Account__c, LeadId FROM CampaignMember WHERE CampaignId=:cmp.Id AND LeadId IN :ld_acct.keySet()]) {
                        // Check if Campaign Member's Associated Account matches the identified Account
                        if(c.Associated_Account__c!=ld_acct.get(c.LeadId)){
                            c.Associated_Account__c=ld_acct.get(c.LeadId);
                            cm.add(c);
                        }
                        // Remove the Lead from the Lead and Account Map
                        ld_acct.remove(c.LeadId);
                    }
                }
                
                // For any remaining Leads create a campaign member
                if(ld_acct!=null&&!ld_acct.isEmpty()&&cmp!=null){
                    // Iterate through the map
                    for (Id ldId : ld_acct.keySet()){
                        if(ld_acct.get(ldId)==null){
                            // If the map has a null value, set a null value for the associated account
                            CampaignMember c = new CampaignMember(CampaignId=cmp.Id, LeadId=ldId, Status='Inserted');
                            cm.add(c);
                        } else {
                            // If the map has a value, set the value for the associated account
                            CampaignMember c = new CampaignMember(Associated_Account__c=ld_acct.get(ldId), CampaignId=cmp.Id, LeadId=ldId, Status='Inserted');
                            cm.add(c);
                        }
                    }
                }
                
                //// Upsert the list of CampaignMembers
                Upsert cm;
            }
        }
    }
    
    public static void assignLeadOwner(list<Lead> newLeads, map<Id, Lead> mapOldLeads) {
        if (newLeads != null && !newLeads.isEmpty()) {
            
            list<Lead> leads_To_Process = new list<Lead>{};
                map<Id, My_Biz_Office_User__c> mapMBOUsers = new map<Id, My_Biz_Office_User__c>();
            Id ld_CRA = Util.getRecordTypeId('Lead','CRA');
            Id ld_DA = Util.getRecordTypeId('Lead','Direct_Associate');
            
            for (Lead ld : newLeads) {
                if ( ld.Enrollment_Manager__c != null && (ld.RecordTypeId == ld_CRA || ld.RecordTypeId == ld_DA) && 
                    (trigger.isInsert || ld.Enrollment_Manager__c != mapOldLeads.get(ld.Id).Enrollment_Manager__c)
                   ) {
                       
                       leads_To_Process.add(ld);
                       mapMBOUsers.put(ld.Enrollment_Manager__c, null);
                   }
            }
            
            if (!mapMBOUsers.isEmpty()) {
                mapMBOUsers.putAll([select Id, Salesforce_User__c from My_Biz_Office_User__c where Id in : mapMBOUsers.keySet() and Salesforce_User__c != null]);
                system.debug(' ### mapMBOUsers ' + mapMBOUsers.size() + ' => ' + mapMBOUsers);
                
                for (Lead ld : leads_To_Process) {
                    if (mapMBOUsers.get(ld.Enrollment_Manager__c) != null) ld.OwnerId = mapMBOUsers.get(ld.Enrollment_Manager__c).Salesforce_User__c;	//&& mapMBOUsers.get(ld.Enrollment_Manager__c).Salesforce_User__c != null
                }
            }
        }
    }
    
    public static void assignEnrollmentManager(list<Lead> newLeads, map<Id, Lead> mapOldLeads) {
        
        if (newLeads != null && !newLeads.isEmpty()) {
            
            map<Id, Id> mapLeadOwnerId_To_MBOUserId = new map<Id, Id>{};
                Id queueId = [SELECT g.ID FROM Group g WHERE g.DeveloperName = 'CSA_Inquiries'].Id;
            Set<Id> rtId = new Set<Id>{Util.getRecordTypeId('Lead', 'CRA'),Util.getRecordTypeId('Lead', 'Direct_Associate')};
                
                for (Lead ld : newLeads) {
                    if ( rtId.contains(ld.RecordTypeId) && ld.owner.Type!='Queue' &&
                        /*ld.RecordTypeId == Util.getRecordTypeId('Lead', 'CRA') || ld.RecordTypeId == Util.getRecordTypeId('Lead', 'Direct_Associate')) && */
                        ( (trigger.isInsert && ld.Enrollment_Manager__c == null) ||
                         (trigger.isUpdate && ld.OwnerId != mapOldLeads.get(ld.Id).OwnerId &&
                          (mapOldLeads.get(ld.Id).OwnerId == queueId || ld.Status == 'New')
                         )
                        )
                       ){
                           mapLeadOwnerId_To_MBOUserId.put(ld.OwnerId, null);
                       }
                }
            
            if (!mapLeadOwnerId_To_MBOUserId.isEmpty()) {
                for (My_Biz_Office_User__c mboUser : [select Id, Salesforce_User__c 
                                                      from My_Biz_Office_User__c 
                                                      where Salesforce_User__c in : mapLeadOwnerId_To_MBOUserId.keySet() 
                                                      order by Salesforce_User__c, CreatedDate]) {
                                                          if (mapLeadOwnerId_To_MBOUserId.get(mboUser.Salesforce_User__c) == null) mapLeadOwnerId_To_MBOUserId.put(mboUser.Salesforce_User__c, mboUser.Id);
                                                      }
                system.debug(' ### mapLeadOwnerId_To_MBOUserId ' + mapLeadOwnerId_To_MBOUserId.size() + ' => ' + mapLeadOwnerId_To_MBOUserId);
                
                for (Lead ld : newLeads) {
                    if ( rtId.contains(ld.RecordTypeId) && ld.owner.Type!='Queue' &&
                        /*ld.RecordTypeId == Util.getRecordTypeId('Lead', 'CRA') || ld.RecordTypeId == Util.getRecordTypeId('Lead', 'Direct_Associate')) &&*/
                        ( (trigger.isInsert && ld.Enrollment_Manager__c == null) ||
                         (trigger.isUpdate && ld.OwnerId != mapOldLeads.get(ld.Id).OwnerId &&
                          (mapOldLeads.get(ld.Id).OwnerId == queueId || ld.Status == 'New')
                         )
                        )
                       ) {
                           if (mapLeadOwnerId_To_MBOUserId.get(ld.OwnerId) != null) ld.Enrollment_Manager__c = mapLeadOwnerId_To_MBOUserId.get(ld.OwnerId);
                       }
                }
            }
            
            assignBusinessManager(newLeads, mapOldLeads);
        }
    }
    
    public static void assignBusinessManager(list<Lead> newLeads, map<Id, Lead> mapOldLeads) {
        
        if (newLeads != null && !newLeads.isEmpty()) {
            Set<Id> rtId = new Set<Id>{Util.getRecordTypeId('Lead', 'CRA'),Util.getRecordTypeId('Lead', 'Direct_Associate')};
                
                for (Lead ld : newLeads) {
                    if (ld.rs_BM__c == null && ld.Enrollment_Manager__c != null && rtId.contains(ld.RecordTypeId) &&
                        (trigger.isInsert || ld.rs_BM__c != mapOldLeads.get(ld.Id).rs_BM__c || ld.Enrollment_Manager__c != mapOldLeads.get(ld.Id).Enrollment_Manager__c || ld.RecordTypeId != mapOldLeads.get(ld.Id).RecordTypeId)
                       ) {
                           ld.rs_BM__c = ld.Enrollment_Manager__c;
                       }
                }
        }
    }
    
    public static void convertCRAandDirectAssociateLeads(list<Lead> leads) {
        
        set<Id> convertedLeadIds = new set<Id>{};
            try {
                if (!disableWFRules && leads != null && !leads.isEmpty()) {
                    //if (system.isFuture()) system.debug(' ### future method of convertCRAandDirectAssociateLeads');
                    
                    map<Id, My_Biz_Office_User__c> mapBusinesstManager = new map<Id, My_Biz_Office_User__c>(); 
                    for (Lead ld : leads) {
                        if (ld.rs_BM__c != null && !ld.IsConverted && ld.Associate_Status__c == 'Active' && (ld.RecordTypeId == Util.getRecordTypeId('Lead', 'CRA') || ld.RecordTypeId == Util.getRecordTypeId('Lead', 'Direct_Associate'))) {
                            mapBusinesstManager.put(ld.rs_BM__c, null);
                        }
                    }
                    
                    if (!mapBusinesstManager.isEmpty()) {
                        mapBusinesstManager = new map<Id, My_Biz_Office_User__c> ([select Id, Salesforce_User__c from My_Biz_Office_User__c where Id in : mapBusinesstManager.keySet() and Salesforce_User__c != null]);
                    }
                    
                    list<Database.LeadConvert> leadConverts = new list<Database.LeadConvert>(); 
                    for (Lead ld : leads) {
                        if (!ld.IsConverted && ld.Associate_Status__c == 'Active' && (ld.RecordTypeId == Util.getRecordTypeId('Lead', 'CRA') || ld.RecordTypeId == Util.getRecordTypeId('Lead', 'Direct_Associate'))) {
                            
                            convertedLeadIds.add(ld.Id);
                            
                            Database.LeadConvert lc = new Database.LeadConvert();
                            lc.setLeadId(ld.Id);
                            lc.setConvertedStatus('Sold');
                            lc.setDoNotCreateOpportunity(true);
                            if (mapBusinesstManager.containsKey(ld.rs_BM__c)) lc.setOwnerId(mapBusinesstManager.get(ld.rs_BM__c).Salesforce_User__c);
                            
                            leadConverts.add(lc);
                        }
                    }
                    
                    system.debug(' ### leadConverts ' + leadConverts + ' isFuture ' + system.isFuture());
                    if (!leadConverts.isEmpty()) {
                        Database.LeadConvertResult[] lcr = Database.convertLead(leadConverts, true);
                    }
                }
            } catch (DmlException ex) {
                system.debug(' ### exception in convertCRAandDirectAssociateLeads ' + ex + ' isFuture ' + system.isFuture());
                if (ex.getDmlMessage(0).containsIgnoreCase('Unable to convert lead that is in use by workflow')) {
                    
                    list<Lead> leads_To_Update = new list<Lead>{};
                        
                        // disable time-based WF rules first and then auto-convert the leads.				
                        for (Id cid : convertedLeadIds) leads_To_Update.add(new Lead(Id=cid, Ignore_Workflow__c=true));
                    
                    disableWFRules = true;
                    update leads_To_Update;
                    disableWFRules = false;
                    convertCRAandDirectAssociateLeads_Future(convertedLeadIds);
                } else {
                    leads[0].addError(ex.getDmlMessage(0));
                }
                //} catch (Exception ex) {
                //leads[0].addError(ex.getMessage());
                //throw ex;
            }
    }
    
    /*@author: Garrett Zaino, @date: November 4, 2014, Description: Get Company Leads with new Account__c, Update Owner*/    
    public static void companyLeadAccountChange (list<Lead> company, map<Id, Lead> mapCompany) {
        
        Set<Id> accountIds = new Set<Id>();
        List<Lead> leads = new List<Lead>();
        Id clientRtId = Util.getRecordTypeId('Lead', 'Client');
        For(Lead l : company){
            
            If(l.recordTypeId == clientRtId &&
               l.Account__c != NULL && 
               (trigger.isInsert || (trigger.isUpdate && 
                                     l.Account__c != mapCompany.get(l.Id).Account__c))){
                                         
                                         accountIds.add(l.Account__c);
                                         leads.add(l);
                                     }
        }
        
        Map<Id, Account> accounts = new Map<Id,Account> ([SELECT OwnerId
                                                          FROM Account
                                                          WHERE Id in :accountIds]);
        If (accounts.size()>0) {
            
            companyOwnerUpdateAccountChange(accounts,leads, FALSE);
        }
    }
    
    /*@author: Garrett Zaino, @date: November 4, 2014, Description: Update Company Lead Owner to Account Onwer*/    
    public static void companyOwnerUpdateAccountChange (Map<Id,Account> accounts, List<Lead> leads, Boolean acctUpdate) {
        System.debug(acctUpdate);
        If (acctUpdate == TRUE){
            System.Debug('TRUE');
            List<lead> ld = new List<lead>();
            For (Lead l : leads) {
                l.OwnerId = accounts.get(l.Account__c).OwnerId;
                ld.add(l);
            }
            update ld;
        } else {
            System.debug('FALSE');
            For (lead l :leads) {
                l.OwnerId = accounts.get(l.Account__c).OwnerId;
            }
        }
    }
    
    public static void queueOwnership(list<Lead> leadList){
        
        If(leadList != NULL && !leadList.isEmpty()){
            Id queuePR = [SELECT g.id FROM Group g WHERE g.DeveloperName='Public_Relations'].id;
            Id queueCO = [SELECT g.id FROM Group g WHERE g.DeveloperName='Company'].id;
            Id coRT = util.getRecordTypeId('lead', 'Client');
            
            For(lead a :leadList){
                IF(a.OwnerId==queuePR||a.OwnerId==queueCO){
                    a.RecordTypeId=coRT;
                }
            }
        }
    }
    
    public Static Void medFullTimeUpdate(List<lead> newLead, Map<Id,Lead> mapOldLead){
        if(!newLead.isEmpty() && newLead!=null){
            Map<Id, Enrollment_Code__c> enrlCode = new Map<Id, Enrollment_Code__c> ([SELECT Id, Name 
                                                                                     FROM Enrollment_Code__c 
                                                                                     WHERE Name LIKE '%PT']);
            List<Lead> leadListPT = new List<Lead>();
            List<Lead> leadListFT = new List<Lead>();
            
            for (Lead ld: newLead){
                If(enrlCode.containsKey(ld.Enrollment_Code__c) && !enrlCode.containsKey(mapOldLead.get(ld.Id).Enrollment_Code__c)){ //If Old Enrl Code wasn't PT but now is
                    leadListPT.add(ld);
                }
                If(!enrlCode.containsKey(ld.Enrollment_Code__c) && enrlCode.containsKey(mapOldLead.get(ld.Id).Enrollment_Code__c)){ //If Old Enrl Code was PT but now isn't
                    leadListFT.add(ld);
                }
            }
            
            List<Enrollment__c> enrlListPT = new List<Enrollment__c>();
            If((leadListPT != NULL && !leadListPT.isEmpty())||(leadListFT != NULL && !leadListFT.isEmpty())){
                For(Enrollment__c e : [SELECT Id, Lead__c, MDFTWorker__c
                                       FROM Enrollment__c
                                       WHERE Lead__c IN :leadListPT]){
                                           enrlListPT.add(e);
                                       }
            }
            
            List<Enrollment__c> enrlListFT = new List<Enrollment__c>();
            If(leadListFT != NULL && !leadListFT.isEmpty()){
                For(Enrollment__c e : [SELECT Id, Lead__c, MDFTWorker__c
                                       FROM Enrollment__c
                                       WHERE Lead__c IN :leadListFT]){
                                           enrlListFT.add(e);
                                       }
            }
            
            EnrollmentHelper.updateMed(enrlListPT, enrlLIstFT);
        }
    }
    
    public Static Void lhiCampaignMember (List<Lead> newLead){
        IF(newLead != null && !newLead.isEmpty()){
            IF([SELECT Count() 
                FROM Campaign 
                WHERE Name 
                LIKE 'Client Referral Program%'
                AND IsActive=TRUE
                AND StartDate <= TODAY
                AND EndDate >= TODAY
                LIMIT 1]==1 &&
               [SELECT Count()
                FROM Account
                WHERE Name = 'Logistics Health Incorporated'
                LIMIT 1]==1){
                    Id clientCampaign = [SELECT c.Id FROM Campaign c WHERE c.Name LIKE 'Client Referral Program%' AND c.IsActive=TRUE AND c.StartDate <= TODAY AND c.EndDate >= TODAY ORDER BY c.CreatedDate Desc LIMIT 1].Id;
                    Id lhiID = [SELECT a.Id FROM Account a WHERE a.Name = 'Logistics Health Incorporated' LIMIT 1].Id;
                    Set<Id> ldSet = new Set<Id>();
                    
                    IF([SELECT Label, CampaignId
                        FROM CampaignMemberStatus 
                        WHERE CampaignId=:clientCampaign 
                        AND Label='Inserted'].size()!=1){
                            CampaignMemberStatus cms = new CampaignMemberStatus (CampaignId=clientCampaign, Label='Inserted', IsDefault=TRUE);
                            Insert cms;
                        }
                    
                    FOR(Lead ld :newLead){
                        IF(ld.Referring_Client__c==lhiId){
                            ldSet.add(ld.Id);
                        }
                    }
                    
                    List<CampaignMember> cmList = new List<CampaignMember>();
                    FOR(Id ld : ldSet){
                        CampaignMember cm = new CampaignMember(CampaignId=clientCampaign, LeadId =ld, Associated_Account__c = lhiId, Status='Inserted');
                        cmList.add(cm);
                    }
                    
                    Insert cmList;
                }
        }
    }
    
    /*    public static void soldLeadRestriction(){
//Continue Development
}*/
    
    @future
    private static void convertCRAandDirectAssociateLeads_Future(set<Id> leadIds) {
        if (leadIds != null && !leadIds.isEmpty()) {
            convertCRAandDirectAssociateLeads([select Id, Name, rs_BM__c, IsConverted, Associate_Status__c, RecordTypeId from Lead where Id in : leadIds]);
        }
    }
    
    public static void generateMBOId(list<SObject> sobjs) {
        if (sobjs != null && !sobjs.isEmpty()) {
            system.debug(' ### sobjs ' + sobjs.size() + ' => ' + sobjs);
            
            for (SObject sobj : sobjs) {
                if ((String) sobj.get('MBO_ID__c') == null) sobj.put('MBO_ID__c', Util.generateGUID()); 
                //sobj.put('MBO_ID__c', Util.generateGUID());
            }
            
            //if (!trigger.isExecuting) update sobjs;
            if (!trigger.isExecuting) Database.update(sobjs, false);
        }
    }
    
    /*	Use the following code, if we use Clone operation. 

public static void generateMBOId(list<Lead> leads) {
if (leads != null && !leads.isEmpty()) {
for (Lead ld : leads) {
if (ld.MBO_ID__c == null || (trigger.isExecuting && trigger.isInsert)) ld.MBO_ID__c = Util.generateGUID(); 
}

if (!trigger.isExecuting) update leads;
}
}

public static void generateMBOId(list<Contact> contacts) {
if (contacts != null && !contacts.isEmpty()) {

map<Id, String> mapContactId_To_LeadadGUID = new map<Id, String>{}; 
for (Contact con : contacts) {
if (con.MBO_ID__c == null || (trigger.isExecuting && trigger.isInsert)) mapContactId_To_LeadadGUID.put(con.Id, null); 
}

if (!mapContactId_To_LeadadGUID.isEmpty()) {

for (Lead ld : [Select Id, ConvertedContactId, MBO_ID__c from Lead where ConvertedContactId in : mapContactId_To_LeadadGUID.keySet()]) {
mapContactId_To_LeadadGUID.put(ld.ConvertedContactId, ld.MBO_ID__c);
}

for (Contact con : contacts) {
if (con.MBO_ID__c == null || (trigger.isExecuting && trigger.isInsert)) {
con.MBO_ID__c = mapContactId_To_LeadadGUID.get(con.Id); 
if (con.MBO_ID__c == null) con.MBO_ID__c = Util.generateGUID();
}
}

update contacts;
}
}
}
*/
    
    public static void updateConvertedLeadEnrollmentsAndQualifications(list<Lead> newLeads, map<Id, Lead> mapOldLeads) {
        if (newLeads != null && !newLeads.isEmpty() && mapOldLeads != null && !mapOldLeads.isEmpty()) {
            
            map<Id, Lead> mapLeadId_To_ContactId = new map<Id, Lead>{};
                for (Lead ld : newLeads) {
                    if (ld.isConverted && !mapOldLeads.get(ld.Id).isConverted && ld.ConvertedContactId != null) {
                        mapLeadId_To_ContactId.put(ld.Id, ld);
                    }
                }
            
            if (!mapLeadId_To_ContactId.isEmpty()) {
                // update Lead Enrollements with Converted Contact Id
                list<Enrollment__c> enrollments_To_Update = [select Id, Activation_Date__c, Lead__c, Contact__c from Enrollment__c where Lead__c in :mapLeadId_To_ContactId.keySet()];
                for (Enrollment__c e : enrollments_To_Update){
                    e.Contact__c = mapLeadId_To_ContactId.get(e.Lead__c).ConvertedContactId;
                    IF(e.Activation_Date__c==null && mapLeadId_To_ContactId.get(e.Lead__c).fd_bcStatusChange__c!=null) e.Activation_Date__c = mapLeadId_To_ContactId.get(e.Lead__c).fd_bcStatusChange__c;
                }
                system.debug(' ### enrollments_To_Update ' + enrollments_To_Update.size() + ' => ' + enrollments_To_Update);
                update enrollments_To_Update;
                
                // update Lead Qualifications with Converted Contact Id
                list<Qualification__c> qualifications_To_Update = [select Id, rs_companyContact__c, Contact__c from Qualification__c where rs_companyContact__c in :mapLeadId_To_ContactId.keySet()];
                for (Qualification__c q : qualifications_To_Update) q.Contact__c = mapLeadId_To_ContactId.get(q.rs_companyContact__c).ConvertedContactId;
                system.debug(' ### qualifications_To_Update ' + qualifications_To_Update.size() + ' => ' + qualifications_To_Update);
                update qualifications_To_Update;
            }
        }
    }
}