public with sharing class HLA_RelatedPartyService implements HLA_IRelatedPartyService {
  //

  private static HLA_IRelatedPartyService service() {
    return (HLA_IRelatedPartyService) Application.Service.newInstance(
      HLA_IRelatedPartyService.class
    );
  }

  public static RelatedParty__c parseAndCreateNewRelatedParty(
    String requestBody
  ) {
    return service().parseAndCreateNewRelatedParty(requestBody);
  }
}