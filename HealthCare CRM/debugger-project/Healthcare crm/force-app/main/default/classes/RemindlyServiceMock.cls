@isTest
global class RemindlyServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        // Fake payload — tests just need a 200 response
        res.setBody('{"success":true,"id":"msg123"}');
        res.setStatusCode(200);
        return res;
    }
}
