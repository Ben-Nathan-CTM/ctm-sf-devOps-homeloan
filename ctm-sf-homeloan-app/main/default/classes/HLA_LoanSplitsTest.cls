@IsTest
public class HLA_LoanSplitsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanSplit__c> lsList = new List<LoanSplit__c>{ new LoanSplit__c() };
    // When
    HLA_ILoanSplits ls = HLA_LoanSplits.newInstance(lsList);

    // Then
    System.assert(ls instanceof HLA_LoanSplits);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanSplit__c> lsList = new List<LoanSplit__c>{
      new LoanSplit__c(
        id = fflib_IDGenerator.generate(LoanSplit__c.sObjectType)
      )
    };
    // When
    HLA_ILoanSplits ls = HLA_LoanSplits.newInstance(
      new Map<id, LoanSplit__c>(lsList).keySet()
    );

    // Then
    System.assert(ls instanceof HLA_LoanSplits);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanSplit__c> lsList = new List<LoanSplit__c>{ new LoanSplit__c() };

    HLA_LoanSplits ls = (HLA_LoanSplits) HLA_LoanSplits.newInstance(lsList);

    // When
    List<LoanSplit__c> returnedList = ls.getlsRecords();

    // Then
    Assert.areEqual(lsList, returnedList);
  }
}
