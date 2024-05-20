@IsTest
public class HLA_LoanContributionsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanContribution__c> lcList = new List<LoanContribution__c>{
      new LoanContribution__c()
    };
    // When
    HLA_ILoanContributions lc = HLA_LoanContributions.newInstance(lcList);

    // Then
    System.assert(lc instanceof HLA_LoanContributions);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanContribution__c> lcList = new List<LoanContribution__c>{
      new LoanContribution__c(
        id = fflib_IDGenerator.generate(LoanContribution__c.sObjectType)
      )
    };
    // When
    HLA_ILoanContributions lc = HLA_LoanContributions.newInstance(
      new Map<id, LoanContribution__c>(lcList).keySet()
    );

    // Then
    System.assert(lc instanceof HLA_LoanContributions);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanContribution__c> lcList = new List<LoanContribution__c>{
      new LoanContribution__c()
    };

    HLA_LoanContributions lc = (HLA_LoanContributions) HLA_LoanContributions.newInstance(
      lcList
    );

    // When
    List<LoanContribution__c> returnedList = lc.getlconRecords();

    // Then
    Assert.areEqual(lcList, returnedList);
  }
}
