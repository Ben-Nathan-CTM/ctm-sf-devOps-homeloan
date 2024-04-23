@IsTest
private class HLA_LoanApplicantEmploymentTriggerTest {
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

    LoanApplicant__c testLaa = new LoanApplicant__c(name = 'test');
    insert testLaa;

    List<LoanApplicantEmployment__c> laaList = new List<LoanApplicantEmployment__c>{
      new LoanApplicantEmployment__c(
        name = 'Test',
        loanapplicant__c = testLaa.id,
        ResidentialLoanApplication__c = mockResi.id
      )
    };

    insert laaList;
  }

  private static List<LoanApplicantEmployment__c> getEmploymentList() {
    return [SELECT isDirty__c FROM LoanApplicantEmployment__c];
  }

  @IsTest
  public static void on_before_update_should_flag_isDirty() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantEmployment__c> empList;
    empList = getEmploymentList();

    Assert.isFalse(empList[0].isDirty__c);

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update empList;
    }
    test.stopTest();

    empList = getEmploymentList();

    Assert.isTrue(empList[0].isDirty__c);
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantEmployment__c> empList;
    empList = getEmploymentList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update empList;
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

    List<LoanApplicantEmployment__c> empList;
    empList = getEmploymentList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete empList;
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
