public class HLA_Utils {
  //

  public static void flagEachRecordIsDirty(
    List<SObject> records,
    Map<Id, SObject> rlaRecordsMap
  ) {
    if (!records.isEmpty()) {
      for (SObject record : records) {
        SObject oldRecord = rlaRecordsMap?.get(record.id);
        if (
          //skip if isDirty is being unflagged
          record.get('isDirty__c') != oldRecord?.get('isDirty__c') &&
          oldRecord?.get('isDirty__c') == true
        ) {
          continue;
        }
        record.put('isDirty__c', true);
      }
    }
  }

  public static void enqueueApplicationUpdatesOrSubmitThem(
    List<SObject> records,
    System.TriggerOperation operationType
  ) {
    if (Limits.GetLimitQueueableJobs() - Limits.GetQueueableJobs() > 0) {
      System.enqueueJob(
        new HLA_LoanApplicationUpdatesQueueable(records, operationType)
      );
    } else {
      HLA_ApplicationService.submitApplicationUpdates(records);
    }
  }

  @InvocableMethod(label='Generate External Id' description='Returns random genreated guid')
  public static String[] generateExternalId(){
    List<String> guidList = new List<String>();
    Blob b = Crypto.GenerateAESKey(128);
    String h = EncodingUtil.ConvertTohex(b);
    String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
    guidList.add(guid);
    return guidList;
  }

  


}
