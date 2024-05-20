public class HLA_AFGCallout {
  @AuraEnabled(cacheable=true)
  public static Integer requestAFGCallout(
    List<Id> residentialLoanAppIds,
    String correlationId
  ) {
    String endpoint = 'HLA_SubmitToAfgService';
    String authorizationSystem = 'Auth0';
    Integer bodyStatusCode;
    CTM_Environment_Config__mdt ctmEnvConfig = GlobalUtilities.CTMEnvConfig;
    CTM_Endpoint__mdt ctmEndpoint = GlobalUtilities.CTMEndpoints.get(endpoint);
    String accessToken = GlobalUtilities.getEndpointAccessToken(
      endpoint,
      authorizationSystem
    );
    for (
      ResidentialLoanApplication__c rla : HLA_ResidentialLoanApplicationsSelector.newInstance()
        .selectByIdWithCustomerId(new Set<Id>(residentialLoanAppIds))
    ) {
      if (
        rla.Account__r?.customerId__c != null &&
        rla.ApplicationId__c != null
      ) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey', ctmEnvConfig.ApiKey__c);
        gen.writeStringField('correlationId', correlationId);
        gen.writeStringField('applicationId', rla.ApplicationId__c);
        gen.writeEndObject();

        String payloadJSON = gen.getAsString();
        Nebula.Logger.info('AFG Submission payloadJSON = ' + payloadJSON);

        HttpRequest req = GlobalUtilities.createHttpRequest(
          payloadJSON,
          ctmEnvConfig,
          ctmEndpoint,
          accessToken
        );
        Nebula.Logger.info('AFG Submission HTTP req = ' + req);
        Nebula.Logger.info('Record Id= ' + rla.Id);

        try {
          Http http = new Http();
          HttpResponse resp = http.send(req);
          //resBody = resp.getBody();
          bodyStatusCode = GlobalUtilities.getStatusFromBody(resp.getBody());
          if (resp.getStatusCode() >= 300 || bodyStatusCode >= 300) {
            Nebula.Logger.error(
              'AFG Error Status: ' +
                resp.getStatus() +
                'AFG Error Body: ' +
                resp.getBody()
            );
          } else {
            Nebula.Logger.info('AFG response = ' + resp);
          }
        } catch (Exception e) {
          System.debug(e.getMessage());
        }
      }
    }
    Nebula.Logger.saveLog();
    return bodyStatusCode;
  }
  @AuraEnabled
  public static void updateRecordToBeDeleted(
    String objectName,
    String recordId
  ) {
    try {
      SObject record = Schema.getGlobalDescribe().get(objectName).newSobject();
      System.debug('Object Name: ' + objectName);
      System.debug('Record Id: ' + recordId);

      record.put('Id', recordId);
      record.put('IsDeleted__c', true);
      update record;

      HLA_DeleteRecord__e event = new HLA_DeleteRecord__e(
        recordId__c = recordId,
        ObjectName__c = objectName
      );
      Database.SaveResult sr = EventBus.publish(event);
      System.debug('EventUuid: ' + event.EventUuid);
      if (sr.isSuccess()) {
        System.debug('Successfully published event.');
      } else {
        for (Database.Error err : sr.getErrors()) {
          System.debug(
            'Error returned: ' + err.getStatusCode() + ' - ' + err.getMessage()
          );
        }
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
