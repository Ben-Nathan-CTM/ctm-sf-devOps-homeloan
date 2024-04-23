@IsTest
public class HLA_TriggerTest {
  // currently just for trigger coverage

  @TestSetup
  static void makeData() {
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
  }

  private static Account getAccount() {
    return [SELECT id, firstname, lastname, customerId__c FROM Account][0];
  }

  private static ResidentialLoanApplication__c getRLA() {
    return [
      SELECT id, Account__c, ApplicationId__c
      FROM ResidentialLoanApplication__c
    ][0];
  }

  @IsTest
  public static void HLA_voiTriggerTest() {
    // Given
    Account acc = getAccount();

    VOI__c voi = new VOI__c();
    voi.Account__c = acc.id;

    // When
    insert voi;
    // Then
  }

  @IsTest
  public static void HLA_ThirdPartyTriggerTest() {
    // Given

    ThirdParty__c tp = new ThirdParty__c();
    insert tp;

    // When

    // Then
  }

  @IsTest
  public static void HLA_CreditScoreTriggerTest() {
    // Given
    CreditScore__c cs = new CreditScore__c();
    insert cs;
    // When
    // Then
  }

  @IsTest
  public static void HLA_ResponsibleLendingTriggerTest() {
    // Given
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    Account acc = getAccount();

    ResidentialLoanApplication__c rla = getRLA();

    ResponsibleLending__c resp = new ResponsibleLending__c();
    resp.ResidentialLoanApplication__c = rla.id;
    insert resp;

    // When

    // Then
  }

  @IsTest
  public static void HLA_PropertyReportTriggerTest() {
    // Given
    // Id personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
    //   .get('PersonAccount')
    //   .getRecordTypeId();

    Account acc = getAccount();

    PropertyReport__c pr = new PropertyReport__c();
    pr.Account__c = acc.id;
    pr.Address__c = '80 jephson street';
    insert pr;

    // When

    // Then
  }

  @IsTest
  public static void HLA_OtherAddressTriggerTest() {
    // Given
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);

    ResidentialLoanApplication__c rla = getRLA();

    OtherAddress__c oa = new OtherAddress__c();
    oa.ResidentialLoanApplication__c = rla.id;
    insert oa;

    // When

    // Then
  }
}
