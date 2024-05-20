public inherited sharing class HLA_EnumWebServiceApiHandler extends Api.Handler {
  //

  public HLA_EnumWebServiceApiHandler() {
    super();
  }

  public override Api.Response doGet(ApiRequestResolver resolver) {
    try {
      Map<String, List<HLA_Enums.EnumItem>> enumsByType = HLA_EnumService.getAllActiveEnumsMappedByType();
      Api.Response res = new Api.Response(JSON.serialize(enumsByType));
      res.success = true;
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      res.success = false;
      return res;
    }
  }
}
