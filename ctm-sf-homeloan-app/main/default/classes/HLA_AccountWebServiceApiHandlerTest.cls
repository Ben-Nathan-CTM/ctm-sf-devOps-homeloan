@IsTest
public class HLA_AccountWebServiceApiHandlerTest {
  //

  @IsTest
  public static void should_call_do_put() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );
    request.requestURI = '/api/hla_accountwebservice/';

    Account mockAccount = new Account(
      Id = fflib_IDGenerator.generate(Account.SObjectType)
    );

    HLA_IAccountService mockAccountServiceImp = (HLA_IAccountService) mocks.mock(
      HLA_AccountServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(
        mockAccountServiceImp.parseAndCreateNewAccount(mockResolver.requestBody)
      )
      .thenReturn(mockAccount);
    mocks.StopStubbing();

    Application.Service.setMock(
      HLA_IAccountService.class,
      mockAccountServiceImp
    );

    HLA_AccountWebServiceApiHandler testHandler = new HLA_AccountWebServiceApiHandler();

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
    ((HLA_IAccountService) mocks.verify(mockAccountServiceImp, 1))
      .parseAndCreateNewAccount(mockResolver.requestBody);
  }

  @IsTest
  public static void should_do_put_and_throw_exception() {
    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf('{}');
    request.requestURI = '/api/hla_accountwebservice/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_AccountWebServiceApiHandler testHandler = new HLA_AccountWebServiceApiHandler();

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