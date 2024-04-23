public with sharing class HLA_ApplicationServiceImp implements HLA_IApplicationService {
  //

  public List<LoanApplicationProduct__c> getEligibleLoanProducts(Id recordId) {
    Set<id> resiLoanAppIds = new Set<id>{ recordId };
    return HLA_LoanApplicationProductsSelector.newInstance()
      .selectLoanApplicationProductsByApplicationIdOrderByRAC(resiLoanAppIds);
  }

  public void deleteApplicationAndRelatedrecords(
    List<Id> residentialLoanAppIds
  ) {
    deleteApplicationAndRelated(residentialLoanAppIds);
  }

  public void submitApplicationUpdates(List<SObject> records) {
    Nebula.Logger.debug('submitApplicationUpdates', records);

    // TODO: convert the below into an unambiguous function (GlobalUtility?) like "getAccessToken(String endpoint,  String authorizationSystem)
    String endpoint = 'HLA_LendingProcess';
    String authorizationSystem = 'Auth0';

    CTM_Environment_Config__mdt ctmEnvConfig = GlobalUtilities.CTMEnvConfig;
    CTM_Endpoint__mdt ctmEndpoint = GlobalUtilities.CTMEndpoints.get(endpoint);
    String accessToken = GlobalUtilities.getEndpointAccessToken(
      endpoint,
      authorizationSystem
    );

    Nebula.Logger.debug('accessToken = ' + accessToken);

    map<Id, List<Sobject>> residentialAppIdsMappedToRecords = mapResidentialLoanIds(
      records
    );

    List<ResidentialLoanApplication__c> rlaList = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .selectByIdWithCustomerId(residentialAppIdsMappedToRecords.keyset());

    for (ResidentialLoanApplication__c rla : rlaList) {
      List<SObject> recordsForThisRLA = residentialAppIdsMappedToRecords.get(
        rla.id
      );
      if (
        rla.Account__r?.customerId__c != null &&
        rla.ApplicationId__c != null
      ) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey', ctmEnvConfig.ApiKey__c);
        gen.writeStringField('flowName', 'application');
        gen.writeNumberField('processOperation', 2);
        gen.writeNumberField('dataVersion', 0);
        gen.writeStringField('dataOwnerUserId', rla.Account__r.customerId__c);
        gen.writeStringField('applicationId', rla.ApplicationId__c);
        gen.writeFieldName('salesforceData');
        gen.writeObject(recordsForThisRLA);
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

        Http http = new Http();
        HttpResponse resp = http.send(req);
        Integer bodyStatusCode = GlobalUtilities.getStatusFromBody(
          resp.getBody()
        );
        if (resp.getStatusCode() >= 300 || bodyStatusCode >= 300) {
          Nebula.Logger.error(
            'Error Status: ' +
              resp.getStatus() +
              'Error Body: ' +
              resp.getBody()
          );
        } else {
          Nebula.Logger.info('response body = ' + resp.getBody());
          Nebula.Logger.info('response = ' + resp);
        }
      }
    }
    Nebula.Logger.saveLog();
  }

  private map<Id, List<Sobject>> mapResidentialLoanIds(List<SObject> records) {
    //TODO: this is messy - could be cleaned up. Potential use case for polymorphism insted of if/else
    map<Id, List<SObject>> mapToReturn = new Map<Id, List<SObject>>();
    map<Id, SObject> sObjectIdmappedToRecord = new Map<Id, SObject>();
    Set<Id> loanApplicantAssetIds = new Set<Id>();
    Set<Id> loanApplicantLiabilityIds = new Set<Id>();
    Set<Id> loanIds = new Set<Id>();

    for (SObject record : records) {
      Nebula.Logger.info('record', record);
      Schema.SObjectType objType = record.getSObjectType();
      Id residentialLoanId;
      Id childId;

      if (objType == ResidentialLoanApplication__c.sObjectType) {
        residentialLoanId = (Id) record.get('Id');
      } else if (objType == LoanApplicantAsset__c.SObjectType) {
        // Applicant records don't have RLA set
        childId = (Id) record.get('LoanApplicationAsset__c');
        sObjectIdmappedToRecord.put(childId, record);
        loanApplicantAssetIds.add(childId);
      } else if (objType == LoanApplicantLiability__c.sObjectType) {
        // Applicant records don't have RLA set
        childId = (Id) record.get('loanApplicationLiability__c');
        sObjectIdmappedToRecord.put(childId, record);
        loanApplicantLiabilityIds.add(childId);
      } else if (objType == LoanEquityRelease__c.sObjectType) {
        // Applicant records don't have RLA set
        childId = (Id) record.get('Loan__c');
        sObjectIdmappedToRecord.put(childId, record);
        loanIds.add(childId);
      } else {
        residentialLoanId = (Id) record.get('ResidentialLoanApplication__c');
      }
      if (residentialLoanId != null) {
        if (!mapToReturn.containsKey(residentialLoanId)) {
          mapToReturn.put(residentialLoanId, new List<SObject>());
        }
        mapToReturn.get(residentialLoanId).add(record);
      }
    }
    if (!loanApplicantAssetIds.isEmpty()) {
      for (LoanApplicationAsset__c laa : [
        SELECT ResidentialLoanApplication__c
        FROM LoanApplicationAsset__c
        WHERE ID IN :loanApplicantAssetIds
      ]) {
        if (!mapToReturn.containsKey(laa.ResidentialLoanApplication__c)) {
          mapToReturn.put(
            laa.ResidentialLoanApplication__c,
            new List<SObject>()
          );
        }
        mapToReturn.get(laa.ResidentialLoanApplication__c)
          .add(sObjectIdmappedToRecord.get(laa.id));
      }
    }
    if (!loanApplicantLiabilityIds.isEmpty()) {
      for (loanApplicationLiability__c lal : [
        SELECT ResidentialLoanApplication__c
        FROM loanApplicationLiability__c
        WHERE ID IN :loanApplicantLiabilityIds
      ]) {
        if (!mapToReturn.containsKey(lal.ResidentialLoanApplication__c)) {
          mapToReturn.put(
            lal.ResidentialLoanApplication__c,
            new List<SObject>()
          );
        }
        mapToReturn.get(lal.ResidentialLoanApplication__c)
          .add(sObjectIdmappedToRecord.get(lal.id));
      }
    }
    if (!loanIds.isEmpty()) {
      for (Loan__c loan : [
        SELECT ResidentialLoanApplication__c
        FROM Loan__c
        WHERE ID IN :loanIds
      ]) {
        if (!mapToReturn.containsKey(loan.ResidentialLoanApplication__c)) {
          mapToReturn.put(
            loan.ResidentialLoanApplication__c,
            new List<SObject>()
          );
        }
        mapToReturn.get(loan.ResidentialLoanApplication__c)
          .add(sObjectIdmappedToRecord.get(loan.id));
      }
    }
    return mapToReturn;
  }

  private void deleteApplicationAndRelated(List<Id> residentialLoanAppIds) {
    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

    
    // TODO: convert the below into an unambiguous function (GlobalUtility?) like "getAccessToken(String endpoint,  String authorizationSystem)
    String endpoint = 'HLA_UnsubmitApplication';
    //String authorizationSystem = 'Auth0';

    CTM_Environment_Config__mdt ctmEnvConfig = GlobalUtilities.CTMEnvConfig;
    CTM_Endpoint__mdt ctmEndpoint = GlobalUtilities.CTMEndpoints.get(endpoint);
    // String accessToken = GlobalUtilities.getEndpointAccessToken(
    //   endpoint,
    //   authorizationSystem
    // );

    // Nebula.Logger.debug('accessToken = ' + accessToken);
    Set<Id> residentialLoanAppIdSet = new Set<Id>(residentialLoanAppIds);

    List<ResidentialLoanApplication__c> rlaList = HLA_ResidentialLoanApplicationsSelector.newInstance()
      .selectByIdWithCustomerId(residentialLoanAppIdSet);

    Nebula.Logger.debug('unsubmitApplications', rlaList);
    
    List<Id> successRLAIds = New List<Id>();
    List<Id> failedRLAIds = New List<Id>();
    for (ResidentialLoanApplication__c rla : rlaList) {
      if (
        rla.Account__r?.customerId__c != null &&
        rla.ApplicationId__c != null
      ) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey', ctmEnvConfig.ApiKey__c);
        gen.writeStringField('dataOwnerUserId', rla.Account__r.customerId__c);
        gen.writeStringField('applicationId', rla.ApplicationId__c);
        gen.writeEndObject();

        String payloadJSON = gen.getAsString();
        Nebula.Logger.info('payloadJSON = ' + payloadJSON);
        Nebula.Logger.info('ctmEnvConfig = ' + ctmEnvConfig);

        HttpRequest req = GlobalUtilities.createHttpRequest(
          payloadJSON,
          ctmEnvConfig,
          ctmEndpoint,
          ''
        );
        Nebula.Logger.info('req = ' + req);

        Http http = new Http();
        HttpResponse resp = http.send(req);
        Integer bodyStatusCode = GlobalUtilities.getStatusFromBody(
          resp.getBody()
        );
        if (resp.getStatusCode() >= 300 || bodyStatusCode >= 300) {
          failedRLAIds.add(rla.Id);
          Nebula.Logger.error(
            'Application SF ID: ' +
              rla.Id +
            'Error Status: ' +
              resp.getStatus() +
              'Error Body: ' +
              resp.getBody()
          );
        } else {
          successRLAIds.add(rla.Id);
          Nebula.Logger.info('response body = ' + resp.getBody());
          Nebula.Logger.info('response = ' + resp);
        }
      }
    }
    Nebula.Logger.saveLog();


    // TODO: need to clean this up into minimal SOQL statements at some point

    LoanApplicant__c[] applicants = [
      SELECT id
      FROM LoanApplicant__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];

    CreditScore__c[] creditscores = [
      SELECT id
      FROM CreditScore__c
      WHERE LoanApplicant__c IN :applicants
    ];

    LoanApplicationAsset__c[] applicationassets = [
      SELECT id
      FROM LoanApplicationAsset__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanApplicationExpense__c[] applicationexpenses = [
      SELECT id
      FROM LoanApplicationExpense__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanApplicationIncome__c[] applicationincomes = [
      SELECT id
      FROM LoanApplicationIncome__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanApplicationLiability__c[] applicationliabilities = [
      SELECT id
      FROM LoanApplicationLiability__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    // applicant related objects
    LoanApplicantAsset__c[] applicantassets = [
      SELECT id
      FROM LoanApplicantAsset__c
      WHERE loanapplicant__c IN :applicants
    ];
    LoanApplicantExpense__c[] applicantexpenses = [
      SELECT id
      FROM LoanApplicantExpense__c
      WHERE loanapplicant__c IN :applicants
    ];
    LoanApplicantIncome__c[] applicantincomes = [
      SELECT id
      FROM LoanApplicantIncome__c
      WHERE loanapplicant__c IN :applicants
    ];
    LoanApplicantLiability__c[] applicantliabilities = [
      SELECT id
      FROM LoanApplicantLiability__c
      WHERE loanapplicant__c IN :applicants
    ];
    LoanApplicantEmployment__c[] applicantEmployment = [
      SELECT id
      FROM LoanApplicantEmployment__c
      WHERE loanapplicant__c IN :applicants
    ];
    //  documents & links
    LoanApplicationDocument__c[] loandocs = [
      SELECT id
      FROM LoanApplicationDocument__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanApplicationDocumentLink__c[] loandoclinks = [
      SELECT id
      FROM LoanApplicationDocumentLink__c
      WHERE LoanApplicationDocument__c IN :loandocs
    ];
    //  loan related objects
    LoanApplicationProduct__c[] loanproducts = [
      SELECT id
      FROM LoanApplicationProduct__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];

    Loan__c[] loans = [
      SELECT id
      FROM Loan__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];

    LoanContribution__c[] loancontribution = [
      SELECT id
      FROM LoanContribution__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanCost__c[] loancost = [
      SELECT id
      FROM LoanCost__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];

    LoanEquityRelease__c[] loanequityreleases = [
      SELECT id
      FROM LoanEquityRelease__c
      WHERE Loan__c IN :loans
    ];

    LoanSecurity__c[] loansecurity = [
      SELECT id
      FROM LoanSecurity__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    LoanSplit__c[] loansplit = [
      SELECT id
      FROM LoanSplit__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    ResponsibleLending__c[] responsibleLending = [
      SELECT id
      FROM ResponsibleLending__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];
    OtherAddress__c[] otherAddresses = [
      SELECT id
      FROM OtherAddress__c
      WHERE ResidentialLoanApplication__c IN :successRLAIds
    ];

  
    uow.registerDeleted(responsibleLending);
    uow.registerDeleted(otherAddresses);
    uow.registerDeleted(loansplit);
    uow.registerDeleted(loansecurity);
    uow.registerDeleted(loancost);
    uow.registerDeleted(loancontribution);
    uow.registerDeleted(loanproducts);
    //uow.registerDeleted(loanequityreleases);
    uow.registerDeleted(loandoclinks);
    uow.registerDeleted(loandocs);
    uow.registerDeleted(loans);
    uow.registerDeleted(applicantEmployment);
    uow.registerDeleted(applicantliabilities);
    uow.registerDeleted(applicantincomes);
    uow.registerDeleted(applicantexpenses);
    uow.registerDeleted(applicantassets);
    uow.registerDeleted(applicationliabilities);
    uow.registerDeleted(applicationincomes);
    uow.registerDeleted(applicationexpenses);
    uow.registerDeleted(applicationassets);
    uow.registerdeleted(creditscores);
    uow.registerDeleted(applicants);
    //uow.registerDeleted(applications);
    uow.commitwork();
  }
}
