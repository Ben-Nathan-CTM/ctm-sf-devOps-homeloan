@IsTest
public class HLA_LoanTrackingWebServiceApiHandlerTest {
  //

  @TestSetup
  static void makeData() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    // When

    Test.setMock(HttpCalloutMock.class, mockHttp);
    Account testAcc = new Account(
      firstName = 'Test',
      lastName = 'Account',
      CustomerId__c = '123',
      recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
    );
    insert testAcc;
    ResidentialLoanApplication__c testRLA = new ResidentialLoanApplication__c(
      Account__c = testAcc.id,
      name = 'test RLA',
      ApplicationId__c = '123'
    );
    insert testRLA;

    Task testTask = new Task(whatid = testRLA.id, loantrackingorder__c = 1);
    insert testTask;
  }

  @IsTest
  public static void should_call_do_get() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    String rlaId = '123';
    request.requestURI = '/api/HLA_LoanTrackingWebService/' + rlaId;

    ITasksSelector mockTaskSelector = (ITasksSelector) mocks.mock(
      TasksSelector.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    Application.Selector.setMock(mockTaskSelector);

    HLA_LoanTrackingWebServiceApiHandler testHandler = new HLA_LoanTrackingWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doGet(mockResolver);
    Test.stopTest();
    system.debug(response);
    // Then

    Assert.areEqual(true, response.success, 'call should have been a success');
  }

  @IsTest
  public static void should_do_get_and_throw_exception_when_no_id_provided() {
    // given
    RestRequest request = new RestRequest();
    String rlaId = (String) fflib_IDGenerator.generate(
      ResidentialLoanApplication__c.SObjectType
    );
    request.requestURI = '/api/HLA_LoanTrackingWebService/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_LoanTrackingWebServiceApiHandler testHandler = new HLA_LoanTrackingWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doGet(mockResolver);
    Test.stopTest();

    system.debug(response);

    // Then

    System.AssertEquals(
      false,
      response.success,
      'call should have failed with an exception'
    );
  }
}
