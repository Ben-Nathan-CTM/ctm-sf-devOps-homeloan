@IsTest
public class HLA_RelatedPartyServiceTest {
  @IsTest
  public static void should_parse_and_create_related_party() {
    // Given
    Account Acct = new Account(lastname = 'test', firstname = 'fred');
    insert Acct;
    String relatedPartyJSON = '{"name":"test", "Email__c":"test@test.com","account__c":"' + Acct.id + '"}';

    // When

    RelatedParty__c relParty = HLA_RelatedPartyService.parseAndCreateNewRelatedParty(
      relatedPartyJSON
    );
    // Then
    relParty = [SELECT name FROM RelatedParty__c WHERE Id = :relParty.id];
    system.assertEquals(
      'test',
      relParty.name,
      'should have parsed and inserted loan scenarion'
    );
  }
}