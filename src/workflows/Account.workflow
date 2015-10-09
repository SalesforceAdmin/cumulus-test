<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Update_Logistics_Center</fullName>
        <description>Update Logistics Center</description>
        <protected>false</protected>
        <recipients>
            <recipient>Logistics_Center</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Update_Logistics_Center</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Change_Date_Today</fullName>
        <field>fd_activityChangeDate__c</field>
        <formula>TODAY()</formula>
        <name>Account Change Date: Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Alumni</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Alumni</literalValue>
        <name>Account Status: Alumni</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Attempted</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Attempted</literalValue>
        <name>Account Status: Attempted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Client</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Client</literalValue>
        <name>Account Status: Client</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_New</fullName>
        <field>Activity_Status__c</field>
        <literalValue>New</literalValue>
        <name>Account Status: New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Status_Working</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Working</literalValue>
        <name>Account Status: Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Activate_Associate</fullName>
        <field>fd_slaActivate__c</field>
        <formula>NOW()</formula>
        <name>Activate Associate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Associate_Activated_Today</fullName>
        <field>fd_slaActivate__c</field>
        <formula>TODAY()</formula>
        <name>Associate Activated: Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Billings_to_Contact</fullName>
        <field>Billings_to_Date__pc</field>
        <formula>TOTBilling__c</formula>
        <name>Billings to Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSUpdate</fullName>
        <field>Contact_Status__pc</field>
        <literalValue>Associate</literalValue>
        <name>Contact Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Status_Date_Now</fullName>
        <field>fd_statusChange__pc</field>
        <formula>TODAY()</formula>
        <name>Contact Status Date - Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Education_and_Research</fullName>
        <field>fb_eduAndResearch__pc</field>
        <literalValue>0</literalValue>
        <name>Education and Research</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Opt_In</fullName>
        <field>PersonHasOptedOutOfEmail</field>
        <literalValue>0</literalValue>
        <name>Email Opt In</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MBO_Sync_True</fullName>
        <field>fb_MBO__c</field>
        <literalValue>1</literalValue>
        <name>MBO Sync True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Newsletters_and_events</fullName>
        <field>fb_nlAndEvents__pc</field>
        <literalValue>0</literalValue>
        <name>Newsletters and events</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Status_Reason_Looking_For_Work</fullName>
        <field>fs_salesStatusReason__pc</field>
        <literalValue>Looking For Work</literalValue>
        <name>Sales Status Reason: Looking For Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Alumni</fullName>
        <field>Contact_Status__pc</field>
        <literalValue>Alumni</literalValue>
        <name>Status: Alumni</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Associate</fullName>
        <field>Contact_Status__pc</field>
        <literalValue>Associate</literalValue>
        <name>Status: Associate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Sold</fullName>
        <field>Contact_Status__pc</field>
        <literalValue>Sold</literalValue>
        <name>Status: Sold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Status_Unidentified_Project</fullName>
        <field>Sub_Status__pc</field>
        <literalValue>Unidentified Project</literalValue>
        <name>Sub-Status: Unidentified Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tips_and_Features</fullName>
        <field>fb_tipsAndFeatures__pc</field>
        <literalValue>0</literalValue>
        <name>Tips and Features</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activity_Status</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Client</literalValue>
        <name>Update Activity Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Practice_Owner_Check</fullName>
        <field>fb_pracOwn__pc</field>
        <literalValue>1</literalValue>
        <name>Update Practice Owner Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Practice_Owner_UnCheck</fullName>
        <field>fb_pracOwn__pc</field>
        <literalValue>0</literalValue>
        <name>Update Practice Owner - UnCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account Status Change Date Update</fullName>
        <actions>
            <name>Account_Change_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(    ISCHANGED(Activity_Status__c),    ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Associate -%3E Alumni</fullName>
        <actions>
            <name>Sales_Status_Reason_Looking_For_Work</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Alumni</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Status_Unidentified_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Contact_Status__pc,&quot;Associate&quot;), ISPICKVAL(Associate_Status__pc, &quot;Terminated&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Associate Creation</fullName>
        <actions>
            <name>Associate_Activated_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(    RecordType.DeveloperName = &quot;Partners_Associate&quot;,    RecordType.DeveloperName = &quot;Client_Referred_Associate&quot; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Change in Billings</fullName>
        <actions>
            <name>Billings_to_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.TOTBilling__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Client Sync</fullName>
        <actions>
            <name>MBO_Sync_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the company to sync with MBO upon &apos;Client&apos; status.</description>
        <formula>ISPICKVAL(Activity_Status__c,&apos;Client&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Consultant%3A Sold SLA</fullName>
        <active>true</active>
        <formula>AND(     RecordTypeId&lt;&gt;&quot;012C0000000Q8Ev&quot;,     RecordTypeId&lt;&gt;&quot;012C0000000Q8Eu&quot;,     ISPICKVAL(Contact_Status__pc,&quot;Sold&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Please_check_on_the_consultant_to_see_if_they_are_still_sold</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.fd_statusChange__pc</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Consultant%3A Working SLA</fullName>
        <active>true</active>
        <formula>AND(     RecordTypeId&lt;&gt;&quot;012C0000000Q8Ev&quot;,     RecordTypeId&lt;&gt;&quot;012C0000000Q8Eu&quot;,     ISPICKVAL(Contact_Status__pc,&quot;Working&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Please_Check_On_The_Consultant_To_See_If_They_Are_Still_A_Working_Prospect</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.fd_statusChange__pc</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Contact Status</fullName>
        <actions>
            <name>CSUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Referred Associate,Direct Associate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Contact_Status__pc</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Changes contact status for newly converted associates to associate.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact Status Change Update</fullName>
        <actions>
            <name>Contact_Status_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR(        ISCHANGED(Contact_Status__pc),        ISNEW()     ),     IsPersonAccount = TRUE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Opt In</fullName>
        <actions>
            <name>Email_Opt_In</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2 or 3</booleanFilter>
        <criteriaItems>
            <field>Account.fb_nlAndEvents__pc</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.fb_tipsAndFeatures__pc</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.fb_eduAndResearch__pc</field>
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
            <field>Account.PersonHasOptedOutOfEmail</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Layoff Alumni Assignment</fullName>
        <actions>
            <name>Follow_Up_Layoff</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Assigns the Layoff Alumni Task. List A.</description>
        <formula>AND(     ISPICKVAL(fs_statusCode__pc,&apos;Layoff&apos;),     IF(         CASE(Owner.Id, &quot;00580000003Xgdb&quot;,1, &quot;005C0000005Kp2O&quot;,1, &quot;005C0000003bREb&quot;,1,0         )=1,         FALSE,         TRUE      ),      NOT(ISPICKVAL(fs_operationPlan__pc,&apos;Non Associate&apos;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Work Order</fullName>
        <actions>
            <name>New_Work_Order</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>AND(     ISCHANGED( fn_workOrderCount__c ),     ISPICKVAL(Associate_Type__pc,&apos;MBO Sub&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opp Count %3C%3D 0</fullName>
        <actions>
            <name>Account_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>fn_totalOpportunities__c &lt;= 0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Count %3E 0%2C Sold %3C%3D 0%2C Open %3C%3D 0%2C Inactive %3C%3D 0</fullName>
        <actions>
            <name>Account_Status_Attempted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     fn_totalOpportunities__c &gt; 0,     fn_totalSoldOpportunities__c &lt;= 0,     fn_totalOpenOpportunities__c &lt;= 0,     fn_totalInactiveOpportunities__c &lt;= 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Count %3E 0%2C Sold %3C%3D 0%2C Open %3C%3D 0%2C Inactive %3E 0</fullName>
        <actions>
            <name>Account_Status_Alumni</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     fn_totalOpportunities__c &gt; 0,     fn_totalSoldOpportunities__c &lt;= 0,     fn_totalOpenOpportunities__c &lt;= 0,     fn_totalInactiveOpportunities__c &gt; 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Count %3E 0%2C Sold %3C%3D 0%2C Open %3E 0</fullName>
        <actions>
            <name>Account_Status_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     fn_totalOpportunities__c &gt; 0,     fn_totalSoldOpportunities__c &lt;= 0,     fn_totalOpenOpportunities__c &gt; 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opp Count %3E 0%2C Sold %3E 0</fullName>
        <actions>
            <name>Account_Status_Client</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     fn_totalOpportunities__c &gt; 0,     fn_totalSoldOpportunities__c &gt; 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sold -%3E Associate</fullName>
        <actions>
            <name>Status_Associate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISPICKVAL(Associate_Status__pc,&quot;Active&quot;),ISPICKVAL(Associate_Status__pc,&quot;Non Billing&quot;),ISPICKVAL(Associate_Status__pc,&quot;Probation&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Activity Status</fullName>
        <actions>
            <name>Update_Activity_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Updates the Company&apos;s status to &apos;Client&apos; upon a closed won opportunity.</description>
        <formula>AND(RecordType.DeveloperName = &apos;ES_Client&apos;,  Total_Closed_Won_Opportunities__c &gt; 0,  OR(ISCHANGED(Total_Closed_Won_Opportunities__c),  ISCHANGED(RecordTypeId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Logistics Center</fullName>
        <actions>
            <name>Update_Logistics_Center</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(    AND(ISPICKVAL(Activity_Status__c,&quot;Client&quot;),          OR(ISCHANGED(Name),           ISCHANGED(Tier__c),           ISCHANGED(Account_Manager__c),           ISCHANGED(AccountExecutive__c)          )       ),    AND(OR(ISPICKVAL(Type,&quot;Partner&quot;),           ISPICKVAL(Type,&quot;Affiliate&quot;)          ),        OR(ISCHANGED(Name),           ISCHANGED(Type)          )       ),    OR(ISPICKVAL(PRIORVALUE(Activity_Status__c),&quot;Client&quot;),       ISPICKVAL(PRIORVALUE(Type),&quot;Partner&quot;),       ISPICKVAL(PRIORVALUE(Type),&quot;Affiliate&quot;)      )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Practice Owner - Check</fullName>
        <actions>
            <name>Update_Practice_Owner_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggers an update to Practice Owner field if it is a practice owner.</description>
        <formula>AND( OR(RecordType.DeveloperName = &apos;Client_Referred_Associate&apos;,  RecordType.DeveloperName = &apos;Partners_Associate&apos;),  OR(NOT ISPICKVAL(How_Did_You_Hear_About_Us__pc, &apos;From a Client&apos;), AND(ISPICKVAL(How_Did_You_Hear_About_Us__pc, &apos;From a Client&apos;),  TOTEngagements__c &gt;= 2)),    OR(CreatedDate =  LastModifiedDate, ISCHANGED(TOTEngagements__c), ISCHANGED(How_Did_You_Hear_About_Us__pc),  ISCHANGED(RecordTypeId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Practice Owner - UnCheck</fullName>
        <actions>
            <name>Update_Practice_Owner_UnCheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggers update to unflag the practice owner if they aren&apos;t.</description>
        <formula>AND( OR(RecordType.DeveloperName = &apos;Client_Referred_Associate&apos;,  RecordType.DeveloperName = &apos;Partners_Associate&apos;),  ISPICKVAL(How_Did_You_Hear_About_Us__pc, &apos;From a Client&apos;),   TOTEngagements__c &lt; 2,    OR(CreatedDate =  LastModifiedDate, ISCHANGED(TOTEngagements__c), ISCHANGED(How_Did_You_Hear_About_Us__pc),  ISCHANGED(RecordTypeId)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Voluntary Alumni Assingment</fullName>
        <actions>
            <name>Follow_Up_Voluntary</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.fs_statusCode__pc</field>
            <operation>equals</operation>
            <value>Voluntary</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.fs_operationPlan__pc</field>
            <operation>notEqual</operation>
            <value>Non Associate</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Sara Conde,Nicolette Taylor,George Sturgis</value>
        </criteriaItems>
        <description>Assigns the Voluntary Alumni task. List B.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Working -%3E Sold</fullName>
        <actions>
            <name>Status_Sold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(Contact_Status__pc,&quot;Working&quot;),OR(ISPICKVAL(Associate_Status__pc,&quot;Pending&quot;),ISPICKVAL(Associate_Status__pc,&quot;Enrolled&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_Up_Layoff</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow up with the alumni regarding their layoff.</description>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up - Layoff</subject>
    </tasks>
    <tasks>
        <fullName>Follow_Up_Voluntary</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow up with the alumni regarding their voluntary resignation.</description>
        <dueDateOffset>180</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up - Voluntary</subject>
    </tasks>
    <tasks>
        <fullName>New_Work_Order</fullName>
        <assignedTo>hprindle@mbopartners.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Work Order</subject>
    </tasks>
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
        <fullName>Please_check_on_the_consultant_to_see_if_they_are_still_sold</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>3</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please check on the consultant to see if they are still sold.</subject>
    </tasks>
</Workflow>
