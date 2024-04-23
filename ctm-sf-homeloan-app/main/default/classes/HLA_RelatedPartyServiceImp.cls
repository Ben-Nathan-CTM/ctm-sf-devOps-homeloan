public with sharing class HLA_RelatedPartyServiceImp implements HLA_IRelatedPartyService {
  //

  public RelatedParty__c parseAndCreateNewRelatedParty(String requestBody) {
    RelatedParty__c relatedPartyRecord = (RelatedParty__c) JSON.deserialize(
      requestBody,
      RelatedParty__c.class
    );

    insert relatedPartyRecord;

    return relatedPartyRecord;
  }
}