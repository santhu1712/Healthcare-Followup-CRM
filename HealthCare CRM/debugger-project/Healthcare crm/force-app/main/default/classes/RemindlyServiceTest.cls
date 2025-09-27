@isTest
private class RemindlyServiceTest {
    @isTest static void testSendSms() {
        Test.setMock(HttpCalloutMock.class, new RemindlyServiceMock());
        Test.startTest();
        Boolean ok = RemindlyService.sendSms('+919000000001','Test message');
        Test.stopTest();
        System.assertEquals(true, ok, 'sendSms should return true when callout returns 200');
    }
}
