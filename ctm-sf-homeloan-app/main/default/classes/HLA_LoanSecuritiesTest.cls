@IsTest
public class HLA_LoanSecuritiesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanSecurity__c> lsList = new List<LoanSecurity__c>{
      new LoanSecurity__c()
    };
    // When
    HLA_ILoanSecurities ls = HLA_LoanSecurities.newInstance(lsList);

    // Then
    System.assert(ls instanceof HLA_LoanSecurities);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanSecurity__c> lsList = new List<LoanSecurity__c>{
      new LoanSecurity__c(
        id = fflib_IDGenerator.generate(LoanSecurity__c.sObjectType)
      )
    };
    // When
    HLA_ILoanSecurities ls = HLA_LoanSecurities.newInstance(
      new Map<id, LoanSecurity__c>(lsList).keySet()
    );

    // Then
    System.assert(ls instanceof HLA_LoanSecurities);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanSecurity__c> lsList = new List<LoanSecurity__c>{
      new LoanSecurity__c()
    };

    HLA_LoanSecurities ls = (HLA_LoanSecurities) HLA_LoanSecurities.newInstance(
      lsList
    );

    // When
    List<LoanSecurity__c> returnedList = ls.getlsRecords();

    // Then
    Assert.areEqual(lsList, returnedList);
  }
}
