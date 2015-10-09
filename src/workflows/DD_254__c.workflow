<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Security_Clearance_Has_DD254</fullName>
        <field>Has_DD254__c</field>
        <literalValue>1</literalValue>
        <name>Security Clearance Has DD254</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Security_Clearance__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Security Clearance Has DD254</fullName>
        <actions>
            <name>Security_Clearance_Has_DD254</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Security_Clearance__c.Has_DD254__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
