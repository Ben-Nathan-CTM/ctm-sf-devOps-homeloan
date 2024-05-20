public with sharing class HLA_LoanApplicationUpdatesQueueable implements Queueable, Database.AllowsCallouts {
  private List<SObject> records;
  private System.TriggerOperation triggerOperation;

  public HLA_LoanApplicationUpdatesQueueable(
    List<SObject> records,
    System.TriggerOperation triggerOperation
  ) {
    this.records = records;
    this.triggerOperation = triggerOperation;
  }

  public void execute(QueueableContext context) {
    switch on triggerOperation {
      when AFTER_UPDATE,AFTER_INSERT {
        HLA_ApplicationService.submitApplicationUpdates(records);
      }
      //AFTER_DELETE not implemented yet
    }
  }
}
