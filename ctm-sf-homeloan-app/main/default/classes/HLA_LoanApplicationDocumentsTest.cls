@IsTest
public class HLA_LoanApplicationDocumentsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationDocument__c> ladList = new List<LoanApplicationDocument__c>{
      new LoanApplicationDocument__c()
    };
    // When
    HLA_ILoanApplicationDocuments lad = HLA_LoanApplicationDocuments.newInstance(
      ladList
    );

    // Then
    System.assert(lad instanceof HLA_LoanApplicationDocuments);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationDocument__c> ladList = new List<LoanApplicationDocument__c>{
      new LoanApplicationDocument__c(
        id = fflib_IDGenerator.generate(LoanApplicationDocument__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationDocuments lad = HLA_LoanApplicationDocuments.newInstance(
      new Map<id, LoanApplicationDocument__c>(ladList).keySet()
    );

    // Then
    System.assert(lad instanceof HLA_LoanApplicationDocuments);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationDocument__c> ladList = new List<LoanApplicationDocument__c>{
      new LoanApplicationDocument__c()
    };

    HLA_LoanApplicationDocuments lad = (HLA_LoanApplicationDocuments) HLA_LoanApplicationDocuments.newInstance(
      ladList
    );

    // When
    List<LoanApplicationDocument__c> returnedList = lad.getladRecords();

    // Then
    Assert.areEqual(ladList, returnedList);
  }
}
