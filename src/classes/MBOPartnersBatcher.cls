/**********************************************************
 * Description      : Batcher Class to perform various actions
 * @author          : Kiran Kumar
 * @date            : April 21 2013
 * Copyright 2013 MBO Partners. All rights reserved.
 **********************************************************/

// Run the following statement to schedule the job 
// MBOPartnersBatcher.Schedule();

global class MBOPartnersBatcher implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    global BatchType bt;
    global enum BatchType {AccountAlumniAssignment, CompleteWorkMarketAssignment, GenerateLeadMBOId, GenerateContactMBOId}

	private set<Id> setIds;
    public Integer batchSize = 200;
    public static String cronExpDaily12AM = '0 0 0 ? * *';

    public MBOPartnersBatcher(BatchType bt, set<Id> cids, Integer bs) {
    	this.bt = bt;
        this.setIds = (cids == null ? new set<Id>{} : cids);
        this.batchSize = bs == null || bs <= 0 || bs > this.batchSize ? this.batchSize : bs;
        //system.debug('\n ### cids in MBOPartnersBatcher ' + cids);
    }

	global Database.QueryLocator start(Database.BatchableContext BC) {

		String soql;
		Database.QueryLocator ql;
		if (bt == BatchType.AccountAlumniAssignment) {
			date dtNoTimeMinus6Months = system.today().addMonths(-6);
			date dtNoTimeMinus12Months = system.today().addMonths(-12);

			soql = 'select Id, fd_bcStatusChange__pc, OwnerId, Enrollment_Manager__pc, Enrollment_Manager__pr.Salesforce_User__c from Account';
			soql += ' where Enrollment_Manager__pc != null and Enrollment_Manager__pr.Salesforce_User__c != null and';
			soql += ' Associate_Status__pc = \'Terminated\' and (RecordType.DeveloperName = \'Partners_Associate\' OR RecordType.DeveloperName = \'Client_Referred_Associate\') and';
			soql += ' ((fb_pracOwn__pc = true and fd_bcStatusChange__pc = :dtNoTimeMinus6Months) OR (fb_pracOwn__pc != true and fd_bcStatusChange__pc = :dtNoTimeMinus12Months))';
			//soql += setIds != null ? ' Id in : setIds ' : '';

		} else if (bt == BatchType.CompleteWorkMarketAssignment) {
			soql = 'select Id, fs_wMAssignmentID__c, rs_client__r.fs_wMClientAccessID__c, fn_pUnitCompleted__c from Opportunity where rs_client__r.fs_wMClientAccessID__c != null and Id in : setIds';
		} else if (bt == BatchType.GenerateLeadMBOId) {
			soql = 'select Id, MBO_ID__c from Lead where IsConverted = false and MBO_ID__c = null';
		} else if (bt == BatchType.GenerateContactMBOId) {
			soql = 'select Id, MBO_ID__c from Contact where MBO_ID__c = null';
		}

		if (test.isRunningTest() && !soql.containsIgnoreCase('Limit ')) soql += ' Limit 1';

		system.debug('\n ### soql ' + soql);
		return Database.getQueryLocator(soql);
	}

	global void execute(Database.BatchableContext BC, list<SObject> sobjs) {
		if (bt == BatchType.AccountAlumniAssignment) {
			AccountAlumniAssignment(sobjs);
		} else if (bt == BatchType.CompleteWorkMarketAssignment) {
			CompleteWorkMarketAssignment(sobjs);
		/*} else if (bt == BatchType.GenerateLeadMBOId) {
			LeadHelper.generateMBOId((list<Lead>) sobjs);
		} else if (bt == BatchType.GenerateContactMBOId) {
			LeadHelper.generateMBOId((list<Contact>) sobjs);*/
		} else if (bt == BatchType.GenerateLeadMBOId || bt == BatchType.GenerateContactMBOId) {
			LeadHelper.generateMBOId(sobjs);
		}
	}

	global void execute(SchedulableContext sc) {
		system.debug('\n ### start scheduled job ' + system.now());
		startJob(this.bt, this.setIds, this.batchSize);
		system.debug('\n ### end scheduled job ' + system.now());
	}

	// Returns true if there are open batch queues
	public static Boolean canExecuteBatch {
		get {
			//return ([Select count() from AsyncApexJob Where JobType = 'BatchApex' and (Status = 'Queued' OR Status = 'Processing')] < 5);
			try {
				return ([Select count() from AsyncApexJob Where JobType = 'BatchApex' and Status IN ('Queued', 'Processing', 'Preparing')] < 5);
			} catch (Exception ex) {
				return false;
			}
		}
	}

	public static void startJob(BatchType bt, set<Id> setIds, Integer bs) {
		//system.debug('\n ### startJob MBOPartnersBatcher: setIds ' + setIds.size() + ' => ' + setIds);
		system.debug('\n ### kick off MBOPartnersBatcher - batch Type: ' + bt.Name() + ' batch size: ' + bs + ' setIds: ' + setIds);
		if (canExecuteBatch) {
			MBOPartnersBatcher blp = new MBOPartnersBatcher(bt, setIds, bs);
			Database.executeBatch(blp, (bs != null && bs > 0 && bs <= blp.batchSize ? bs : blp.batchSize));
		//} else {
			//Schedule(1, bt.Name(), bt, setIds, bs);
		}
	}
	
	public static void Schedule() {
		System.Schedule('Schedule Account Alumni Assignment' + (test.isRunningTest() ? ' - Test' : ''), MBOPartnersBatcher.cronExpDaily12AM, new MBOPartnersBatcher(BatchType.AccountAlumniAssignment, null, null));
	}

/*
	public static void Schedule(Integer minutes, String batchName, BatchType bt, set<Id> setIds, Integer bs) {
		system.debug('\n ### Scheduling MBOPartners Batcher: BatchType ' + bt + ' batchsize ' + bs);

		try {
	 		Datetime sysTime = System.now();
	        sysTime = sysTime.addMinutes(minutes==null || minutes <= 0 ? 1 : minutes);
			String cronExpNow = sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
			System.Schedule(batchName + ' ' + system.today().format() + ' ' + sysTime.getTime(), cronExpNow, new MBOPartnersBatcher(bt, setIds, bs));
		} catch (exception ex) {

		}
	}
*/

	public static list<Account> AccountAlumniAssignment(list<Account> accounts) {
		if (accounts != null && !accounts.isEmpty()) {

			list<Account> accounts_To_Update = new list<Account>(); 
			for (Account a : accounts) {
				if (a.Enrollment_Manager__pr.Salesforce_User__c != null && a.OwnerId != a.Enrollment_Manager__pr.Salesforce_User__c) {
					a.OwnerId = a.Enrollment_Manager__pr.Salesforce_User__c;

					accounts_To_Update.add(a);
				}
			}

			system.debug('\n ### accounts_To_Update ' + accounts_To_Update.size());
			if (!accounts_To_Update.isEmpty()) update accounts_To_Update;
		}

		return accounts;
	}

	private static String getRequestBody(map<String, String> params) {
		String body = '';
		//if (this.requestMethod == 'GET') this.body = this.endPoint + (serviceMethod=='' ? '' : serviceMethod) + '?';
		system.debug('\n ### params ' + params);
		if (params != null) {
			for (String key : params.keySet()) {
				//body += key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8') + '&';
				body += (body!='' ? '&' : '') + key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
			}
		}
		System.debug(System.LoggingLevel.INFO, '\n ### getBody: ' + body); 
		return body;
	}
	
	/*public static String CompleteWorkMarketAssignment(Id oppId) {
		return CompleteWorkMarketAssignment([select Id, fs_wMAssignmentID__c, rs_client__r.fs_wMClientAccessID__c, fn_pUnitCompleted__c from Opportunity where rs_client__r.fs_wMClientAccessID__c != null and Id = :oppId]);
	}*/

	public static void CompleteWorkMarketAssignment(list<Opportunity> opps) {
		for (Opportunity opp : opps) {
			String retVal = CompleteWorkMarketAssignment(opp);
			if (retVal != '') Util.sendTextEmail('Unable to Complete Work Market Assignment', 'Unable to Complete Work Market Assignment for Opportunity ' + (URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp.Id) + '\n\n' + retVal, new list<String>{'kkurella@gmail.com'});
		}
	}

	private static String CompleteWorkMarketAssignment(Opportunity opp) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String retVal;

        //system.debug('\n ### getCallouts ' + Limits.getCallouts() + ' getLimitCallouts ' + Limits.getLimitCallouts());
        system.debug('\n ### opp in CompleteWorkMarketAssignment ' + opp);

		//req.setEndpoint('http://test-mbo.dev.workmarket.com' + '/api/v1/assignments/' + EncodingUtil.urlEncode(opp.fs_wMAssignmentID__c, 'UTF-8') + '/complete');
        req.setEndpoint(MBOPartnersHelper.WorkMarketEndPoint + '/api/v1/assignments/' + EncodingUtil.urlEncode(opp.fs_wMAssignmentID__c, 'UTF-8') + '/complete');
        system.debug('\n ### endpoint ' + req.getEndpoint());

        req.setMethod('POST');
        req.setBody(getRequestBody(new map<String, String> {
				        						'access_token' 	=> (opp.rs_client__r.fs_wMClientAccessID__c==null ? '' : opp.rs_client__r.fs_wMClientAccessID__c),
				        						'output_format' => 'xml',	//json
				        						'Content-Type'  => 'application/x-www-form-urlencoded',
				        						'resolution' 	=> 'Completed via MBO Partners',
				        						'hours_worked' 	=> (opp.fn_pUnitCompleted__c==null ? '' : String.valueOf(opp.fn_pUnitCompleted__c)),
				        						'units'         => (opp.fn_pUnitCompleted__c==null ? '' : String.valueOf(opp.fn_pUnitCompleted__c))
        									}));

        try {
        	if (!system.Test.isRunningTest()) {
            	res = http.send(req);
            	//system.debug('\n ### getCallouts ' + Limits.getCallouts() + ' getLimitCallouts ' + Limits.getLimitCallouts());
        	} else {
				res = new HttpResponse();
				res.setBody('<envelope><meta><errors><item/></errors><status_code>400</status_code><version>1</version><execution_time>0.493</execution_time><timestamp>1386787289</timestamp></meta><response/></envelope>');
                res.setStatusCode(200);
        	}

	        if (res != null) {
	        	system.debug(System.LoggingLevel.INFO, '\n ### RESPONSE BODY: ' + res.getBody().replace('\\n',''));
	        	
		        dom.XmlNode root = res.getBodyDocument().getRootElement();
				system.debug('\n ### root ' + root);

				dom.XmlNode responseNode = root.getChildElement('response', null);
				system.debug('\n ### responseNode ' + responseNode);

				//responseNode.getChildElements()[0].getText()
				retVal = Util.getNodeString(responseNode, 'successful', null)=='1' ? '' : processErrors(root.getChildElement('meta', null));
	        }

        } catch (system.CalloutException e) {
        	//### callout error: System.CalloutException: java.security.cert.CertificateException: No subject alternative DNS name matching test-mbo.dev.workmarket.com found. System.HttpResponse[Status=null, StatusCode=0]
            system.debug('\n ### callout error: '+ e + ' ' + res.toString());
        }

		system.debug('\n ### retVal in CompleteWorkMarketAssignment: ' + retVal);
        return retVal;
	}

	private static String processErrors(dom.XmlNode metaNode) {
		String errorMessage = '';
		if (metaNode != null && !metaNode.getChildElements().isEmpty()) {
			dom.XmlNode errorsNode = metaNode.getChildElement('errors', null);

			if (errorsNode != null) {
				for (dom.XmlNode item : errorsNode.getChildElements()) {
					errorMessage += Util.getNodeString(item, 'message', null) != null ? ('Error Code ' + Util.getNodeString(item, 'code', null) + ' - ' + Util.getNodeString(item, 'message', null) + '\n') : '';
				}
				//Utils.addMessage(ApexPages.SEVERITY.ERROR, errorMessage);
			}
		}
		system.debug('\n ### errorMessage in processErrors: ' + errorMessage);
		return errorMessage;
	}

	global void finish(Database.BatchableContext BC) {

		// Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext. 
		// Query the AsyncApexJob object to retrieve the current job's information. 
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];

		if (a.NumberOfErrors > 0 || Test.isRunningTest()) {
			//Send an email to the Apex job's submitter notifying of job completion. 
		   	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   	String[] toAddresses = new String[] {'kkurella@gmail.com'};
		   	mail.setToAddresses(toAddresses);
		   	mail.setSubject('Batch Lead Processor ' + a.Status);
		   	mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
									' batches with '+ a.NumberOfErrors + ' failures.');
		   	//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}
}