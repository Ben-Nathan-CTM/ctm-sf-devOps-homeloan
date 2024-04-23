@IsTest
public class HLA_LeadWebServiceApiHandlerTest {
  @IsTest
  public static void should_call_do_put() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );

    Lead mockLead = new Lead(Id = fflib_IDGenerator.generate(Lead.SObjectType));

    HLA_ILeadService mockLeadService = (HLA_ILeadService) mocks.mock(
      HLA_LeadServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockLeadService.parseAndCreateNewLead(mockResolver.requestBody))
      .thenReturn(mockLead);
    mocks.StopStubbing();

    Application.Service.setMock(HLA_ILeadService.class, mockLeadService);

    HLA_LeadWebServiceApiHandler testHandler = new HLA_LeadWebServiceApiHandler();

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
    ((HLA_ILeadService) mocks.verify(mockLeadService, 1))
      .parseAndCreateNewLead(mockResolver.requestBody);
  }

  @IsTest
  public static void should_do_put_and_throw_exception() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );

    Lead mockLead = new Lead(Id = fflib_IDGenerator.generate(Lead.SObjectType));

    HLA_ILeadService mockLeadService = (HLA_ILeadService) mocks.mock(
      HLA_LeadServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockLeadService.parseAndCreateNewLead(mockResolver.requestBody))
      .thenThrow(new Application.ApplicationException('mock exception'));
    mocks.StopStubbing();

    Application.Service.setMock(HLA_ILeadService.class, mockLeadService);

    HLA_LeadWebServiceApiHandler testHandler = new HLA_LeadWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doPut(mockResolver);
    Test.stopTest();

    // Then

    System.AssertEquals(
      false,
      response.success,
      'call should have thrown exception'
    );

    System.AssertEquals(
      'mock exception',
      response.responseBody,
      'call should have thrown exception'
    );
    // service called once
    ((HLA_ILeadService) mocks.verify(mockLeadService, 1))
      .parseAndCreateNewLead(mockResolver.requestBody);
  }

  @IsTest
  public static void should_call_do_get() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );

    String mockLead = '{"customerId__c" : "1234", "lastname":"test"}';

    HLA_ILeadService mockLeadService = (HLA_ILeadService) mocks.mock(
      HLA_LeadServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockLeadService.getRecordsToReturn()).thenReturn(mockLead);
    mocks.StopStubbing();

    Application.Service.setMock(HLA_ILeadService.class, mockLeadService);

    HLA_LeadWebServiceApiHandler testHandler = new HLA_LeadWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doGet(mockResolver);
    Test.stopTest();

    // Then

    System.AssertEquals(
      true,
      response.success,
      'call should have been a success'
    );

    // service called once
    ((HLA_ILeadService) mocks.verify(mockLeadService, 1)).getRecordsToReturn();
  }

  @IsTest
  public static void should_do_get_and_throw_exception() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );

    Lead mockLead = new Lead(Id = fflib_IDGenerator.generate(Lead.SObjectType));

    HLA_ILeadService mockLeadService = (HLA_ILeadService) mocks.mock(
      HLA_LeadServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockLeadService.getRecordsToReturn())
      .thenThrow(new Application.ApplicationException('mock exception'));
    mocks.StopStubbing();

    Application.Service.setMock(HLA_ILeadService.class, mockLeadService);

    HLA_LeadWebServiceApiHandler testHandler = new HLA_LeadWebServiceApiHandler();

    // When

    Test.startTest();
    Api.Response response = testHandler.doGet(mockResolver);
    Test.stopTest();

    // Then

    System.AssertEquals(
      false,
      response.success,
      'call should have thrown exception'
    );

    System.AssertEquals(
      'mock exception',
      response.responseBody,
      'call should have thrown exception'
    );
    // service called once
    ((HLA_ILeadService) mocks.verify(mockLeadService, 1)).getRecordsToReturn();
  }
}