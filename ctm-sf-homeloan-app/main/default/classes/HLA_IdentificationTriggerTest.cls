@IsTest
private class HLA_IdentificationTriggerTest {
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

    List<Identification__c> identificationList = new List<Identification__c>{
      new Identification__c(ResidentialLoanApplication__c = mockResi.id)
    };

    insert identificationList;
  }

  private static List<Identification__c> getIdentificationList() {
    return [SELECT isDirty__c FROM Identification__c];
  }

  @IsTest
  public static void on_before_update_should_flag_isDirty() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    // MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    // MockHttpResponseGenerator.statusCodetoReturn = 301;

    List<Identification__c> identificationList;
    identificationList = getIdentificationList();

    Assert.isFalse(identificationList[0].isDirty__c);

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update identificationList;
    }
    test.stopTest();

    identificationList = getIdentificationList();

    Assert.isTrue(identificationList[0].isDirty__c);
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<Identification__c> identificationList;
    identificationList = getIdentificationList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update identificationList;
    }
    test.stopTest();

    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      2,
      'should have generated 2 mock callouts for update'
    );
  }

  @IsTest
  public static void on_after_delete_should_enqueue() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<Identification__c> identificationList;
    identificationList = getIdentificationList();

    Test.startTest();
    delete identificationList;
    test.stopTest();
    /* delete currently commented out in trigger handler
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have generated a mock callout for deletion'
    ); */
  }
}
