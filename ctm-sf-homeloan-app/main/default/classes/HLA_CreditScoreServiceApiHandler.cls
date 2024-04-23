public inherited sharing class HLA_CreditScoreServiceApiHandler extends Api.Handler {
  //

  public HLA_CreditScoreServiceApiHandler() {
    super();
  }

  public override Api.Response doDelete(ApiRequestResolver resolver) {
    try {
      Nebula.logger.info('resolver ' + resolver);
      String externalIdFound = resolver.RequestUrlBody;
      if (
        externalIdFound.containsIgnoreCase('CreditScoreService') ||
        externalIdFound.length() == 0
      ) {
        IllegalArgumentException e = new IllegalArgumentException();
        e.setMessage('Invlaid URL Parameter');
        throw e;
      }
      Set<String> applicantExternalIds = new Set<String>{ externalIdFound };
      HLA_CreditScoreService.deleteCreditScoresUsingApplicantExternalIds(
        applicantExternalIds
      );
      Api.Response res = new Api.Response(JSON.serialize(applicantExternalIds));
      res.success = true;
      Nebula.logger.info('Response: ' + res);
      Nebula.Logger.saveLog();
      return res;
    } catch (Exception e) {
      Api.Response res = new Api.Response(e.getMessage());
      res.success = false;
      Nebula.logger.info('Response: ' + res);
      Nebula.Logger.saveLog();
      return res;
    }
  }
}
