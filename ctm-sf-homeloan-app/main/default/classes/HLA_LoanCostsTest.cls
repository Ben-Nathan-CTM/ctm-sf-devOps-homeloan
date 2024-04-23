@IsTest
public class HLA_LoanCostsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanCost__c> lcList = new List<LoanCost__c>{ new LoanCost__c() };
    // When
    HLA_ILoanCosts lc = HLA_LoanCosts.newInstance(lcList);

    // Then
    System.assert(lc instanceof HLA_LoanCosts);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanCost__c> lcList = new List<LoanCost__c>{
      new LoanCost__c(id = fflib_IDGenerator.generate(LoanCost__c.sObjectType))
    };
    // When
    HLA_ILoanCosts lc = HLA_LoanCosts.newInstance(
      new Map<id, LoanCost__c>(lcList).keySet()
    );

    // Then
    System.assert(lc instanceof HLA_LoanCosts);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanCost__c> lcList = new List<LoanCost__c>{ new LoanCost__c() };

    HLA_LoanCosts lc = (HLA_LoanCosts) HLA_LoanCosts.newInstance(lcList);

    // When
    List<LoanCost__c> returnedList = lc.getlcRecords();

    // Then
    Assert.areEqual(lcList, returnedList);
  }
}
