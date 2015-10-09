/**********************************************************
 * Description      : Handles various Lead events
 * @author          : Kiran Kurella
 * @date            : April 16, 2013
 * Copyright 2013 MBO Partners. All rights reserved.
 **********************************************************/

trigger LeadTrigger on Lead (before insert, before update, after insert, after undelete, after update) {

    if (trigger.isBefore && trigger.isInsert) {
        LeadHelper.generateMBOId(trigger.new);
        //MBOPartnersHelper.updateLeadSuppression(trigger.new, trigger.oldMap);
        LeadHelper.queueOwnership(trigger.new);
    }

    if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        LeadHelper.assignLeadOwner(trigger.new, trigger.oldMap);
        LeadHelper.assignEnrollmentManager(trigger.new, trigger.oldMap);
        // Moved Business Manager assignment logic to assignEnrollmentManager in LeadHelper class. 
        //LeadHelper.assignBusinessManager(trigger.new, trigger.oldMap);
        LeadHelper.companyLeadAccountChange(trigger.new, trigger.oldMap); /*@author: Garrett Zaino, @date: November 4, 2014*/
        
        //if (trigger.isUpdate) MBOPartnersHelper.restrictAssociateSuppressionUpdate(trigger.new, trigger.oldMap);
    }

    if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        LeadHelper.convertCRAandDirectAssociateLeads(trigger.new);
        LeadHelper.updateConvertedLeadEnrollmentsAndQualifications(trigger.new, trigger.oldMap);
        LeadHelper.alumniReferral(trigger.new);
        if (trigger.isInsert){
            LeadHelper.lhiCampaignMember(Trigger.new);
        }
        if (trigger.isUpdate){
            LeadHelper.medFullTimeUpdate(trigger.new,trigger.oldMap);
        }
    }

    //if (trigger.isAfter && (trigger.isUndelete || trigger.isUpdate)) MBOPartnersHelper.updateLeadSuppression(trigger.new, trigger.oldMap);
}