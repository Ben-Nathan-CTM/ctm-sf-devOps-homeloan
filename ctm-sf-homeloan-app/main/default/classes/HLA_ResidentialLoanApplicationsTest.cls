@IsTest
public class HLA_ResidentialLoanApplicationsTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<ResidentialLoanApplication__c> rlaList = new List<ResidentialLoanApplication__c>{
      new ResidentialLoanApplication__c()
    };
    // When
    HLA_IResidentialLoanApplications rla = HLA_ResidentialLoanApplications.newInstance(
      rlaList
    );

    // Then
    System.assert(rla instanceof HLA_ResidentialLoanApplications);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<ResidentialLoanApplication__c> rlaList = new List<ResidentialLoanApplication__c>{
      new ResidentialLoanApplication__c(
        id = fflib_IDGenerator.generate(
          ResidentialLoanApplication__c.sObjectType
        )
      )
    };
    // When
    HLA_IResidentialLoanApplications rla = HLA_ResidentialLoanApplications.newInstance(
      new Map<id, ResidentialLoanApplication__c>(rlaList).keySet()
    );

    // Then
    System.assert(rla instanceof HLA_ResidentialLoanApplications);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<ResidentialLoanApplication__c> rlaList = new List<ResidentialLoanApplication__c>{
      new ResidentialLoanApplication__c()
    };

    HLA_ResidentialLoanApplications rla = (HLA_ResidentialLoanApplications) HLA_ResidentialLoanApplications.newInstance(
      rlaList
    );

    // When
    List<ResidentialLoanApplication__c> returnedList = rla.getRLARecords();

    // Then
    Assert.areEqual(rlaList, returnedList);
  }
}
