<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_that_the_Assignment_has_been_completed</fullName>
        <description>Alert that the Assignment has been completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Assignment_Completed</template>
    </alerts>
    <alerts>
        <fullName>Case_Assignment_To_Queue_Notification</fullName>
        <description>Case Assignment To Queue Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Case_Assignment_to_Queue</template>
    </alerts>
    <alerts>
        <fullName>Case_Task_Re_open_Notification</fullName>
        <description>Case Task Re-open Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_and_Knowledge_Templates/Case_Task_Reopened</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assigned_NOW</fullName>
        <field>Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>Assigned = NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Assignment_Status</fullName>
        <field>fs_status__c</field>
        <literalValue>Assigned</literalValue>
        <name>Case Assignment Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_NOW</fullName>
        <field>Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Closed = NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_Closed_NULL</fullName>
        <field>Closed_Date__c</field>
        <name>Date Closed: NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>Finance_Case_Assignment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Finance Assignment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HR_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>HR_Case_Assignment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>HR Assignment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Accounts_Receivable</fullName>
        <field>OwnerId</field>
        <lookupValue>Accounts_Receivable</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Accounts Receivable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Expense</fullName>
        <field>OwnerId</field>
        <lookupValue>Expense</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Expense</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Invoice</fullName>
        <field>OwnerId</field>
        <lookupValue>Invoice</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Invoice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Payment</fullName>
        <field>OwnerId</field>
        <lookupValue>Payment</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Payment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Payrol</fullName>
        <field>OwnerId</field>
        <lookupValue>Payroll</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Payrol</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Security</fullName>
        <field>OwnerId</field>
        <lookupValue>Security</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner: Security</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Technology_Solutions_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>Tech_Solutions_Case_Assignments</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Technology Solutions Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Assigned</fullName>
        <actions>
            <name>Assigned_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Assignment_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISCHANGED(OwnerId),     NOT(BEGINS(OwnerId, &apos;00G&apos;))     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Accounts Receivable</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Accounts_Receivable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Collection Request&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Expense</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Expense</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Approve Negative Expense&quot;, 1,          &quot;Approve Expense&quot;, 1,          &quot;Denied Expense Escalation&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Finance</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Finance_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE(fs_topic__c,          &quot;Manual Payment Advance&quot;, 1,          &quot;Ledger Insurance Premiums&quot;, 1,          &quot;Manual Wire Advance&quot;, 1,          &quot;Ledger Pay Records&quot;, 1,          &quot;Service Fee Adjustment&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to HR</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>HR_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Update Fidelity&quot;, 1,          &quot;Terminate/Backdate Insurance&quot;, 1,          &quot;401K Inquiry/Return of Excess&quot;, 1,          &quot;Claims - WC, Life, LTD&quot;, 1,          &quot;E-Verify&quot;, 1,          &quot;Evidence of Insurability&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Invoice</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Invoice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Push Invoice&quot;, 1,          &quot;Void Invoice&quot;, 1,          &quot;Manual Invoice&quot;, 1,          &quot;Unauthorize Time&quot;, 1,          &quot;Credit Memo&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Payment</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Payment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Apply Negative Invoice&quot;, 1,          &quot;Refund Request&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Payroll</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Payrol</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Reverse Payroll&quot;, 1,          &quot;Upload W-2&quot;, 1,          &quot;Garnishment&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Security</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Owner_Security</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(     CASE( fs_topic__c,          &quot;Visit/Badge Request&quot;, 1,          &quot;Security Clearance/DD-254&quot;, 1,          0) = 1,     TRUE,     FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assignment to Technology Solutions</fullName>
        <actions>
            <name>Case_Assignment_To_Queue_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Technology_Solutions_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(    CASE( fs_topic__c,         &quot;Urgent Tech Support&quot;, 1,         &quot;Troubleshooting&quot;, 1,         0) = 1,    TRUE,    FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assingment Completion</fullName>
        <actions>
            <name>Alert_that_the_Assignment_has_been_completed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Closed_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(fs_status__c, &quot;Completed&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assingment Reopened</fullName>
        <actions>
            <name>Case_Task_Re_open_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Date_Closed_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(fs_status__c),     NOT(ISPICKVAL(fs_status__c,&quot;Completed&quot;))     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
