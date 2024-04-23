@IsTest
public class HLA_LoanApplicationExpensesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationExpense__c> laexpList = new List<LoanApplicationExpense__c>{
      new LoanApplicationExpense__c()
    };
    // When
    HLA_ILoanApplicationExpenses laexp = HLA_LoanApplicationExpenses.newInstance(
      laexpList
    );

    // Then
    System.assert(laexp instanceof HLA_LoanApplicationExpenses);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationExpense__c> laexpList = new List<LoanApplicationExpense__c>{
      new LoanApplicationExpense__c(
        id = fflib_IDGenerator.generate(LoanApplicationExpense__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationExpenses laexp = HLA_LoanApplicationExpenses.newInstance(
      new Map<id, LoanApplicationExpense__c>(laexpList).keySet()
    );

    // Then
    System.assert(laexp instanceof HLA_LoanApplicationExpenses);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationExpense__c> laexpList = new List<LoanApplicationExpense__c>{
      new LoanApplicationExpense__c()
    };

    HLA_LoanApplicationExpenses laexp = (HLA_LoanApplicationExpenses) HLA_LoanApplicationExpenses.newInstance(
      laexpList
    );

    // When
    List<LoanApplicationExpense__c> returnedList = laexp.getLaeRecords();

    // Then
    Assert.areEqual(laexpList, returnedList);
  }
}
