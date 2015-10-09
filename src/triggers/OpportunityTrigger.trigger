/**********************************************************
* Description      : Handles various Opportunity events
* @author          : Kiran Kurella
* @date            : Dec 9, 2013
* Copyright 2013 MBO Partners. All rights reserved.
**********************************************************/

trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    
    if (trigger.isAfter && (trigger.isInsert || trigger.isUndelete || trigger.isUpdate)) {
        MBOPartnersHelper.CompleteWorkMarketAssignment(trigger.newMap, trigger.oldMap);
        
        //MBOPartnersHelper.updateClientAssociateSuppression(trigger.new, trigger.oldMap);
        
        if (trigger.isInsert || trigger.isUpdate){
            AccountHelper.initialActiveWorkOrder(trigger.new);
        }
    }
    
    if (trigger.isAfter && trigger.isUpdate) MBOPartnersHelper.updateDD254WorkOrderExpired(trigger.new, trigger.oldMap);
    
    //if (trigger.isAfter && trigger.isDelete) MBOPartnersHelper.updateClientAssociateSuppression(trigger.old, null);
}