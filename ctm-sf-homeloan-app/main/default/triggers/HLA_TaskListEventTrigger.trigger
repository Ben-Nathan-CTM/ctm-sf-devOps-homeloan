trigger HLA_TaskListEventTrigger on HLA_TaskListEvent__e(after insert) {
  Nebula.Logger.info(
    Trigger.operationType + ' ENTRY ' + Trigger.new.size() + ' record(s)',
    Trigger.new
  );
  HLA_TaskListEvents.triggerHandler(HLA_TaskListEvents.class);
  Nebula.Logger.info('EXIT');
  Nebula.Logger.saveLog();
}
