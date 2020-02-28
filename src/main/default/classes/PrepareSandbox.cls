/**
 * Sandbox initialization class
 * 1. retrieve the id of this class via SOQL: SELECT Id FROM ApexClass WHERE Name = 'PrepareSandbox'
 * 2. use the id in the ApexClassId field of your sandbox definition file.
 */
global class PrepareSandbox implements SandboxPostCopy {

    /**
     * Runs some logic after a sandbox is created:
     * create a user with the System Administrator profile
     */
    global void runApexClass(SandboxContext context) {
        // Get system admin profile
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        // Get sanbox users from custom metadata
        List<Sandbox_User__mdt> sbxUsers = [SELECT DeveloperName, Base_Username__c, Email__c FROM Sandbox_User__mdt];

        // Create sandbox users with admin profile
        List<User> newUsers = new List<User>();
        for (Sandbox_User__mdt sbxUser : sbxUsers)
        {
            String username = sbxUser.Base_Username__c +'.'+ context.sandboxName();
            User newUser = new User(
                UserName = username,
                Email = sbxUser.Email__c,
                LastName = sbxUser.DeveloperName,
                Alias = sbxUser.DeveloperName,
                ProfileId = adminProfile.Id,
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US', 
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/Los_Angeles'
            );
            newUsers.add(newUser);
        }
        insert newUsers;

        // Reset user passwords when not in test mode
        if(!Test.isRunningTest()) {
            for (Sandbox_User__mdt sbxUser : sbxUsers) {
                System.resetPassword(sbxUser.Id, true);
            }
        }
    }
}