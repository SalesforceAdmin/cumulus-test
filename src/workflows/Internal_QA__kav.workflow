<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Internal_Article_Rejected_Notification</fullName>
        <description>Internal Article Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Internal_QA_Rejected_Article</template>
    </alerts>
    <alerts>
        <fullName>Internal_Q_A_Article_Published</fullName>
        <description>Internal Q&amp;A Article Published</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Internal_Q_A_Knowledge_Article_Published</template>
    </alerts>
    <alerts>
        <fullName>Internal_Q_A_Expiration</fullName>
        <description>Internal Q&amp;A: Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Internal_Q_A_Expiration</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Work_In_Progress</fullName>
        <description>Status changes to Work In Progress</description>
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
        <description>Internal Q&amp;A Article is now pending approval.</description>
        <field>ValidationStatus</field>
        <literalValue>Pending Approval</literalValue>
        <name>Validation Status: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_Internal</fullName>
        <description>Set Internal Q&amp;A article Validation Status to Approved Internal.</description>
        <field>ValidationStatus</field>
        <literalValue>Approved</literalValue>
        <name>Validation Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Internal_Q_A_Article</fullName>
        <action>PublishAsNew</action>
        <description>Publish internal Q&amp;A article.</description>
        <label>Publish Internal Q&amp;A Article</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>Internal Q%26A%3A Expiration</fullName>
        <active>true</active>
        <formula>NOT(ISNULL( Expiration__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Internal_Q_A_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Internal_QA__kav.Expiration__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
