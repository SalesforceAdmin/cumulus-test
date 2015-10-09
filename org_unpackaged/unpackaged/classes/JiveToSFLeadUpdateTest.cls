@isTest
public class JiveToSFLeadUpdateTest{
    
    public static testmethod void TestJiveToSFLeadUpdate() {
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
    	Lead testLead = new Lead( FirstName = 'STEVE' , LastName = 'JOHN', UserName__c = 'stevej', Email = 'ramiya@gmail.com', Title = 'testtest', fs_skills__c = 'developement' , fs_overview__c='good', fs_facebook__c='facebook', fs_twitter__c='twitter', fs_linkedin__c = 'linkedin');
        insert testLead;       
        
        Test.setMock(HTTPCalloutMock.class, new MockHttpResponseGeneratorSanchivan());
        
        Test.startTest();

        JiveToSFLeadUpdate leadJiveCallOutBatchable = new JiveToSFLeadUpdate();
        Id batchprocessid = Database.executeBatch(leadJiveCallOutBatchable, 5);  
       
        Test.stopTest();
        
        //String jiveResponse = '{\"type\":\"person\",\"displayName\":\"testing\",\"jive\":{\"username\":\"stevej\",\"profile\":[{\"value\":\"President&CEO,MBOPartners2\",\"jive_label\":\"Title\"},{\"value\":\"11/06/2011\",\"jive_label\":\"JoinDate\"},{\"value\":\"LivedinNYformostofmylifeandthenmovedtotheDCareainthelate90s.BackgroundismostlyentrepreneurialwithsomeformalFinance,AccountingandBusinesstraining.NowIamfocusedonmakingiteasierthaneveryforpeopletotakecontrolandbuildtheirownindependentcareerandbusinesswithMBOPartners.\",\"jive_label\":\"Biography\"},{\"value\":\"ContractTalentmanagement,Entrepreneurship,GeneralBusinessConsulting,ManagementandFinance.\",\"jive_label\":\"Expertise\"},{\"value\":\"IamanentrepreneurwholovestobuildcompaniesandnowIcanhelpothersbuildasuccessfulbusinessesoftheirown.Itssorewarding.\",\"jive_label\":\"What do you do?\"},{\"value\":\"Isurroundmyselfwithgreatpeople,challengethem,guidethem,supportthembutletthemowntheirowntheircontributionstotheteam.\",\"jive_label\":\"MyStyle\"},{\"value\":\"http://www.mbopartners.com\",\"jive_label\":\"Website\"},{\"value\":\"\",\"jive_label\":\"BusinessManager\"},{\"value\":\"http://www.facebook.com/genezaino\",\"jive_label\":\"Facebook\"},{\"value\":\"http://www.linkedin.com/in/genezaino\",\"jive_label\":\"LinkedIn\"},{\"value\":\"https://twitter.com/#!/GeneZaino\",\"jive_label\":\"Twitter\"}]},\"resources\":{\"following\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/@following\",\"allowed\":[\"GET\"]},\"followers\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/@followers\",\"allowed\":[\"GET\"]},\"images\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/images\",\"allowed\":[\"GET\",\"POST\"]},\"streams\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/streams\",\"allowed\":[\"GET\",\"POST\"]},\"self\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010\",\"allowed\":[\"GET\",\"DELETE\",\"PUT\"]},\"html\":{\"ref\":\"https://uat.access.mbopartners.com/people/gzaino\",\"allowed\":[\"GET\"]},\"followingIn\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/followingIn\",\"allowed\":[\"GET\"]},\"avatar\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/avatar\",\"allowed\":[\"GET\"]},\"members\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/members/people/2010\",\"allowed\":[\"GET\"]},\"activity\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/activities\",\"allowed\":[\"GET\"]}},\"id\":\"2010\"}\'';
       	String jiveResponse = jsonStr();
        
        
        Lead leadRec = JiveToSFLeadUpdateHelper.processJiveResponse(testLead, jiveResponse);
        System.assertNotEquals(leadRec, Null);
    }
    
    public static String jsonStr(){
        String jsonstrTest = '{'+
		'  \"name\" : {'+
		'    \"givenName\" : \"Gene\",'+
		'    \"familyName\" : \"Zaino\",'+
		'    \"formatted\" : \"Gene Zaino\"'+
		'  },'+
		'  \"type\" : \"person\",'+
		'  \"displayName\" : \"gene\",'+
		'  \"tags\" : [ \"test\", \"services1\" ],'+
		'  \"jive\" : {'+
		'    \"username\" : \"gzaino\",'+
		'    \"profile\" : [ {'+
		'      \"value\" : \"CEO\",'+
		'      \"jive_label\" : \"Title\"'+
		'    }, {'+
		'      \"value\" : \"http://www.facebook.com/garrett.zaino\",'+
		'      \"jive_label\" : \"Facebook\"'+
		'    }, {'+
		'      \"value\" : \"http://www.linkedin.com/in/genezaino\",'+
		'      \"jive_label\" : \"LinkedIn\"'+
		'    }, {'+
		'      \"value\" : \"https://twitter.com/#!/GeneZaino\",'+
		'      \"jive_label\" : \"Twitter\"'+
		'    } ]'+
		'  },'+
		'  \"emails\" : [ {'+
		'    \"value\" : \"gzaino@mbopartner.com\",'+
		'    \"type\" : \"work\",'+
		'    \"jive_label\" : \"Email\",'+
		'    \"primary\" : true'+
		'  } ],'+
		'  \"resources\" : {'+
		'    \"following\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/@following\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"followers\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/@followers\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"images\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/images\",'+
		'      \"allowed\" : [ \"POST\", \"GET\" ]'+
		'    },'+
		'    \"streams\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/streams\",'+
		'      \"allowed\" : [ \"POST\", \"GET\" ]'+
		'    },'+
		'    \"self\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010\",'+
		'      \"allowed\" : [ \"PUT\", \"DELETE\", \"GET\" ]'+
		'    },'+
		'    \"html\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/people/gzaino\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"followingIn\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/followingIn\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"avatar\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/avatar\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"members\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/members/people/2010\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"activity\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/2010/activities\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    }'+
		'  },'+
		'  \"id\" : \"2010\"'+
		'}';
        
       
        return jsonstrTest;
        
    }

}