trigger AppointmentTrigger on Appointment__c (after update) {
    List<FollowUp_Schedule__c> newFollowUps = new List<FollowUp_Schedule__c>();

    for (Appointment__c appt : Trigger.new) {
        Appointment__c oldAppt = Trigger.oldMap.get(appt.Id);

        if (appt.Status__c == 'Missed' && oldAppt.Status__c != 'Missed') {
            newFollowUps.add(new FollowUp_Schedule__c(
                Patient__c = appt.Patient__c,
                Follow_Up_Date__c = Date.today().addDays(7), // ✅ corrected
                Follow_Up_Notes__c = 'Auto-created for missed appointment'
            ));
        }
    }
    if (!newFollowUps.isEmpty()) {
        try {
            insert newFollowUps;
        } catch (DmlException e) {
            System.debug('Error while inserting follow-ups: ' + e.getMessage());
        }
    }
}