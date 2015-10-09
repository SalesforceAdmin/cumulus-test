<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Conenct_Case_Notification</fullName>
        <description>Conenct Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Connect_Cases</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Connect_Case_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Status_Date</fullName>
        <field>fd_statusChangeDate__c</field>
        <formula>Today()</formula>
        <name>Case Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case Status Date</fullName>
        <actions>
            <name>Case_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the case&apos;s status change date.</description>
        <formula>ISCHANGED(Status) ||  ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Connect Case Notification</fullName>
        <actions>
            <name>Conenct_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>RecordTypeId = &apos;012M00000004xwq&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
