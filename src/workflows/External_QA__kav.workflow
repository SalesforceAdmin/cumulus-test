<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>External_Article_Published</fullName>
        <description>External Article Published</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/External_QA_Knowledge_Article_Published</template>
    </alerts>
    <alerts>
        <fullName>External_Article_Rejected_Notification</fullName>
        <description>External Article Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/External_QA_Rejected_Article</template>
    </alerts>
    <alerts>
        <fullName>External_Q_A_Expiration</fullName>
        <description>External Q&amp;A: Expiration</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/External_Q_A_Expiration</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_to_Approved_External</fullName>
        <description>Approved to send article externally as a PDF.</description>
        <field>ValidationStatus</field>
        <literalValue>Approved</literalValue>
        <name>Validation Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Pending_Approval</fullName>
        <description>Sets article validation status to Pending Approval.</description>
        <field>ValidationStatus</field>
        <literalValue>Pending Approval</literalValue>
        <name>Validation Status: Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Work_in_Progress</fullName>
        <description>Sets rejected article back to Work in Progress.</description>
        <field>ValidationStatus</field>
        <literalValue>Work in Progress</literalValue>
        <name>Validation Status: Work In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_External_Q_A_Article_Internally</fullName>
        <action>PublishAsNew</action>
        <description>Publishes a new version of an External Q&amp;A Article</description>
        <label>External Q&amp;A: New Version</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>ExternalQA%3A Expiration</fullName>
        <active>true</active>
        <formula>NOT(ISNULL( Expiration__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>External_Q_A_Expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>External_QA__kav.Expiration__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
