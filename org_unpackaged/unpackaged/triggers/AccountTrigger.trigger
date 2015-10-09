/**********************************************************
* Description      : Handles various Lead events
* @author          : Kiran Kurella
* @date            : April 17, 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

trigger AccountTrigger on Account (before insert, before update, after update, after undelete, before delete, after delete) {
    
    if (trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        AccountHelper.assignPersonAccountOwner(trigger.new, trigger.oldMap);
        AccountHelper.AccountAlumniAssignment(trigger.new, trigger.oldMap);
        
        //if (trigger.isUpdate) MBOPartnersHelper.restrictAssociateSuppressionUpdate(trigger.new, trigger.oldMap);
    }
    
    if (trigger.isAfter && trigger.isUpdate) {
        AccountHelper.companyAccountOwnerChange(trigger.new, trigger.oldMap);
        AccountHelper.enrollmentActivation(trigger.new, trigger.oldMap);
        AccountHelper.alumniReferral(trigger.new);
    }
    
    //if (trigger.isAfter && (trigger.isUndelete || trigger.isUpdate)) MBOPartnersHelper.updateClientAssociateSuppression(trigger.new, trigger.oldMap);
    //if (trigger.isDelete) MBOPartnersHelper.updateClientAssociateSuppression(trigger.old, null);
}