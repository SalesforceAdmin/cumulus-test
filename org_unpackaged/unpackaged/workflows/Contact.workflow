<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Education_and_Research</fullName>
        <field>fb_eduAndResearch__c</field>
        <literalValue>0</literalValue>
        <name>Education and Research</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Opt_In</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>0</literalValue>
        <name>Email Opt In</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Newsletters_and_events</fullName>
        <field>fb_nlAndEvents__c</field>
        <literalValue>0</literalValue>
        <name>Newsletters and events</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualified_Grade_Update</fullName>
        <field>Pardot_Qualifier_Grade__c</field>
        <formula>Qualified_Grade__c</formula>
        <name>Qualified Grade Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tips_and_Features</fullName>
        <field>fb_tipsAndFeatures__c</field>
        <literalValue>0</literalValue>
        <name>Tips and Features</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Opt In</fullName>
        <actions>
            <name>Email_Opt_In</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Contact.fb_nlAndEvents__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.fb_eduAndResearch__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.fb_tipsAndFeatures__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Opt Out</fullName>
        <actions>
            <name>Education_and_Research</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Newsletters_and_events</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tips_and_Features</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Qualfied Grade Update</fullName>
        <actions>
            <name>Qualified_Grade_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Qualified_Grade__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
