/**********************************************************
 * Description      : Util class
 * @author          : Kiran Kumar
 * @date            : April 16, 2013
 * Copyright 2013 MBO Partners. All rights reserved.
 **********************************************************/

public with sharing class Util {

	private static map<String, Id> mapRecordTypes = new map<String, Id>();
    public static Id getRecordTypeId(String rtObject, String rtName) {
    	try {
    		String rtKey = rtObject + '-' + rtName;

    		if (!mapRecordTypes.containsKey(rtKey)) {
    			Id rid = [Select r.Id From RecordType r where r.SobjectType = : rtObject and (r.Name = : rtName OR r.DeveloperName = : rtName) and r.IsActive = true].Id;
    			//system.debug('\n ### Adding RecordType Id ' + rid +  ' for Sobject ' + rtObject + ' RecordType ' + rtName);
				mapRecordTypes.put(rtKey, rid);
    		}
    		return mapRecordTypes.get(rtKey);

    	} catch (Exception ex) {
    		return null;
    	}
    }
    
  	private static map<String, Schema.SObjectType> mapGlobalDescribe;
  	public static map<String, Schema.SObjectType> getGlobalDescribe() {
  		if (mapGlobalDescribe == null) mapGlobalDescribe = Schema.getGlobalDescribe();
  		return mapGlobalDescribe;
  	}

  	public static Schema.SObjectType getGlobalDescribe(String sobjName) {
  		return getGlobalDescribe().get(sobjName);
  	}

  	public static boolean RecordOf(Id recordId, String sobjName) {
  		return recordId != null && sobjName != null ? recordId.getSObjectType()==getGlobalDescribe(sobjName) : false;
  	}

    public static Boolean containsIgnoreCase(String compString, list<String> compList) {
    	if (compString != null && compList != null && !compList.isEmpty()) {
			for (String s : compList) {
				if (compString.containsIgnoreCase(s)) return true;
			}
    	}

    	return false;
    }

/*    
	public static map<String, decimal> getAggResultsMap(String aggLabel, String keyFieldName, String aggFieldName, AggregateResult[] aggResults) {
		String key;
		decimal aggTotal;
		map<String, decimal> aggResultsMap = new map<String, decimal>();

		system.debug('\n ### aggResults-' + aggLabel + '.size ' + aggResults.size() + ' => ' + aggResults);		
		if (aggResults != null) {
			for (AggregateResult ar : aggResults) {
				System.debug('\n ### ar ' + keyFieldName + ' ' + ar);

				key = '';
				for (String field : keyFieldName.split(',')) {
					if (key != '') key += ',';
					key += (String)ar.get(field);
				}

				aggTotal = (decimal)ar.get(aggFieldName);
				System.debug('\n ### key ' + key + ' Agg. Summary ' + aggTotal);

				aggResultsMap.put(key, aggTotal);
			}
		}
		system.debug('\n ### ' + aggLabel + 'Map.size ' + aggResultsMap.size() + ' => ' + aggResultsMap);
		return aggResultsMap;
	}
*/

	public static String getNodeString(Dom.XmlNode node, String nodeName, String namespace) {
		String text;
		Dom.XmlNode n = node.getChildElement(nodeName, namespace);
		if (n != null) text = n.getText();
		return text;
	}

    public static void sendTextEmail(String emailSubject, String textBody, list<String> recipients) {
        sendEmail(emailSubject, textBody, recipients, null, null, 'MBOPartners Automation', 'noreply@MBOPartners.com', false, null, false, true);
    }

    public static Messaging.SingleEmailMessage sendEmail(String emailSubject, String body, list<String> recipients, list<String> recipientsCC, list<String> recipientsBCC, String senderDisplayName, String replyTo, Boolean useHTML, list<Messaging.EmailFileAttachment> fileAttachments, boolean saveAsActivity, boolean send) { 
        if( (recipients == null || recipients.isEmpty()) && (recipientsCC == null || recipientsCC.isEmpty()) && (recipientsBCC == null || recipientsBCC.isEmpty())) return null;

        // Create a new single email message object
        // that will send out a single email to the addresses in the To, CC & BCC list.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        // Assign the addresses for the To lists to the mail object.
        if (recipients != null && !recipients.isEmpty()) mail.setToAddresses(recipients);
        if (recipientsCC != null && !recipientsCC.isEmpty()) mail.setCCAddresses(recipientsCC);
        if (recipientsBCC != null && !recipientsBCC.isEmpty()) mail.setBCCAddresses(recipientsBCC);

        if (senderDisplayName != null) mail.setSenderDisplayName(senderDisplayName);
        
        //the email is not saved as an activity.
        //mail.setSaveAsActivity(false);
        mail.setSaveAsActivity(saveAsActivity==null ? false : saveAsActivity);

        // Set to True if you want to BCC yourself on the email.
        mail.setBccSender(false);

        // The email address of the user executing the Apex Code will be used.
        mail.setUseSignature(false);

        if (replyTo != null && replyTo != '') mail.setReplyTo(replyTo);

/*
        if (useHTML) {
            // Specify the html content of the email.
            mail.setHtmlBody(body);
        } else {
            // Specify the text content of the email.
            mail.setPlainTextBody(body);
        }
*/

        // Specify the subject line for your email address.        
        mail.setSubject(emailSubject);
        mail.setPlainTextBody(body);
        
        // Specify FileAttachments
        if(fileAttachments != null && !fileAttachments.isEmpty()) mail.setFileAttachments(fileAttachments);

        system.debug('\n ### sending email ' + mail);
        
        // Send the email you have created.
        if (send) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        return mail;
    }

 	private static String kHexChars = '0123456789abcdef';
    public static String generateGUID() {

        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0; i<16; i++) {
            if (i==4 || i==6 || i==8 || i==10) 
                returnValue += '-';

            nextByte = (Math.round(Math.random() * 255)-128) & 255;
            //system.debug('\n ### nextByte1 ' + nextByte);

            if (i==6) {
                nextByte = nextByte & 15;
                //system.debug('\n ### nextByte2 ' + nextByte);
                nextByte = nextByte | (4 << 4);
                //system.debug('\n ### nextByte3 ' + nextByte);
            }

            if (i==8) {
                nextByte = nextByte & 63;
                //system.debug('\n ### nextByte4 ' + nextByte);
                nextByte = nextByte | 128;
                //system.debug('\n ### nextByte5 ' + nextByte + ' >>4 ' + (nextByte >> 4) + ' &15 ' + (nextByte & 15));
            }

            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }

        return returnValue;
    }

    public static String getCharAtIndex(String str, Integer index) {

        if (str == null) return null;
        if (str.length() <= 0) return str;
        if (index == str.length()) return null;
        return str.substring(index, index+1);
    }
}