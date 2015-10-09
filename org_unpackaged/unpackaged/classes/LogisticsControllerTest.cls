@isTest (seeAllData=False)
public class LogisticsControllerTest {

    static testMethod void test_setSL1(){
        // Setup Data
        //// Create MBO Users
        My_Biz_Office_User__c mboUser = new My_Biz_Office_User__c (Name='Test User');
        Insert mboUser;
        
        //// Create Account
        Id coRT = Util.getRecordTypeId('Account', 'ES_Client');
        Account acct = new Account (RecordTypeId=coRT, Name='Test Account', Activity_Status__c='Working', Account_Manager__c = mboUser.Id );
        Insert acct;
        
        //// Create Service Contracts
        List<ServiceContract> scList = new List<ServiceContract>();
        for(Integer i = 0; i < 250; i++){
            ServiceContract sc = new ServiceContract (Name = 'Service Contract'+i, Operations_Lead__c = mboUser.Id, Program_Coordinator__c = mboUser.Id, Service_Level__c = String.valueOf((i+1)/5) );
            scList.add(sc);
        }
        Insert scList;
        
        //// Build Query for Assertion
        List<ServiceContract> scAssert = [SELECT Id FROM ServiceContract WHERE Service_Level__c != '5'];
        
        // Test Controller
        //// Create Controller and List of Contracts
        LogisticsController controller = new LogisticsController();
        List<ServiceContract> getSC = controller.getServiceContracts();
        
        // Assert Controller
        //// Compare Assertion Query to Controller Contracts
        System.assert(scAssert.size() == getSC.size());
    }
}