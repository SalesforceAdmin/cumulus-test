<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_WO_Expired</fullName>
        <field>Date_Expired__c</field>
        <formula>today()</formula>
        <name>Date WO Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Work_Order_Expired_Checked</fullName>
        <field>Work_Order_Expired_WF__c</field>
        <literalValue>1</literalValue>
        <name>Update Work Order Expired - Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Work_Order_Expired_UnChecked</fullName>
        <field>Work_Order_Expired_WF__c</field>
        <literalValue>0</literalValue>
        <name>Update Work Order Expired - UnChecked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Work Order Expired - Checked</fullName>
        <actions>
            <name>Update_Work_Order_Expired_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Work_Order_Expired__c = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Work Order Expired - UnChecked</fullName>
        <actions>
            <name>Update_Work_Order_Expired_UnChecked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Work_Order_Expired__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
