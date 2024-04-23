@IsTest
public class HLA_ResidentialLoanAppSelectorTest {
  // full name for class was too long

  @IsTest
  public static void should_return_new_instance() {
    // Given
    // When
    HLA_IResidentialLoanApplicationsSelector selector = HLA_ResidentialLoanApplicationsSelector.newInstance();
    // Then
    system.assert(selector instanceof HLA_ResidentialLoanApplicationsSelector);
  }

  @IsTest
  public static void should_getSObjectFieldList() {
    // Given
    // When
    List<Schema.SObjectField> fields = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .getSObjectFieldList();
    // Then
    system.assert(fields.contains(ResidentialLoanApplication__c.Id));
  }

  @IsTest
  public static void should_getSObjectType() {
    // Given
    // When
    Schema.SObjectType sObjType = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .getSObjectType();
    // Then
    system.assert(sObjType == ResidentialLoanApplication__c.sObjectType);
  }

  @IsTest
  public static void should_getOrderBy() {
    // Given
    // When
    String orderBy = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .getOrderBy();
    // Then
    system.assert(orderBy == 'Name');
  }

  @IsTest
  public static void should_setNewSortOrder() {
    // Given
    // When
    HLA_ResidentialLoanApplicationsSelector sel = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .setNewSortOrder('CreatedDate');
    // Then
    system.assert(sel.getOrderBy() == 'CreatedDate');
  }

  @IsTest
  public static void should_selectByIdWithTaskListWithLoanTracking() {
    // Given
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account acc = new Account();
    acc.firstname = 'test';
    acc.lastname = 'Account';
    acc.customerId__c = '123';
    insert acc;

    ResidentialLoanApplication__c rla = new ResidentialLoanApplication__c();
    rla.Account__c = acc.id;
    rla.ApplicationId__c = acc.id;

    insert rla;

    // When

    task testTask = new Task(LoanTrackingOrder__c = 1, whatId = rla.id);
    insert testTask;

    List<ResidentialLoanApplication__c> rlaList = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .selectByIdWithTaskListWithLoanTracking(new Set<Id>{ rla.id });
    // Then
    system.assert(rlaList[0].tasks.isEmpty() == false);
  }
}
