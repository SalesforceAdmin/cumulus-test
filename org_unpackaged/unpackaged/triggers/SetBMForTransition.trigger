trigger SetBMForTransition on Lead (after update, after insert)
{
//  for(Lead a : [SELECT Id, Associate_Status__c, rs_BM__c from Lead
//                  WHERE (Associate_Status__c = 'Pending'
//                  OR Associate_Status__c='Enrolled' )
//                  AND rs_BM__c = null] )
//                  {a.rs_BM__c=a.Enrollment_Manager__c;}
    for (Lead a : Trigger.New)
    {
        if ((a.Associate_Status__c == 'Pending' || a.Associate_Status__c == 'Enrolled') && a.rs_BM__c == null)
        {
            //My_Biz_Office_User__c EM = [SELECT Id FROM My_Biz_Office_User__c];
            //a.rs_BM__c = a.get(EM.Id);
            //a.rs_BM__c==a.Enrollment_Manager__c;
            //update a;
            a.rs_BM__c = a.Enrollment_Manager__r.Id;
        }
        update a;
    }
}