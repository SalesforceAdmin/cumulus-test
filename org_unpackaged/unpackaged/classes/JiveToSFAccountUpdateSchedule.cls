global class JiveToSFAccountUpdateSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc) {
		JiveToSFAccountUpdate accountupdate = new JiveToSFAccountUpdate();
		database.executeBatch(accountupdate, 5);
    }
    
}