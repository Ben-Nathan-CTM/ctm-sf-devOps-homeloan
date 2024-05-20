@IsTest
public class HLA_IdentificationTest {
  //

  @IsTest
  public static void should_return_new_instance_from_record_list() {
    // Given

    List<Identification__c> idList = new List<Identification__c>{
      new Identification__c()
    };
    // When
    HLA_IIdentification ids = HLA_Identification.newInstance(idList);

    // Then
    System.assert(ids instanceof HLA_Identification);
  }

  @IsTest
  public static void should_return_new_instance_from_IdSet() {
    // Given

    List<Identification__c> idList = new List<Identification__c>{
      new Identification__c(
        id = fflib_IDGenerator.generate(Identification__c.sObjectType)
      )
    };
    // When
    HLA_IIdentification ids = HLA_Identification.newInstance(
      new Map<id, Identification__c>(idList).keySet()
    );

    // Then
    System.assert(ids instanceof HLA_Identification);
  }

  @IsTest
  public static void should_return_record_list() {
    // Given

    List<Identification__c> idList = new List<Identification__c>{
      new Identification__c()
    };

    HLA_Identification ids = (HLA_Identification) HLA_Identification.newInstance(
      idList
    );

    // When
    List<Identification__c> returnedList = ids.getIdentificationRecords();

    // Then
    Assert.areEqual(idList, returnedList);
  }
}
