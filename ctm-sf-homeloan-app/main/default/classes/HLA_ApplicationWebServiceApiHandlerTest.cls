@IsTest
public class HLA_ApplicationWebServiceApiHandlerTest {
  //

  @IsTest
  public static void should_call_do_delete() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();

    request.requestURI =
      '/api/HLA_ApplicationWebService/' +
      fflib_IDGenerator.generate(ResidentialLoanApplication__c.SObjectType);

    Account mockAccount = new Account(
      Id = fflib_IDGenerator.generate(Account.SObjectType)
    );

    HLA_IApplicationService mockApplicationServiceImp = (HLA_IApplicationService) mocks.mock(
      HLA_ApplicationServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    Application.Service.setMock(
      HLA_IApplicationService.class,
      mockApplicationServiceImp
    );

    HLA_ApplicationWebServiceApiHandler testHandler = new HLA_ApplicationWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doDelete(mockResolver);
    Test.stopTest();

    // Then

    System.AssertEquals(
      true,
      response.success,
      'call should have been a success'
    );
  }

  @IsTest
  public static void should_do_delete_and_throw_exception() {
    // given
    RestRequest request = new RestRequest();
    request.requestURI = '/api/HLA_ApplicationWebService/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_ApplicationWebServiceApiHandler testHandler = new HLA_ApplicationWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doDelete(mockResolver);
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
