<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Idea_Accepted</fullName>
        <description>Idea Accepted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Idea_Accepted</template>
    </alerts>
    <alerts>
        <fullName>NewIdea</fullName>
        <description>Email alert for a new idea</description>
        <protected>false</protected>
        <recipients>
            <recipient>jdobbels@mbopartners.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Idea_created</template>
    </alerts>
    <fieldUpdates>
        <fullName>Idea_Initial_Status</fullName>
        <field>Status</field>
        <literalValue>Suggested</literalValue>
        <name>Idea Initial Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Idea Accepted</fullName>
        <actions>
            <name>Idea_Accepted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Idea Initial Status</fullName>
        <actions>
            <name>Idea_Initial_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.Status</field>
            <operation>notEqual</operation>
            <value>Suggested,Accepted,Completed,Denied</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Idea Post</fullName>
        <actions>
            <name>NewIdea</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Idea.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule will trigger upon a newly created idea</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
