public inherited sharing class HLA_ProductsWebServiceApiHandler extends Api.Handler {
  private final String DELETE_SUCCESS = 'Successfully Deleted';

  public HLA_ProductsWebServiceApiHandler() {
    super();
  }

  public override Api.Response doDelete(ApiRequestResolver resolver) {
    try {
      Nebula.logger.info('resolver ' + resolver);
      if (resolver.RequestUrlBody.length() == 0) {
        IllegalArgumentException e = new IllegalArgumentException();
        e.setMessage('Invlaid URL Parameter');
        throw e;
      }

      Set<String> applicationExternalIds = new Set<String>{
        resolver.RequestUrlBody
      };
      List<Id> residentialLoanAppIds = getRLAIds(applicationExternalIds);
      if (residentialLoanAppIds.isEmpty()) {
        QueryException e = new QueryException();
        e.setMessage('No Application Found');
        throw e;
      }
      HLA_ProductRecommendations.deleteExistingProductRecommendations(
        residentialLoanAppIds
      );
      Api.Response res = new Api.Response(DELETE_SUCCESS);
      res.success = true;
      Nebula.logger.info('Response: ' + res);
      Nebula.Logger.saveLog();
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      res.success = false;
      Nebula.logger.error('Response: ' + res);
      Nebula.Logger.saveLog();
      return res;
    }
  }

  private List<Id> getRLAIds(Set<String> applicationExternalIds) {
    List<Id> rlaIds = new List<Id>();
    for (
      ResidentialLoanApplication__c rla : HLA_ResidentialLoanApplicationsSelector.newInstance()
        .selectByApplicationId(applicationExternalIds)
    ) {
      rlaIds.add(rla.id);
    }
    return rlaIds;
  }
}
