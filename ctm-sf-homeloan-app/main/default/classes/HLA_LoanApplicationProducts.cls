public inherited sharing class HLA_LoanApplicationProducts extends ApplicationSObjectDomain implements HLA_ILoanApplicationProducts {
  //

  public static HLA_ILoanApplicationProducts newInstance(
    List<LoanApplicationProduct__c> records
  ) {
    return (HLA_ILoanApplicationProducts) Application.Domain.newInstance(
      records
    );
  }

  public static HLA_ILoanApplicationProducts newInstance(Set<Id> recordIds) {
    return (HLA_ILoanApplicationProducts) Application.Domain.newInstance(
      recordIds
    );
  }

  public HLA_LoanApplicationProducts(List<LoanApplicationProduct__c> records) {
    super(records);
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_LoanApplicationProducts(sObjectList);
    }
  }

  private List<LoanApplicationProduct__c> lapRecords {
    get {
      if (lapRecords == null) {
        lapRecords = (List<LoanApplicationProduct__c>) records;
      }
      return lapRecords;
    }
    private set;
  }

  public List<LoanApplicationProduct__c> getlapRecords() {
    return this.lapRecords;
  }
}
