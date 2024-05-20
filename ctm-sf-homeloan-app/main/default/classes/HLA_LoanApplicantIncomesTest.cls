@IsTest
public class HLA_LoanApplicantIncomesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicantIncome__c> laiList = new List<LoanApplicantIncome__c>{
      new LoanApplicantIncome__c()
    };
    // When
    HLA_ILoanApplicantIncomes lai = HLA_LoanApplicantIncomes.newInstance(
      laiList
    );

    // Then
    System.assert(lai instanceof HLA_LoanApplicantIncomes);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicantIncome__c> laiList = new List<LoanApplicantIncome__c>{
      new LoanApplicantIncome__c(
        id = fflib_IDGenerator.generate(LoanApplicantIncome__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicantIncomes lai = HLA_LoanApplicantIncomes.newInstance(
      new Map<id, LoanApplicantIncome__c>(laiList).keySet()
    );

    // Then
    System.assert(lai instanceof HLA_LoanApplicantIncomes);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicantIncome__c> laiList = new List<LoanApplicantIncome__c>{
      new LoanApplicantIncome__c()
    };

    HLA_LoanApplicantIncomes lai = (HLA_LoanApplicantIncomes) HLA_LoanApplicantIncomes.newInstance(
      laiList
    );

    // When
    List<LoanApplicantIncome__c> returnedList = lai.getlaiRecords();

    // Then
    Assert.areEqual(laiList, returnedList);
  }
}
