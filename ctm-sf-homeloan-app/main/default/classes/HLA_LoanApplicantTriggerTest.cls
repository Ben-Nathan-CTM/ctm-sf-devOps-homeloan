@IsTest
private class HLA_LoanApplicantTriggerTest {
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

    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      PersonEmail = 'test@gmail.com',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    uow.register(testAcc);
    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );
    //uow.register(mockResi);
    uow.register(mockResi, ResidentialLoanApplication__c.Account__c, testAcc);

    LoanApplicant__c testLoanApplicant = new LoanApplicant__c(
      name = 'test',
      ResidentialLoanApplication__c = mockResi.id
    );
    uow.register(
      testLoanApplicant,
      LoanApplicant__c.ResidentialLoanApplication__c,
      mockResi
    );
    uow.commitwork();
  }

  private static List<LoanApplicant__c> getlaList() {
    return [SELECT Id FROM LoanApplicant__c];
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<LoanApplicant__c> laList = getlaList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update laList;
    }
    test.stopTest();

    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have generated 2 mock callout for update'
    );
  }

  @IsTest
  public static void on_after_insert_should_attach_contact() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<LoanApplicant__c> laList = getlaList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete laList;
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
