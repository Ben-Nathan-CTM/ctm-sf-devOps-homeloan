@IsTest
public class HLA_LoanScenarioWebServiceApiHandlerTest {
  //

  @IsTest
  public static void should_call_do_put() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );
    request.requestURI = '/api/HLA_LoanScenarioServiceWebService/';

    Loan_Scenario__c mockLoanScenario = new Loan_Scenario__c(
      Id = fflib_IDGenerator.generate(Loan_Scenario__c.SObjectType)
    );

    HLA_ILoanScenarioService mockLoanScenarioServiceImp = (HLA_ILoanScenarioService) mocks.mock(
      HLA_LoanScenarioServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(
        mockLoanScenarioServiceImp.parseAndCreateNewLoanScenario(
          mockResolver.requestBody
        )
      )
      .thenReturn(mockLoanScenario);
    mocks.StopStubbing();

    Application.Service.setMock(
      HLA_ILoanScenarioService.class,
      mockLoanScenarioServiceImp
    );

    HLA_LoanScenarioWebServiceApiHandler testHandler = new HLA_LoanScenarioWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doPut(mockResolver);
    Test.stopTest();

    // Then

    System.AssertEquals(
      true,
      response.success,
      'call should have been a success'
    );

    // service called once
    ((HLA_ILoanScenarioService) mocks.verify(mockLoanScenarioServiceImp, 1))
      .parseAndCreateNewLoanScenario(mockResolver.requestBody);
  }

  @IsTest
  public static void should_do_put_and_throw_exception() {
    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf('');
    request.requestURI = '/api/HLA_RelatedPartyWebService/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_LoanScenarioWebServiceApiHandler testHandler = new HLA_LoanScenarioWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doPut(mockResolver);
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