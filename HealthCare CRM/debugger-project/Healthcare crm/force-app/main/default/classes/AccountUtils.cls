public with sharing class AccountUtils {
    // Static method to return Accounts by BillingState
    public static List<Account> accountsByState(String stateAbbr) {
        List<Account> accounts = [
            SELECT Id, Name 
            FROM Account 
            WHERE BillingState = :stateAbbr
        ];
        return accounts;
    }
}