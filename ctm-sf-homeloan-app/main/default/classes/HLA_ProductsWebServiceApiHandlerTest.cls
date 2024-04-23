@IsTest
public class HLA_ProductsWebServiceApiHandlerTest {
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

    LoanApplicationProduct__c originalLAP = new LoanApplicationProduct__c(
      ResidentialLoanApplication__c = testRLA.id
    );
    insert originalLAP;
  }

  @IsTest
  public static void should_call_do_delete() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    String rlaId = '123';
    request.requestURI = '/api/HLA_ProductsWebService/' + rlaId;

    List<LoanApplicationProduct__c> mockProducts = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c(
        Id = fflib_IDGenerator.generate(LoanApplicationProduct__c.SObjectType)
      )
    };

    HLA_ILoanApplicationProductsSelector mockProductsSelector = (HLA_ILoanApplicationProductsSelector) mocks.mock(
      HLA_LoanApplicationProductsSelector.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    Application.Selector.setMock(mockProductsSelector);

    HLA_ProductsWebServiceApiHandler testHandler = new HLA_ProductsWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doDelete(mockResolver);
    Test.stopTest();

    // Then

    Assert.areEqual(true, response.success, 'call should have been a success');
  }

  @IsTest
  public static void should_do_delete_and_throw_exception_when_no_id_provided() {
    // given
    RestRequest request = new RestRequest();

    request.requestURI = '/api/HLA_ProductsWebService/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_ProductsWebServiceApiHandler testHandler = new HLA_ProductsWebServiceApiHandler();

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
