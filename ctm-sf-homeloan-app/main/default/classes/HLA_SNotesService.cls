public with sharing class HLA_SNotesService {
  //

  @AuraEnabled(cacheable=true)
  public static List<ContentDocumentLink> getFilteredSNoteData(
    String relatedRecordId,
    String filter
  ) {
    return [
      SELECT
        Id,
        ContentDocument.Title,
        ContentDocument.createdDate,
        ContentDocument.LatestPublishedVersion.textpreview
      FROM ContentDocumentLink
      WHERE
        linkedentityId = :relatedRecordId
        AND ContentDocument.LatestPublishedVersion.relatedTab__c = :filter
      ORDER BY ContentDocument.createdDate DESC
    ];
  }
}
