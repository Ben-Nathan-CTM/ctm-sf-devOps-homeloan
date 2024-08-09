public with sharing class HLA_AddFinancialstoRLAService implements HLA_IAddFinancialstoRLAService {
  private static HLA_IAddFinancialstoRLAService service() {
    return (HLA_IAddFinancialstoRLAService) Application.Service.newInstance(
      HLA_IAddFinancialstoRLAService.class
    );
  }

  @InvocableMethod(
    label='Submit RLA Finacials To Middleware'
    description='To submit related application and applicants assets,liabilities,expense'
    callout=true
  )
  public static List<OutputVariables> ScreenFlowRlaFinancialsToMiddleware(
    List<InputVariables> variables
  ) {
    List<OutputVariables> returnValueList = new List<OutputVariables>();
    OutputVariables returnValue = new OutputVariables();
    String referenceId = variables.get(0).ReferenceId;
    String applId = variables.get(0).RLAId;

    Map<Integer, String> responseMap = new Map<Integer, String>();
    responseMap = HLA_AddFinancialstoRLAService.createPayloadFlowCreatedFinancialRecords(
      referenceId,
      applId
    );
    for (Integer key : responseMap.keySet()) {
      returnValue.HttpErrorMessage = responseMap.get(key);
      returnValue.HttpResponseCode = key;
    }
    returnValueList.add(returnValue);
    return returnValueList;
  }

  public static Map<Integer, String> createPayloadFlowCreatedFinancialRecords(
    String referenceId,
    String applId
  ) {
    return service()
      .createPayloadFlowCreatedFinancialRecords(referenceId, applId);
  }

  public class InputVariables {
    @InvocableVariable(required=true)
    public String RLAId;

    @InvocableVariable(required=true)
    public String ReferenceId;
  }

  public class OutputVariables {
    @InvocableVariable
    public Integer HttpResponseCode;

    @InvocableVariable
    public String HttpErrorMessage;
  }
}
