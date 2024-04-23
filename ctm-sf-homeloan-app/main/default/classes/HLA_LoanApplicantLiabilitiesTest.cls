@IsTest
public class HLA_LoanApplicantLiabilitiesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicantLiability__c> lalList = new List<LoanApplicantLiability__c>{
      new LoanApplicantLiability__c()
    };
    // When
    HLA_ILoanApplicantLiabilities lal = HLA_LoanApplicantLiabilities.newInstance(
      lalList
    );

    // Then
    System.assert(lal instanceof HLA_LoanApplicantLiabilities);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicantLiability__c> lalList = new List<LoanApplicantLiability__c>{
      new LoanApplicantLiability__c(
        id = fflib_IDGenerator.generate(LoanApplicantLiability__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicantLiabilities lal = HLA_LoanApplicantLiabilities.newInstance(
      new Map<id, LoanApplicantLiability__c>(lalList).keySet()
    );

    // Then
    System.assert(lal instanceof HLA_LoanApplicantLiabilities);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicantLiability__c> lalList = new List<LoanApplicantLiability__c>{
      new LoanApplicantLiability__c()
    };

    HLA_LoanApplicantLiabilities lal = (HLA_LoanApplicantLiabilities) HLA_LoanApplicantLiabilities.newInstance(
      lalList
    );

    // When
    List<LoanApplicantLiability__c> returnedList = lal.getlalRecords();

    // Then
    Assert.areEqual(lalList, returnedList);
  }
}
