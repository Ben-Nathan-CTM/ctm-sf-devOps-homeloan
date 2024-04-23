public with sharing class HLA_RelatedPartyWebServiceApiHandler extends Api.Handler {
  //

  public HLA_RelatedPartyWebServiceApiHandler() {
    super();
  }

  public override Api.Response doPut(ApiRequestResolver resolver) {
    try {
      RelatedParty__c relatedPartyRecord = HLA_RelatedPartyService.parseAndCreateNewRelatedParty(
        resolver.requestBody
      );
      Api.Response res = new Api.Response(relatedPartyRecord.Id);
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      return res;
    }
  }
}