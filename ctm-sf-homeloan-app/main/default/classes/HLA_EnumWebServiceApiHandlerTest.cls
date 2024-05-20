@IsTest
public class HLA_EnumWebServiceApiHandlerTest {
  //

  @IsTest
  public static void should_call_do_get() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );
    request.requestURI = '/api/HLA_EnumWebService/';

    Map<String, List<HLA_Enums.EnumItem>> mockEnumMap = new Map<String, List<HLA_Enums.EnumItem>>{
      'test' => new List<HLA_Enums.EnumItem>()
    };

    HLA_IEnumService mockEnumServiceImp = (HLA_IEnumService) mocks.mock(
      HLA_EnumServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockEnumServiceImp.getAllActiveEnumsMappedByType())
      .thenReturn(mockEnumMap);
    mocks.StopStubbing();

    Application.Service.setMock(HLA_IEnumService.class, mockEnumServiceImp);

    HLA_EnumWebServiceApiHandler testHandler = new HLA_EnumWebServiceApiHandler();

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
    ((HLA_IEnumService) mocks.verify(mockEnumServiceImp, 1))
      .getAllActiveEnumsMappedByType();
  }

  @IsTest
  public static void should_do_get_and_throw_exception() {
    fflib_ApexMocks mocks = new fflib_ApexMocks();

    // given
    RestRequest request = new RestRequest();
    request.requestBody = Blob.valueOf(
      '{"customerId__c" : "1234", "lastname":"test"}'
    );
    request.requestURI = '/api/HLA_EnumWebService/';

    Map<String, List<HLA_Enums.EnumItem>> mockEnumMap = new Map<String, List<HLA_Enums.EnumItem>>{
      'test' => new List<HLA_Enums.EnumItem>()
    };

    HLA_IEnumService mockEnumServiceImp = (HLA_IEnumService) mocks.mock(
      HLA_EnumServiceImp.class
    );

    ApiRequestResolver mockResolver = new ApiRequestResolver(request);

    mocks.StartStubbing();
    mocks.when(mockEnumServiceImp.getAllActiveEnumsMappedByType())
      .thenThrow(new TestException('mock exception'));
    mocks.StopStubbing();

    Application.Service.setMock(HLA_IEnumService.class, mockEnumServiceImp);

    HLA_EnumWebServiceApiHandler testHandler = new HLA_EnumWebServiceApiHandler();

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
    ((HLA_IEnumService) mocks.verify(mockEnumServiceImp, 1))
      .getAllActiveEnumsMappedByType();
  }

  public class TestException extends Exception {
  }
}