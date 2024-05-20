public with sharing class HLA_AccountServiceImp implements HLA_IAccountService {
  private final static Id personAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
    .get('PersonAccount')
    .getRecordTypeId();

  public Account parseAndCreateNewAccount(String requestBody) {
    Account accountRecord = (Account) JSON.deserialize(
      requestBody,
      Account.class
    );
    accountRecord.RecordTypeId = personAccountRTId;

    // not using Unit Of Work here becuase it can't upsert on ExtId
    upsert accountRecord CustomerId__c;
    return accountRecord;
  }
}