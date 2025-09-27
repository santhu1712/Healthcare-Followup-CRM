public class RemindlySendJob implements Queueable, Database.AllowsCallouts {
    private Id followUpId;
    public RemindlySendJob(Id followUpId) {
        this.followUpId = followUpId;
    }
    public void execute(QueueableContext ctx) {
        try {
            FollowUp_Schedule__c f = [
                SELECT Id, Follow_Up_Date__c, Follow_Up_Notes__c, Patient__c,
                       Patient__r.Name, Patient__r.Phone_Number__c
                FROM FollowUp_Schedule__c
                WHERE Id = :followUpId
                LIMIT 1
            ];

            String phone = '';
            if (f.Patient__r != null && f.Patient__r.Phone_Number__c != null) {
                phone = String.valueOf(f.Patient__r.Phone_Number__c);
            }
            String messageBody = 'Reminder: your follow-up is scheduled on ' + String.valueOf(f.Follow_Up_Date__c);
            Boolean sent = RemindlyService.sendSms(phone, messageBody);
            System.debug('RemindlySendJob result for ' + f.Id + ' sent=' + sent);
            // Optionally update a field on FollowUp_Schedule__c like Reminder_Sent__c
            if (sent) {
                f.put('Reminder_Sent__c', true);
                update f;
            }
        } catch (Exception ex) {
            System.debug('RemindlySendJob error: ' + ex.getMessage());
            // Optionally log or handle
        }
    }
}
