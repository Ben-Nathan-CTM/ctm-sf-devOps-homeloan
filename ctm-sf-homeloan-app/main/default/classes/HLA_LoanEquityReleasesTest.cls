@IsTest
public class HLA_LoanEquityReleasesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanEquityRelease__c> lerList = new List<LoanEquityRelease__c>{
      new LoanEquityRelease__c()
    };
    // When
    HLA_ILoanEquityReleases ler = HLA_LoanEquityReleases.newInstance(lerList);

    // Then
    System.assert(ler instanceof HLA_LoanEquityReleases);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanEquityRelease__c> lerList = new List<LoanEquityRelease__c>{
      new LoanEquityRelease__c(
        id = fflib_IDGenerator.generate(LoanEquityRelease__c.sObjectType)
      )
    };
    // When
    HLA_ILoanEquityReleases ler = HLA_LoanEquityReleases.newInstance(
      new Map<id, LoanEquityRelease__c>(lerList).keySet()
    );

    // Then
    System.assert(ler instanceof HLA_LoanEquityReleases);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanEquityRelease__c> lerList = new List<LoanEquityRelease__c>{
      new LoanEquityRelease__c()
    };

    HLA_LoanEquityReleases ler = (HLA_LoanEquityReleases) HLA_LoanEquityReleases.newInstance(
      lerList
    );

    // When
    List<LoanEquityRelease__c> returnedList = ler.getlerRecords();

    // Then
    Assert.areEqual(lerList, returnedList);
  }
}
