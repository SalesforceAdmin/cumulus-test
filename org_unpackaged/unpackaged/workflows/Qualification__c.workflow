<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Not_Staff</fullName>
        <field>Not_Staff__c</field>
        <literalValue>1</literalValue>
        <name>Not Staff</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_of_Completion_Update</fullName>
        <field>Time_of_Completion__c</field>
        <formula>Now()</formula>
        <name>Time of Completion Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Qualification Complete</fullName>
        <actions>
            <name>Time_of_Completion_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.fs_qualificationResult__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Status Call</fullName>
        <actions>
            <name>Not_Staff</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.fs_resultReasons__c</field>
            <operation>includes</operation>
            <value>Went Staff,Went Exec</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Enrollment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
