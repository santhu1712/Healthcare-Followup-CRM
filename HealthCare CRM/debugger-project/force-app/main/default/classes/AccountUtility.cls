public class AccountUtility {
    public static void viewAnnualRevenue() {
        // Create a list to store Account records
        List<Account> accountsList = [SELECT Name, AnnualRevenue FROM Account];

        // Loop through each account in the list
        for (Account acc : accountsList) {
            // Concatenate Account Name and Annual Revenue
            String acctRev = acc.Name + ' : ' + acc.AnnualRevenue;

            // Print to debug log
            System.debug(acctRev);
        }
    }
}