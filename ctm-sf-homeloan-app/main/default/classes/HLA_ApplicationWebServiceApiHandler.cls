public inherited sharing class HLA_ApplicationWebServiceApiHandler extends Api.Handler {
  //

  public HLA_ApplicationWebServiceApiHandler() {
    super();
  }

  public override Api.Response doDelete(ApiRequestResolver resolver) {
    try {
      List<id> applicationIds = new List<Id>{ (Id) resolver.RequestUrlBody };
      HLA_ApplicationService.deleteApplicationAndRelatedrecords(applicationIds);
      Api.Response res = new Api.Response('Successfully Deleted');
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      res.success = false;
      return res;
    }
  }
}
