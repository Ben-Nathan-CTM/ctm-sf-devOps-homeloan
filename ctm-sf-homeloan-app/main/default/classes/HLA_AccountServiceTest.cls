@IsTest
public class HLA_AccountServiceTest {
  //

  @IsTest
  public static void should_parse_and_create_new_account() {
    // Given

    String acctJSON = '{"customerId__c" : "1234", "lastname":"test"}';
    Account acct;

    // When
    acct = HLA_AccountService.parseAndCreateNewAccount(acctJSON);

    // Then
    System.assertNotEquals(null, acct.id, 'should have upserted Account');
  }
}
