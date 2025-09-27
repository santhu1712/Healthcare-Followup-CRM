public with sharing class QuickScheduleController {
    @AuraEnabled(cacheable=true)
    public static List<Patient__c> getPatients() {
        return [
            SELECT Id, Name
            FROM Patient__c
            ORDER BY CreatedDate DESC
            LIMIT 200
        ];
    }

    @AuraEnabled
    public static Id createAppointment(Id patientId, String appointmentDateTimeLocal) {
        if (patientId == null || String.isBlank(appointmentDateTimeLocal)) {
            throw new AuraHandledException('Patient and Appointment Date/Time are required');
        }
        // appointmentDateTimeLocal expected like "2025-09-23T14:30" (datetime-local)
        String dtStr = appointmentDateTimeLocal.replace('T',' ') + ':00';
        Datetime dt;
        try {
            dt = Datetime.valueOf(dtStr);
        } catch (Exception e) {
            throw new AuraHandledException('Invalid date format: ' + appointmentDateTimeLocal);
        }

        Appointment__c appt = new Appointment__c(
            Patient__c = patientId,
            Appointment_Start__c = dt,
            Appointment_End__c = dt.addHours(1),
            Status__c = 'Scheduled'
        );
        insert appt;
        return appt.Id;
    }
}
