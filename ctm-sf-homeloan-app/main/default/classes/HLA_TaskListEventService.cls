public inherited sharing class HLA_TaskListEventService implements HLA_ITaskListEventService {
  //

  private static HLA_ITaskListEventService service() {
    return (HLA_ITaskListEventService) Application.Service.newInstance(
      HLA_ITaskListEventService.class
    );
  }

  public static void processEvents(List<HLA_TaskListEvent__e> taskListEvents) {
    service().processEvents(taskListEvents);
  }
}
