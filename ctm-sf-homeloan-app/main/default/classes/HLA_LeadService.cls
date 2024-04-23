public with sharing class HLA_LeadService implements HLA_ILeadService {
  //

  private static HLA_ILeadService service() {
    return (HLA_ILeadService) Application.Service.newInstance(
      HLA_ILeadService.class
    );
  }

  public static Lead parseAndCreateNewLead(String requestBody) {
    return service().parseAndCreateNewLead(requestBody);
  }

  public static String getRecordsToReturn() {
    return service().getRecordsToReturn();
  }
}