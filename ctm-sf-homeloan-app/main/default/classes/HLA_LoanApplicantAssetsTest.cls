@IsTest
public class HLA_LoanApplicantAssetsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<LoanApplicantAsset__c> laList = new List<LoanApplicantAsset__c>{
      new LoanApplicantAsset__c()
    };
    // When
    HLA_ILoanApplicantAssets laa = HLA_LoanApplicantAssets.newInstance(laList);

    // Then
    System.assert(laa instanceof HLA_LoanApplicantAssets);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<LoanApplicantAsset__c> laList = new List<LoanApplicantAsset__c>{
      new LoanApplicantAsset__c(
        id = fflib_IDGenerator.generate(LoanApplicantAsset__c.sObjectType)
      )
    };
    // When
    HLA_ILoanApplicantAssets laa = HLA_LoanApplicantAssets.newInstance(
      new Map<id, LoanApplicantAsset__c>(laList).keySet()
    );

    // Then
    System.assert(laa instanceof HLA_LoanApplicantAssets);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<LoanApplicantAsset__c> laList = new List<LoanApplicantAsset__c>{
      new LoanApplicantAsset__c()
    };

    HLA_LoanApplicantAssets laa = (HLA_LoanApplicantAssets) HLA_LoanApplicantAssets.newInstance(
      laList
    );

    // When
    List<LoanApplicantAsset__c> returnedList = laa.getlaaRecords();

    // Then
    Assert.areEqual(laList, returnedList);
  }
}
