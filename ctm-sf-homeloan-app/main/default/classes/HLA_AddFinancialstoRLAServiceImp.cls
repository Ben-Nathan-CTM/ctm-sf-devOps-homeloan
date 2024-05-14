public with sharing class HLA_AddFinancialstoRLAServiceImp implements HLA_IAddFinancialstoRLAService {
  private CTM_Environment_Config__mdt ctmEnvConfig;
  private CTM_Endpoint__mdt ctmEndpoint;
  private String accessToken;
  private String PayloadJSON;

  public Map<Integer, String> createPayloadFlowCreatedFinancialRecords(
    String referenceId,
    String rlaId
  ) {
    //retreive  map of  records
    List<Sobject> collectedRecords = getRecords(referenceId, rlaId);

    //create payload json body
    List<ResidentialLoanApplication__c> rlaList = getRLAList(rlaId);
    PayloadJSON = createJsonBody(collectedRecords, rlaList[0]);
    system.debug(PayloadJSON);

    //http callout to send payload
    return sendPayload(PayloadJSON, rlaList[0]);
  }

  public List<Sobject> getRecords(String referenceId, String rlaId) {
    List<Sobject[]> sRecordsList = new List<Sobject[]>{
      HLA_LoanApplicationAssetsSelector.newInstance()
        .selectLoanApplicationAssetsByReferenceId(referenceId, rlaId),
      HLA_LoanApplicantAssetsSelector.newInstance()
        .selectLoanApplicantAssetsByReferenceId(referenceId, rlaId),
      HLA_LoanApplicationLiabilitiesSelector.newInstance()
        .selectLoanApplicationLiabilitiesByReferenceId(referenceId, rlaId),
      HLA_LoanApplicantLiabilitiesSelector.newInstance()
        .selectLoanApplicantLiabilitiesByReferenceId(referenceId, rlaId),
      HLA_LoanApplicationIncomeSelector.newInstance()
        .selectLoanApplicationIncomesByReferenceId(referenceId, rlaId),
      HLA_LoanApplicantIncomesSelector.newInstance()
        .selectLoanApplicantIncomesByReferenceId(referenceId, rlaId),
      HLA_LoanApplicationExpensesSelector.newInstance()
        .selectLoanApplicationExpensesByReferenceId(referenceId, rlaId),
      HLA_LoanApplicantExpensesSelector.newInstance()
        .selectLoanApplicantExpensesByReferenceId(referenceId, rlaId)
    };

    List<Sobject> allObjectRecords = new List<Sobject>();
    for (Sobject[] recordsList : sRecordsList) {
      if (!recordsList.isEmpty()) {
        for (Sobject records : recordsList) {
          allObjectRecords.add(records);
        }
      }
    }

    return allObjectRecords;
  }

  public string createJsonBody(
    List<Sobject> records,
    ResidentialLoanApplication__c rla
  ) {
    String endpoint = 'HLA_LendingProcess';
    String authorizationSystem = 'Auth0';

    ctmEnvConfig = GlobalUtilities.CTMEnvConfig;
    ctmEndpoint = GlobalUtilities.CTMEndpoints.get(endpoint);
    accessToken = GlobalUtilities.getEndpointAccessToken(
      endpoint,
      authorizationSystem
    );

    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('apiKey', ctmEnvConfig.ApiKey__c);
    gen.writeStringField('flowName', 'application');
    gen.writeNumberField('processOperation', 2);
    gen.writeNumberField('dataVersion', 0);
    gen.writeStringField('dataOwnerUserId', rla.Account__r.customerId__c);
    gen.writeStringField('applicationId', rla.ApplicationId__c);
    gen.writeFieldName('salesforceData');
    gen.writeObject(records);
    gen.writeEndObject();
    return gen.getAsString();
  }

  public Map<Integer, String> sendPayload(
    String payloadJSON,
    ResidentialLoanApplication__c rla
  ) {
    system.debug('Http Callout Inititated');
    Nebula.Logger.debug('Application Financials payload = ' + payloadJSON);
    Map<Integer, String> httpResponseMap = new Map<Integer, String>();
    Integer bodyStatusCode;
    String responseBody;
    if (rla.Account__r?.customerId__c != null && rla.ApplicationId__c != null) {
      //create request
      HttpRequest req = GlobalUtilities.createHttpRequest(
        payloadJSON,
        ctmEnvConfig,
        ctmEndpoint,
        accessToken
      );
      system.debug('Request ->' + req);
      Nebula.Logger.info('Application Financialsreq = ' + req);

      //Do callout
      Http http = new Http();
      HttpResponse resp = http.send(req);
      system.debug('Response' + resp);
      bodyStatusCode = GlobalUtilities.getStatusFromBody(resp.getBody());
      system.debug('Request Status' + bodyStatusCode);
      responseBody = resp.getBody();
      if (resp.getStatusCode() >= 300 || bodyStatusCode >= 300) {
        Nebula.Logger.error(
          'Error Status: ' + resp.getStatus() + 'Error Body: ' + resp.getBody()
        );
      } else {
        Nebula.Logger.info(
          'Application Financials response body = ' + resp.getBody()
        );
        Nebula.Logger.info('Application Financials response = ' + resp);
      }
    }

    Nebula.Logger.saveLog();
    httpResponseMap.put(bodyStatusCode, responseBody);
    return httpResponseMap;
  }

  public List<ResidentialLoanApplication__c> getRLAList(String RLAId) {
    Set<Id> rlaSetId = new Set<Id>();
    rlaSetId.add(RLAId);
    List<ResidentialLoanApplication__c> rlaList = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .selectByIdWithCustomerId(rlaSetId);
    return rlaList;
  }
}
