public with sharing class HLA_TaskListEventServiceImp implements HLA_ITaskListEventService {
  private List<HLA_TaskListEvent__e> externalEvents;
  private List<HLA_TaskListEvent__e> internalEvents;
  private List<String> taskListJSON;

  private final IApplicationSObjectUnitOfWork uow;

  public HLA_TaskListEventServiceImp() {
    this.uow = Application.UnitOfWork.newInstance();
  }

  public void processEvents(List<HLA_TaskListEvent__e> taskListEvents) {
    separateExternalFromInternalEvents(taskListEvents);
    updateTasklistFromExternalData();
    exportInternalTaskEventData();
  }

  private void separateExternalFromInternalEvents(
    List<HLA_TaskListEvent__e> taskListEvents
  ) {
    externalEvents = new List<HLA_TaskListEvent__e>();
    internalEvents = new List<HLA_TaskListEvent__e>();

    for (HLA_TaskListEvent__e taskListEvent : taskListEvents) {
      if (taskListEvent.OriginatedInternally__c) {
        internalEvents.add(taskListEvent);
      } else {
        externalEvents.add(taskListEvent);
      }
    }
  }

  private void updateTasklistFromExternalData() {
    if (!externalEvents.isEmpty()) {
      for (HLA_TaskListEvent__e taskListEvent : externalEvents) {
        list<Task> updatedTaskList = (List<Task>) JSON.deserialize(
          taskListEvent.TaskListJSON__c,
          List<Task>.class
        );
        uow.register(updatedTaskList);
      }
      uow.commitwork();
    }
  }

  private void exportInternalTaskEventData() {
    if (!internalEvents.isEmpty()) {
      Nebula.Logger.info('internalEvents', internalEvents);
      Set<id> residentialLoanIds = new Set<id>();
      for (HLA_TaskListEvent__e taskListEvent : internalEvents) {
        residentialLoanIds.add(taskListEvent.RelatedRecordId__c);
      }
      Nebula.Logger.info('residentialLoanIds = ' + residentialLoanIds);

      List<ResidentialLoanApplication__c> rlaList = HLA_ResidentialLoanApplicationsSelector.newInstance()
        .selectByIdWithTaskListWithLoanTracking(residentialLoanIds);
      new HLA_TaskListEventAsyncProcessor().get(rlaList).kickoff();
    }
  }
}
