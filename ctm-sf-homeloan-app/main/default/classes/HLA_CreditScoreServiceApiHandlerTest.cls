@IsTest
public class HLA_CreditScoreServiceApiHandlerTest {
  //

  //   @TestSetup
  //   static void makeData() {
  //     MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
  //     // When

  //     Test.setMock(HttpCalloutMock.class, mockHttp);
  //     Account testAcc = new Account(
  //       firstName = 'Test',
  //       lastName = 'Account',
  //       CustomerId__c = '123',
  //       recordtypeId = HLA_ResidentialLoanApplications.personAccountRTId
  //     );
  //     insert testAcc;
  //     ResidentialLoanApplication__c testRLA = new ResidentialLoanApplication__c(
  //       Account__c = testAcc.id,
  //       name = 'test RLA',
  //       ApplicationId__c = '123'
  //     );
  //     insert testRLA;

  //     Task testTask = new Task(whatid = testRLA.id, loantrackingorder__c = 1);
  //     insert testTask;
  //   }

  @IsTest
  public static void should_call_do_delete() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    String rlaId = '123';
    request.requestURI = '/api/HLA_LoanTrackingWebService/' + rlaId;

    HLA_ICreditScoreService mockService = (HLA_ICreditScoreService) mocks.mock(
      HLA_CreditScoreServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    Application.Service.setMock(HLA_ICreditScoreService.class, mockService);

    HLA_CreditScoreServiceApiHandler testHandler = new HLA_CreditScoreServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doDelete(mockResolver);
    Test.stopTest();
    system.debug(response);
    // Then

    Assert.areEqual(true, response.success, 'call should have been a success');
  }

  @IsTest
  public static void should_do_delete_and_throw_exception_when_no_id_provided() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();

    request.requestURI = '/api/HLA_LoanTrackingWebService/';

    HLA_ICreditScoreService mockService = (HLA_ICreditScoreService) mocks.mock(
      HLA_CreditScoreServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    Application.Service.setMock(HLA_ICreditScoreService.class, mockService);

    HLA_CreditScoreServiceApiHandler testHandler = new HLA_CreditScoreServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doDelete(mockResolver);
    Test.stopTest();
    system.debug(response);
    // Then

    Assert.areEqual(false, response.success, 'call should have been a failure');
  }
}
