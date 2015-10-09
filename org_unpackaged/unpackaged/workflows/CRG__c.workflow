<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Expense_Policy_COPY</fullName>
        <field>fs_expensePolicyDetail_COPY__c</field>
        <formula>fs_expensePolicyDetail__c</formula>
        <name>Expense Policy: COPY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Funding_Source_COPY</fullName>
        <field>fs_fundingSource_COPY__c</field>
        <formula>fs_funding__c</formula>
        <name>Funding Source: COPY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tax_Info_COPY</fullName>
        <field>fs_taxInformation_COPY__c</field>
        <formula>fs_taxInformation__c</formula>
        <name>Tax Info: COPY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Expense Policy Update</fullName>
        <actions>
            <name>Expense_Policy_COPY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( fs_expensePolicyDetail__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Funding Update</fullName>
        <actions>
            <name>Funding_Source_COPY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(fs_funding__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tax Info Update</fullName>
        <actions>
            <name>Tax_Info_COPY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( fs_taxInformation__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
