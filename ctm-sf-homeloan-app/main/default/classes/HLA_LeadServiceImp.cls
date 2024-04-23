public with sharing class HLA_LeadServiceImp implements HLA_ILeadService {
  //

  public Lead parseAndCreateNewLead(String requestBody) {
    Lead leadRecord = (Lead) JSON.deserialize(requestBody, Lead.class);

    upsert leadRecord;
    return leadRecord;
  }

  public String getRecordsToReturn() {
    List<Account> accounts = [
      SELECT Id, Name, Phone
      FROM Account
      WITH SECURITY_ENFORCED
    ];

    return JSON.serialize(accounts);
  }
}