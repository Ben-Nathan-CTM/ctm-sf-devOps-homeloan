public interface HLA_IApplicationService {
  void submitApplicationUpdates(List<SObject> records);
  List<LoanApplicationProduct__c> getEligibleLoanProducts(Id resiLoanId);
  void deleteApplicationAndRelatedrecords(List<Id> residentialLoanAppIds);
}
