public with sharing class HLA_TaskListEventAsyncProcessor extends AsyncProcessor implements Database.AllowsCallouts {
  //

  protected override void innerExecute(List<SObject> records) {
    // TODO: might work better for SOC to put this logic into the TaskListEventService
    String endpoint = 'HLA_Loantracking';
    String authorizationSystem = 'Auth0';

    CTM_Environment_Config__mdt ctmEnvConfig = GlobalUtilities.CTMEnvConfig;
    CTM_Endpoint__mdt ctmEndpoint = GlobalUtilities.CTMEndpoints.get(endpoint);
    String accessToken = GlobalUtilities.getEndpointAccessToken(
      endpoint,
      authorizationSystem
    );

    while (
      records.isEmpty() == false &&
      Limits.getCallouts() < Limits.getLimitCallouts()
    ) {
      ResidentialLoanApplication__c rla = (ResidentialLoanApplication__c) records.remove(
        0
      );
      Nebula.Logger.debug('ResidentialLoanApplication__c', rla);

      if (
        rla.ApplicationId__c != null &&
        rla.Account__r.customerId__c != null
      ) {
        // create JSON payload
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey', ctmEnvConfig.ApiKey__c);
        gen.writeStringField('flowName', 'application');
        gen.writeNumberField('processOperation', 2);
        gen.writeNumberField('dataVersion', 0);
        gen.writeStringField('dataOwnerUserId', rla.Account__r.customerId__c);
        gen.writeStringField('applicationId', rla.ApplicationId__c);
        gen.writeFieldName('clientApplicationChanges');
        gen.writeStartObject();
        gen.writeFieldName('calculated');
        gen.writeStartObject();
        gen.writeFieldName('tracking');
        gen.writeObject(rla.tasks);
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();

        String payloadJSON = gen.getAsString();
        Nebula.Logger.info('payloadJSON = ' + payloadJSON);

        HttpRequest req = GlobalUtilities.createHttpRequest(
          payloadJSON,
          ctmEnvConfig,
          ctmEndpoint,
          accessToken
        );
        Nebula.Logger.info('req = ' + req);
        // temp while m2m not deployed for /api/v1/lending/processing/process
        req.setHeader('Authorization', '');

        Http h = new Http();
        String exceptionErrorMessage;
        HttpResponse res = new HttpResponse();
        try {
          res = h.send(req);
        } catch (Exception e) {
          exceptionErrorMessage = e.getMessage();
          System.debug('exception =' + exceptionErrorMessage);
        }

        Integer bodyStatusCode = GlobalUtilities.getStatusFromBody(
          res.getBody()
        );
        if (
          res.getStatusCode() >= 300 ||
          bodyStatusCode >= 300 ||
          exceptionErrorMessage != null
        ) {
          Nebula.Logger.error(
            'Error Status: ' +
              res.getStatus() +
              'Error Body: ' +
              res.getBody() +
              ' exceptionErrorMessage = ' +
              exceptionErrorMessage
          );
        } else {
          Nebula.Logger.info('response body = ' + res.getBody());
          Nebula.Logger.info('response = ' + res);
        }
      }

      // not currently doing anything with the responses
      Nebula.Logger.saveLog();
      if (records.isEmpty() == false) {
        this.kickoff();
      }
    }
  }
}
