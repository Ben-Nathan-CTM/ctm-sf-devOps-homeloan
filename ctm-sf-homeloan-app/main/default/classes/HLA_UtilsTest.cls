@IsTest
private class HLA_UtilsTest {
  @IsTest
  public static void should_flag_is_dirty() {
    // Given
    ResidentialLoanApplication__C testResi = new ResidentialLoanApplication__c();
    List<SObject> resiList = new List<SObject>{ testResi };
    // When

    HLA_Utils.flagEachRecordIsDirty(resiList, new Map<Id, SObject>());
    // Then

    Assert.areEqual(testResi.isDirty__c, true);
  }

  @IsTest
  public static void should_enqueue_updates() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);
    // Given
    ResidentialLoanApplication__C testResi = new ResidentialLoanApplication__c();
    List<SObject> resiList = new List<SObject>{ testResi };
    // When
    Test.startTest();
    HLA_Utils.enqueueApplicationUpdatesOrSubmitThem(
      resiList,
      TriggerOperation.AFTER_UPDATE
    );
    Assert.areEqual(Limits.GetQueueableJobs() > 0, true);
    Test.stopTest();
    // Then
  }
}
