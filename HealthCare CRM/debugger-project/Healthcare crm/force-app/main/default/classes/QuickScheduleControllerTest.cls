@isTest
private class QuickScheduleControllerTest {
    @isTest static void testCreateAppointmentAndGetPatients() {
        // create test patient — use your actual required field API names
        Patient__c p = new Patient__c(
            LastName__c = 'TS', 
            Phone_Number__c = 900000011
        );
        insert p;

        // create appointment via controller
        String dtStr = Datetime.now().addDays(1).format('yyyy-MM-dd\'T\'HH:mm'); // "yyyy-MM-ddTHH:mm"
        Test.startTest();
        Id apptId = QuickScheduleController.createAppointment(p.Id, dtStr);
        Test.stopTest();

        System.assertNotEquals(null, apptId);

        // ensure getPatients returns at least one record
        List<Patient__c> patients = QuickScheduleController.getPatients();
        System.assert(patients.size() > 0);
    }
}
