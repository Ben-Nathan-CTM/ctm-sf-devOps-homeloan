@IsTest
public class HLA_LoanApplicantsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicant__c> laList = new List<LoanApplicant__c>{
      new LoanApplicant__c()
    };
    // When
    HLA_ILoanApplicants la = HLA_LoanApplicants.newInstance(laList);

    // Then
    System.assert(la instanceof HLA_LoanApplicants);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicant__c> laList = new List<LoanApplicant__c>{
      new LoanApplicant__c(
        id = fflib_IDGenerator.generate(LoanApplicant__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicants la = HLA_LoanApplicants.newInstance(
      new Map<id, LoanApplicant__c>(laList).keySet()
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicants);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicant__c> laList = new List<LoanApplicant__c>{
      new LoanApplicant__c()
    };

    HLA_LoanApplicants la = (HLA_LoanApplicants) HLA_LoanApplicants.newInstance(
      laList
    );

    // When
    List<LoanApplicant__c> returnedList = la.getlaRecords();

    // Then
    Assert.areEqual(laList, returnedList);
  }
}
