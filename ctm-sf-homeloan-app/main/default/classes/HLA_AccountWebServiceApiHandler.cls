public with sharing class HLA_AccountWebServiceApiHandler extends Api.Handler {
  //

  public HLA_AccountWebServiceApiHandler() {
    super();
  }

  public override Api.Response doPut(ApiRequestResolver resolver) {
    try {
      Account acct = HLA_AccountService.parseAndCreateNewAccount(
        resolver.requestBody
      );
      Api.Response res = new Api.Response(acct.id);
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      return res;
    }
  }
}