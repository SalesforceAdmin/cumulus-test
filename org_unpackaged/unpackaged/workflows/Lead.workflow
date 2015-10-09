<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CompanyQueueAlert</fullName>
        <description>CompanyQueueAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ClientServices</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>EnterpriseSales</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>sconde@mbopartners.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/QueueAlert</template>
    </alerts>
    <alerts>
        <fullName>ConsultantQueueAlert</fullName>
        <description>ConsultantQueueAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ConsultantServices</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/QueueAlert</template>
    </alerts>
    <alerts>
        <fullName>GeneralInquiriesQueueAlert</fullName>
        <description>GeneralInquiriesQueueAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>General_Inquiries</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/QueueAlert</template>
    </alerts>
    <alerts>
        <fullName>PRQueueAlert</fullName>
        <description>PRQueueAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>PublicRelations</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/QueueAlert</template>
    </alerts>
    <alerts>
        <fullName>Score_Alert_for_MRT</fullName>
        <description>Score Alert for MRT</description>
        <protected>false</protected>
        <recipients>
            <recipient>Marketing_Response_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Workflow_emails/MRTAlert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Associate_Type_Sub</fullName>
        <field>fs_associateType__c</field>
        <literalValue>MBO Sub</literalValue>
        <name>Associate Type: Sub</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Company_NULL</fullName>
        <field>Company</field>
        <name>Company: NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Company_Update</fullName>
        <field>Company</field>
        <formula>Account__r.Name</formula>
        <name>Company: Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
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
        <fullName>Email_Opt_in</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>0</literalValue>
        <name>Email Opt in</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Begins</fullName>
        <field>fd_slaPending__c</field>
        <formula>TODAY()</formula>
        <name>Enrollment Begins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Complete</fullName>
        <field>fd_slaEnrollComplete__c</field>
        <formula>TODAY()</formula>
        <name>Enrollment Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enrollment_Sent</fullName>
        <field>fd_slaInquiry__c</field>
        <formula>TODAY()</formula>
        <name>Inquiry Completion Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBO_Record_ID_Contact</fullName>
        <field>fs_mboRecordIdContact__c</field>
        <formula>MBORecordId__c</formula>
        <name>MBO Record ID Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Owner_Assigned_Date_null</fullName>
        <field>Owner_Assigned_Date__c</field>
        <name>Owner Assigned Date: null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PardotCampaignClientReferred</fullName>
        <field>pi__campaign__c</field>
        <formula>&quot;Client Referred (&quot;+TEXT(YEAR(TODAY()))+&quot;)&quot;</formula>
        <name>PardotCampaignClientReferred</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PardotCampaignWorkMarket</fullName>
        <field>pi__campaign__c</field>
        <formula>&quot;Work Market&quot;</formula>
        <name>PardotCampaignWorkMarket</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualifier_Grade_Update</fullName>
        <field>pardot_Qualifier_Grade__c</field>
        <formula>Qualified_Grade__c</formula>
        <name>Qualifier Grade Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Owner_Update</fullName>
        <field>fs_referrerOwner__c</field>
        <formula>CASE(
                 Referring_Contact__r.Contact_Status__c,&quot;Associate&quot;, 
                 Referring_Contact__r.BM_FName__c + &quot; &quot; + Referring_Contact__r.BM_LName__c,  
                 Referring_Contact__r.EM_FName__c + &quot; &quot; + Referring_Contact__r.EM_LName__c
                 )</formula>
        <name>Referral Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SLA_Qualification_Questionnaire_Complete</fullName>
        <field>fd_slaQualQuestionComp__c</field>
        <formula>TODAY()</formula>
        <name>SLA Qualification Questionnaire Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SQLThresholdCrossed</fullName>
        <field>SQL_Threshold_Crossed__c</field>
        <formula>NOW()</formula>
        <name>SQLThresholdCrossed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SQL_Threshold_null</fullName>
        <field>SQL_Threshold_Crossed__c</field>
        <name>SQL Threshold: null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Status_Date</fullName>
        <field>Status_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>Sales Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_Assigned_Date</fullName>
        <field>Owner_Assigned_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Owner Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_Assigned_Date_Time</fullName>
        <field>Owner_Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Owner Assigned Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sold</fullName>
        <field>Status</field>
        <literalValue>Sold</literalValue>
        <name>Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Working</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Status: Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Status_NULL</fullName>
        <field>Sub_Status__c</field>
        <name>Sub-Status: NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sync_Last_Modified_Date_Update</fullName>
        <field>fd_syncLastModDate__c</field>
        <formula>NOW()</formula>
        <name>Sync Last Modified Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>Associate with Company</fullName>
        <actions>
            <name>Company_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Referred Associate,Direct Associate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Background and%2For Drug Check</fullName>
        <actions>
            <name>Task_23</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the task list for Enroll Link - Enterprise Client w/ Background and/or Drug Check. List M.</description>
        <formula>AND(IsConverted = false,     IF(         CASE(Owner:User.Id, &quot;00580000003Xgdb&quot;,1, &quot;005C0000005Kp2O&quot;,1, &quot;005C0000003bREb&quot;,1,0         )=1,         FALSE,         TRUE      ),      ISPICKVAL(Associate_Status__c,&apos;Pending&apos;),      IF(         CASE( Enrollment_Code__r.Name, &apos;&apos;,1,0)=1,TRUE,FALSE))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Begin Enrollment</fullName>
        <actions>
            <name>Enrollment_Begins</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Associate_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Company%3A Update</fullName>
        <actions>
            <name>Company_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Account__c != NULL</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CompanyQueueAlert</fullName>
        <actions>
            <name>CompanyQueueAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SQLThresholdCrossed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Company Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.pi__score__c</field>
            <operation>greaterOrEqual</operation>
            <value>500</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completed Enrollment</fullName>
        <actions>
            <name>Task_46</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the tasks for the completed enrollment list. List P.</description>
        <formula>AND(     ISPICKVAL( Associate_Status__c,&apos;Enrolled&apos;),     IF(         CASE(Owner:User.Id, &quot;00580000003Xgdb&quot;,1, &quot;005C0000005Kp2O&quot;,1, &quot;005C0000003bREb&quot;,1,0         )=1,         FALSE,         TRUE      ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Consultant%3A Working SLA</fullName>
        <active>true</active>
        <formula>AND(     RecordTypeId&lt;&gt;&quot;012C0000000Q7rl&quot;,     ISPICKVAL(Status,&quot;Working&quot;),     Ignore_Workflow__c != true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Please_Check_On_The_Consultant_To_See_If_They_Are_Still_A_Working_Prospect</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Lead.Status_Change_Date__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ConsultantQueueAlert</fullName>
        <actions>
            <name>ConsultantQueueAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SQLThresholdCrossed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Customer Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.pi__score__c</field>
            <operation>greaterOrEqual</operation>
            <value>125</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Qualified_Grade__c</field>
            <operation>equals</operation>
            <value>A,B</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Opt In</fullName>
        <actions>
            <name>Email_Opt_in</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>Lead.fb_eduAndResearch__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.fb_nlAndEvents__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.fb_tipsAndFeatures__c</field>
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
            <field>Lead.HasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Complete</fullName>
        <actions>
            <name>Enrollment_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Associate_Status__c</field>
            <operation>equals</operation>
            <value>Enrolled</value>
        </criteriaItems>
        <description>Updates the SLA Timestamp with when the enrollment was completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Follow-up Assignment</fullName>
        <actions>
            <name>Task_40</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the task to Follow-up after enrollment is sent. List F.</description>
        <formula>AND(IsConverted = false, NOT(ISBLANK( Enrollment_Code__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Follow-up Assignment Check</fullName>
        <actions>
            <name>Task_40</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the task to Follow-up after enrollment is sent. List G.</description>
        <formula>AND(IsConverted = false,       NOT(           ISBLANK(Enrollment_Code__c)       ),       IF(          CASE(Owner:User.Id, &quot;00580000003Xgdb&quot;,1, &quot;005C0000003bREb&quot;,1, &quot;005C0000004mhaE&quot;,1, &quot;005C0000004mhZk&quot;,1,0          )=1,          FALSE,          TRUE       ),       IF(          CASE(Enrollment_Code__r.Name, &quot;AMERCSCANFTSTAFF&quot;,1, &quot;AMERCSCANPTSTAFF&quot;,1, &quot;AMERCSFTSTAFF&quot;,1, &quot;AMERCSPTSTAFF&quot;,1, &quot;AMZNEXEC&quot;,1, &quot;AMZNEXECPT&quot;,1, &quot;AMZNSUB&quot;,1, &quot;ATKFTSTAFF&quot;,1, &quot;ATKPTSTAFF&quot;,1, &quot;ATKSTAFF980&quot;,1, &quot;ATKMBEFT&quot;,1, &quot;ATKBEPT&quot;,1, &quot;AKTSUBVAST&quot;,1, &quot;ATKNONASSOC&quot;,1, &quot;BESTBUYFTSTAFF&quot;,1, &quot;BESTBUYMBEFT&quot;,1, &quot;BESTBUYMBEPT&quot;,1, &quot;BESTBUYPTSTAFF&quot;,1, &quot;BESTBUYSUBVAST&quot;,1, &quot;CDWMBEFT&quot;,1, &quot;CDWMBEPT&quot;,1, &quot;CDWPTSTAFF&quot;,1, &quot;  CDWFTSTAFF&quot;,1, &quot;CHSMBC&quot;,1, &quot;CHSMBE&quot;,1, &quot;CHSMBEPT&quot;,1, &quot;CITIFTMBE&quot;,1, &quot;CITIPTMBE&quot;,1, &quot;  CSXMBC&quot;,1, &quot;CSXMBE&quot;,1, &quot;CTRPLRMBEFT&quot;,1, &quot;CTRPLRMBEPT&quot;,1, &quot;DUKEMBC&quot;,1, &quot;DUKEMBCNONCORP&quot;,1, &quot;DUKEMBCNONW2&quot;,1, &quot;DUKEMBE&quot;,1, &quot;ENTERGYMBC&quot;,1, &quot;ENTERGYMBCNON&quot;,1, &quot;ENTERGYMBE&quot;,1, &quot;ENTERGYMBCNONW2&quot;,1, &quot;FPLMBC&quot;,1, &quot;FPLMBCNONW2&quot;,1, &quot;FPLMBE&quot;,1, &quot;FPLMBESSHR&quot;,1, &quot;FPLMBSUBNONCOP&quot;,1, &quot;HPMBEFT&quot;,1, &quot;HPMBEPT&quot;,1, &quot;HPSUBVAST&quot;,1, &quot;INSGHTMBC&quot;,1, &quot;INSGHTMBEFT&quot;,1, &quot;INSGHTMBEPT&quot;,1, &quot;INSGHTNONW2&quot;,1, &quot;INSGHTSTAFF&quot;,1, &quot;INSGHTSUBVAST&quot;,1, &quot;IRNWDMBC&quot;,1, &quot;IRNWDMBEFT&quot;,1, &quot;IRNWDMBEPT&quot;,1, &quot;LMTDFTSTAF&quot;,1, &quot;LMTDMBC&quot;,1, &quot;LMTDMBEFT&quot;,1, &quot;LMTDMBEPT&quot;,1, &quot;LMTSPTSTAFF&quot;,1, &quot;LSMBOEXEC&quot;,1, &quot;LSMBOSTAFF&quot;,1, &quot;LSMBOSUB&quot;,1, &quot;MSFTMBEPT&quot;,1, &quot;MSFTBROKER&quot;,1, &quot;MSFTMBCNONCORP&quot;,1, &quot;MSFTMBCNONW2&quot;,1, &quot;MSFTMBE&quot;,1, &quot;MSFTSUBVAST&quot;,1, &quot;NUMBC&quot;,1, &quot;NUMBE&quot;,1, &quot;PBMBC&quot;,1, &quot;PBMBCNONW2&quot;,1, &quot;PBMBE&quot;,1, &quot;PBMBEPT&quot;,1, &quot;PBSUBNONCORP&quot;,1, &quot;PHLPSMBEFT&quot;,1, &quot;PHLPSMBEPT&quot;,1, &quot;PHLPSUBVASTPROGRESSMBC&quot;,1, &quot;PROGRESSMBCNONCORP&quot;,1, &quot;PROGRESSMBCNONW2&quot;,1, &quot;PROGRESSMBE&quot;,1, &quot;REEDMBC&quot;,1, &quot;REEDMBE&quot;,1, &quot;SCHLMFTMBE&quot;,1, &quot;SCHLMMBC&quot;,1, &quot;SCHLMMBCNONW2&quot;,1, &quot;SCHLMPTMBE&quot;,1, &quot;SCIMBC&quot;,1, &quot;SCIMBE&quot;,1, &quot;SFDCFTEXEC&quot;,1, &quot;SFDCPTEXEC&quot;,1, &quot;SFDCSTAFF&quot;,1, &quot;SFDCSUBVAST&quot;,1, &quot;SPRINTMBC&quot;,1, &quot;SPRINTMBCNONCORP&quot;,1, &quot;SPRINTMBCNONW2&quot;,1, &quot;SPRINTMBE&quot;,1, &quot;SUNGARDMBE&quot;,1, &quot;SUNGARDPTMBE&quot;,1, &quot;UHGCOMPLIANCE&quot;,1, &quot;UHGSTAFF&quot;,1, &quot;UHGMBC&quot;,1, &quot;UHGMBCNONW2&quot;,1, &quot;UHGMBEFT&quot;,1, &quot;UHGMBEPT&quot;,1, &quot;UHGPHYMBC&quot;,1, &quot;UHGPHYMBE&quot;,1, &quot;UHGPTSTAFF&quot;,1, &quot;UHGSTAFFHR&quot;,1, &quot;WELLNONW2&quot;,1, &quot;WELLPTMBE&quot;,1, &quot;WELLPTSUBVAST&quot;,1, &quot;WHRLPLFTSTAFF&quot;,1, &quot;WHRPLMBC&quot;,1, &quot;WHRPLMBEFT&quot;,1, &quot;WHRPLMBEPT&quot;,1, &quot;WHRPLPTSTAFF&quot;,1, &quot;WMGFTSTAFF&quot;,1, &quot;WMGMBCNONW2&quot;,1, &quot;WMGMBEFT&quot;,1, &quot;WMGMBEPT&quot;,1, &quot;WMGMBSUB&quot;,1, &quot;WMGPTSTAFF&quot;,1, &quot;WPAIMMBC&quot;,1, &quot;WPAIMMBEFT&quot;,1, &quot;WPAIMMBEPT&quot;,1,0          )=1,          TRUE,          FALSE       )   )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Follow-up Assignment No Check</fullName>
        <actions>
            <name>Task_44</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the task to Follow-up after enrollment is sent. List F.</description>
        <formula>AND(IsConverted = false,      IF(         CASE(Owner:User.Id, &quot;00580000003Xgdb&quot;,1, &quot;005C0000003bREb&quot;,1, &quot;005C0000004mhaE&quot;,1, &quot;005C0000004mhZk&quot;,1,0         )=1,         FALSE,         TRUE      ),      NOT(          ISBLANK(Enrollment_Code__c)      ),      IF(         CASE(Enrollment_Code__r.Name, &quot;AMERCSCANFTSTAFF&quot;,1, &quot;AMERCSCANPTSTAFF&quot;,1, &quot;AMERCSFTSTAFF&quot;,1, &quot;AMERCSPTSTAFF&quot;,1, &quot;AMZNEXEC&quot;,1, &quot;AMZNEXECPT&quot;,1, &quot;AMZNSUB&quot;,1, &quot;ATKFTSTAFF&quot;,1, &quot;ATKPTSTAFF&quot;,1, &quot;ATKSTAFF980&quot;,1, &quot;ATKMBEFT&quot;,1, &quot;ATKBEPT&quot;,1, &quot;AKTSUBVAST&quot;,1, &quot;ATKNONASSOC&quot;,1, &quot;BESTBUYFTSTAFF&quot;,1, &quot;BESTBUYMBEFT&quot;,1, &quot;BESTBUYMBEPT&quot;,1, &quot;BESTBUYPTSTAFF&quot;,1, &quot;BESTBUYSUBVAST&quot;,1, &quot;CDWMBEFT&quot;,1, &quot;CDWMBEPT&quot;,1, &quot;CDWPTSTAFF&quot;,1, &quot;  CDWFTSTAFF&quot;,1, &quot;CHSMBC&quot;,1, &quot;CHSMBE&quot;,1, &quot;CHSMBEPT&quot;,1, &quot;CITIFTMBE&quot;,1, &quot;CITIPTMBE&quot;,1, &quot;  CSXMBC&quot;,1, &quot;CSXMBE&quot;,1, &quot;CTRPLRMBEFT&quot;,1, &quot;CTRPLRMBEPT&quot;,1, &quot;DUKEMBC&quot;,1, &quot;DUKEMBCNONCORP&quot;,1, &quot;DUKEMBCNONW2&quot;,1, &quot;DUKEMBE&quot;,1, &quot;ENTERGYMBC&quot;,1, &quot;ENTERGYMBCNON&quot;,1, &quot;ENTERGYMBE&quot;,1, &quot;ENTERGYMBCNONW2&quot;,1, &quot;FPLMBC&quot;,1, &quot;FPLMBCNONW2&quot;,1, &quot;FPLMBE&quot;,1, &quot;FPLMBESSHR&quot;,1, &quot;FPLMBSUBNONCOP&quot;,1, &quot;HPMBEFT&quot;,1, &quot;HPMBEPT&quot;,1, &quot;HPSUBVAST&quot;,1, &quot;INSGHTMBC&quot;,1, &quot;INSGHTMBEFT&quot;,1, &quot;INSGHTMBEPT&quot;,1, &quot;INSGHTNONW2&quot;,1, &quot;INSGHTSTAFF&quot;,1, &quot;INSGHTSUBVAST&quot;,1, &quot;IRNWDMBC&quot;,1, &quot;IRNWDMBEFT&quot;,1, &quot;IRNWDMBEPT&quot;,1, &quot;LMTDFTSTAF&quot;,1, &quot;LMTDMBC&quot;,1, &quot;LMTDMBEFT&quot;,1, &quot;LMTDMBEPT&quot;,1, &quot;LMTSPTSTAFF&quot;,1, &quot;LSMBOEXEC&quot;,1, &quot;LSMBOSTAFF&quot;,1, &quot;LSMBOSUB&quot;,1, &quot;MSFTMBEPT&quot;,1, &quot;MSFTBROKER&quot;,1, &quot;MSFTMBCNONCORP&quot;,1, &quot;MSFTMBCNONW2&quot;,1, &quot;MSFTMBE&quot;,1, &quot;MSFTSUBVAST&quot;,1, &quot;NUMBC&quot;,1, &quot;NUMBE&quot;,1, &quot;PBMBC&quot;,1, &quot;PBMBCNONW2&quot;,1, &quot;PBMBE&quot;,1, &quot;PBMBEPT&quot;,1, &quot;PBSUBNONCORP&quot;,1, &quot;PHLPSMBEFT&quot;,1, &quot;PHLPSMBEPT&quot;,1, &quot;PHLPSUBVASTPROGRESSMBC&quot;,1, &quot;PROGRESSMBCNONCORP&quot;,1, &quot;PROGRESSMBCNONW2&quot;,1, &quot;PROGRESSMBE&quot;,1, &quot;REEDMBC&quot;,1, &quot;REEDMBE&quot;,1, &quot;SCHLMFTMBE&quot;,1, &quot;SCHLMMBC&quot;,1, &quot;SCHLMMBCNONW2&quot;,1, &quot;SCHLMPTMBE&quot;,1, &quot;SCIMBC&quot;,1, &quot;SCIMBE&quot;,1, &quot;SFDCFTEXEC&quot;,1, &quot;SFDCPTEXEC&quot;,1, &quot;SFDCSTAFF&quot;,1, &quot;SFDCSUBVAST&quot;,1, &quot;SPRINTMBC&quot;,1, &quot;SPRINTMBCNONCORP&quot;,1, &quot;SPRINTMBCNONW2&quot;,1, &quot;SPRINTMBE&quot;,1, &quot;SUNGARDMBE&quot;,1, &quot;SUNGARDPTMBE&quot;,1, &quot;UHGCOMPLIANCE&quot;,1, &quot;UHGSTAFF&quot;,1, &quot;UHGMBC&quot;,1, &quot;UHGMBCNONW2&quot;,1, &quot;UHGMBEFT&quot;,1, &quot;UHGMBEPT&quot;,1, &quot;UHGPHYMBC&quot;,1, &quot;UHGPHYMBE&quot;,1, &quot;UHGPTSTAFF&quot;,1, &quot;UHGSTAFFHR&quot;,1, &quot;WELLNONW2&quot;,1, &quot;WELLPTMBE&quot;,1, &quot;WELLPTSUBVAST&quot;,1, &quot;WHRLPLFTSTAFF&quot;,1, &quot;WHRPLMBC&quot;,1, &quot;WHRPLMBEFT&quot;,1, &quot;WHRPLMBEPT&quot;,1, &quot;WHRPLPTSTAFF&quot;,1, &quot;WMGFTSTAFF&quot;,1, &quot;WMGMBCNONW2&quot;,1, &quot;WMGMBEFT&quot;,1, &quot;WMGMBEPT&quot;,1, &quot;WMGMBSUB&quot;,1, &quot;WMGPTSTAFF&quot;,1, &quot;WPAIMMBC&quot;,1, &quot;WPAIMMBEFT&quot;,1, &quot;WPAIMMBEPT&quot;,1,0         )=1,         FALSE,         TRUE      )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment Sent</fullName>
        <actions>
            <name>Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK( Enrollment_Code__c )), IsConverted = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Enrollment with No Inquiry Date</fullName>
        <actions>
            <name>Enrollment_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISBLANK(fd_slaInquiry__c),     NOT(         ISBLANK(Enrollment_Code__c)     ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GIQueueAlert</fullName>
        <actions>
            <name>GeneralInquiriesQueueAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SQLThresholdCrossed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>General Inquiries</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.pi__score__c</field>
            <operation>greaterOrEqual</operation>
            <value>500</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inquiry Follow-up Assignment</fullName>
        <actions>
            <name>Task_36</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Referred Associate,Direct Associate,Qualification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Inquiry,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Sara Conde,Nicolette Taylor,Emily Stringer,Meghan Moul</value>
        </criteriaItems>
        <description>Assigns a task to follow-up with an inquiry. List C.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Sync Update</fullName>
        <actions>
            <name>Sync_Last_Modified_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(fs_region__c),ISCHANGED(How_Heard__c),ISCHANGED(Enrollment_Manager__c),ISCHANGED(fb_pracOwn__c),ISCHANGED(rs_BM__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MBO Record ID</fullName>
        <actions>
            <name>MBO_Record_ID_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( MBORecordId__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MRTAlert</fullName>
        <actions>
            <name>Score_Alert_for_MRT</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Customer Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.pi__score__c</field>
            <operation>greaterOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MS%2FAmazon Background and%2For drug check</fullName>
        <actions>
            <name>ToDo_26</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the task list for Enroll Link - MS/Amazon. List N.</description>
        <formula>AND(ISPICKVAL(Associate_Status__c,&apos;Pending&apos;), IF(CASE( Enrollment_Code__r.Name,&apos;AMZNEXEC&apos;,1, &apos;AMZNEXECPT&apos;,1, &apos;AMZNSUB&apos;,1, &apos;MSFTMBC&apos;,1, &apos;MSFTMBE&apos;,1, &apos;MSFTMBEPT&apos;,1, &apos;MSFTSUBVAST&apos;,1,0)=1,TRUE,FALSE))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Moved from New</fullName>
        <actions>
            <name>Enrollment_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(      ISPICKVAL(Status,&apos;New&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRQueueAlert</fullName>
        <actions>
            <name>PRQueueAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SQLThresholdCrossed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Public Relations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.pi__score__c</field>
            <operation>greaterOrEqual</operation>
            <value>500</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PardotCampaignClientReferred</fullName>
        <actions>
            <name>PardotCampaignClientReferred</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Referring_Client__r.Name = &quot;Logistics Health Incorporated&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PardotCampaignWorkMarket</fullName>
        <actions>
            <name>PardotCampaignWorkMarket</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSourceData__c</field>
            <operation>equals</operation>
            <value>Work Market Registration App</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Parked Assignment</fullName>
        <actions>
            <name>Task_4</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>2 and (1 or 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Lead.Sub_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Parked,Deferred</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Searching for contract assignment,Unidentified Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Sara Conde,Nicolette Taylor,George Sturgis</value>
        </criteriaItems>
        <description>Assigns the task for Parked. List D.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Prospect Assignment</fullName>
        <actions>
            <name>Task_5</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Referred Associate,Direct Associate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Prospect,Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
            <value>Sara Conde,Nicolette Taylor,George Sturgis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.fb_qualification__c</field>
            <operation>notEqual</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>Assigns the task for Prospect. List E.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Qualification</fullName>
        <actions>
            <name>Associate_Type_Sub</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VASTcall</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.fb_qualification__c</field>
            <operation>equals</operation>
            <value>Qualification</value>
        </criteriaItems>
        <description>Assigns the task list for VAST. LIst Z.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Qualified Grade Update</fullName>
        <actions>
            <name>Qualifier_Grade_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Qualified_Grade__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Referrer Owner</fullName>
        <actions>
            <name>Referral_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(IsConverted = false, NOT(ISBLANK( Referring_Contact__c )))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Enrollment Questionnaire Complete</fullName>
        <actions>
            <name>SLA_Qualification_Questionnaire_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(     ISPICKVAL(fb_qualification__c, &quot;&quot;)     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SLA Reset</fullName>
        <actions>
            <name>Owner_Assigned_Date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SQL_Threshold_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.fs_owner__c</field>
            <operation>equals</operation>
            <value>Customer Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Status Date</fullName>
        <actions>
            <name>Sales_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Sales status change date</description>
        <formula>AND(     OR(        ISCHANGED(Status),         ISNEW()     ),     IsConverted = false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Owner Assigned Date</fullName>
        <actions>
            <name>Set_Owner_Assigned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Owner_Assigned_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>BEGINS(Owner:User.Id, &apos;005&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Siemens Bkgd-Drug Check</fullName>
        <actions>
            <name>Please_initiate_the_background_and_or_drug_check</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>AND(     IF(        CASE(Referring_Client__c,             &quot;001C000000xPy1V&quot;,1,             &quot;0018000000gqA0c&quot;,1,             &quot;0018000000meQbC&quot;,1,             0) = 1,        TRUE,        FALSE        ),     NOT(ISPICKVAL(Status,&quot;New&quot;))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sold SLA-Timebased</fullName>
        <active>true</active>
        <formula>AND(     RecordTypeId&lt;&gt;&quot;012C0000000Q7rl&quot;,     ISPICKVAL(Status,&quot;Sold&quot;),     Ignore_Workflow__c != true )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Please_Check_On_The_Consultant_To_See_If_They_Are_Still_Sold</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Lead.Status_Change_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Working -%3E Sold</fullName>
        <actions>
            <name>Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     ISPICKVAL(Status, &quot;Working&quot;),     Enrollment_Code__c != NULL )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Please_Check_On_The_Consultant_To_See_If_They_Are_Still_A_Working_Prospect</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please Check On The Consultant To See If They Are Still A &apos;Working&apos; Prospect</subject>
    </tasks>
    <tasks>
        <fullName>Please_Check_On_The_Consultant_To_See_If_They_Are_Still_Sold</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please Check On The Consultant To See If They Are Still Sold.</subject>
    </tasks>
    <tasks>
        <fullName>Please_initiate_the_background_and_or_drug_check</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please initiate the background and/or drug check.</subject>
    </tasks>
    <tasks>
        <fullName>Someone_filled_out_an_inquiry_form_on_our_site_please_respond_to_them</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Someone filled out an inquiry form on our site - please respond to them</subject>
    </tasks>
    <tasks>
        <fullName>Task_23</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please initiate the background and/or drug check.</subject>
    </tasks>
    <tasks>
        <fullName>Task_29</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please confirm you receive a complete and accurate I9 form.</subject>
    </tasks>
    <tasks>
        <fullName>Task_30</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please confirm you receive the completed on-boarding documents.</subject>
    </tasks>
    <tasks>
        <fullName>Task_31</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please confirm the accurate work order is supplied by client (work order activated in VMS, if applicable).</subject>
    </tasks>
    <tasks>
        <fullName>Task_33</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please confirm you receive all supporting qualification documentation.</subject>
    </tasks>
    <tasks>
        <fullName>Task_36</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>1</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>(Attempt 1) Please call the new inquiry and consult them to see if it&apos;s a good fit</subject>
    </tasks>
    <tasks>
        <fullName>Task_4</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>20</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please contact the Parked Lead regarding their work status.</subject>
    </tasks>
    <tasks>
        <fullName>Task_40</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>(Attempt 1) Please contact the Associate and assist with enrollment completion.</subject>
    </tasks>
    <tasks>
        <fullName>Task_44</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>(Attempt 1) Please contact the Associate and assist with enrollment completion</subject>
    </tasks>
    <tasks>
        <fullName>Task_46</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please initiate the enrollment documentation process.</subject>
    </tasks>
    <tasks>
        <fullName>Task_5</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>4</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please call the Prospect regarding their work status.</subject>
    </tasks>
    <tasks>
        <fullName>Time_Based_Workflow_1_Day</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Time-Based Workflow 1 Day</subject>
    </tasks>
    <tasks>
        <fullName>ToDo_26</fullName>
        <assignedTo>rsuri@mbopartners.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>2</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please initiate the background and/or drug check</subject>
    </tasks>
    <tasks>
        <fullName>VASTcall</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Complete VAST consultation call</subject>
    </tasks>
</Workflow>
