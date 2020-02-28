@isTest
class PrepareSandboxTest {

    private final static String SANDBOX_NAME = 'sbx';

    @isTest
    static void runApexClass_should_work() {
        // Count users
        Integer initialUserCount = database.countQuery('SELECT COUNT() FROM User');
        // Get sanbox users from custom metadata
        List<Sandbox_User__mdt> sbxUsers = [SELECT DeveloperName, Base_Username__c, Email__c FROM Sandbox_User__mdt];

        // Simulate sandbox copy
        Test.startTest();
        Test.testSandboxPostCopyScript(
            new PrepareSandbox(),
            UserInfo.getOrganizationId(),
            UserInfo.getOrganizationId(),
            SANDBOX_NAME
        );
        Test.stopTest();

        // Check that users were created
        Integer newUserCount = database.countQuery('SELECT COUNT() FROM User');
        System.assertEquals(newUserCount, initialUserCount + sbxUsers.size());
        
        // Check that at least one user has the right username and the admin profile
        if (sbxUsers.size() > 0) {
            User sbxUser = [SELECT Username, Profile.Name FROM User ORDER BY CreatedDate DESC LIMIT 1];
            String expectedUsername = sbxUsers[sbxUsers.size() -1].Base_Username__c +'.'+ SANDBOX_NAME;
            System.assertEquals(sbxUser.Username, expectedUsername);
            System.assertEquals(sbxUser.Profile.Name, 'System Administrator');
        }
    }
}