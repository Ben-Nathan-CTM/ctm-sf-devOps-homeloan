public interface HLA_ILeadService {
  Lead parseAndCreateNewLead(String requestBody);
  String getRecordsToReturn();
}