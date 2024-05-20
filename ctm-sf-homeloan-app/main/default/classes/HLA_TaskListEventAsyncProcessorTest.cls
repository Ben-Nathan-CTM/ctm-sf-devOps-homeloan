@IsTest
private class HLA_TaskListEventAsyncProcessorTest {
  //

  @IsTest
  static void test_inner_execute_once() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account mockAcct = new Account(
      Id = fflib_IDgenerator.generate(Account.sObjectType),
      name = 'Test',
      CustomerId__c = '123'
    );
    ResidentialLoanApplication__c mockLoanApp = new ResidentialLoanApplication__c(
      Id = fflib_IDgenerator.generate(
        ResidentialLoanApplication__c.sObjectType
      ),
      Account__c = mockAcct.id,
      ApplicationId__c = 'appid123'
    );
    mockLoanApp = (ResidentialLoanApplication__c) fflib_ApexMocksUtils.setReadOnlyFields(
      mockLoanApp,
      ResidentialLoanApplication__c.class,
      new Map<String, Object>{ 'Account__r' => mockAcct }
    );

    Task mockTask = new Task(
      Id = fflib_IDgenerator.generate(Task.sObjectType),
      whatId = mockLoanApp.id
    );

    List<ResidentialLoanApplication__c> listRLA = new List<ResidentialLoanApplication__c>{
      mockLoanApp
    };

    listRLA = (List<ResidentialLoanApplication__c>) fflib_ApexMocksUtils.makeRelationship(
      'ResidentialLoanApplication__c',
      'Task',
      listRLA,
      'whatId',
      new List<List<Task>>{ new List<Task>{ mockTask } }
    );

    Test.startTest();
    new HLA_TaskListEventAsyncProcessor().get(listRLA).kickoff();
    Test.stopTest();

    assert.areEqual(
      2,
      MockHttpResponseGenerator.calloutCounter,
      'should have made 2 callouts (token fecth + callout)'
    );
  }
}
