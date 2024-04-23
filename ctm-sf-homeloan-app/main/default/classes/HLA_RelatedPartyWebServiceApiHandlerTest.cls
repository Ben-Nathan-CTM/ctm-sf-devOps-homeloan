@IsTest
public class HLA_RelatedPartyWebServiceApiHandlerTest {
  //

  @IsTest
  public static void should_call_do_put() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );
    request.requestURI = '/api/HLA_RelatedPartyWebService/';

    RelatedParty__c mockRelatedParty = new RelatedParty__c(
      Id = fflib_IDGenerator.generate(RelatedParty__c.SObjectType)
    );

    HLA_IRelatedPartyService mockRelatedPartyServiceImp = (HLA_IRelatedPartyService) mocks.mock(
      HLA_RelatedPartyServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(
        mockRelatedPartyServiceImp.parseAndCreateNewRelatedParty(
          mockResolver.requestBody
        )
      )
      .thenReturn(mockRelatedParty);
    mocks.StopStubbing();

    Application.Service.setMock(
      HLA_IRelatedPartyService.class,
      mockRelatedPartyServiceImp
    );

    HLA_RelatedPartyWebServiceApiHandler testHandler = new HLA_RelatedPartyWebServiceApiHandler();

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
    ((HLA_IRelatedPartyService) mocks.verify(mockRelatedPartyServiceImp, 1))
      .parseAndCreateNewRelatedParty(mockResolver.requestBody);
  }

  @IsTest
  public static void should_do_put_and_throw_exception() {
    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf('{}');
    request.requestURI = '/api/HLA_RelatedPartyWebService/';

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);
    HLA_RelatedPartyWebServiceApiHandler testHandler = new HLA_RelatedPartyWebServiceApiHandler();

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