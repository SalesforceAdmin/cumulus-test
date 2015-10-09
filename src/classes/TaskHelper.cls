/**********************************************************
 * Description      : Task Helper class
 * @author          : Kiran Kumar
 * @date            : May 21, 2013
 * Copyright 2013 MBO Partners. All rights reserved.
 **********************************************************/

public with sharing class TaskHelper {

	private static set<Id> processesTaskIds = new set<Id>(); 

	private static map<String, TaskList> mapParentSubjectToTaskList = new map<String, TaskList>();
	public static map<String, TaskList> getTaskList() {
		//map<String, list<Task_List__c>> mapParentSubjectToChildTasks = new map<String, list<Task_List__c>>();

		if (mapParentSubjectToTaskList == null || mapParentSubjectToTaskList.isEmpty()) {
			for (Task_List__c tl : [select Id, Name, Subject__c, Parent_Field_Name__c, Status_To_Update_Parent_Field__c,
											(select Id, Parent_Task__c, Parent_Task_Status__c, Parent_Associate_Status__c,
												Child_Task__c, Child_Task__r.Name, Child_Task__r.Subject__c, Child_Task__r.Type__c, Child_Task__r.Priority__c,
												Child_Task__r.Assign_To__c, Child_Task__r.Assign_To_MBO_User_Field_Name__c, Child_Task__r.Due_Days__c 
											from Parent_Task__r
											where IsActive__c = true)
								 	from  	Task_List__c
								 	where	IsActive__c = true]) {

				mapParentSubjectToTaskList.put(tl.Subject__c, new TaskList(tl));
			}
		}

		return mapParentSubjectToTaskList;
	}

	private static set<String> setMBOUserFields = new set<String>{};
	private static String getTaskListFields() {

		String leadFields = '';
		set<String> setLeadFields = new set<String>{'Associate_Status__c', 'IsConverted'};

		getTaskList();
		for (TaskList tl : mapParentSubjectToTaskList.values()) {
			if (tl.parentTaskList.Parent_Field_Name__c != null) setLeadFields.add(tl.parentTaskList.Parent_Field_Name__c);

			for (Task_Relationship__c trel : tl.childTaskRelations) {
				if (trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c != null) {
					setLeadFields.add(trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c);
					setMBOUserFields.add(trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c);
				}
			}
		}

		if (!setLeadFields.isEmpty()) {
			for (String fieldName : setLeadFields) {
				leadFields += (leadFields != '' ? ', ' : '') + fieldName;
			}
		}
		//system.debug('\n ### leadFields ' + leadFields);

		return leadFields;
	}

	public static void evaluateTasks(map<Id, Task> mapNewTasks, map<Id, Task> mapOldTasks) {

		try {
			map<Id, Lead> mapLeads = new map<Id, Lead>();
			map<Id, Lead> leads_To_Update = new map<Id, Lead>();
			map<Id, My_Biz_Office_User__c> mapMBOUsers = new map<Id, My_Biz_Office_User__c>();
			list<Task> tasks_To_Insert = new list<Task>();
	
			for (Task t : mapNewTasks.values()) {
				if (!processesTaskIds.contains(t.Id) && Util.RecordOf(t.whoId, 'Lead') && (t.Status != mapOldTasks.get(t.Id).Status || t.Subject != mapOldTasks.get(t.Id).Subject)) {
					if (mapParentSubjectToTaskList == null || mapParentSubjectToTaskList.isEmpty()) getTaskList();
	
					if (mapParentSubjectToTaskList.containsKey(t.Subject)) {
						mapLeads.put(t.whoId, null);
					}
				}
			}
	
			if (!mapLeads.isEmpty()) {
				set<Id> leadIds = mapLeads.keySet();
				String soql = 'Select Id, ' + getTaskListFields() + ' from Lead where Id in : leadIds';
				system.debug('\n ### soql ' + soql);
				for (Lead l : Database.query(soql)) {
					mapLeads.put(l.Id, l);
	
					//if (l.Enrollment_Manager__c != null) mapMBOUsers.put(l.Enrollment_Manager__c, null);
					for (String fieldName : setMBOUserFields) {
						Id lookupFieldValue = (Id) l.get(fieldName);
						if (lookupFieldValue != null) mapMBOUsers.put(lookupFieldValue, null);
					}
				}
				system.debug('\n ### mapLeads ' + mapLeads.size() + ' => ' + mapLeads);
	
				if (!mapMBOUsers.isEmpty()) mapMBOUsers = new  map<Id, My_Biz_Office_User__c>([select Id, Salesforce_User__c from My_Biz_Office_User__c where Id in : mapMBOUsers.keySet() and Salesforce_User__c != null and Salesforce_User__r.isActive = true]);
				system.debug('\n ### mapMBOUsers ' + mapMBOUsers.size() + ' => ' + mapMBOUsers);
			}
	
			for (Task t : mapNewTasks.values()) {
				if (!processesTaskIds.contains(t.Id) && Util.RecordOf(t.whoId, 'Lead') && (t.Status != mapOldTasks.get(t.Id).Status || t.Subject != mapOldTasks.get(t.Id).Subject)) {
	
					if (mapParentSubjectToTaskList.containsKey(t.Subject)) {
						TaskList parentTask = mapParentSubjectToTaskList.get(t.Subject);
						Task_List__c parentTaskList = parentTask.parentTaskList;
						Lead ld = mapLeads.get(t.WhoId);

						// parent field updates
						if (!ld.IsConverted && parentTaskList.Parent_Field_Name__c != null && (parentTaskList.Status_To_Update_Parent_Field__c == null || Util.containsIgnoreCase(t.Status, parentTaskList.Status_To_Update_Parent_Field__c.split(';')))) {
							if (!leads_To_Update.containsKey(ld.Id)) leads_To_Update.put(ld.Id, new Lead(Id=ld.Id));
							if (ld.get(parentTaskList.Parent_Field_Name__c) == null && leads_To_Update.get(ld.Id).get(parentTaskList.Parent_Field_Name__c) == null) leads_To_Update.get(ld.Id).put(parentTaskList.Parent_Field_Name__c, system.today()); 
						}

						// create subsequent tasks
						for (Task_Relationship__c trel : parentTask.childTaskRelations) {
							//if ( (trel.Parent_Task_Status__c == null || (trel.Parent_Task_Status__c != null && Util.containsIgnoreCase(t.Status, trel.Parent_Task_Status__c.split(';')) && !Util.containsIgnoreCase(mapOldTasks.get(t.Id).Status, trel.Parent_Task_Status__c.split(';')))) &&
							//	   (trel.Parent_Associate_Status__c == null || (trel.Parent_Associate_Status__c != null && Util.containsIgnoreCase(ld.Associate_Status__c, trel.Parent_Associate_Status__c.split(';')))) )
							if ( (trel.Parent_Task_Status__c == null || (Util.containsIgnoreCase(t.Status, trel.Parent_Task_Status__c.split(';')) && !Util.containsIgnoreCase(mapOldTasks.get(t.Id).Status, trel.Parent_Task_Status__c.split(';')))) &&
								 (trel.Parent_Associate_Status__c == null || !Util.containsIgnoreCase(ld.Associate_Status__c, trel.Parent_Associate_Status__c.split(';'))) ) {
								Task_List__c childTaskList = trel.Child_Task__r;
	
								Id ownerId = trel.Child_Task__r.Assign_To__c;
								ownerId = ownerId == null && trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c != null && mapMBOUsers.containsKey((Id) ld.get(trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c)) ? mapMBOUsers.get((Id) ld.get(trel.Child_Task__r.Assign_To_MBO_User_Field_Name__c)).Salesforce_User__c : null;
								if (ownerId == null && MBOPartnersHelper.MBOAdminUser != null) ownerId = MBOPartnersHelper.MBOAdminUser.Id;
								//if (ownerId == null) ownerId = ld.OwnerId;
								Date activityDate = system.today().addDays(Integer.valueOf(trel.Child_Task__r.Due_Days__c==null ? 0 : trel.Child_Task__r.Due_Days__c)); 
	
								processesTaskIds.add(t.Id);
								tasks_To_Insert.add(new Task(WhoId=ld.Id, Subject=childTaskList.Subject__c, Type=childTaskList.Type__c, Priority=childTaskList.Priority__c, OwnerId=ownerId, ActivityDate=activityDate, IsReminderSet=true, ReminderDateTime=activityDate));	//system.now().addMinutes(2)
							}
						}
					}
				}
			}

			system.debug('\n ### tasks_To_Insert ' + tasks_To_Insert.size() + ' => ' + tasks_To_Insert);
			if (!tasks_To_Insert.isEmpty()) insert tasks_To_Insert;
	
			system.debug('\n ### leads_To_Update ' + leads_To_Update.size() + ' => ' + leads_To_Update);
			if (!leads_To_Update.isEmpty()) update leads_To_Update.values();

		} catch (DmlException ex) {
			mapNewTasks.values()[0].addError(ex.getDmlMessage(0));
		}
	}

	// TaskList wrapper class
	public with sharing class TaskList {
		public Task_List__c parentTaskList						{get; set;}
		public list<Task_Relationship__c> childTaskRelations	{get; set;}

		public TaskList(Task_List__c taskList) {
			this.parentTaskList = taskList;
			if (taskList != null && taskList.Parent_Task__r != null) this.childTaskRelations = taskList.Parent_Task__r;
			if (this.childTaskRelations == null) this.childTaskRelations = new list<Task_Relationship__c>();
		}
	}
}