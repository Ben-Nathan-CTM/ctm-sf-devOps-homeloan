@IsTest
private class HLA_CreditScoreAssmntAsyncProccessorTest {
  @IsTest
  private static void test_inner_execute_once() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<Account> accts = new List<Account>();
    Account testAcc = new Account(
      firstname = 'test',
      lastname = 'acct',
      description = 'test desc',
      CustomerId__c = '1234',
      CreditScoreID__c = 'testID'
    );
    accts.add(testAcc);

    Test.startTest();
    new HLA_CreditScoreAssessmentAsyncProccessor().get(accts).kickoff();
    Test.stopTest();

    assert.areEqual(
      2,
      MockHttpResponseGenerator.calloutCounter,
      'should have made 2 callouts'
    );
  }

  @IsTest
  private static void test_inner_execute_multiple() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    List<Account> accts = new List<Account>();
    Account testAcc = new Account(
      firstname = 'test',
      lastname = 'acct',
      description = 'test desc',
      CustomerId__c = '1234',
      CreditScoreID__c = 'testID'
    );

    Account testAcc2 = new Account(
      firstname = 'test2',
      lastname = 'acc2t',
      description = 'test desc',
      CustomerId__c = '12345',
      CreditScoreID__c = 'testID2'
    );
    accts.add(testAcc);
    accts.add(testAcc2);

    Test.startTest();
    new HLA_CreditScoreAssessmentAsyncProccessor().get(accts).kickoff();
    Test.stopTest();

    assert.areEqual(
      3,
      MockHttpResponseGenerator.calloutCounter,
      'should have made 3 callouts'
    );
  }
}
