/**********************************************************
 * Description      : Handles various Contact events
 * @author          : Kiran Kurella
 * @date            : May 25, 2014
 * Copyright 2014 MBO Partners. All rights reserved.
 **********************************************************/

trigger ContactTrigger on Contact (before insert) {

	if (trigger.isBefore && trigger.isInsert) LeadHelper.generateMBOId(trigger.new);

}