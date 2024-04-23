@IsTest
public class HLA_LoanApplicantExpensesTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicantExpense__c> laeList = new List<LoanApplicantExpense__c>{
      new LoanApplicantExpense__c()
    };
    // When
    HLA_ILoanApplicantExpenses lae = HLA_LoanApplicantExpenses.newInstance(
      laeList
    );

    // Then
    System.assert(lae instanceof HLA_LoanApplicantExpenses);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicantExpense__c> laeList = new List<LoanApplicantExpense__c>{
      new LoanApplicantExpense__c(
        id = fflib_IDGenerator.generate(LoanApplicantExpense__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicantExpenses lae = HLA_LoanApplicantExpenses.newInstance(
      new Map<id, LoanApplicantExpense__c>(laeList).keySet()
    );

    // Then
    System.assert(lae instanceof HLA_LoanApplicantExpenses);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicantExpense__c> laeList = new List<LoanApplicantExpense__c>{
      new LoanApplicantExpense__c()
    };

    HLA_LoanApplicantExpenses lae = (HLA_LoanApplicantExpenses) HLA_LoanApplicantExpenses.newInstance(
      laeList
    );

    // When
    List<LoanApplicantExpense__c> returnedList = lae.getlaexpRecords();

    // Then
    Assert.areEqual(laeList, returnedList);
  }
}
