<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Overview_Article_Published_Notification</fullName>
        <description>Overview Article Published Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Overview_Knowledge_Article_Published</template>
    </alerts>
    <alerts>
        <fullName>Overview_Article_Rejected_Notification</fullName>
        <description>Overview Article Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Overview_Rejected_Article</template>
    </alerts>
    <alerts>
        <fullName>Overview_Expiration</fullName>
        <description>Overview: Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Overview_Expiration</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_from_Pending_to_Work_in_Progress</fullName>
        <description>Rejecting Overview article puts it back in Work in Progress from Pending Approval.</description>
        <field>ValidationStatus</field>
        <literalValue>Work in Progress</literalValue>
        <name>Validation Status: Work In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_from_WIP_to_Pending_Approval</fullName>
        <description>After submitting, Overview article moves from Work in Progress to Pending Approval.</description>
        <field>ValidationStatus</field>
        <literalValue>Pending Approval</literalValue>
        <name>Validation Status: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_Internal2</fullName>
        <description>Status changed from Pending Approval to Approved Internal.</description>
        <field>ValidationStatus</field>
        <literalValue>Approved</literalValue>
        <name>Validation Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Overview_Article</fullName>
        <action>PublishAsNew</action>
        <description>Publish Overview article.</description>
        <label>Publish Overview Article</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>Overview%3A Expiration</fullName>
        <active>true</active>
        <formula>NOT(ISNULL( Expiration__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Overview_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Overview__kav.Expiration__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
