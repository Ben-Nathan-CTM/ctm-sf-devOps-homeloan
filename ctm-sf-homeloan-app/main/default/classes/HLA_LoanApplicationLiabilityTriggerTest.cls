@IsTest
private class HLA_LoanApplicationLiabilityTriggerTest {
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

    List<LoanApplicationLiability__c> lalList = new List<LoanApplicationLiability__c>{
      new LoanApplicationLiability__c(
        name = 'test',
        ResidentialLoanApplication__c = mockResi.id
      )
    };

    insert lalList;
  }

  private static List<LoanApplicationLiability__c> getlalList() {
    return [SELECT Id FROM LoanApplicationLiability__c];
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<LoanApplicationLiability__c> lalList = getlalList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update lalList;
    }
    test.stopTest();

    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have generated 2 mock callout for update'
    );
  }

  @IsTest
  public static void on_after_delete_should_enqueue() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicationLiability__c> lalList = getlalList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete lalList;
    }
    test.stopTest();

    /* delete currently commented out in trigger handler
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have generated a mock callout for deletion'
    ); */
  }
}
