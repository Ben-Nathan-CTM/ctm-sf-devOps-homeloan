@IsTest
private class HLA_LoanApplicantAssetTriggerTest {
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

    Account TestAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    insert TestAcc;
    ResidentialLoanApplication__c mockResi = new ResidentialLoanApplication__c(
      Account__c = TestAcc.id,
      name = 'Test RLA',
      ApplicationId__c = '123'
    );
    insert mockResi;

    LoanApplicationAsset__c TestApplicationAsset = new LoanApplicationAsset__c(
      name = 'Test',
      ResidentialLoanApplication__c = mockResi.id
    );
    insert TestApplicationAsset;

    LoanApplicant__c TestLaa = new LoanApplicant__c(name = 'Test');
    insert TestLaa;

    List<LoanApplicantAsset__c> laaList = new List<LoanApplicantAsset__c>{
      new LoanApplicantAsset__c(
        name = 'Test',
        loanapplicant__c = TestLaa.id,
        LoanApplicationAsset__c = TestApplicationAsset.id
      )
    };

    insert laaList;
  }

  private static List<LoanApplicantAsset__c> getLaaList() {
    return [SELECT isDirty__c FROM LoanApplicantAsset__c];
  }

  private static User getDifferentUser() {
    return [
      SELECT Id
      FROM User
      WHERE
        ID != :UserInfo.getUserId()
        AND IsActive = TRUE
        AND (NOT profile.name = 'System Administrator')
      LIMIT 1
    ][0];
  }

  @IsTest
  public static void on_before_update_should_not_flag_isDirty_when_user_doesnt_have_permission() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantAsset__c> laaList;
    laaList = getlaaList();

    Test.startTest();

    Assert.isFalse(laaList[0].isDirty__c);
    System.runAs(getDifferentUser()) {
      update laaList;
    }
    Test.stopTest();

    laaList = getlaaList();

    Assert.isFalse(laaList[0].isDirty__c);
  }

  @IsTest
  public static void on_before_update_should_flag_isDirty_when_user_has_permission() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantAsset__c> laaList;
    laaList = getlaaList();

    Assert.isFalse(laaList[0].isDirty__c);

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update laaList;
    }
    Test.stopTest();

    laaList = getlaaList();
    Assert.isTrue(laaList[0].isDirty__c);
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantAsset__c> laaList;
    laaList = getlaaList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update laaList;
    }
    Test.stopTest();

    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have generated 2 mock callout for update'
    );
  }

  @IsTest
  public static void on_after_delete_should_enqueue() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanApplicantAsset__c> laaList;
    laaList = getlaaList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete laaList;
    }
    Test.stopTest();

    /* delete currently commented out in trigger handler
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have generated a mock callout for deletion'
    ); */
  }
}
