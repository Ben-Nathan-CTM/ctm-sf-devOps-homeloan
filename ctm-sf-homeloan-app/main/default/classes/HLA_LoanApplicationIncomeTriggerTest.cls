@IsTest
private class HLA_LoanApplicationIncomeTriggerTest {
  @TestSetup
  static void makeData() {
    System.runAs(new User(Id = UserInfo.getUserId())) {
      PermissionSet ps = new PermissionSet(
        Name = 'CustomPermissionEnabled',
        Label = 'Custom Permisison Enabled'
      );
      insert ps;

      SetupEntityAccess sea = new SetupEntityAccess(
        ParentId = ps.Id,
        SetupEntityId = [
          SELECT Id
          FROM CustomPermission
          WHERE DeveloperName = 'CanSubmitApplicationChanges'
          LIMIT 1
        ]
        .Id
      );

      PermissionSetAssignment psa = new PermissionSetAssignment(
        AssigneeId = UserInfo.getUserId(),
        PermissionSetId = ps.Id
      );

      insert new List<SObject>{ sea, psa };
    }

    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    insert testAcc;
    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );
    insert mockResi;

    LoanApplicationIncome__c mockLAI = new LoanApplicationIncome__c(
      residentialLoanApplication__c = mockResi.id
    );
    insert mockLAI;
  }

  private static List<LoanApplicationIncome__c> getLAIList() {
    return [
      SELECT Id, residentialLoanApplication__c
      FROM LoanApplicationIncome__c
    ];
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicationIncome__c> laiList = getLAIList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update laiList;
    }
    test.stopTest();
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have generated 2 mock callout for update'
    );
  }

  /* delete currently commented out in trigger handler
  @IsTest
  public static void on_after_delete_should_enqueue() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicationIncome__c> laiList = getLAIList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete laiList;
    }
    test.stopTest();

    
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have generated a mock callout for deletion'
    ); 
  }*/
}
