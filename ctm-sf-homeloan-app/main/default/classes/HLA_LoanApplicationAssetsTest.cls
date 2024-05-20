@IsTest
public class HLA_LoanApplicationAssetsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicationAsset__c> laaList = new List<LoanApplicationAsset__c>{
      new LoanApplicationAsset__c()
    };
    // When
    HLA_ILoanApplicationAssets la = HLA_LoanApplicationAssets.newInstance(
      laaList
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationAssets);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicationAsset__c> laaList = new List<LoanApplicationAsset__c>{
      new LoanApplicationAsset__c(
        id = fflib_IDGenerator.generate(LoanApplicationAsset__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicationAssets la = HLA_LoanApplicationAssets.newInstance(
      new Map<id, LoanApplicationAsset__c>(laaList).keySet()
    );

    // Then
    System.assert(la instanceof HLA_LoanApplicationAssets);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicationAsset__c> laaList = new List<LoanApplicationAsset__c>{
      new LoanApplicationAsset__c()
    };

    HLA_LoanApplicationAssets la = (HLA_LoanApplicationAssets) HLA_LoanApplicationAssets.newInstance(
      laaList
    );

    // When
    List<LoanApplicationAsset__c> returnedList = la.getlaaRecords();

    // Then
    Assert.areEqual(laaList, returnedList);
  }
}
