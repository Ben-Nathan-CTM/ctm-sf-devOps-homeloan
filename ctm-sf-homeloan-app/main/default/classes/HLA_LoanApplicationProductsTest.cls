@IsTest
public class HLA_LoanApplicationProductsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationProduct__c> lapList = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c()
    };
    // When
    HLA_ILoanApplicationProducts la = HLA_LoanApplicationProducts.newInstance(
      lapList
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationProducts);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationProduct__c> lapList = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c(
        id = fflib_IDGenerator.generate(LoanApplicationProduct__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationProducts la = HLA_LoanApplicationProducts.newInstance(
      new Map<id, LoanApplicationProduct__c>(lapList).keySet()
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationProducts);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationProduct__c> lapList = new List<LoanApplicationProduct__c>{
      new LoanApplicationProduct__c()
    };

    HLA_LoanApplicationProducts la = (HLA_LoanApplicationProducts) HLA_LoanApplicationProducts.newInstance(
      lapList
    );

    // When
    List<LoanApplicationProduct__c> returnedList = la.getlapRecords();

    // Then
    Assert.areEqual(lapList, returnedList);
  }
}
