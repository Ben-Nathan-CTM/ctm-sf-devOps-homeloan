public interface HLA_IAddFinancialstoRLAService {
  Map<Integer, String> createPayloadFlowCreatedFinancialRecords(
    String referenceId,
    String applId
  );
}
