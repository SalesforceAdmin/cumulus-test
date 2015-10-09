/**********************************************************
* Description      : Test methods for Triggers and Classes
* @author          : Kiran Kurella
* @date            : April 21 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

@isTest (seeAllData=false)
public class MBOPartnersTests {
    
    private MBOPartnersTests() {
        // create SF Users
        system.assertEquals(SFUsers.isEmpty(), false);
    }
    
    static testMethod void test_LeadTrigger() {
        
        //system.assertEquals(MBOUsers.isEmpty(), false);
        
        //build test company leads for insert
        list<Lead> companyLeads = new list<Lead>();
        for (Integer i = 1; i <= 250; i++) {
            Lead a = new Lead(FirstName='Test', LastName='Leada '+i, Title='CEO', Company='Consulting Co '+i,
                              Status='New', Phone='(555)-555-5555', Email='Test@test.com',RecordTypeId = Util.getRecordTypeId('Lead', 'Client'),
                              Account__c=companyAccounts[0].Id);
            
            companyLeads.add(a);
        }
        
        system.assertEquals(Qualifications.isEmpty(), false);
        system.assertEquals(Enrollments.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        // create Leads
        system.assertEquals(Leads.isEmpty(), false);
        system.assertEquals(companyLeads.isEmpty(), false);
        
        // convert the Lead
        try {
            
            // kick off assignEnrollmentManager method in LeadHelper
            //leads[2].Enrollment_Manager__c = MBOUsers[0].Id;
            leads[2].OwnerId = MBOUsers[0].Salesforce_User__c; 
            update leads[2];
            
            //leads[1].MBORecordId__c = '1xz';
            leads[1].Associate_Status__c = 'Active';
            leads[1].Enrollment_Manager__c = MBOUsers[0].Id;
            leads[1].Enrollment_Code__c = enrollmentCodes[0].Id;
            leads[1].Status = 'Sold';
            update leads[1];
        } catch (exception ex) {
            system.debug(' ### exception 1 ' + ex);
            system.debug(' ### Lead Info: '+leads[1]);
        }
        
        /*
try {
leads[1].Status = 'Sold';
update leads[1];
} catch (exception ex) {
system.debug(' ### exception 2 ' + ex);
}

try {
leads[1].Enrollment_Code__c = enrollmentCodes[0].Id;
update leads[1];
} catch (exception ex) {
system.debug(' ### exception 3 ' + ex);
}
*/
        
        try {
            leads[2].Associate_Status__c = 'Active';
            update leads[2];
        } catch (exception ex) {
            system.debug(' ### exception 3 ' + ex);
        }
        
        /****** Test LeadHelper.companyLeadAccountChange ********/
        //Single record insert
        Lead l = companyLeads.remove(0);
        System.debug(l);
        try{
            insert l;
        } catch (exception ex) {
            system.debug('Single Record Insert on LeadHelper.companyLeadAccountChange exception' + ex);
        }
        System.debug(l);
        l = [SELECT Id, ownerId
             FROM Lead
             WHERE Id = :l.Id];
        system.assertEquals(companyAccounts[0].ownerId, l.ownerId);
        //Single record update
        l.Account__c = companyAccounts[1].Id;
        try{ 
            update l;
        } catch (exception ex) {
            system.debug('Single Record Update on LeadHelper.companyLeadAccountChange exception' + ex);
        }
        l = [SELECT ownerId
             FROM Lead
             WHERE Id = :l.Id];
        system.assertEquals(companyAccounts[1].ownerId, l.OwnerId);
        
        //Bulk record insert
        try{
            insert companyLeads;
        } catch (exception ex){
            system.debug('Bulk Record Insert on LeadHelper.companyLeadAccountChange exception' + ex);
        }
        List<lead> assertInsert = [SELECT Id, ownerId, Account__c 
                                   FROM Lead 
                                   WHERE Id in :companyLeads 
                                   and OwnerId = :companyAccounts[0].ownerId];
        System.assertEquals(companyLeads.size(), assertInsert.size());
        //Bulk record update
        for(lead lu : assertInsert){
            lu.Account__c = companyAccounts[1].Id;
        }
        try{
            update assertInsert;
        } catch (exception ex){
            system.debug('Bulk Record Update on LeadHelper.companyLeadAccountChange exception' + ex);
        }
        List<lead> assertUpdate = [SELECT Id, ownerId 
                                   FROM Lead 
                                   WHERE Id IN :assertInsert 
                                   and ownerId = :companyAccounts[1].ownerId];
        System.assertEquals(assertInsert.size(), assertUpdate.size());
        
        // Switch back to runtime context
        Test.stopTest();
    }
    
    static testMethod void test_LeadTrigger_queueOwnership(){
        //build test queue Leads for insert
        list<Lead> queueLeads = new List<Lead>();
        list<Lead> nonQueueLeads = new List<Lead>();
        Id queuePR = [SELECT g.id FROM Group g WHERE g.DeveloperName='Public_Relations'].id;
        Id queueCO = [SELECT g.id FROM Group g WHERE g.DeveloperName='Company'].id;
        Id coRT = Util.getRecordTypeId('Lead', 'Client');
        
        for(Integer i = 0; i <= 250; i++){
            Lead a = new Lead(LastName='Test'+i, Email='test'+i+'@test.com', OwnerId=queuePR);
            Lead b = new Lead(LastName='CO'+i, Email='test'+i+'@co.com', OwnerId=queueCo);
            queueLeads.add(a);
            queueLeads.add(b);
        }
        lead qld = queueLeads.remove(0);
        
        for(Integer i = 0; i <= 250; i++){
            Lead a = new Lead(LastName='Non-Test'+i, Email='Non-test'+i+'@test.com', OwnerId=UserInfo.getUserId());
            Lead b = new Lead(LastName='Non-CO'+i, Email='Non-test'+i+'@co.com', OwnerId=UserInfo.getUserId());
            nonQueueLeads.add(a);
            nonQueueLeads.add(b);
        }
        lead ld = nonQueueLeads.remove(0);
        
        //Start Test
        Test.startTest();
        
        /**** LeadHelper.queueOwnership Test ****/
        //Single Record Insert
        Try{
            insert qld;
        } Catch (exception e){
            System.debug(logginglevel.INFO,'##leadHelper.queueOwnership Positive Single Test Insert Exception: '+e.getMessage());
        }
        qld = [SELECT Id, OwnerId, RecordTypeId 
               FROM Lead 
               WHERE Id = :qld.Id];
        System.assertEquals(coRT, qld.RecordTypeId);
        
        Try{
            insert ld;
        } Catch (exception e){
            System.debug('##leadHelper.queueOwnership Negative Single Test Insert Exception: '+e.getMessage());
        }
        ld = [SELECT Id, OwnerId, RecordTypeId 
              FROM Lead 
              WHERE Id = :ld.Id];
        System.assert(ld.RecordTypeId!=coRT);
        
        //Bulk Record Insert
        Try{
            insert queueLeads;
        }Catch(exception e){
            System.debug('##leadHelper.queueOwnership Positive Bulk Test Insert Exception: '+e.getMessage());
        }
        List<Lead> queueLeadsAssert = [SELECT Id, RecordTypeId 
                                       FROM Lead 
                                       WHERE Id IN :queueLeads 
                                       AND RecordTypeId = :coRT];
        System.assertEquals(queueLeads.size(), queueLeadsAssert.size());
        
        Try{
            insert nonQueueLeads;
        }catch (exception e){
            System.debug('##leadHelper.queueOwnership Negative Bulk Test Insert Exception: '+e.getMessage());
        }
        List<Lead> nonQueueLeadsAssert = [SELECT Id, RecordTypeId 
                                          FROM Lead 
                                          WHERE Id IN :nonQueueLeads 
                                          AND RecordTypeId != :coRT];
        System.assertEquals(nonQueueLeads.size(), nonQueueLeadsAssert.size());
        
        //End Test
        Test.stopTest();
    }
    
    Static testMethod void test_LeadTrigger_lhiCampaignMember(){
        /**** Build Test Data ****/
        Id clientCampaign;
        IF([SELECT Count() FROM Campaign WHERE Name LIKE 'Client Referral Program%' AND IsActive=TRUE AND StartDate <= TODAY AND EndDate >= TODAY LIMIT 1]==1){
            clientCampaign = [SELECT c.Id FROM Campaign c WHERE c.Name LIKE 'Client Referral Program%' AND c.IsActive=TRUE AND c.StartDate <= TODAY AND c.EndDate >= TODAY ORDER BY c.CreatedDate Desc LIMIT 1].Id;
        } ELSE {
            Campaign c = new Campaign (Name = 'Client Referral Program (2015)', ActualCost=1000.00, RecordTypeId=Util.getRecordTypeId('Campaign', 'Child'), IsActive = TRUE, StartDate=System.today()-30, EndDate=System.today()+30, Status = 'In Progress', Type='Referral Programs');
            IF([SELECT count() FROM Campaign WHERE Name LIKE 'MBO-Hosted Campaigns' LIMIT 1]==1 ){
                c.ParentId=[SELECT c.Id FROM Campaign c WHERE c.Name LIKE 'MBO-Hosted Campaigns' ORDER BY c.CreatedDate desc LIMIT 1].Id;
            } ELSE {
                Campaign parent = new Campaign (Name = 'MBO-Hosted Campaigns', Type='MBO Independent', Status='In Progress', RecordTypeId=Util.getRecordTypeId('Campaign','Child'));
                Insert parent;
                c.ParentId=parent.Id;
            }
            Insert c;
            CampaignMemberStatus cms = new CampaignMemberStatus(CampaignId=c.Id,Label='Inserted', IsDefault=TRUE, SortOrder=0);
            Insert cms;
            clientCampaign = c.Id;
        }
        
        Id lhiID;
        IF([SELECT count() FROM Account WHERE Name = 'Logistics Health Incorporated' LIMIT 1]==1){
            lhiID = [SELECT a.Id FROM Account a WHERE a.Name = 'Logistics Health Incorporated' LIMIT 1].Id;
        } ELSE {
            Account acct = new Account (Name='Logistics Health Incorporated', RecordTypeId=Util.getRecordTypeId('Account', 'ES_Client'));
            Insert acct;
            lhiID = acct.Id;
        }
        
        List<Lead> ldList = new List<Lead>();
        FOR(Integer i=0; i < 210; i++){
            Lead ld = new Lead();
            ld.Email='test'+i+'@mbopartners.com';
            ld.LastName='test'+i;
            ld.Referring_Client__c=lhiID;
            ldList.add(ld);
        }
        Lead ld = ldList.remove(0);
        
        /**** Begin Test ****/
        Test.startTest();
        
        //Single Lead Insert
        Insert ld;
        System.assert([SELECT Id, CampaignId, LeadId, Status, Associated_Account__c FROM CampaignMember WHERE CampaignId=:clientCampaign AND Associated_Account__c=:lhiID AND LeadId=:ld.Id].size()==1);
        
        //Bulk Lead Insert
        Insert ldList;
        System.assert([SELECT Id, CampaignId, LeadId, Status, Associated_Account__c FROM CampaignMember WHERE CampaignId=:clientCampaign AND Associated_Account__c=:lhiID AND LeadId IN :ldList].size()==ldList.size());
    }
    
    /*    static testMethod void test_LeadTrigger_soldLeadRestriction(){
//Build Test Data
Id daRT = Util.getRecordTypeId('Lead', 'Direct_Associate');
Id craRT = Util.getRecordTypeId('Lead', 'CRA');
Id clientRT = Util.getRecordTypeId('Lead', 'Client');
System.assert(!enrollmentCodes.isEmpty());
System.assert(!MBOUsers.isEmpty());
System.assert(!SFUsers.isEmpty());
Id sfUser;
Id csGroup;

IF([SELECT count() FROM Group WHERE DeveloperName ='ConsultantServices'] < 1){
Group cs = new Group (DeveloperName='ConsultantServices', Name='Consultant Services', Type='Lead');
insert cs;
csGroup=cs.Id;
GroupMember gm = new GroupMember (GroupId=cs.Id, UserOrGroupId=SFUsers[0].Id);
insert gm;
sfUser=gm.UserOrGroupId;
} ELSE {
Group cs = [SELECT g.Id FROM Group g WHERE g.DeveloperName='ConsultantServices'];
csGroup=cs.Id;
IF([SELECT count() FROM GroupMember WHERE GroupId=:cs.id] < 1){
GroupMember gm = new GroupMember (GroupId=cs.Id, UserOrGroupId=SFUsers[0].Id);
sfUser=gm.UserOrGroupId;
} ELSE{
sfUser=[SELECT gm.Id, gm.UserOrGroupId FROM GroupMember gm WHERE gm.GroupId=:cs.Id].UserOrGroupId;
}
}

List<Lead> ldInsert = new List<Lead>();
List<Lead> ldUpdate = new List<Lead>();

For(Integer i=0; i<=250; i++){
Lead ld = new Lead();
ld.LastName='Insert'+i;
ld.Email='Insert'+i+'@mbopartners.com';
ld.RecordTypeId=daRT;
ld.Enrollment_Code__c=enrollmentCodes[0].Id;

Lead l = new Lead();
ld.LastName='Update'+i;
ld.Email='Update'+i+'@mbopartners.com';

}
//  Begin Test  
//Single Record Insert

//When Lead is inserted with (Record Type == Direct or Client Referred) && (Enrollment Code != null or Status == 'Sold') && Current User is in Consultant Services Group && (at least 1 related Enrollment with InvoiceDate__c, ExpectedBillings__c, and AssignmentLength__c != null)
//THEN throw error restricting record from being saved
//Single Record Update

//Bulk Record Insert

//Bulk Record Update

}*/
    
    Static testMethod void leadEnrollmentRollupSumaryInsert(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        /**** Begin Tests ****/
        test.startTest();
        
        //Is initial data accurate
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id 
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        /**** Insert Tests ****/
        //Enrollment with Forecast
        Enrollment__c enr0 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+15, ExpectedBillings__c = 15000.00, AssignmentLength__c = 3);
        Insert enr0;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment with Partial Forecast
        Enrollment__c enr1 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = 20000.00, AssignmentLength__c = 5);
        Insert enr1;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment without Forecast
        Enrollment__c enr2 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
        Insert enr2;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    Static testMethod void leadEnrollmentRollupSumaryUpdate(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        Enrollment__c enr0 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+15, ExpectedBillings__c = 15000.00, AssignmentLength__c = 3);
        Insert enr0;
        Enrollment__c enr1 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = 20000.00, AssignmentLength__c = 5);
        Insert enr1;
        Enrollment__c enr2 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
        Insert enr2;
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Update Tests ****/
        //Enrollment with Forecast
        enr1.Invoice_Date__c=system.today()+31;
        Update enr1;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment with Partial Forecast
        enr2.ExpectedBillings__c=5000.00;
        Update enr2;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment without Forecast
        enr0.Invoice_Date__c = null;
        enr0.ExpectedBillings__c=null;
        enr0.AssignmentLength__c=null;
        Update enr0;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryDelete(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        Enrollment__c enr0 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
        Insert enr0;
        Enrollment__c enr1 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+31, ExpectedBillings__c = 20000.00, AssignmentLength__c = 5);
        Insert enr1;
        Enrollment__c enr2 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = 5000.00, AssignmentLength__c = null);
        Insert enr2;
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Delete Tests ****/
        //Enrollment with Forecast
        Delete enr1;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment with Partial Forecast
        Delete enr2;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment without Forecast
        Delete enr0;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryUndelete(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        Enrollment__c enr0 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
        Insert enr0;
        Delete enr0;
        Enrollment__c enr1 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+31, ExpectedBillings__c = 20000.00, AssignmentLength__c = 5);
        Insert enr1;
        Delete enr1;
        Enrollment__c enr2 = new Enrollment__c (Lead__c=Leads[1].Id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = 5000.00, AssignmentLength__c = null);
        Insert enr2;
        Delete enr2;
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Undelete Tests ****/
        //Enrollment with Forecast
        Undelete enr1;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment with Partial Forecast
        Undelete enr2;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        //Enrollment without Forecast
        Undelete enr0;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryBulkInsert(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        For(Integer i=0; i<50; i++){
            //Full Forecast
            Enrollment__c enrComp = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+10, ExpectedBillings__c = 8000.00, AssignmentLength__c = 5);
            enrList.add(enrComp);
            //Partial Forecast
            Enrollment__c enrPart = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = 10);
            enrList.add(enrPart);
            //No Forecast
            Enrollment__c enrNo = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
            enrList.add(enrNo);
        }
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Bulk Insert Tests ****/
        Insert enrList;
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryBulkUpdate(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        For(Integer i=0; i<50; i++){
            //Full Forecast
            Enrollment__c enrComp = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+10, ExpectedBillings__c = 8000.00, AssignmentLength__c = 5);
            enrList.add(enrComp);
            //Partial Forecast
            Enrollment__c enrPart = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = 10);
            enrList.add(enrPart);
            //No Forecast
            Enrollment__c enrNo = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
            enrList.add(enrNo);
        }
        Insert enrList;
        
        For(Enrollment__c e :enrList) {
            IF (e.Invoice_Date__c==null && e.ExpectedBillings__c==null && e.AssignmentLength__c==null){
                //Partial Forecast
                e.ExpectedBillings__c=Math.random()*50000.00;
            } ELSE IF (e.Invoice_Date__c==null || e.ExpectedBillings__c==null || e.AssignmentLength__c==null){
                //Full Forecast
                IF(e.Invoice_Date__c==null) e.Invoice_Date__c=System.today()+Math.round((Math.random()*10));
                IF(e.ExpectedBillings__c==null) e.ExpectedBillings__c=Math.random()*50000.00;
                IF(e.AssignmentLength__c==null) e.AssignmentLength__c=Math.round(Math.random()*10);
            } ELSE {
                //No Forecast
                IF(e.Invoice_Date__c!=null) e.Invoice_Date__c=null;
                IF(e.ExpectedBillings__c!=null) e.ExpectedBillings__c=null;
                IF(e.AssignmentLength__c!=null) e.AssignmentLength__c=null;
            }
        }
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Bulk Update Tests ****/
        Update enrList;
        
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryBulkDelete(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        For(Integer i=0; i<50; i++){
            //Full Forecast
            Enrollment__c enrComp = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+10, ExpectedBillings__c = 8000.00, AssignmentLength__c = 5);
            enrList.add(enrComp);
            //Partial Forecast
            Enrollment__c enrPart = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = System.today()+Math.round((Math.random()*10)), ExpectedBillings__c = Math.random()*50000.00, AssignmentLength__c = Math.round(Math.random()*10));
            enrList.add(enrPart);
            //No Forecast
            Enrollment__c enrNo = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
            enrList.add(enrNo);
        }
        Insert enrList;
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Bulk Delete Tests ****/
        Delete enrList;
        
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void leadEnrollmentRollupSumaryBulkUndelete(){
        /**** Build Test Data ****/
        System.assert(!Enrollments.isEmpty());
        Id rtDir = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        For(Integer i=0; i<50; i++){
            //Full Forecast
            Enrollment__c enrComp = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = system.today()+10, ExpectedBillings__c = 8000.00, AssignmentLength__c = 5);
            enrList.add(enrComp);
            //Partial Forecast
            Enrollment__c enrPart = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = System.today()+Math.round((Math.random()*10)), ExpectedBillings__c = Math.random()*50000.00, AssignmentLength__c = Math.round(Math.random()*10));
            enrList.add(enrPart);
            //No Forecast
            Enrollment__c enrNo = new Enrollment__c(Lead__c=Leads[1].id, RecordTypeId=rtDir, Invoice_Date__c = null, ExpectedBillings__c = null, AssignmentLength__c = null);
            enrList.add(enrNo);
        }
        Insert enrList;
        Delete enrList;
        
        /**** Begin Tests ****/
        test.startTest();
        
        /**** Bulk Undelete Tests ****/
        Undelete enrList;
        
        System.assertEquals(
            [SELECT Count() 
             From Enrollment__c 
             WHERE Lead__c = :Leads[1].Id
             AND Invoice_Date__c != null 
             AND ExpectedBillings__c != null 
             AND AssignmentLength__c != null], 
            [SELECT l.Enrollment_Checklists_with_Forecasting__c 
             FROM Lead l 
             WHERE l.Id = :Leads[1].id].Enrollment_Checklists_with_Forecasting__c
        );
        
        test.stopTest();
    }
    
    static testMethod void test_enrollmentHelper_MedFTUpdate(){
        //Build data
        Id assocId = Util.getRecordTypeId('Lead', 'Direct_Associate');
        Id directEnrollId = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        List<lead> ldList = new List<lead>();
        List<Enrollment__c> enrllList = new List<Enrollment__c>();
        
        For(Integer i=0;i<60;i++){
            lead ld0 = new lead (lastName='Test'+i, email='test'+i+'@mbopartners.com', Status='New',
                                 Enrollment_Manager__c=MBOUsers[0].Id, RecordTypeId = assocId,
                                 Enrollment_Code__c=enrollmentCodes[0].Id);
            lead ld1 = new lead (lastName='Test'+i, email='test'+i+'@mbopartners.com', Status='New',
                                 Enrollment_Manager__c=MBOUsers[0].Id, RecordTypeId = assocId,
                                 Enrollment_Code__c=enrollmentCodes[1].Id);
            lead ld2 = new lead (lastName='Test'+i, email='test'+i+'@mbopartners.com', Status='New',
                                 Enrollment_Manager__c=MBOUsers[0].Id, RecordTypeId = assocId,
                                 Enrollment_Code__c=enrollmentCodes[2].Id);
            lead ld3 = new lead (lastName='Test'+i, email='test'+i+'@mbopartners.com', Status='New',
                                 Enrollment_Manager__c=MBOUsers[0].Id, RecordTypeId = assocId,
                                 Enrollment_Code__c=enrollmentCodes[3].Id);
            ldList.add(ld0);
            ldList.add(ld1);
            ldList.add(ld2);
            ldList.add(ld3);
        }
        Insert ldList;
        
        Lead lead0 = ldList.remove(0);
        Enrollment__c e0 = new Enrollment__c (RecordTypeId=directEnrollId, Lead__c=lead0.Id);
        Insert e0;
        
        Lead lead1 = ldList.remove(1);
        Enrollment__c e1 = new Enrollment__c (RecordTypeId=directEnrollId, Lead__c=lead1.Id);
        Insert e1;
        
        For(Lead ld :ldList){
            Enrollment__c e = new Enrollment__c (RecordTypeId=directEnrollId, Lead__c=ld.Id);
            enrllList.add(e);
        }
        Insert enrllList;
        
        //Start Test
        Test.startTest();
        
        //Single Assertions
        //Lead's Enrollment Code Changes
        lead0.Enrollment_Code__c=enrollmentCodes[2].Id;
        Update lead0;
        System.assert([SELECT e.MDFTWorker__c FROM Enrollment__c e WHERE e.id=:e0.Id].MDFTWorker__c == 'No');
        
        lead1.Enrollment_Code__c=enrollmentCodes[3].Id;
        Update lead1;
        //        System.assert([SELECT e.MDFTWorker__c FROM Enrollment__c e WHERE e.id=:e1.Id].MDFTWorker__c == null);
        
        //Enrollment's Lead Changes
        List<Enrollment__c> enrllPTList = new List<Enrollment__c>();
        List<Enrollment__c> enrllFTList = new List<Enrollment__c>();
        
        For(Enrollment__c e : [SELECT Lead__c, Lead__r.Enrollment_Code__c,  MDFTWorker__c FROM Enrollment__c WHERE Lead__c = :lead1.Id]){
            e.Lead__c = lead0.Id;
            enrllPTList.add(e);
        }
        
        For(Enrollment__c e : [SELECT Lead__c, Lead__r.Enrollment_Code__c, MDFTWorker__c FROM Enrollment__c WHERE Lead__c = :lead0.Id]){
            e.Lead__c = lead1.Id;
            enrllFTList.add(e);
        }
        
        Update enrllPTList;
        Update enrllFTList;
        
        System.assertEquals([SELECT Lead__c 
                             FROM Enrollment__c 
                             WHERE Lead__c = :lead0.Id].size() ,
                            [SELECT Lead__c, MDFTWorker__c
                             FROM Enrollment__c
                             WHERE Lead__c = :lead0.Id 
                             AND MDFTWorker__c = 'No'].size() );
        
        /*        System.assertEquals([SELECT Lead__c 
FROM Enrollment__c 
WHERE Lead__c = :lead1.Id].size() ,
[SELECT Lead__c, MDFTWorker__c
FROM Enrollment__c
WHERE Lead__c = :lead1.Id 
AND MDFTWorker__c = null].size() );*/
        
        //Enrollment Inserted
        List<Enrollment__c> eList = new List<Enrollment__c>{
            New Enrollment__c(RecordTypeId=directEnrollId, Lead__c=lead0.Id),
                New Enrollment__c(RecordTypeId=directEnrollId, Lead__c=lead1.Id)
                };
                    Insert eList;
        eList = [SELECT Id, RecordTypeId, Lead__c, MDFTWorker__c FROM Enrollment__c WHERE Id IN :eList];
        System.debug(LoggingLevel.INFO,'## eList: '+eList);        
        System.assert(eList.get(0).MDFTWOrker__c=='No');
        //        System.assert(eList.get(1).MDFTWorker__c==null);
        
        //Batch Assertions
        //Lead's Enrollment Codes Changed
        List<lead> ldListPT = new List<lead>();
        List<lead> ldListFT = new List<lead>();
        For(lead ld: LdList){
            If(ld.Enrollment_Code__c==enrollmentCodes[2].Id){
                ld.Enrollment_Code__c=enrollmentCodes[0].Id;
                ldListFT.add(ld);
            }else {
                ld.Enrollment_Code__c=enrollmentCodes[2].Id;
                ldListPT.add(ld);
            }
        }
        Update ldListPT;
        Update ldListFT;
        
        System.assertEquals([SELECT Lead__c 
                             FROM Enrollment__c 
                             WHERE Lead__c IN :ldListPT].size(), 
                            [SELECT Lead__c, MDFTWorker__c 
                             FROM Enrollment__c 
                             WHERE Lead__c IN :ldListPT 
                             AND MDFTWorker__c='No'].size());
        /*        System.assertEquals([SELECT Lead__c 
FROM Enrollment__c 
WHERE Lead__c IN :ldListFT].size(), 
[SELECT Lead__c, MDFTWorker__c 
FROM Enrollment__c 
WHERE Lead__c IN :ldListFT 
AND MDFTWorker__c=null].size());*/
        
        //Enrollment's Lead Changes
        Map<Id,List<Enrollment__c>> leadEnrollmentMap = new Map<Id,List<Enrollment__c>>();
        for(Enrollment__c e : enrllList){
            If(String.isNotBlank(e.Lead__c)){
                if(!leadEnrollmentMap.containsKey(e.Lead__c)){
                    leadEnrollmentMap.put(e.Lead__c, new List<Enrollment__c>());
                }
                leadEnrollmentMap.get(e.Lead__c).add(e);
            }
        }
        
        List<Id> ldIdList = new List<Id>();
        ldIdList.addAll(leadEnrollmentMap.keySet());
        List<Enrollment__c> enrlUpdate = new List<Enrollment__c>();
        For(Integer i = 0; i < ldIdList.size(); i++){
            If(i<ldIdList.size()-1){
                FOR(Enrollment__c e :leadEnrollmentMap.get(ldIdList[i])){
                    e.Lead__c=ldIdList[i+1];
                    enrlUpdate.add(e);
                }
            } Else {
                FOR(Enrollment__c e :leadEnrollmentMap.get(ldIdLIst[i])){
                    e.Lead__c=ldIdList[0];
                    enrlUpdate.add(e);
                }
            }
        }
        Update enrlUpdate;
        
        List<Enrollment__c> endPT = new List<Enrollment__c>();
        enrlUpdate = [SELECT Id,Lead__c, Lead__r.Enrollment_Code__c, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c
                      FROM Enrollment__c
                      WHERE Id IN :enrlUpdate];
        
        FOR(Enrollment__c e: enrlUpdate){
            IF(e.Lead__r.Enrollment_Code__r.Name.endsWith('PT')){
                endPT.add(e);
            }
        }
        System.assertEquals([SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c 
                             FROM Enrollment__c 
                             WHERE Id IN :endPT].size(),
                            [SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c
                             FROM Enrollment__c
                             WHERE Id IN :endPT
                             AND MDFTWorker__c='No'].size());
        /*        System.assertEquals([SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c 
FROM Enrollment__c 
WHERE Id IN :enrlUpdate
AND ID NOT IN :endPT].size(),
[SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWOrker__c
FROM Enrollment__c
WHERE Id IN :enrlUpdate
AND Id NOT IN :endPT
AND MDFTWorker__c=null].size());*/
        
        //Enrollment Inserted
        List<Enrollment__c> enrlFTInsert = New List<Enrollment__c>();
        List<Enrollment__c> enrlPTInsert = New List<Enrollment__c>();
        ldList = [SELECT Id, Enrollment_Code__c, Enrollment_Code__r.Name 
                  FROM Lead
                  WHERE ID IN :ldList];
        For(Lead ld :ldList){
            Enrollment__c e = new Enrollment__c (RecordTypeId=directEnrollId, Lead__c=ld.Id);
            IF(ld.Enrollment_Code__r.Name.endsWith('PT')){
                enrlPTInsert.add(e);
            } else {
                enrlFTInsert.add(e);
            }
        }
        Insert enrlPTInsert;
        Insert enrlFTInsert;
        System.assertEquals([SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c 
                             FROM Enrollment__c 
                             WHERE Id IN :enrlFTInsert].size(),
                            [SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWOrker__c
                             FROM Enrollment__c
                             WHERE Id IN :enrlFTInsert
                             AND MDFTWorker__c=null].size());
        /*        System.assertEquals([SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWorker__c 
FROM Enrollment__c 
WHERE Id IN :enrlPTInsert].size(),
[SELECT Id, Lead__r.Enrollment_Code__r.Name, MDFTWOrker__c
FROM Enrollment__c
WHERE Id IN :enrlPTInsert
AND MDFTWorker__c='No'].size());*/
        
    }
    
    static testMethod void test_MBOPartnersBatcher() {
        
        system.assertEquals(accounts.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        Account consultant = accounts[1];
        
        User admin = [SELECT Id
                      FROM User
                      WHERE UserName LIKE 'mboadmin@mbopartners.co%'];
        
        System.runAs(admin){
            
            /*
consultant.Enrollment_Manager__pc = MBOUsers[0].Id;
consultant.Associate_Status__pc = 'Terminated';
consultant.fd_bcStatusChange__pc = system.today().addMonths(-13);
update consultant;
*/
            
            consultant = [select OwnerId, Enrollment_Manager__pc, Enrollment_Manager__pr.Salesforce_User__c, fd_bcStatusChange__pc, fb_pracOwn__pc from Account where Id = :consultant.Id];
            //system.assertEquals(consultant.OwnerId, MBOUsers[0].Salesforce_User__c);
            
            consultant.fd_bcStatusChange__pc = consultant.fb_pracOwn__pc ? system.today().addMonths(-6) : system.today().addMonths(-12); 
            consultant.OwnerId = UserInfo.getUserId();
            //update consultant;
            
            MBOPartnersBatcher.AccountAlumniAssignment(new list<Account> {consultant});
            
            system.assertNotEquals(MBOPartnersBatcher.canExecuteBatch, null); 
            
            //MBOPartnersBatcher.AccountAlumniAssignment(null);
            MBOPartnersBatcher.startJob(MBOPartnersBatcher.BatchType.AccountAlumniAssignment, null, 1);
            
            // Schedule
            //MBOPartnersBatcher.Schedule('Account Alumni Assignment', BatchType.AccountAlumniAssignment, new set<Id> {consultant.Id}, 1);
            //System.Schedule('Schedule Account Alumni Assignment - Test', MBOPartnersBatcher.cronExpDaily12AM, new MBOPartnersBatcher(bt, consultant.Id, 200));
            MBOPartnersBatcher.Schedule();
            
            // Switch back to runtime context
        }
        Test.stopTest();
    }
    
    static testMethod void test_evaluateTasks() {
        
        system.assertEquals(taskRelationships.isEmpty(), false);
        system.assertEquals(tasks.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        tasks[0].Status = 'Completed Unsuccessfully';
        update tasks[0];
        
        list<Task> task37 = [select Id, Status from Task where WhoId = :Leads[1].Id and Subject = :taskLists[1].Subject__c];
        system.assertEquals(task37.isEmpty(), false);
        
        task37[0].Status = 'Completed Unsuccessfully';
        update task37[0];
        
        // make sure the field updates are done properly.
        String soql = 'select Id, ' + taskLists[0].Parent_Field_Name__c + ', ' + taskLists[1].Parent_Field_Name__c + ' from Lead where Id = \'' + Leads[1].Id + '\'';
        list<Lead> lds = Database.query(soql);
        
        //system.assertEquals(lds[0].get(taskLists[0].Parent_Field_Name__c), system.today());
        //system.assertEquals(lds[0].get(taskLists[1].Parent_Field_Name__c), system.today());
        
        // Switch back to runtime context
        Test.stopTest();
    }
    
    static testMethod void test_Util() {
        // Switch to test context
        Test.startTest();
        
        // raise an error
        system.assertEquals(Util.getRecordTypeId('Account', 'Testingxyz1246'), null);
        
        Util.sendTextEmail('Unable to Complete Work Market Assignment', 'Unable to Complete Work Market Assignment for Opportunity ' + (URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id) + '\n\n', new list<String>{'kkurella@gmail.com'});
        
        system.debug(' ### ' + AccountHelper.WorkMarketClient);
        
        // Switch back to runtime context
        Test.stopTest();
    }
    
    static testMethod void test_OpportunityTrigger() {
        
        // Switch to test context
        Test.startTest();
        
        User admin = [SELECT Id
                      FROM User
                      WHERE UserName LIKE 'mboadmin@mbopartners.co%'];
        
        System.runAs(admin){
            
            // create Opportunity
            system.assertNotEquals(opp.Id, null);
            
            // update oppty stage to kick off the batch process to close Work Market assignment
            opp.StageName = 'Inactive';
            update opp;
            
            MBOPartnersBatcher.CompleteWorkMarketAssignment(new list<Opportunity> {opp});
            
            system.assertNotEquals(MBOPartnersBatcher.canExecuteBatch, null);
            
            //MBOPartnersBatcher.AccountAlumniAssignment(null);
            MBOPartnersBatcher.startJob(MBOPartnersBatcher.BatchType.CompleteWorkMarketAssignment, new set<Id>{opp.Id}, 1);
            
            Util.sendTextEmail('Unable to Complete Work Market Assignment', 'Unable to Complete Work Market Assignment for Opportunity ' + (URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id) + '\n\n', new list<String>{'kkurella@gmail.com'});
        }
        
        // Switch back to runtime context
        Test.stopTest();
    }
    /*
    static testMethod void test_AssociateSuppression() {
        
        // create Client and Associate records
        system.assertEquals(companyAccounts.isEmpty(), false);
        system.assertEquals(personAccounts.isEmpty(), false);
        system.assertEquals(leads.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        // validate initial suppression values
        system.assertEquals(leads[0].Enterprise_Associate_Suppression__c, false);
        // referring client is suppressed
        system.assertEquals(leads[2].Enterprise_Associate_Suppression__c, true);
        
        // there are no work orders and hence the suppression field is set to false.
        system.assertEquals(personAccounts[0].Enterprise_Associate_Suppression__pc, false);
        system.assertEquals(personAccounts[1].Enterprise_Associate_Suppression__pc, false);
        
        // create work orders
        system.assertEquals(WorkOrders.isEmpty(), false);
        
        // re-query Leads and Person Accounts to verify the suppression fields
        Lead ld = [Select Enterprise_Associate_Suppression__c from Lead where Id = :leads[2].Id];
        
        // Lead's Work Order Suppression field is false.
        system.assertEquals(ld.Enterprise_Associate_Suppression__c, false);
        
        // raise an error
        try {
            MBOPartnersHelper.allowAssociateSuppressionUpdate = false;
            ld.Enterprise_Associate_Suppression__c = true;
            update ld;
        } catch (exception ex) {
            // do nothing
        }
        
        Account pa = [Select Id, Enterprise_Associate_Suppression__pc from Account where Id = :personAccounts[0].Id];
        
        // Associate's Work Order Suppression field is true
        system.assertEquals(pa.Enterprise_Associate_Suppression__pc, true);
        
        // raise an error
        try {
            MBOPartnersHelper.allowAssociateSuppressionUpdate = false;
            pa.Enterprise_Associate_Suppression__pc = false;
            update pa;
        } catch (exception ex) {
            // do nothing
        }
        
        system.runAs(MBOPartnersHelper.MBOAdminUser) {
            
            MBOPartnersHelper.allowAssociateSuppressionUpdate = false;
            
            companyAccounts[1].Enterprise_Suppression__c = false;
            update companyAccounts[1];
            
            companyAccounts[1].Enterprise_Suppression__c = true;
            update companyAccounts[1];
            
            leads[1].Referring_Client__c = companyAccounts[1].Id;
            leads[2].Referring_Client__c = null;
            update leads[1];
            update leads[2];
            
            delete workOrders;
            
            // re-query Leads and Person Accounts to verify the suppression fields
            pa = [Select Id, Enterprise_Associate_Suppression__pc from Account where Id = :personAccounts[0].Id];
            
            // there are no Work Orders and verify the suppression field is false
            system.assertEquals(pa.Enterprise_Associate_Suppression__pc, false);
        }
        
        // Switch back to runtime context
        Test.stopTest();
    }
    */
    static testMethod void test_DD254WOExpired() {
        
        system.assertNotEquals(SecurityClearance.Id, null);
        
        // create Client and Associate records
        system.assertEquals(companyAccounts.isEmpty(), false);
        system.assertEquals(personAccounts.isEmpty(), false);
        system.assertEquals(leads.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        // create work orders
        system.assertEquals(WorkOrders.isEmpty(), false);
        
        // create DD_254 and their corresponding Joint records
        //system.assertEquals(DD254WOJoints.isEmpty(), false);
        
        DD254 = [Select Name, Total_Number_of_WOs__c, Total_Number_of_Expired_WOs__c, All_Work_Orders_Expired__c from DD_254__c where Id = :DD254.Id];
        
        system.assertEquals(DD254.Total_Number_of_WOs__c, 0);
        system.assertEquals(DD254.Total_Number_of_Expired_WOs__c, 0);
        system.assertEquals(DD254.All_Work_Orders_Expired__c, false);
        
        system.runAs(MBOPartnersHelper.MBOAdminUser) {
            WorkOrders[0].StageName = 'Inactive';
            update WorkOrders[0];
        }
        
        // Switch back to runtime context
        Test.stopTest();
    }
    
    static testMethod void test_enrollmentActivation_singleInsert() {
        // Setup an Associate Lead with an Enrollment for activation
        System.assert(!Enrollments.isEmpty());
        System.assert(!Leads.isEmpty());
        //// Relate the Enrollment to the Associate Lead
        Enrollments[0].Lead__c=Leads[2].id;
        Update Enrollments[0];
        //// Prepare the Associate Lead
        Leads[2].Associate_Status__c='Active';
        Leads[2].fd_bcStatusChange__c=Date.today();
        //// Assert the Enrollment is setup properly
        System.assert(Enrollments[0].Activation_Date__c==null);
        //// Begin Admin User
        User admin = [SELECT Id FROM User WHERE Id='00580000003Xfjx'];
        System.runAs(admin){
        
            // Begin Test
            test.startTest();
            
            // Activate Associate
            Update Leads[2];
            
            // End Test
            test.stopTest();
        }
        
        // Assert Enrollment has the correct activation date
        System.debug('Enrollment Activation Date: '+[SELECT e.Activation_Date__c FROM Enrollment__c e WHERE Id = :Enrollments[0].Id].Activation_Date__c);
        System.debug('Lead Status Change Date: '+Leads[2].fd_bcStatusChange__c);
        System.assert([SELECT e.Activation_Date__c FROM Enrollment__c e WHERE Id = :Enrollments[0].Id].Activation_Date__c == Leads[2].fd_bcStatusChange__c);
    }
    
    static testMethod void test_enrollmentActivation_singleUpdate(){
        // Setup an Associate Account with an Enrollment for activation
        System.assert(!Enrollments.isEmpty());
        System.assert(!personAccounts.isEmpty());
        //// Relate Enrollment Record to the Associate Account
        Enrollments[0].Lead__c=null;
        Enrollments[0].Contact__c=[SELECT Id, AccountId FROM Contact WHERE AccountId=:personAccounts[0].Id].Id;
        Update Enrollments[0];
        //// Perpare Associate Account
        personAccounts[0].Associate_Status__pc='Active';
        personAccounts[0].fd_bcStatusChange__pc=Date.today();
        //// Assert the Enrollment is setup properly
        System.assert(Enrollments[0].Activation_Date__c==null);
        //// Begin Admin User
        User admin = [SELECT Id FROM User WHERE Id='00580000003Xfjx'];
        System.runAs(admin) {
        
            // Begin Test
            test.startTest();
            
            // Activate Associate
            Update personAccounts[0];
            
            // End Test
            test.stopTest();
        }

        // Assert Enrollment has the correct Activation Date
        System.assert([SELECT e.Activation_Date__c FROM Enrollment__c e WHERE Id = :Enrollments[0].Id].Activation_Date__c == personAccounts[0].fd_bcStatusChange__pc);
    }
    
    static testMethod void test_enrollmentActivation_bulkInsert(){
        // Setup a few Associate Leads with a bulk quantity of Enrollments for activation
        Id dirEnrRT = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        //// Build the Leads
        System.assert(!Leads.isEmpty());
        Leads[1].Enrollment_Code__c=enrollmentCodes[0].Id;
        Update Leads[1];
        //// Prepare the Enrollments
        List<Enrollment__c> enrollList = new List<Enrollment__c>();
        For(Integer i=0; i>=249; i++){
            Enrollment__c e1 = new Enrollment__c(Lead__c=Leads[1].Id, RecordTypeId=dirEnrRT);
            Enrollment__c e2 = new Enrollment__c(Lead__c=Leads[2].Id, RecordTypeId=dirEnrRT);
            enrollList.add(e1);
            enrollList.add(e2);
        }
        Insert enrollList;
        //// Prepare the Leads
        List<Lead> leadList = new List<Lead>();
        Leads[1].Associate_Status__c='Active';
        Leads[1].fd_bcStatusChange__c=Date.today();
        Leads[2].Associate_Status__c='Active';
        Leads[2].fd_bcStatusChange__c=Date.today()+1;
        leadList.add(Leads[1]);
        leadList.add(Leads[2]);
        //// Confirm Enrollments are setup properly
        System.assert([SELECT count() FROM Enrollment__c WHERE Id IN :enrollList AND Activation_Date__c!=null]==0);
        //// Begin Admin User
        User admin = [SELECT Id FROM User WHERE Id='00580000003Xfjx'];
        System.runAs(admin){
            
            // Begin Test
            test.startTest();
            
            // Activate Associates
            Update leadList;
            
            // End Test
            test.stopTest();
        }
        
        // Assert all Enrollments have the correct Activation Date
        System.assert([SELECT count() FROM Enrollment__c WHERE Lead__c=:Leads[1].Id AND Activation_Date__c!=:Leads[1].fd_bcStatusChange__c]==0);
        System.assert([SELECT count() FROM Enrollment__c WHERE Lead__c=:Leads[2].Id AND Activation_Date__c!=:Leads[2].fd_bcStatusChange__c]==0);
    }
    
    static testMethod void test_enrollmentActivation_bulkUpdate() {
        // Setup a few Associate Accounts with a bulk quantity of enrollments for activation
        Id dirEnrRT = Util.getRecordTypeId('Enrollment__c', 'Direct_Enrollment');
        //// Build the Accounts
        System.assert(!personAccounts.isEmpty());
        //// Prepare the Enrollments
        List<Enrollment__c> enrollList = new List<Enrollment__c>();
        For(Integer i=0; i>=249; i++){
            Enrollment__c e1 = new Enrollment__c(Lead__c=personAccounts[0].Id, RecordTypeId=dirEnrRT);
            Enrollment__c e2 = new Enrollment__c(Lead__c=personAccounts[1].Id, RecordTypeId=dirEnrRT);
            Enrollment__c e3 = new Enrollment__c(Lead__c=personAccounts[2].Id, RecordTypeId=dirEnrRT);
            enrollList.add(e1);
            enrollList.add(e2);
            enrollList.add(e3);
        }
        Insert enrollList;
        //// Prepare the Accounts
        List<Account> accountList = new List<Account>();
        personAccounts[0].Associate_Status__pc='Active';
        personAccounts[1].Associate_Status__pc='Active';
        personAccounts[2].Associate_Status__pc='Active';
        personAccounts[0].fd_bcStatusChange__pc=Date.today();
        personAccounts[1].fd_bcStatusChange__pc=Date.today()+1;
        personAccounts[2].fd_bcStatusChange__pc=Date.today()+2;
        accountList.add(personAccounts[0]);
        accountList.add(personAccounts[1]);
        accountList.add(personAccounts[2]);
        //// Confirm Enrollments are setup properly
        System.assert([SELECT count() FROM Enrollment__c WHERE Id IN :enrollList AND Activation_Date__c!=null]==0);
        //// Begin Admin User
        User admin = [SELECT Id FROM User WHERE Id='00580000003Xfjx'];
        System.runAs(admin){
            
            // Begin Test
            test.startTest();
            
            // Activate Associate
            Update accountList;
            
            // End Test
            test.stopTest();
        }
        
        // Assert all Enrollments have the correct Activation Date
        System.assert([SELECT count() FROM Enrollment__c WHERE Contact__r.AccountId=:accountList[0].Id AND Activation_Date__c=:accountList[0].fd_bcStatusChange__pc]==0);
        System.assert([SELECT count() FROM Enrollment__c WHERE Contact__r.AccountId=:accountList[1].Id AND Activation_Date__c=:accountList[1].fd_bcStatusChange__pc]==0);
        System.assert([SELECT count() FROM Enrollment__c WHERE Contact__r.AccountId=:accountList[2].Id AND Activation_Date__c=:accountList[2].fd_bcStatusChange__pc]==0);
    }

    static testMethod void test_BillRateCalculator() {

        // create Client and Associate records
        //system.assertEquals(leads.isEmpty(), false);
        
        // Switch to test context
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'POST';
        // Add a JSON Header as it is validated
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BillRate/v1/';
        req.requestBody = Blob.valueOf('{'+
                                       '	\"user\" : {'+
                                       '		\"userId\" : \"\",'+
                                       '		\"firstName\" : \"MBO\",'+
                                       '		\"lastName\" : \"Customer\",'+
                                       '		\"email\" : \"BRCLeadTest1x@mbopartners.com\",'+
                                       '		\"state\" : \"VA\"'+
                                       '	},'+
                                       '	\"targetWages\" : 100000,	'+
                                       '	\"profitMargin\" : 0.1,'+
                                       '	\"workHours\" : 50,'+
                                       '	\"nonBillableTime\" : ['+
                                       '    		{ \"purpose\" :	\"Business Development\", \"amount\" : 10, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Invoicing and Collection\", \"amount\" : 10, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Contract Management\", \"amount\" : 0, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Additional Business Admin\", \"amount\" : 0, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Expense Tracking\", \"amount\" : 0, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Professional Development\", \"amount\" : 0, \"periods\" : 52 },'+
                                       '    		{ \"purpose\" :	\"Time Off\", \"amount\" : 10, \"periods\" : 8 },'+
                                       '    		{ \"purpose\" :	\"Other Non-Billable Time\", \"amount\" : 10, \"periods\" : 8}'+
                                       '	],'+
                                       '	\"expenses\" : ['+
                                       '		{ \"purpose\" :	\"Business Insurance\", \"amount\" : 5000, \"periods\" : 1 },'+
                                       '		{ \"purpose\" :	\"Communications\", \"amount\" : 500, \"periods\" : 12 },'+
                                       '		{ \"purpose\" :	\"Professional Fees\", \"amount\" : 1500, \"periods\" : 1 },'+
                                       '		{ \"purpose\" :	\"Other Expenses\", \"amount\" : 250, \"periods\" : 12 },'+
                                       '		{ \"purpose\" :	\"Office Equipment\", \"amount\" : 500, \"periods\" : 1 },'+
                                       '		{ \"purpose\" :	\"Professional Development\", \"amount\" : 1500, \"periods\" : 1 },'+
                                       '		{ \"purpose\" :	\"Non-Billable Travel\", \"amount\" : 3000, \"periods\" : 1 },'+
                                       '		{ \"purpose\" :	\"Marketing and Sales\", \"amount\" : 1000, \"periods\" : 12 },'+
                                       '		{ \"purpose\" :	\"Non-Billable Meals and Entertainment\", \"amount\" : 2500, \"periods\" : 12 },'+
                                       '		{ \"purpose\" :	\"Personal Insurance\", \"amount\" : 1000, \"periods\" : 12 },'+
                                       '		{ \"purpose\" :	\"Retirement\", \"amount\" : 10000, \"periods\" : 12 }			'+
                                       '	]'+
                                       '}');
        system.debug(' ### req: ' + req);
        
        RestContext.request = req;
        RestContext.response = res;
        
        // return zero as the required parameters are missing
        BillRateCalculator.doPost();
        
        system.assertEquals(MBOPartnersTests.StateTaxRates.isEmpty(), false);
        BillRateCalculator.mapStateTaxRates = null;
        
        // create a new Lead
        //req.requestBody = Blob.valueOf('{"user":{"userId":"","firstName":"MBO","lastName":"Customer","email":"BRCLeadTest1x@mbopartners.com","state":"VA"},"targetWages":100000,"profitMargin":0.1,"workHours":50,"nonBillableTime":[{"purpose":"Business Development","amount":10,"periods":52},{"purpose":"Invoicing and Collection","amount":10,"periods":52},{"purpose":"Contract Management","amount":0,"periods":52},{"purpose":"Additional Business Admin","amount":0,"periods":52},{"purpose":"Expense Tracking","amount":0,"periods":52},{"purpose":"Professional Development","amount":0,"periods":52},{"purpose":"Time Off","amount":10,"periods":8},{"purpose":"Other Non-Billable Time","amount":10,"periods":8}],"expenses":[{"purpose":"Business Insurance","amount":5000,"periods":1},{"purpose":"Communications","amount":500,"periods":12},{"purpose":"Professional Fees","amount":1500,"periods":1},{"purpose":"Other Expenses","amount":250,"periods":12},{"purpose":"Office Equipment","amount":500,"periods":1},{"purpose":"Professional Development","amount":1500,"periods":1},{"purpose":"Non-Billable Travel","amount":3000,"periods":1},{"purpose":"Marketing and Sales","amount":1000,"periods":12},{"purpose":"Non-Billable Meals and Entertainment","amount":2500,"periods":12},{"purpose":"Personal Insurance","amount":1000,"periods":12},{"purpose":"Retirement","amount":10000,"periods":12}]}');
        BillRateCalculator.doPost();
        
        // temporarily adding the Lead as the Post method is not finding the existing Lead
        Lead ld = new Lead (FirstName='BRC', LastName='LEAD', Email='BRCLeadTest1x@mbopartners.com', RecordTypeId=Util.getRecordTypeId('Lead','Direct_Associate'));
        insert ld;
        
        // update an existing Lead's Bill Rate Result record. 
        BillRateCalculator.doPost();
        
        BillRateCalculator.BillRateDetail brd = new BillRateCalculator.BillRateDetail();
        
        // Switch back to runtime context
        Test.stopTest();
    }

/*****************************************************************************************************************************************
												Setup test data
*****************************************************************************************************************************************/
    
    public static list<Account> accounts {
        get {
            if (accounts == null) {
                accounts = new List<Account> {
                    new Account(Name='Microsoft', Phone='(123)456-7890', Industry='IT', fs_wMClientAccessID__c='3543636565', RecordTypeId=Util.getRecordTypeId('Account', 'ES_Client')),
                        new Account(Name='Oracle', Phone='(123)456-7890', Industry='IT', fs_wMClientAccessID__c='12132324232', RecordTypeId=Util.getRecordTypeId('Account', 'ES_Client')),
                        new Account(FirstName='Kiran', LastName='Kumar', Phone='(124)456-7890', Industry='IT', RecordTypeId=Util.getRecordTypeId('Account', 'Partners_Associate')),
                        new Account(FirstName='James', LastName='Bond', Phone='(124)456-7890', Industry='IT', RecordTypeId=Util.getRecordTypeId('Account', 'Partners_Associate'))
                        };
                            
                            insert accounts;
            }
            return accounts;
        }
        private set;
    }
    
    public static list<Account> companyAccounts {
        get {
            if (companyAccounts == null) {
                companyAccounts = new list<Account> {
                    new Account(Name='MBOTest1', Phone='(124)456-7890', Industry='IT', RecordTypeId=Util.getRecordTypeId('Account', 'ES_Client'), OwnerId=SFUsers[0].Id, Tier__c='5', Enterprise_Suppression__c=false),
                        new Account(Name='MBOTest2', Phone='(124)456-7890', Industry='IT', RecordTypeId=Util.getRecordTypeId('Account', 'ES_Client'), OwnerId=SFUsers[1].Id, Tier__c='5', Enterprise_Suppression__c=true)
                        };
                            insert companyAccounts;
            }
            return companyAccounts;
        }
        private set;
    }
    
    public static list<Account> personAccounts {
        get {
            if (personAccounts == null) {
                Id rtAssoc=Util.getRecordTypeId('Account', 'Partners_Associate');
                personAccounts = new List<Account> {
                    new Account(FirstName='Test', LastName='Assoc1', Phone='(124)456-7890', PersonEmail='test@mbopartners.com', RecordTypeId=rtAssoc, Enterprise_Associate_Suppression__pc=false),
                        new Account(FirstName='Test', LastName='Assoc2', Phone='(124)456-7890', PersonEmail='test2@mbopartners.com', RecordTypeId=rtAssoc, Enterprise_Associate_Suppression__pc=false),
                        new Account(FirstName='Test', LastName='Assoc3', Phone='(123)456-7890', PersonEmail='test3@mbopartners.com', RecordTypeId=rtAssoc, Enterprise_Associate_Suppression__pc=false)
                        };
                            
                            insert personAccounts;
            }
            return personAccounts;
        }
        private set;
    }
    
    public static list<Contact> Contacts {
        get {
            if (Contacts == null) {
                
                Contacts = new list<Contact> {                     
                    new Contact(AccountId = companyAccounts[0].Id, FirstName='Company Contact', LastName='User 1', Email='test1@gmail.com')                    
                        };
                            
                            insert Contacts;
            }
            return Contacts;
        }
        private set;
    }
    
    public static list<Lead> Leads {
        get {
            if (Leads == null) {
                Leads = new list<Lead> {
                    new Lead(FirstName='Kiran', LastName='Kumar', Title='CEO',//Company='Kurella Consulting',
                             Status='New', rs_opsAdmin__c=MBOUsers[0].Id, LeadSource='Other/Legacy', Phone='(555)-555-5555',
                             Email='Test@test.com', Persona__c='Consultant', Enterprise_Associate_Suppression__c=false,
                             Enrollment_Manager__c=MBOUsers[0].Id, RecordTypeId = Util.getRecordTypeId('Lead', 'Direct_Associate'),
                             Associate_Status__c='Active', Enrollment_Code__c = enrollmentCodes[0].Id, Referring_Client__c=null),//MBORecordId__c='1xz'
                        
                        new Lead(FirstName='Non SFUser', LastName='Manager1', Title='Assistant',
                                 Status='New', rs_opsAdmin__c=MBOUsers[0].Id, LeadSource='Other/Legacy', Phone='(555)-155-5555',
                                 Email='test@nonSFUser.com', Persona__c='Assistant', Enterprise_Associate_Suppression__c=false,
                                 Enrollment_Manager__c=MBOUsers[1].Id, RecordTypeId = Util.getRecordTypeId('Lead', 'Direct_Associate'), Referring_Client__c=null),//MBORecordId__c='xzy',
                        
                        new Lead(FirstName='Non SFUser', LastName='Manager2', Title='Assistant',
                                 Status='Sold', rs_opsAdmin__c=MBOUsers[0].Id, LeadSource='Other/Legacy', Phone='(555)-155-5555', 
                                 Email='test@nonSFUser.com', Persona__c='Assistant', Enterprise_Associate_Suppression__c=false,
                                 //Enrollment_Manager__c=MBOUsers[1].Id, Enrollment_Code__c = enrollmentCodes[0].Id,
                                 OwnerId=SFUsers[0].Id, Enrollment_Code__c = enrollmentCodes[0].Id,
                                 RecordTypeId = Util.getRecordTypeId('Lead', 'Direct_Associate'), Associate_Status__c='Pending', Referring_Client__c=companyAccounts[1].Id)
                        };
                            
                            insert Leads;
                
                Leads = [Select Id, Name, FirstName, LastName, Title, Status, LeadSource, Phone, Email, Persona__c, Enterprise_Associate_Suppression__c, Enrollment_Manager__c, 
                         Enrollment_Code__c, RecordTypeId, Associate_Status__c, IsConverted
                         from Lead
                         where Id in :leads];
            }
            return Leads;
        }
        private set;
    }
    
    public static list<Enrollment__c> Enrollments {
        get {
            if (Enrollments == null) {
                Enrollments = new list<Enrollment__c> {
                    new Enrollment__c(Lead__c=Leads[1].Id, associateType__c=true, WOSetup__c=true),
                        new Enrollment__c(Lead__c=Leads[1].Id, SFActivitiesClosed__c=true, CSATransitionCall__c=true)
                        };
                            
                            insert Enrollments;
            }
            return Enrollments;
        }
    }
    
    public static list<Qualification__c> Qualifications {
        get {
            if (Qualifications == null) {
                Qualifications = new list<Qualification__c> {
                    new Qualification__c(rs_companyContact__c=Leads[1].Id, rs_qualificationAdvisor__c=MBOUsers[0].Id, fs_companyName__c='Test Company', fd_sow__c=true)
                        };
                            
                            insert Qualifications;
            }
            
            return Qualifications;
        }
    }
    
    public static Opportunity opp {
        get {
            if (opp == null) {
                opp = new Opportunity(Name='Test Work Assignment', RecordTypeId=Util.getRecordTypeId('Opportunity', 'Work_Order'), CloseDate=system.today().addDays(-4), fs_woStart__c=system.today().addDays(-3), fs_woEnd__c=system.today().addDays(3), 
                                      fs_wMAssignmentID__c='987654321', rs_client__c=accounts[0].Id, fn_pUnitCompleted__c=10, StageName='Active');
                insert opp;
            }
            return opp;
        }
        private set;
    }
    
    public static list<Opportunity> WorkOrders {
        get {
            if (WorkOrders == null) {
                WorkOrders = new list<Opportunity> {
                    new Opportunity(Name='Test Work Assignment 1', RecordTypeId=Util.getRecordTypeId('Opportunity', 'Work_Order'), CloseDate=system.today().addDays(-4), fs_woStart__c=system.today().addDays(-2), fs_woEnd__c=system.today().addDays(2), fs_wMAssignmentID__c='987654321', rs_client__c=companyAccounts[0].Id, AccountId=null, rs_leadAssociate__c=Leads[2].Id, fn_pUnitCompleted__c=10, StageName='Active'),
                        new Opportunity(Name='Test Work Assignment 2', RecordTypeId=Util.getRecordTypeId('Opportunity', 'Work_Order'), CloseDate=system.today().addDays(-4), fs_woStart__c=system.today().addDays(-1), fs_woEnd__c=system.today().addDays(1), fs_wMAssignmentID__c='987654322', rs_client__c=companyAccounts[1].Id, AccountId=personAccounts[0].Id, rs_leadAssociate__c=null, fn_pUnitCompleted__c=10, StageName='Active')
                        //new Opportunity(Name='Test Work Assignment 3', RecordTypeId=Util.getRecordTypeId('Opportunity', 'Work_Order'), CloseDate=system.today().addDays(-4), fs_woStart__c=system.today().addDays(-1), fs_woEnd__c=system.today().addDays(1), fs_wMAssignmentID__c='987654322', rs_client__c=companyAccounts[1].Id, AccountId=CompanyAccounts[0].Id, rs_leadAssociate__c=null, fn_pUnitCompleted__c=10, StageName='Active'),
                        //new Opportunity(Name='Test Work Assignment 4', RecordTypeId=Util.getRecordTypeId('Opportunity', 'Work_Order'), CloseDate=system.today().addDays(-4), fs_woStart__c=system.today().addDays(-1), fs_woEnd__c=system.today().addDays(1), fs_wMAssignmentID__c='987654322', rs_client__c=companyAccounts[1].Id, AccountId=CompanyAccounts[0].Id, rs_leadAssociate__c=null, fn_pUnitCompleted__c=10, StageName='Active')
                        };
                            
                            insert WorkOrders;
            }
            
            return WorkOrders;
        }
    }
    
    public static list<User> SFUsers {
        get {
            if(SFUsers == null) {
                SFUsers = new list<User> {
                    
                    new User(ProfileID = UserInfo.getProfileId(), EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US', TimeZoneSidKey = 'America/New_York',	//UserRoleId = CustomerPortalUserRoleId,
                             LocaleSidKey = 'en_US', FirstName = 'Test', LastName='User1', Username='TestUser1@TestUser123.com', CompanyName = 'MBO Partners',
                             CommunityNickname = 'testUser123', Alias = 't1', Email = 'TestUser1@TestUser1.com', IsActive = true),
                        
                        new User(ProfileID = UserInfo.getProfileId(), EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US', TimeZoneSidKey = 'America/New_York',	//UserRoleId = CustomerPortalUserRoleId,
                                 LocaleSidKey = 'en_US', FirstName = 'Test', LastName='User2', Username='TestUser2@TestUser123.com', CompanyName = 'MBO Partners',
                                 CommunityNickname = 'testUser321', Alias = 't2', Email = 'TestUser2@TestUser2.com', IsActive = true)
                        };
                            
                            insert SFUsers;
            }
            return SFUsers;
        }
    }
    
    public static list<My_Biz_Office_User__c> MBOUsers {
        get {
            if(MBOUsers == null) {
                MBOUsers = new list<My_Biz_Office_User__c> {
                    
                    new My_Biz_Office_User__c(Name=SFUsers[0].FirstName + ' ' + SFUsers[0].LastName, Email__c=SFUsers[0].Email, First_Name__c=SFUsers[0].FirstName,
                                              Last_Name__c=SFUsers[0].LastName, Full_Name__c=SFUsers[0].FirstName + ' ' + SFUsers[0].LastName, MBORecordID__c='MBOUser10001',
                                              fs_phone__c='123-456-7890', Salesforce_User__c=SFUsers[0].Id, fs_title__c='Operational Account Manager', UserName__c=SFUsers[0].Email),
                        
                        new My_Biz_Office_User__c(Name='Non SF User', Email__c='test@nonSFUser.com', First_Name__c='Non SF',
                                                  Last_Name__c='User', Full_Name__c='Non SF User', MBORecordID__c='MBOUser10002',
                                                  fs_phone__c='122-456-7890', Salesforce_User__c=null, fs_title__c='Consultant Services Advisor', UserName__c='test@nonSFUser.com')            								
                        };
                            
                            insert MBOUsers;
            }
            return MBOUsers;
        }
    }
    
    public static list<Enrollment_Code__c> enrollmentCodes {
        get {
            if (enrollmentCodes == null) {
                enrollmentCodes = new List<Enrollment_Code__c> {
                    
                    new Enrollment_Code__c(Name='EC1', fs_dsc__c='Enrollment code 1', fs_mBORecordId__c='MBOEC1'),
                        new Enrollment_Code__c(Name='EC2', fs_dsc__c='Enrollment code 2', fs_mBORecordId__c='MBOEC2'),
                        new Enrollment_Code__c(Name='EC1PT', fs_dsc__c='Enrollment code 1 Part Time', fs_mBORecordId__c='MBOEC3'),
                        new Enrollment_Code__c(Name='ECPT2', fs_dsc__c='Enrollment code 2 Part Time', fs_mBORecordId__c='MBOEC4')
                        
                        };
                            
                            insert enrollmentCodes;
            }
            return enrollmentCodes;
        }
        private set;
    }
    
    public static list<Task_List__c> taskLists {
        get {
            if(taskLists == null) {
                taskLists = new list<Task_List__c> {
                    // Inquiry tasks
                    new Task_List__c(Name='Task36', Subject__c='(Attempt 1) Please call the new inquiry and consult them to see if it\'s a good fit', Type__c='Call', Priority__c='1', Assign_To_MBO_User_Field_Name__c='Enrollment_Manager__c', Assign_To__c=null, Parent_Field_Name__c='fd_slaInitialCall1__c', Status_To_Update_Parent_Field__c='Completed Successfully; Completed Unsuccessfully', IsActive__c=true),
                        new Task_List__c(Name='Task37', Subject__c='(Attempt 2) Please call the new inquiry and consult them to see if it\'s a good fit', Type__c='Call', Priority__c='1', Assign_To_MBO_User_Field_Name__c='Enrollment_Manager__c', Assign_To__c=null, Parent_Field_Name__c='fd_slaInitialCall2__c', Status_To_Update_Parent_Field__c='Completed Successfully; Completed Unsuccessfully', IsActive__c=true),
                        new Task_List__c(Name='Task38', Subject__c='(Attempt 3) Please call the new inquiry and consult them to see if it\'s a good fit', Type__c='Call', Priority__c='1', Assign_To_MBO_User_Field_Name__c=null, Assign_To__c=null, Parent_Field_Name__c='fd_slaInitialCall3__c', Status_To_Update_Parent_Field__c='Completed Successfully; Completed Unsuccessfully', IsActive__c=true),
                        new Task_List__c(Name='Task39', Subject__c='Please move the inquiry to \'Parked\' and escalate them.', Type__c='Action', Priority__c='1', Assign_To_MBO_User_Field_Name__c=null, Assign_To__c=null, Parent_Field_Name__c='fd_slaInitialPark__c', Status_To_Update_Parent_Field__c='Completed Successfully; Completed Unsuccessfully', IsActive__c=true)
                        };
                            
                            insert taskLists;
            }
            return taskLists;
        }
    }
    
    public static list<Task_Relationship__c> taskRelationships {
        get {
            if (taskRelationships == null) {
                taskRelationships = new list<Task_Relationship__c> {
                    new Task_Relationship__c(Parent_Task__c=taskLists[0].Id, Child_Task__c=taskLists[1].Id, Parent_Task_Status__c='Completed Unsuccessfully', Parent_Associate_Status__c=null, IsActive__c=true),
                        new Task_Relationship__c(Parent_Task__c=taskLists[1].Id, Child_Task__c=taskLists[2].Id, Parent_Task_Status__c='Completed Unsuccessfully', Parent_Associate_Status__c=null, IsActive__c=true),
                        new Task_Relationship__c(Parent_Task__c=taskLists[2].Id, Child_Task__c=taskLists[3].Id, Parent_Task_Status__c='Completed Unsuccessfully', Parent_Associate_Status__c=null, IsActive__c=true)
                        };
                            
                            insert taskRelationships;
            }
            return taskRelationships;
        }
    }
    
    public static list<Task> tasks {
        get {
            if (tasks == null) {
                tasks = new list<Task> {
                    new Task(whoId=Leads[1].Id, Subject=taskLists[0].Subject__c, Type=taskLists[0].Type__c, Priority=taskLists[0].Priority__c)
                        };
                            
                            insert tasks;
            }
            return tasks;
        }
    }
    
    public static Security_Clearance__c SecurityClearance {
        get {
            if (SecurityClearance == null) {
                SecurityClearance = new Security_Clearance__c(Associate__c=Contacts[0].Id, Has_DD254__c=false, Classification__c='Secret', Activation_Date__c=system.today().addDays(-2));
                insert SecurityClearance;
            }
            return SecurityClearance;
        }
        private set;
    }
    
    public static DD_254__c DD254 {
        get {
            if (DD254 == null) {
                DD254 = new DD_254__c(Security_Clearance__c=SecurityClearance.Id, Classification__c='Secret', Contact_Name__c=Contacts[0].FirstName + ' ' + Contacts[0].LastName);
                insert DD254;
            }
            return DD254;
        }
        private set;
    }
    
    public static list<DD_254_WO_Joint__c> DD254WOJoints {
        get {
            if (DD254WOJoints == null) {
                DD254WOJoints = new list<DD_254_WO_Joint__c> {
                    new DD_254_WO_Joint__c(DD_254__c=DD254.Id, Work_Order__c=WorkOrders[2].Id),
                        new DD_254_WO_Joint__c(DD_254__c=DD254.Id, Work_Order__c=WorkOrders[3].Id)
                        };
                            
                            insert DD254WOJoints;
            }
            return DD254WOJoints;
        }
    }

    public static list<State_Tax_Rate__c> StateTaxRates {
        get {
            if (StateTaxRates == null) {
                StateTaxRates = new list<State_Tax_Rate__c> {
                		new State_Tax_Rate__c(Name='All', Tax_Rate__c=0.15),
                		new State_Tax_Rate__c(Name='VA', Tax_Rate__c=0.25)
                	};

                insert StateTaxRates;
                system.debug(' ### StateTaxRates ' + StateTaxRates.size() + ' => ' + StateTaxRates);
            }

            return StateTaxRates;
        }
        private set;
    }
}