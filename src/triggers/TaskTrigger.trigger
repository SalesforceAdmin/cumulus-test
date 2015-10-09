/**********************************************************
 * Description      : Handles various Task events
 * @author          : Kiran Kumar
 * @date            : MAY 21, 2013
 * Copyright 2013 MBO Partners. All rights reserved.
 **********************************************************/

trigger TaskTrigger on Task (after update) {

	if (trigger.isAfter && trigger.isUpdate) {
		TaskHelper.evaluateTasks(trigger.newMap, trigger.oldMap);
	}
}