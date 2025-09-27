public with sharing class UpcomingFollowupsController {
    @AuraEnabled(cacheable=true)
    public static List<FollowUp_Schedule__c> getUpcomingFollowUps(Id patientId) {
        if (patientId == null) return new List<FollowUp_Schedule__c>();
        return [
            SELECT Id, Follow_Up_Date__c, Follow_Up_Notes__c
            FROM FollowUp_Schedule__c
            WHERE Patient__c = :patientId
              AND Follow_Up_Date__c >= :Date.today()
            ORDER BY Follow_Up_Date__c ASC
        ];
    }

    @AuraEnabled
    public static Id createFollowUp(Id patientId, String followUpDateStr) {
        if (patientId == null) {
            throw new AuraHandledException('Patient Id is required');
        }
        // followUpDateStr expected as 'YYYY-MM-DD'
        Date followUpDate = Date.valueOf(followUpDateStr);
        FollowUp_Schedule__c f = new FollowUp_Schedule__c(
            Patient__c = patientId,
            Follow_Up_Date__c = followUpDate,
            Follow_Up_Notes__c = 'Created from LWC'
        );
        insert f;
        return f.Id;
    }
}
