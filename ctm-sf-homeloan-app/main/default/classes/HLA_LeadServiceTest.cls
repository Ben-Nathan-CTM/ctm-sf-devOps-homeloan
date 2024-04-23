@IsTest
public class HLA_LeadServiceTest {
  //

  @IsTest
  public static void should_get_records_to_return_in_serialized_format() {
    // Given
    Account testAcct = new Account(name = 'test');
    insert testAcct;

    // When
    String serializedAccounts = HLA_LeadService.getRecordsToReturn();

    // Then
    System.assert(serializedAccounts.contains('test'));
  }

  @IsTest
  public static void should_parse_and_create_new_lead() {
    // Given
    String mockLead = '{"customerId__c" : "1234", "lastname":"test"}';

    // When
    Lead insertedLead = HLA_LeadService.parseAndCreateNewLead(mockLead);

    // Then
    System.assertEquals(insertedLead.LastName, 'test', 'lead inserted');
  }
}