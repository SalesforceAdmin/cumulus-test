<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Visit_Requests_Greater_than_30_Days_Repo</fullName>
        <field>Display_on_Reports__c</field>
        <literalValue>1</literalValue>
        <name>Visit Requests Greater than 30 Days Repo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Security Clearance Request Expiration Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Security_Clearance_Visit_Request__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Security_Clearance_Visit_Request__c.Display_on_Reports__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>An_Associate_s_Security_Clearance_Visit_Request_is_about_to_expire</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Security_Clearance_Visit_Request__c.End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Visit Requests Greater than 30 Days Reported On</fullName>
        <actions>
            <name>Visit_Requests_Greater_than_30_Days_Repo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>End_Date__c  -  Start_Date__c &gt; 30</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>An_Associate_s_Security_Clearance_Visit_Request_is_about_to_expire</fullName>
        <assignedTo>saweber@mbopartners.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>1</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>An Associate&apos;s Security Clearance Visit Request is about to expire.</subject>
    </tasks>
</Workflow>
