public with sharing class HLA_LenderProductSearch {
  /**
   * getProductList Allows us to query the current products based
   * on the Account Name. It calls out to the endpoint, passing the
   * Name from the record.
   * @param  lender  the Account name
   * @return         return the latest products that belong to the lender
   */
  @AuraEnabled(cacheable=true)
  public static String getProductList(String lender) {
    Body reqBody = new Body();
    reqBody.p_lendername = lender;

    String calloutURL = Label.LenderProductEndpoint;

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(calloutURL);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setBody(JSON.serialize(reqBody));

    String exceptionErrorMessage;
    HttpResponse res = new HttpResponse();
    try {
      res = System.Test.isRunningTest()
        ? new MockHttpResponseGenerator().respond(req)
        : h.send(req);
    } catch (Exception e) {
      exceptionErrorMessage = e.getMessage();
      System.debug('exception =' + exceptionErrorMessage);
    }

    return res.getBody();
  }

  private class Body {
    public string p_lendername;
  }
}
