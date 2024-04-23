public with sharing class HLA_ProductRecommendationQueueable implements Queueable, Database.AllowsCallouts {
  private List<Id> residentialLoanAppIds;

  public HLA_ProductRecommendationQueueable(List<Id> residentialLoanAppIds) {
    this.residentialLoanAppIds = residentialLoanAppIds;
  }

  public void execute(QueueableContext context) {
    Nebula.Logger.info('ENTRY ' + residentialLoanAppIds);
    HLA_ProductRecommendations.requestNewProductsCallout(residentialLoanAppIds);
    Nebula.Logger.saveLog();
  }
}
