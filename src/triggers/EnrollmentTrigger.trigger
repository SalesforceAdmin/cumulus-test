trigger EnrollmentTrigger on Enrollment__c (before insert, before update, after insert, after update, after delete, after undelete) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        EnrollmentHelper.leadChange(Trigger.new);
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete)){
        EnrollmentHelper.leadEnrollmentRollupSummary(Trigger.new, Trigger.oldMap);
    }
}