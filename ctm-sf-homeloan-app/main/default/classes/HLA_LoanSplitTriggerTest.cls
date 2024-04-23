@IsTest
private class HLA_LoanSplitTriggerTest {
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

    LoanSplit__c mockLS = new LoanSplit__c(
      residentialLoanApplication__c = mockResi.id
    );
    insert mockLS;
  }

  private static List<LoanSplit__c> getlsList() {
    return [SELECT Id, residentialLoanApplication__c FROM LoanSplit__c];
  }

  @IsTest
  public static void on_after_update_should_submit_updates() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

    List<LoanSplit__c> lsList = getlsList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      update lsList;
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

    List<LoanSplit__c> lsList = getlsList();

    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      delete lsList;
    }
    test.stopTest();

    
    Assert.areEqual(
      MockHttpResponseGenerator.calloutCounter,
      1,
      'should have generated a mock callout for deletion'
    ); 
  }*/
}
