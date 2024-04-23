@IsTest
private class HLA_SNotesServiceTest {
  //

  // @IsTest
  // public static void should_launchSNoteScreenflow() {
  //   // Given

  //   Id testId = fflib_IDGenerator.generate(account.sobjecttype);
  //   String testString = 'testString';

  //   // When
  //   HLA_SNotesService.launchSNoteScreenflow(testId, testString);

  //   // Then
  // }

  @IsTest
  public static void should_getFilteredSNoteData() {
    // Given
    String filter = 'filter';

    Account testAcc = new Account(name = 'Test');
    insert testAcc;

    ContentVersion cv = new ContentVersion(
      Title = 'Test',
      PathOnClient = 'test.txt',
      versiondata = blob.valueOf('test'),
      relatedTab__c = filter
    );
    insert cv;

    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];
    //create ContentDocumentLink  record
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.LinkedEntityId = testAcc.id;
    cdl.ContentDocumentId = documents[0].Id;
    cdl.shareType = 'V';
    insert cdl;

    List<ContentDocumentLink> cdlList;

    // When
    Test.startTest();
    cdlList = HLA_SNotesService.getFilteredSNoteData(testAcc.id, filter);
    Test.stopTest();

    // Then
    Assert.isNotNull(
      cdlList,
      'should have returned the earlier inserted records'
    );

    Assert.isFalse(
      cdlList.isEmpty(),
      'should have returned the earlier inserted records'
    );
  }
}
