@isTest
private class SetBMForTransitionTriggerTest
{
    static testMethod void insertAndUpdate() 
    {
		//instantiate the data
//        List<Lead> inquiries = new List<Lead>();
//        My_Biz_Office_User__c a = new My_Biz_Office_User__c();
//        a.name='Sara Conde';
//        My_Biz_Office_User__c b = new My_Biz_Office_User__c();
//        b.name='Nicolette Taylor';
//        insert a;
//        insert b;	
//        for (Integer i = 1; i <=20; i++)
//        {
//        	inquiries.add(new Lead(FirstName='Test'
//        						  ,LastName='Inquiry' + i
//        						  ,Enrollment_Manager__c=b.id
//        					      ,Status='Inquiry'));
//        }
//        for(Lead newInquiry : [SELECT id, name, Enrollment_Manager__c, Status
//        					   FROM Lead
//        					   WHERE Id
//       					   IN :inquiries]){
//					      		  	insert(newInquiry);
//        					   }
//
		//update the data
//        for(Lead change : [SELECT id, name, Enrollment_Manager__c, rs_BM__c, Status 
//        				   FROM Lead
//        				   WHERE Id
//         				   IN :inquiries]){
//        					  	change.Status='Pending';
//      	}
//        for(Lead newInquiry : [SELECT id, name, Enrollment_Manager__c, Status
//        					   FROM Lead
//        					   WHERE Id
//        					   IN :inquiries]){
//					      		  	update(newInquiry);
//        					   }
//
		//test the data
//        for(Lead updated : [SELECT id, name, Enrollment_Manager__c, rs_BM__c 
//        					FROM Lead
//        					WHERE Id
//        					IN :inquiries]){
//                				System.assertEquals(updated.rs_BM__c,updated.Enrollment_Manager__c);
//    	}
    	
    			//instantiate the data
        //My_Biz_Office_User__c a = new My_Biz_Office_User__c();
        //a.name='Sara Conde';
        My_Biz_Office_User__c b = new My_Biz_Office_User__c(name='Nicolette Taylor');
        //insert a;
        insert b;
        System.debug('MBO_User.id=' + b.id + ', MBO_User.name=' + b.name);	
        List<Lead> inquiries = new List<Lead>();
        for (Integer i = 1; i <=20; i++)
        {
        	inquiries.add(new Lead(FirstName='Test'
        						  ,LastName='Inquiry' + i
        						  ,Enrollment_Manager__c=b.id
        					      ,Status='Inquiry'
        					      ,Persona__c='Consultant'
        					      ,Sub_Persona__c='Professional Service Consultant'));
        }
        insert inquiries;
        for(Lead updated : inquiries)
        {
       		System.debug('Lead ID=' + updated.id + ' BM ID=' + updated.rs_BM__c + ' EM ID=' + updated.Enrollment_Manager__c);
        	updated.Status='Pending';
        }
      	update inquiries;
		//test the data
        for(Lead updated : [SELECT id, name, Enrollment_Manager__c, rs_BM__c, status 
        					FROM Lead
        					WHERE Id
        					IN :inquiries])
        {
        	System.debug('Lead ID=' + updated.id + ' Status=' + updated.Status + ' BM ID=' + updated.rs_BM__c + ' EM ID=' + updated.Enrollment_Manager__c);
        	System.assertEquals(updated.Enrollment_Manager__c,updated.rs_BM__c);
    	}
	}
}