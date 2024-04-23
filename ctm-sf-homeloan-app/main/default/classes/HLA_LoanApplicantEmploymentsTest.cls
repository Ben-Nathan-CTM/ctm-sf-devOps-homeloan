@IsTest
public class HLA_LoanApplicantEmploymentsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicantEmployment__c> laeList = new List<LoanApplicantEmployment__c>{
      new LoanApplicantEmployment__c()
    };
    // When
    HLA_ILoanApplicantEmployments lae = HLA_LoanApplicantEmployments.newInstance(
      laeList
    );

    // Then
    System.assert(lae instanceof HLA_LoanApplicantEmployments);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicantEmployment__c> laeList = new List<LoanApplicantEmployment__c>{
      new LoanApplicantEmployment__c(
        id = fflib_IDGenerator.generate(LoanApplicantEmployment__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicantEmployments lae = HLA_LoanApplicantEmployments.newInstance(
      new Map<id, LoanApplicantEmployment__c>(laeList).keySet()
    );

    // Then
    System.assert(lae instanceof HLA_LoanApplicantEmployments);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicantEmployment__c> laeList = new List<LoanApplicantEmployment__c>{
      new LoanApplicantEmployment__c()
    };

    HLA_LoanApplicantEmployments lae = (HLA_LoanApplicantEmployments) HLA_LoanApplicantEmployments.newInstance(
      laeList
    );

    // When
    List<LoanApplicantEmployment__c> returnedList = lae.getlaeRecords();

    // Then
    Assert.areEqual(laeList, returnedList);
  }
}
