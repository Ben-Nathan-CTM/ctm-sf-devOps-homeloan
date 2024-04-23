public inherited sharing class HLA_LoanTrackingWebServiceApiHandler extends Api.Handler {
  //

  public HLA_LoanTrackingWebServiceApiHandler() {
    super();
  }

  public override Api.Response doGet(ApiRequestResolver resolver) {
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

      TasksSelector taskelector = (TasksSelector) TasksSelector.newinstance();
      List<Task> tasksFromApplication = (List<Task>) Database.query(
        taskelector.newQueryFactory()
          .setCondition(
            'whatid in (SELECT Id FROM residentialloanapplication__c WHERE applicationId__c IN :applicationExternalIds) AND LoanTrackingOrder__c != null'
          )
          .toSOQL()
      );

      if (tasksFromApplication.isEmpty()) {
        QueryException e = new QueryException();
        e.setMessage('No Tasks Found');
        throw e;
      }
      Api.Response res = new Api.Response(JSON.serialize(tasksFromApplication));
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
