public with sharing class RemindlyService {
    // Simple callout returning whether it succeeded (200-299)
    @AuraEnabled
    public static Boolean sendSms(String phone, String messageBody) {
        HttpRequest req = new HttpRequest();
        // Use Named Credential name here. Replace Remindly_NC with your Named Credential API Name.
        req.setEndpoint('callout:Remindly_NC/v1/messages');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        Map<String, Object> payload = new Map<String, Object>{
            'to' => phone,
            'message' => messageBody
        };
        req.setBody(JSON.serialize(payload));

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Remindly sendSms status: ' + res.getStatus() + ' body: ' + res.getBody());
        return res.getStatusCode() >= 200 && res.getStatusCode() < 300;
    }
}