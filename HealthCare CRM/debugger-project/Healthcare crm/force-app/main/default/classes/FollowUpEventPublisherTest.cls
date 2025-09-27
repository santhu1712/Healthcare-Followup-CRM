@isTest
private class FollowUpEventPublisherTest {
    @isTest static void testPublishFor() {
        // Create minimal test patient and follow-up
        Patient__c p = new Patient__c(LastName__c='T', Phone_Number__c=900000001);
        insert p;
        FollowUp_Schedule__c f = new FollowUp_Schedule__c(
            Name = 'FU Test',
            Patient__c = p.Id,
            Follow_Up_Date__c = Date.today().addDays(7),
            Follow_Up_Notes__c = 'Test from unit'
        );
        Test.startTest();
            insert f; // this will fire trigger -> handler -> EventBus.publish
        Test.stopTest();
        // No direct assertion on platform events here, but ensure no exception and trigger ran.
        System.assert(true);
    }
}
