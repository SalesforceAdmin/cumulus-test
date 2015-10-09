<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Enrollment_Approval_Accept</fullName>
        <description>Enrollment Approval Accept</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Enrollment_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Enrollment_Approval_Reject</fullName>
        <description>Enrollment Approval Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/Enrollment_Approval_Reject</template>
    </alerts>
    <fieldUpdates>
        <fullName>Enrollment_Checklist_Complete</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Enrollment Checklist Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Initial_Contact_Attempted</fullName>
        <field>Number_of_Initial_Call_Attempts__c</field>
        <formula>Number_of_Initial_Call_Attempts__c + 1</formula>
        <name>Enrollment Initial Contact Attempted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Intro_Email_Sent</fullName>
        <field>Most_Recent_Initial_Call_Attempt__c</field>
        <formula>Send_Intro_Email__c</formula>
        <name>Enrollment Intro Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Pending_Approval</fullName>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Enrollment Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Associate_Actions_Completed</fullName>
        <field>Associate_Actions_Completed__c</field>
        <literalValue>1</literalValue>
        <name>Set Associate Actions Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Associate_Actions_Completed_Date</fullName>
        <field>Associate_Actions_Completed_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Associate Actions Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Enrollment_Completion_Date</fullName>
        <field>Enrollment_Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Enrollment Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Exec_Task_Number</fullName>
        <field>Number_of_Tasks_To_Complete__c</field>
        <formula>IF(ISBLANK(Most_Recent_Initial_Call_Attempt__c),1,0)+
IF(ISBLANK(Client_Notified_Enrollment_is_Complete__c),1,0)+ 
IF(ISBLANK(Enrollment_Call_Scheduled__c),1,0)+
IF(ISBLANK(Send_Service_Summary_Email__c),1,0)+
IF(ISBLANK(Send_Enrollment_Link__c),1,0)+
IF(ISBLANK(Online_Enrollment_Begins__c),1,0)+
IF(ISBLANK(Online_Portion_of_Enrollment_Completed__c),1,0)+
IF(ISBLANK(Client_Work_Authorization_Accepted__c),1,0)+
IF(ISBLANK(Setup_work_order_in_MBO__c),1,0)+
IF(ISBLANK(Send_Activation_Email__c),1,0)+
IF(ISBLANK(Complete_Enrollment_Call__c),1,0)+
IF(ISBLANK(Receive_I9_form_List_A_if_applicable__c),1,0)+
IF(ISBLANK(Receive_Intro_Survey__c),1,0)+
IF(ISBLANK(Review_NCE__c),1,0)+
IF(ISBLANK(Send_Intro_Email__c),1,0)+
IF(
   ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)+
       IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0)
      ),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)
      )
     ),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0),
      0
     )
  )</formula>
        <name>Set Exec Task Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Staff_Task_Number</fullName>
        <field>Number_of_Tasks_To_Complete__c</field>
        <formula>IF(ISBLANK(Most_Recent_Initial_Call_Attempt__c),1,0)+
IF(ISBLANK(Enrollment_Call_Scheduled__c),1,0)+
IF(ISBLANK(Send_Service_Summary_Email__c),1,0)+
IF(ISBLANK(Send_Enrollment_Link__c),1,0)+
IF(ISBLANK(Online_Enrollment_Begins__c),1,0)+
IF(ISBLANK(Online_Portion_of_Enrollment_Completed__c),1,0)+
IF(ISBLANK(Client_Work_Authorization_Accepted__c),1,0)+
IF(ISBLANK(Setup_work_order_in_MBO__c),1,0)+
IF(ISBLANK(Send_Activation_Email__c),1,0)+
IF(ISBLANK(Client_Notified_Enrollment_is_Complete__c),1,0)+ 
IF(ISBLANK(Receive_I9_form_List_A_if_applicable__c),1,0)+
IF(ISBLANK(Complete_Enrollment_Call__c),1,0)+
IF(
   ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)+
       IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0)
      ),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)
      )
     ),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0),
      0
     )
  )</formula>
        <name>Set Staff Task Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sub_Task_Number</fullName>
        <field>Number_of_Tasks_To_Complete__c</field>
        <formula>IF(ISBLANK(Most_Recent_Initial_Call_Attempt__c),1,0)+
IF(ISBLANK(Enrollment_Call_Scheduled__c),1,0)+
IF(ISBLANK(Send_Service_Summary_Email__c),1,0)+
IF(ISBLANK(Send_Enrollment_Link__c),1,0)+
IF(ISBLANK(Online_Enrollment_Begins__c),1,0)+
IF(ISBLANK(Online_Portion_of_Enrollment_Completed__c),1,0)+
IF(ISBLANK(Client_Work_Authorization_Accepted__c),1,0)+
IF(ISBLANK(Setup_work_order_in_MBO__c),1,0)+
IF(ISBLANK(Send_Activation_Email__c),1,0)+
IF(ISBLANK(Client_Notified_Enrollment_is_Complete__c),1,0)+
IF(ISBLANK(Receive_Intro_Survey__c),1,0)+
IF(ISBLANK(Send_Intro_Email__c),1,0)+
IF(ISBLANK(VAST_Call_Completed__c),1,0)+
IF(ISBLANK(Qualification_Documents_Received__c),1,0)+
IF(ISBLANK(Certificate_of_Insurance_Received__c),1,0)+
IF(
   ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)+
       IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0)
      ),
      (
       IF(ISBLANK(Submit_for_background_and_or_drug_screen__c),1,0)+
       IF(ISBLANK(Receive_background_drug_screening_result__c),1,0)
      )
     ),
   IF(
      ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Required&apos;),
      IF(ISBLANK(Receive_signed_on_boarding_documents__c),1,0),
      0
     )
  )</formula>
        <name>Set Sub Task Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Working</fullName>
        <field>Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Status: Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Enrollment Initial Contact Attempted</fullName>
        <actions>
            <name>Enrollment_Initial_Contact_Attempted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Most_Recent_Initial_Call_Attempt__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Intro Email Sent</fullName>
        <actions>
            <name>Enrollment_Intro_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Send_Intro_Email__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Exec Associate Enrollment Actions Complete</fullName>
        <actions>
            <name>Set_Associate_Actions_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Associate_Actions_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(        RecordTypeId = &apos;012C0000000QaX8&apos;,        NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),        NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c)),        OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Receive_background_drug_screening_result__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;))               )           )       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Exec Enrollment Checklist Complete</fullName>
        <actions>
            <name>Enrollment_Checklist_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Enrollment_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     NOT(ISNULL(Client_Notified_Enrollment_is_Complete__c)),     NOT(ISNULL(Client_Work_Authorization_Accepted__c)),     NOT(ISNULL(Enrollment_Call_Scheduled__c)),     NOT(ISNULL(Most_Recent_Initial_Call_Attempt__c)),     NOT(ISNULL(Online_Enrollment_Begins__c)),     NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),     NOT(ISNULL(Send_Activation_Email__c)),     NOT(ISNULL(Send_Enrollment_Link__c)),     NOT(ISNULL(Send_Service_Summary_Email__c)),     NOT(ISNULL(Setup_work_order_in_MBO__c)),     AND(         RecordTypeId = &apos;012C0000000QaX8&apos;,         OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Review_NCE__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Review_NCE__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               ),            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Review_NCE__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Review_NCE__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               )           )        )    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Exec Enrollment Task Number</fullName>
        <actions>
            <name>Set_Exec_Task_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordTypeId = &apos;012C0000000QaX8&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Staff Enrollment Task Number</fullName>
        <actions>
            <name>Set_Staff_Task_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordTypeId = &apos;012C0000000QaX9&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Sub Enrollment Task Number</fullName>
        <actions>
            <name>Set_Sub_Task_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordTypeId = &apos;012C0000000QaXA&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Staff Associate Enrollment Actions Complete</fullName>
        <actions>
            <name>Set_Associate_Actions_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Associate_Actions_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(        RecordTypeId = &apos;012C0000000QaX9&apos;,        NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),        NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c)),        OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),           AND(               ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),               OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),               NOT(ISNULL(Receive_background_drug_screening_result__c))              ),           AND(               OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),               OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;))              )           )       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Staff Enrollment Checklist Complete</fullName>
        <actions>
            <name>Enrollment_Checklist_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Enrollment_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     NOT(ISNULL(Client_Notified_Enrollment_is_Complete__c)),      NOT(ISNULL(Client_Work_Authorization_Accepted__c)),     NOT(ISNULL(Enrollment_Call_Scheduled__c)),     NOT(ISNULL(Most_Recent_Initial_Call_Attempt__c)),     NOT(ISNULL(Online_Enrollment_Begins__c)),     NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),     NOT(ISNULL(Send_Activation_Email__c)),     NOT(ISNULL(Send_Enrollment_Link__c)),     NOT(ISNULL(Send_Service_Summary_Email__c)),     NOT(ISNULL(Setup_work_order_in_MBO__c)),     AND(         RecordTypeId = &apos;012C0000000QaX9&apos;,          OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))               ),           AND(               ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),               OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),               NOT(ISNULL(Receive_background_drug_screening_result__c)),               NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))              ),           AND(               OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),               OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                   ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),               NOT(ISNULL(Receive_I9_form_List_A_if_applicable__c))              )           )        )     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sub Associate Enrollment Actions Complete</fullName>
        <actions>
            <name>Set_Associate_Actions_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Associate_Actions_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(        RecordTypeId = &apos;012C0000000QaXA&apos;,        NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),        OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c))               ),            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Receive_background_drug_screening_result__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;))               )           )       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sub Enrollment Checklist Complete</fullName>
        <actions>
            <name>Enrollment_Checklist_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Enrollment_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     NOT(ISNULL(Client_Notified_Enrollment_is_Complete__c)),      NOT(ISNULL(Client_Work_Authorization_Accepted__c)),     NOT(ISNULL(Enrollment_Call_Scheduled__c)),     NOT(ISNULL(Most_Recent_Initial_Call_Attempt__c)),     NOT(ISNULL(Online_Enrollment_Begins__c)),     NOT(ISNULL(Online_Portion_of_Enrollment_Completed__c)),     NOT(ISNULL(Send_Activation_Email__c)),     NOT(ISNULL(Send_Enrollment_Link__c)),     NOT(ISNULL(Send_Service_Summary_Email__c)),     NOT(ISNULL(Setup_work_order_in_MBO__c)),     AND(         RecordTypeId = &apos;012C0000000QaXA&apos;,         OR(            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(VAST_Call_Completed__c)),                NOT(ISNULL(Qualification_Documents_Received__c)),                NOT(ISNULL(Certificate_of_Insurance_Received__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                ISPICKVAL(Client_On_Boarding_Docs_Required__c, &apos;Required&apos;),                NOT(ISNULL(Receive_signed_on_boarding_documents__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(VAST_Call_Completed__c)),                NOT(ISNULL(Qualification_Documents_Received__c)),                NOT(ISNULL(Certificate_of_Insurance_Received__c))               ),            AND(                ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Required&apos;),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Receive_background_drug_screening_result__c)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(VAST_Call_Completed__c)),                NOT(ISNULL(Qualification_Documents_Received__c)),                NOT(ISNULL(Certificate_of_Insurance_Received__c))               ),            AND(                OR(ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Background_Check_Drug_Screen_Required__c,&apos;Contingent&apos;)),                OR(ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Not Required&apos;),                    ISPICKVAL(Client_On_Boarding_Docs_Required__c,&apos;Contingent&apos;)),                NOT(ISNULL(Send_Intro_Email__c)),                NOT(ISNULL(VAST_Call_Completed__c)),                NOT(ISNULL(Qualification_Documents_Received__c)),                NOT(ISNULL(Certificate_of_Insurance_Received__c))               )           )        )     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
