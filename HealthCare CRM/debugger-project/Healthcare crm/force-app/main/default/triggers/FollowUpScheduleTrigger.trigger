trigger FollowUpScheduleTrigger on FollowUp_Schedule__c (after insert) {
    // call handler for publishing platform events
    FollowUpEventPublisher.publishFor(Trigger.new);
}
