public with sharing class PatientFollowUpService {
    public static void createFollowUp(Id patientId, Date followUpDate) {
        FollowUp_Schedule__c f = new FollowUp_Schedule__c(
            Patient__c = patientId,
            Follow_Up_Date__c = followUpDate,   
            Follow_Up_Notes__c = 'Auto-created via Apex Service'
        );
        insert f;
    }
}