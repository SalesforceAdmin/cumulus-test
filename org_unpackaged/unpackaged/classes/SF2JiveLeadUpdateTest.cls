@isTest
public class SF2JiveLeadUpdateTest{
	public static testmethod void TestSF2JiveLeadUpdate() {
        JiveSettings__c jive = new JiveSettings__c(); 
        jive.Name = 'JiveURL';
        jive.Value__c = 'https://uat.access.mbopartners.com/api/core/v3';
        //jive.Value__c = 'https://uat.access.mbopartners.com/api/core/v3/search/people';
        insert jive;
        
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
        Lead testLead = new Lead( FirstName = 'STEVE', MBOAccess__c = true, LastName = 'JOHN', UserName__c = 'stevej', Email = 'ramiya@gmail.com', Title = 'testtest', fs_skills__c = 'developement' , fs_overview__c='good', fs_facebook__c='facebook', fs_twitter__c='twitter', fs_linkedin__c = 'linkedin');
        insert testLead;   
    
        Set<Id> leadsToSync = new Set<Id>();
        leadsToSync.add(testLead.Id);
        
        //Test.setMock(HTTPCalloutMock.class, new MockHttpResponseGeneratorSanchivan());
        
        Test.startTest();
        
        SF2JiveLeadUpdate leadSFToJiveBatchable = new SF2JiveLeadUpdate(leadsToSync);
        Id batchprocessid = Database.executeBatch(leadSFToJiveBatchable, 5);  
        
        Test.stopTest();
        
        //String jiveResponse = '{\"type\":\"person\",\"displayName\":\"testing\",\"jive\":{\"username\":\"stevej\",\"profile\":[{\"value\":\"President&CEO,MBOPartners2\",\"jive_label\":\"Title\"},{\"value\":\"11/06/2011\",\"jive_label\":\"JoinDate\"},{\"value\":\"LivedinNYformostofmylifeandthenmovedtotheDCareainthelate90s.BackgroundismostlyentrepreneurialwithsomeformalFinance,AccountingandBusinesstraining.NowIamfocusedonmakingiteasierthaneveryforpeopletotakecontrolandbuildtheirownindependentcareerandbusinesswithMBOPartners.\",\"jive_label\":\"Biography\"},{\"value\":\"ContractTalentmanagement,Entrepreneurship,GeneralBusinessConsulting,ManagementandFinance.\",\"jive_label\":\"Expertise\"},{\"value\":\"IamanentrepreneurwholovestobuildcompaniesandnowIcanhelpothersbuildasuccessfulbusinessesoftheirown.Itssorewarding.\",\"jive_label\":\"Whatdoyoudo?\"},{\"value\":\"Isurroundmyselfwithgreatpeople,challengethem,guidethem,supportthembutletthemowntheirowntheircontributionstotheteam.\",\"jive_label\":\"MyStyle\"},{\"value\":\"http://www.mbopartners.com\",\"jive_label\":\"Website\"},{\"value\":\"\",\"jive_label\":\"BusinessManager\"},{\"value\":\"http://www.facebook.com/genezaino\",\"jive_label\":\"Facebook\"},{\"value\":\"http://www.linkedin.com/in/genezaino\",\"jive_label\":\"LinkedIn\"},{\"value\":\"https://twitter.com/#!/GeneZaino\",\"jive_label\":\"Twitter\"}]},\"resources\":{\"following\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/@following\",\"allowed\":[\"GET\"]},\"followers\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/@followers\",\"allowed\":[\"GET\"]},\"images\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/images\",\"allowed\":[\"GET\",\"POST\"]},\"streams\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/streams\",\"allowed\":[\"GET\",\"POST\"]},\"self\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010\",\"allowed\":[\"GET\",\"DELETE\",\"PUT\"]},\"html\":{\"ref\":\"https://uat.access.mbopartners.com/people/gzaino\",\"allowed\":[\"GET\"]},\"followingIn\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/followingIn\",\"allowed\":[\"GET\"]},\"avatar\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/avatar\",\"allowed\":[\"GET\"]},\"members\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/members/people/2010\",\"allowed\":[\"GET\"]},\"activity\":{\"ref\":\"https://uat.access.mbopartners.com/api/core/v3/people/2010/activities\",\"allowed\":[\"GET\"]}},\"id\":\"2010\"}\'';
        String jiveResponse = jsonStr();
        
        JSON2Apex personRec = SF2JiveLeadHelper.generatePersonJSON(jiveResponse, testLead);
        System.assertNotEquals(personRec, Null);
        
        String personJson = SF2JiveLeadHelper.serializePersonRecord(personRec);
        System.assertNotEquals(personJson, Null);
    }
    
    public static String jsonStr(){
        String jsonstrTest = '{'+
		'  \"name\" : {'+
		'    \"givenName\" : \"Gene\",'+
		'    \"familyName\" : \"Zaino\",'+
		'    \"formatted\" : \"Gene Zaino\"'+
		'  },'+
		'  \"type\" : \"person\",'+
		'  \"tags\" : [ \"design\", \"develop\", \"testing\" ],'+
		'  \"jive\" : {'+
		'    \"username\" : \"stevej\",'+
		'    \"profile\" : [ {'+
		'      \"value\" : \"President & CEO, MBO Partners 2\",'+
		'      \"jive_label\" : \"Title\"'+
		'    }, {'+
		'      \"value\" : \"I am an entrepreneur who loves to build companies and now I can help others build a successful businesses of their own. It\'s so rewarding..\",'+
		'      \"jive_label\" : \"What do you do?\"'+
		'    }, {'+
		'      \"value\" : \"http://www.facebook.com/genezaino\",'+
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
		'    \"value\" : \"gzainoatmbopartners.com@localhost\",'+
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
        
        
       /* String jsonstrTest = '{'+
		'  \"name\" : {'+
		'    \"givenName\" : \"API\",'+
		'    \"familyName\" : \"User01\",'+
		'    \"formatted\" : \"API User01\"'+
		'  },'+
		'  \"type\" : \"person\",'+
		'  \"jive\" : {'+
		'    \"username\" : \"api01\",'+
		'    \"profile\" : [ {'+
		'      \"value\" : \"I work with the MBO as a salesforce developer.\",'+
		'      \"jive_label\" : \"What do you do?\"'+
		'    } ]'+
		'  },'+
		'  \"emails\" : [ {'+
		'    \"value\" : \"webmaster@mbopartners.com\",'+
		'    \"type\" : \"work\",'+
		'    \"jive_label\" : \"Email\",'+
		'    \"primary\" : true'+
		'  } ],'+
		'  \"resources\" : {'+
		'    \"following\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/@following\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"followers\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/@followers\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"images\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/images\",'+
		'      \"allowed\" : [ \"POST\", \"GET\" ]'+
		'    },'+
		'    \"streams\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/streams\",'+
		'      \"allowed\" : [ \"POST\", \"GET\" ]'+
		'    },'+
		'    \"self\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856\",'+
		'      \"allowed\" : [ \"PUT\", \"DELETE\", \"GET\" ]'+
		'    },'+
		'    \"html\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/people/api01\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"tasks\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/tasks\",'+
		'      \"allowed\" : [ \"POST\", \"GET\" ]'+
		'    },'+
		'    \"followingIn\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/followingIn\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"avatar\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/avatar\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"members\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/members/people/12856\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    },'+
		'    \"activity\" : {'+
		'      \"ref\" : \"https://uat.access.mbopartners.com/api/core/v3/people/12856/activities\",'+
		'      \"allowed\" : [ \"GET\" ]'+
		'    }'+
		'  },'+
		'  \"id\" : \"12856\"'+
		'}';*/
        
        return jsonstrTest;
        
    }
}