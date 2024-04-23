@IsTest
public class HLA_LoanApplicationIncomeTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationIncome__c> laiList = new List<LoanApplicationIncome__c>{
      new LoanApplicationIncome__c()
    };
    // When
    HLA_ILoanApplicationIncome lai = HLA_LoanApplicationIncome.newInstance(
      laiList
    );

    // Then
    System.assert(lai instanceof HLA_LoanApplicationIncome);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationIncome__c> laiList = new List<LoanApplicationIncome__c>{
      new LoanApplicationIncome__c(
        id = fflib_IDGenerator.generate(LoanApplicationIncome__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationIncome lai = HLA_LoanApplicationIncome.newInstance(
      new Map<id, LoanApplicationIncome__c>(laiList).keySet()
    );

    // Then
    System.assert(lai instanceof HLA_LoanApplicationIncome);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationIncome__c> laiList = new List<LoanApplicationIncome__c>{
      new LoanApplicationIncome__c()
    };

    HLA_LoanApplicationIncome lai = (HLA_LoanApplicationIncome) HLA_LoanApplicationIncome.newInstance(
      laiList
    );

    // When
    List<LoanApplicationIncome__c> returnedList = lai.getLaiRecords();

    // Then
    Assert.areEqual(laiList, returnedList);
  }
}
