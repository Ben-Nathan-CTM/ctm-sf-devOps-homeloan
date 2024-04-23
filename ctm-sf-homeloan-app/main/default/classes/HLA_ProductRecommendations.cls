public with sharing class HLA_ProductRecommendations {
  //

  @InvocableMethod(
    label='Request New Product Recommendations'
    description='Requests new product recommendations (deletes current ones)'
    category='Residential Loans'
  )
  public static void requestNewProducts(List<Id> residentialLoanAppIds) {
    deleteExistingProductRecommendations(residentialLoanAppIds);
    System.enqueueJob(
      new HLA_ProductRecommendationQueueable(residentialLoanAppIds)
    );
  }

  @AuraEnabled(cacheable=true)
  public static List<LoanApplicationProduct__c> getApplicationRelatedLoanProducts(
    String applicationRecordId,
    String fieldToOrderBy
  ) {
    try {
      return HLA_LoanApplicationProductsSelector.newInstance()
        .setNewSortOrder(fieldToOrderBy)
        .selectLoanApplicationProductsByApplicationId(
          new Set<id>{ applicationRecordId }
        );
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled
  public static void deleteExistingProductRecommendations(
    List<Id> residentialLoanAppIds
  ) {
    List<LoanApplicationProduct__c> productsToDelete = HLA_LoanApplicationProductsSelector.newInstance()
      .selectLoanApplicationProductsByApplicationId(
        new Set<id>(residentialLoanAppIds)
      );
    Database.DeleteResult[] results = Database.delete(productsToDelete, true);
    Boolean hadErrors = false;
    for (Database.DeleteResult result : results) {
      if (result.isSuccess()) {
        Nebula.logger.info(
          'Successfully deleted Loan App Product with ID: ' + result.getId()
        );
      } else {
        hadErrors = true;
        for (Database.Error err : result.getErrors()) {
          Nebula.logger.error(
            'The following error has occurred.' +
              err.getStatusCode() +
              ': ' +
              err.getMessage()
          );
        }
      }
    }
    if (hadErrors) {
      DmlException e = new DmlException();
      e.setMessage('Error Deleting Products');
      throw e;
    }
  }

  @AuraEnabled
  public static void requestNewProductsCallout(List<Id> residentialLoanAppIds) {
    String endpoint = 'HLA_ProductRecommendations';
    String authorizationSystem = 'Auth0';

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
        gen.writeStringField('dataOwnerUserId', rla.Account__r.customerId__c);
        gen.writeStringField('applicationId', rla.ApplicationId__c);
        gen.writeBooleanField('generate', true);

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
}