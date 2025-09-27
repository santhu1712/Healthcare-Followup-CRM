@isTest
private class UpcomingFollowupsControllerTest {
    @isTest static void testGetAndCreate() {
        // create test patient — update these field API names if your org differs
        Patient__c p = new Patient__c(LastName__c='TestLast', Phone_Number__c = 900000001);
        insert p;

        Test.startTest();
        // create follow-up via controller (date string in yyyy-MM-dd)
        String dateStr = String.valueOf(Date.today().addDays(3)); // yyyy-MM-dd
        Id fId = UpcomingFollowupsController.createFollowUp(p.Id, dateStr);
        List<FollowUp_Schedule__c> res = UpcomingFollowupsController.getUpcomingFollowUps(p.Id);
        Test.stopTest();

        System.assertEquals(1, res.size());
        System.assertEquals(fId, res[0].Id);
    }
}
