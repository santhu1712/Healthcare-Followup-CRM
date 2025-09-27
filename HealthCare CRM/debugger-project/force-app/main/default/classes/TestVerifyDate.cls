@isTest
private class TestVerifyDate {

    @isTest
    static void testDateWithin30Days() {
        // date2 is 10 days after date1 → should return date2
        Date d1 = Date.today();
        Date d2 = d1.addDays(10);
        Date result = VerifyDate.CheckDates(d1, d2);
        System.assertEquals(d2, result, 'Expected date2 to be returned when within 30 days');
    }

    @isTest
    static void testDateInPast() {
        // date2 is before date1 → should return end of month of date1
        Date d1 = Date.newInstance(2024, 6, 15);
        Date d2 = Date.newInstance(2024, 6, 10);
        Date result = VerifyDate.CheckDates(d1, d2);
        Date expected = Date.newInstance(2024, 6, 30);
        System.assertEquals(expected, result, 'Expected end of month when date2 < date1');
    }

    @isTest
    static void testDateMoreThan30Days() {
        // date2 is 40 days after date1 → should return end of month
        Date d1 = Date.newInstance(2024, 7, 1);
        Date d2 = d1.addDays(40);
        Date result = VerifyDate.CheckDates(d1, d2);
        Date expected = Date.newInstance(2024, 7, 31);
        System.assertEquals(expected, result, 'Expected end of month when date2 > 30 days away');
    }

    @isTest
    static void testDateExactly30Days() {
        // date2 is exactly 30 days after date1 → should return end of month
        Date d1 = Date.newInstance(2024, 8, 1);
        Date d2 = d1.addDays(30);
        Date result = VerifyDate.CheckDates(d1, d2);
        Date expected = Date.newInstance(2024, 8, 31);
        System.assertEquals(expected, result, 'Expected end of month when date2 is exactly 30 days away');
    }
}