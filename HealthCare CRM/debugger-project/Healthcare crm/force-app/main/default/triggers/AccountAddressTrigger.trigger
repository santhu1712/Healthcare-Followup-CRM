trigger AccountAddressTrigger on Account (before insert, before update) {
    for (Account acct : Trigger.new) {
        // Check if checkbox is selected
        if (acct.Match_Billing_Address__c == true) {
            // Copy Billing Postal Code to Shipping Postal Code
            acct.ShippingPostalCode = acct.BillingPostalCode;
        }
    }
}