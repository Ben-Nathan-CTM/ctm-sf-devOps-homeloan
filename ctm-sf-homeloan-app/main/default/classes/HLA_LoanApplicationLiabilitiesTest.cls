@IsTest
public class HLA_LoanApplicationLiabilitiesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationLiability__c> lalList = new List<LoanApplicationLiability__c>{
      new LoanApplicationLiability__c()
    };
    // When
    HLA_ILoanApplicationLiabilities la = HLA_LoanApplicationLiabilities.newInstance(
      lalList
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationLiabilities);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationLiability__c> lalList = new List<LoanApplicationLiability__c>{
      new LoanApplicationLiability__c(
        id = fflib_IDGenerator.generate(LoanApplicationLiability__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationLiabilities la = HLA_LoanApplicationLiabilities.newInstance(
      new Map<id, LoanApplicationLiability__c>(lalList).keySet()
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationLiabilities);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationLiability__c> lalList = new List<LoanApplicationLiability__c>{
      new LoanApplicationLiability__c()
    };

    HLA_LoanApplicationLiabilities la = (HLA_LoanApplicationLiabilities) HLA_LoanApplicationLiabilities.newInstance(
      lalList
    );

    // When
    List<LoanApplicationLiability__c> returnedList = la.getlalRecords();

    // Then
    Assert.areEqual(lalList, returnedList);
  }
}
