public with sharing class FollowUpEventPublisher {
    public static void publishFor(List<FollowUp_Schedule__c> newFollowUps) {
        if (newFollowUps == null || newFollowUps.isEmpty()) return;
        List<FollowUpCreated__e> events = new List<FollowUpCreated__e>();
        for (FollowUp_Schedule__c f : newFollowUps) {
            FollowUpCreated__e e = new FollowUpCreated__e(
                PatientId__c = (f.Patient__c == null ? null : String.valueOf(f.Patient__c)),
                FollowUpDate__c = f.Follow_Up_Date__c,
                Notes__c = f.Follow_Up_Notes__c
            );
            events.add(e);
        }
        if (!events.isEmpty()) {
            // publish events in bulk
            Database.SaveResult[] results = EventBus.publish(events);
            // optional: check save results for failures and log
            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    // log the error to debug (or to a custom object for production)
                    System.debug('Failed to publish event for FollowUp: ' + results[i].getErrors()[0].getMessage());
                }
            }
        }
    }
}
