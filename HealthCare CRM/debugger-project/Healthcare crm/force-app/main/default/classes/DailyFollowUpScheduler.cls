global class DailyFollowUpScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Query follow-ups that are due today and not sent yet
        List<FollowUp_Schedule__c> due = [
            SELECT Id, Follow_Up_Date__c, Patient__r.Phone_Number__c
            FROM FollowUp_Schedule__c
            WHERE Follow_Up_Date__c = :Date.today()
            LIMIT 100
        ];
        for (FollowUp_Schedule__c f : due) {
            // enqueue a job per record (or batch them into chunks)
            System.enqueueJob(new RemindlySendJob(f.Id));
        }
    }
}
