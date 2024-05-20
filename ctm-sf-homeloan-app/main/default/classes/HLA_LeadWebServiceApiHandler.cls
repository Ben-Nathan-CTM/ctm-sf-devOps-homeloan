public with sharing class HLA_LeadWebServiceApiHandler extends Api.Handler {
  //

  public HLA_LeadWebServiceApiHandler() {
    super();
  }

  public override Api.Response doPut(ApiRequestResolver resolver) {
    try {
      Lead leadRecord = HLA_LeadService.parseAndCreateNewLead(
        resolver.requestBody
      );
      Api.Response res = new Api.Response(leadRecord.id);
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      return res;
    }
  }

  public override Api.Response doGet(ApiRequestResolver resolver) {
    try {
      String serializedAccounts = HLA_LeadService.getRecordsToReturn();
      Api.Response res = new Api.Response(serializedAccounts);
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      return res;
    }
  }
}