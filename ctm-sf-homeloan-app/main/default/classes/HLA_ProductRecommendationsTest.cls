@IsTest
public class HLA_ProductRecommendationsTest {
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

  private static List<ResidentialLoanApplication__c> getrlaList() {
    return [SELECT Id FROM ResidentialLoanApplication__c];
  }

  private static Id getrlaId() {
    return [SELECT Id FROM ResidentialLoanApplication__c].id;
  }

  @IsTest
  public static void should_request_new_products_after_deleting_existing() {
    // Given
    Id rlaId = getrlaId();
    List<Id> residentialLoanAppIds = new List<Id>{ rlaId };
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    // When

    Test.setMock(HttpCalloutMock.class, mockHttp);
    Test.startTest();
    HLA_ProductRecommendations.requestNewProducts(residentialLoanAppIds);
    Test.stopTest();
    // Then
    Assert.isTrue(
      [SELECT id FROM LoanApplicationProduct__c].isEmpty(),
      'should have deleted existing products'
    );
  }

  @IsTest
  public static void should_return_mock_http_above_300_response() {
    // Given
    Id rlaId = getrlaId();
    List<Id> residentialLoanAppIds = new List<Id>{ rlaId };
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    MockHttpResponseGenerator.statusCodetoReturn = 301;
    // When

    Test.setMock(HttpCalloutMock.class, mockHttp);
    Test.startTest();
    HLA_ProductRecommendations.requestNewProducts(residentialLoanAppIds);
    Test.stopTest();
    // Then
    Assert.isTrue(
      [SELECT id FROM LoanApplicationProduct__c].isEmpty(),
      'should have deleted existing products'
    );
  }

  @IsTest
  public static void should_getApplicationRelatedLoanProducts() {
    // Given
    Id rlaId = getrlaId();
    List<LoanApplicationProduct__c> returnedList;
    String fieldToOrderBy = 'Name';

    // When
    Test.startTest();
    returnedList = HLA_ProductRecommendations.getApplicationRelatedLoanProducts(
      rlaId,
      fieldToOrderBy
    );
    Test.stopTest();
    // Then
    Assert.isFalse(returnedList.isEmpty(), 'should have returned products');
  }
}
