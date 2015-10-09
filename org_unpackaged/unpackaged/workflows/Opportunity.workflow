<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Associate_Alert_for_New_WM_Opportunities</fullName>
        <description>Associate Alert for New WM Opportunities</description>
        <protected>false</protected>
        <recipients>
            <field>fs_associateEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Market_Assignment_Insert</template>
    </alerts>
    <alerts>
        <fullName>Internal_Alert_for_new_WM_Opportunities</fullName>
        <description>Internal Alert for new WM Opportunities</description>
        <protected>false</protected>
        <recipients>
            <field>fs_clientEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Work_Market_Assignment_Insert_Internal_Alert</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Sold_Approval</fullName>
        <description>Opportunity Sold Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Opportunity_Sold_Approval</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Sold_Rejections</fullName>
        <description>Opportunity Sold Rejections</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Opportunity_Sold_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Billing_Change_Date_TODAY</fullName>
        <field>fd_billingChangeDate__c</field>
        <formula>TODAY()</formula>
        <name>Billing Change Date: TODAY</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CloseDate_Today</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>CloseDate:Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_to_decision_time</fullName>
        <description>Updates time of decision with the close date</description>
        <field>Timeframe_of_decision__c</field>
        <formula>CloseDate</formula>
        <name>Close to decision time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Maximum_Budget_Formula</fullName>
        <field>fn_pAllowedCost__c</field>
        <formula>fn_pUnitCost__c *  fn_pUnitAllowed__c</formula>
        <name>Maximum Budget Formula</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Deferral_Date</fullName>
        <field>fd_deferralDate__c</field>
        <name>Nullify Deferral Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Sold</fullName>
        <field>StageName</field>
        <literalValue>Sold</literalValue>
        <name>Opportunity Stage: Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sub_stage_Null</fullName>
        <field>fs_subStage__c</field>
        <name>Opportunity Sub-stage Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prob_10</fullName>
        <field>Probability</field>
        <formula>0.10</formula>
        <name>Prob: 10%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prob_50</fullName>
        <field>Probability</field>
        <formula>0.50</formula>
        <name>Prob: 50%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prob_90</fullName>
        <field>Probability</field>
        <formula>0.90</formula>
        <name>Prob: 90%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Associate_Email_Address</fullName>
        <field>fs_associateEmail__c</field>
        <formula>Account.PersonEmail</formula>
        <name>Set Associate Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Client_Email_Address</fullName>
        <field>fs_clientEmail__c</field>
        <formula>rs_client__r.fs_clientEmail__c</formula>
        <name>Set Client Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StageName_Identifying</fullName>
        <field>StageName</field>
        <literalValue>Identifying</literalValue>
        <name>StageName: Identifying</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Change_Date</fullName>
        <field>fd_stageChangeDate__c</field>
        <formula>TODAY()</formula>
        <name>Stage Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Aged Identifying</fullName>
        <active>true</active>
        <formula>ISPICKVAL(StageName, &quot;Identifying&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>You_Have_an_Opportunity_Sitting_in_Identifying_for_60_Days</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.fd_stageChangeDate__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Aged Working</fullName>
        <active>true</active>
        <formula>ISPICKVAL(StageName,&quot;Working&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>You_Have_an_Opportunity_Sitting_in_Working_for_90_Days</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.fd_stageChangeDate__c</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Billing Change Date</fullName>
        <actions>
            <name>Billing_Change_Date_TODAY</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( fn_billing__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Deferral Date</fullName>
        <actions>
            <name>Nullify_Deferral_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISPICKVAL(StageName,&quot;Deferred&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close to decision time</fullName>
        <actions>
            <name>Close_to_decision_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Updates time of decision with the close date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Closing Prob</fullName>
        <actions>
            <name>Prob_90</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.fs_subStage__c</field>
            <operation>equals</operation>
            <value>Closing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Default</fullName>
        <actions>
            <name>StageName_Identifying</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName = &quot;B2B&quot; &amp;&amp;  ISPICKVAL(StageName,&quot;&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Deferral Date Reminder</fullName>
        <active>true</active>
        <formula>OR(    ISPICKVAL(StageName,&quot;Deferred&quot;),    AND(        ISPICKVAL(StageName,&quot;Deferred&quot;),        fd_deferralDate__c &lt; TODAY()    ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Schedule_a_follow_up_with_the_Opportunity_Contacts</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.fd_deferralDate__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Developing Prob</fullName>
        <actions>
            <name>Prob_50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.fs_subStage__c</field>
            <operation>equals</operation>
            <value>Developing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Maximum Budget</fullName>
        <actions>
            <name>Maximum_Budget_Formula</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.fs_wMAssignmentID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Qualifying Prob</fullName>
        <actions>
            <name>Prob_10</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.fs_subStage__c</field>
            <operation>equals</operation>
            <value>Qualifying</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send WM Emails</fullName>
        <actions>
            <name>Associate_Alert_for_New_WM_Opportunities</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Internal_Alert_for_new_WM_Opportunities</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(     fs_associateEmail__c&lt;&gt;NULL,     fs_clientEmail__c&lt;&gt;NULL )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Email Addresses</fullName>
        <actions>
            <name>Set_Associate_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Client_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR(        AccountId &lt;&gt; NULL,        rs_leadAssociate__c &lt;&gt; NULL     ),     RecordTypeId = &apos;012C0000000QFCb&apos;,     fs_wMAssignmentID__c &lt;&gt; NULL,     rs_client__c &lt;&gt; NULL )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stage Change Date</fullName>
        <actions>
            <name>Stage_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(    ISCHANGED(StageName),    ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Order Inactive</fullName>
        <active>false</active>
        <formula>ISPICKVAL(StageName, &quot;Inactive&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Schedule_a_follow_up_with_the_Opportunity_Contacts</fullName>
        <assignedToType>owner</assignedToType>
        <description>The Deferral Date is coming up in 15 days, please schedule a follow up.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule a Follow up with the Opportunity Contacts or Delay the Deferral</subject>
    </tasks>
    <tasks>
        <fullName>You_Have_an_Opportunity_Sitting_in_Identifying_for_60_Days</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>You Have an Opportunity Sitting in Identifying for 60 Days</subject>
    </tasks>
    <tasks>
        <fullName>You_Have_an_Opportunity_Sitting_in_Working_for_90_Days</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>You Have an Opportunity Sitting in Working for 90 Days</subject>
    </tasks>
</Workflow>
