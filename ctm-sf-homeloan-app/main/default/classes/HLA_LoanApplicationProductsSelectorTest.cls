@IsTest
private class HLA_LoanApplicationProductsSelectorTest {
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

  private static List<ResidentialLoanApplication__c> getrlaList() {
    return [SELECT Id, applicationId__c FROM ResidentialLoanApplication__c];
  }

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_ILoanApplicationProductsSelector selector = HLA_LoanApplicationProductsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_LoanApplicationProductsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = ((HLA_LoanApplicationProductsSelector) HLA_LoanApplicationProductsSelector.newInstance())
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(LoanApplicationProduct__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = ((HLA_LoanApplicationProductsSelector) HLA_LoanApplicationProductsSelector.newInstance())
      .getSObjectType();
    // Then
    system.assert(sObjType == LoanApplicationProduct__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = ((HLA_LoanApplicationProductsSelector) HLA_LoanApplicationProductsSelector.newInstance())
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_LoanApplicationProductsSelector sel = ((HLA_LoanApplicationProductsSelector) HLA_LoanApplicationProductsSelector.newInstance())
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_return_products_by_application_id() {
    // Given
    Id rlaId = getrlaList()[0].id;
    Set<Id> rlaIds = new Set<Id>{ rlaId };

    // When
    Test.startTest();

    List<LoanApplicationProduct__c> lapList = HLA_LoanApplicationProductsSelector.newInstance()
      .selectLoanApplicationProductsByApplicationId(rlaIds);

    Test.stopTest();

    // Then
    Assert.istrue(!lapList.IsEmpty(), 'should return results');
  }

  @IsTest
  public static void should_return_products_using_external_application_id() {
    // Given
    String applicationIdExternal = getrlaList()[0].applicationId__c;
    Set<String> applicationExternalIds = new Set<String>{
      applicationIdExternal
    };
    // When
    Test.startTest();

    List<LoanApplicationProduct__c> lapList = HLA_LoanApplicationProductsSelector.newInstance()
      .selectUsingApplicationExternalIdInWhereClause(applicationExternalIds);

    Test.stopTest();

    // Then
    Assert.istrue(!lapList.IsEmpty(), 'should return results');
  }
}
