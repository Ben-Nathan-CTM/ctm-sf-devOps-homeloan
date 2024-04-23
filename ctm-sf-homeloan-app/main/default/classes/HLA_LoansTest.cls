@IsTest
public class HLA_LoansTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<Loan__c> lList = new List<Loan__c>{ new Loan__c() };
    // When
    HLA_ILoans l = HLA_Loans.newInstance(lList);

    // Then
    System.assert(l instanceof HLA_Loans);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<Loan__c> lList = new List<Loan__c>{
      new Loan__c(id = fflib_IDGenerator.generate(Loan__c.sObjectType))
    };
    // When
    HLA_ILoans l = HLA_Loans.newInstance(new Map<id, Loan__c>(lList).keySet());

    // Then
    System.assert(l instanceof HLA_Loans);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<Loan__c> lList = new List<Loan__c>{ new Loan__c() };

    HLA_Loans l = (HLA_Loans) HLA_Loans.newInstance(lList);

    // When
    List<Loan__c> returnedList = l.getloanRecords();

    // Then
    Assert.areEqual(lList, returnedList);
  }
}
