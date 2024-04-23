public inherited sharing class HLA_TaskListEvents extends ApplicationSObjectDomain implements HLA_ITaskListEvents {
  //

  public static HLA_ITaskListEvents newInstance(
    List<HLA_TaskListEvent__e> records
  ) {
    return (HLA_ITaskListEvents) Application.Domain.newInstance(records);
  }

  public HLA_TaskListEvents(List<HLA_TaskListEvent__e> events) {
    super(events);
  }

  private List<HLA_TaskListEvent__e> taskListEvents {
    get {
      if (taskListEvents == null) {
        taskListEvents = (List<HLA_TaskListEvent__e>) records;
      }
      return taskListEvents;
    }
    private set;
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new HLA_TaskListEvents(sObjectList);
    }
  }

  public override void onAfterInsert() {
    system.debug('onAfterInsert');
    HLA_TaskListEventService.processEvents(taskListEvents);
  }

  public class LoanTracking {
    public String applicationId { get; set; }
    public String customerId { get; set; }
    public List<Task> tasks { get; set; }
  }
}
