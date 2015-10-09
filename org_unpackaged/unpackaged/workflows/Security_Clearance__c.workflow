<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Security_Clearance_Activation_Date</fullName>
        <field>Activation_Date__c</field>
        <formula>today()</formula>
        <name>Security Clearance Activation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Security Clearance Activation Date</fullName>
        <actions>
            <name>Security_Clearance_Activation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Security_Clearance__c.MBO_Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Security Clearance Expiration Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Security_Clearance__c.Investigation_End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Please_Remind_Associate_of_Security_Clearance_expiration_date</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Security_Clearance__c.Investigation_End_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Please_Remind_Associate_of_Security_Clearance_expiration_date</fullName>
        <assignedTo>saweber@mbopartners.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>1</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please Remind Associate of Security Clearance expiration date.</subject>
    </tasks>
</Workflow>
