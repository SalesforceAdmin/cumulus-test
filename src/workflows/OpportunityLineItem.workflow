<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Management_Fee_Rate</fullName>
        <description>Updates Discount with 1-management fee rate</description>
        <field>Discount</field>
        <formula>1-Management_Fee_Rate__c</formula>
        <name>Management Fee Rate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Management Fee Rate</fullName>
        <actions>
            <name>Management_Fee_Rate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Management_Fee_Rate__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Quantity</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.UnitPrice</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates Discount with 1-management fee rate</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
