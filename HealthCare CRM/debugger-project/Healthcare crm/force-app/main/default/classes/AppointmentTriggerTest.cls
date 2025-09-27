@isTest
public class AppointmentTriggerTest {
    @isTest static void testMissedAppointmentTrigger() {
        // Create Patient
        Patient__c p = new Patient__c(
            LastName__c = 'TestPatient',
            Phone_Number__c = 999999999L
        );
        insert p;
        
        // Create Appointment
        Appointment__c appt = new Appointment__c(
            Patient__c = p.Id,
            Appointment_Start__c = System.now().addDays(1), // ✅ corrected field
            Status__c = 'Scheduled'                         // ✅ corrected field
        );
        insert appt;
        
        // Update Appointment to Missed
        appt.Status__c = 'Missed';                          // ✅ corrected field
        update appt;
        
        // Query Follow-Up
        List<FollowUp_Schedule__c> fList = [
            SELECT Id, Follow_Up_Date__c 
            FROM FollowUp_Schedule__c 
            WHERE Patient__c = :p.Id
        ];
        
        System.assertEquals(1, fList.size(), 'Follow-up should be created');
    }
}