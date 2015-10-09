@isTest
public class JobFeedSFToJiveBatchableTest{
	public static testmethod void TestJobFeedSFToJiveBatchable() {
        JiveSettings__c jiveURL = new JiveSettings__c( ); 
        jiveURL.Name = 'JiveURL';
        jiveURL.Value__c = 'https://uat.access.mbopartners.com/api/core/v3';
        //jive.Value__c = 'https://uat.access.mbopartners.com/api/core/v3/search/people';
        insert jiveURL;
        
        JiveSettings__c jiveName = new JiveSettings__c( ); 
        jiveName.Name = 'Jive Username';
        jiveName.Value__c = 'api01';
        insert jiveName;
        
        
        JiveSettings__c jivePW = new JiveSettings__c( ); 
        jivePW.Name = 'Jive Password';
        jivePW.Value__c = 'r8*&!$4*g40XpRsYUw0I';
        insert jivePW;
        
        JiveSettings__c lockTriggerBatchable = new JiveSettings__c();
        lockTriggerBatchable.Name = 'Lock Trigger Batchable';
        lockTriggerBatchable.Value__c = 'false';
        insert lockTriggerBatchable;
        
        /* Populate the date for your lead object and make sure you populate all the field so that this record gets queried in your Start() method */
    	Lead testLead = new Lead( FirstName = 'STEVE' , LastName = 'JOHN', UserName__c = 'stevej', MBOAccess__c = true, Email = 'ramiya@gmail.com', Title = 'testtest', fs_skills__c = 'developement' , fs_overview__c='good', fs_facebook__c='facebook', fs_twitter__c='twitter', fs_linkedin__c = 'linkedin');
        insert testLead;    
        
        Feed__c jobFeed = new Feed__c();
        jobFeed.rs_recipientLead__c = testLead.Id;
        jobFeed.Name = 'Test';
        jobFeed.fs_description__c = 'Test';
        jobFeed.fs_url__c = 'https://www.salesforce.com';
        insert jobFeed;
        
        Set<Id> feedIds = new Set<Id>();
        feedIds.add(jobFeed.Id);
        
        Test.setMock(HTTPCalloutMock.class, new MockHttpResponseGeneratorSanchivan());
        
        Test.startTest();

        JobFeedSFtoJiveBatchable jobFeedSFtoJiveBatchable = new JobFeedSFtoJiveBatchable(feedIds);
        Id batchprocessid = Database.executeBatch(jobFeedSFtoJiveBatchable, 5);  
       
        Test.stopTest();
        
        JivePersonObject personObject = new JivePersonObject();
        personObject.type = 'test Type';
        personObject.displayName = 'test displayName';
        
        JiveProfiles profile = new JiveProfiles();
        profile.jive_label = 'test';
        profile.setvalue('test');
        profile.getvalue();
        
        JivePersonInfo jive = new JivePersonInfo();
        jive.username = 'test username';
        jive.putProfileByName('Test', 'Test Value');
        jive.profile.add(profile);
                
        JiveEmails email = new JiveEmails();
        email.jive_label = 'test';
        email.primary = 'test';
        email.type = 'type';
        email.value = 'test';
        
        JiveName name = new JiveName();
        name.familyName = 'test';
        name.formatted = 'test';
        name.givenName = 'test';
                
        personObject.jive = jive;
        personObject.emails = new List<JiveEmails>();
        personObject.emails.add(email);
        personObject.name = name;
        
        personObject.id = 1111;
        personObject.tags = new List<String>();
        personObject.tags.add('test');
        
        
    }
}