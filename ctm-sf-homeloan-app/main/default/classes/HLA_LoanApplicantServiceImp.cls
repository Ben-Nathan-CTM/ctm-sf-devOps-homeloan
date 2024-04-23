public with sharing class HLA_LoanApplicantServiceImp implements HLA_ILoanApplicantService {
  //

  // TODO: Ben - could move this logic to Flow? ... or the LoanApplicant Domain if not using flow

  public void attachContactsToApplicants(List<LoanApplicant__c> applicants) {
    List<LoanApplicant__c> borrowerApplicants = checkForBorrowers(applicants);
    if (!borrowerApplicants.isEmpty()) {
      Map<String, List<LoanApplicant__c>> emailAddressesMappedToApplicants = mapEmailAdressesToApplicants(
        borrowerApplicants
      );
      List<AggregateResult> matchingContacts = matchContactsUsingEmail(
        emailAddressesMappedToApplicants.keySet()
      );
      attachContactsAndAlertDuplicates(
        emailAddressesMappedToApplicants,
        matchingContacts
      );
    }
  }

  private List<LoanApplicant__c> checkForBorrowers(
    List<LoanApplicant__c> applicants
  ) {
    List<LoanApplicant__c> borrowers = new List<LoanApplicant__c>();
    for (LoanApplicant__c applicant : applicants) {
      String picklistLabel = GlobalUtilities.getLabelFromPicklistValue(
        LoanApplicant__c.PersonType__c,
        applicant.PersonType__c
      );
      if (picklistLabel == 'Borrower' && applicant.EmailAddress__c != null) {
        borrowers.add(applicant);
      }
    }
    return borrowers;
  }

  private Map<String, List<LoanApplicant__c>> mapEmailAdressesToApplicants(
    List<LoanApplicant__c> borrowerApplicants
  ) {
    Map<String, List<LoanApplicant__c>> emailMap = new Map<String, List<LoanApplicant__c>>();
    for (LoanApplicant__c applicant : borrowerApplicants) {
      if (!emailMap.containsKey(applicant.EmailAddress__c)) {
        emailMap.put(applicant.EmailAddress__c, new List<LoanApplicant__c>());
      }
      emailMap.get(applicant.EmailAddress__c).add(applicant);
    }
    return emailMap;
  }

  private List<AggregateResult> matchContactsUsingEmail(
    Set<String> emailAddresses
  ) {
    List<AggregateResult> matchedContacts = [
      SELECT Id, account.personcontactid, email
      FROM contact
      WHERE email IN :emailAddresses
      GROUP BY email, account.personcontactid, Id
      ORDER BY account.personcontactid DESC NULLS LAST
    ];
    return matchedContacts;
  }

  private void attachContactsAndAlertDuplicates(
    Map<String, List<LoanApplicant__c>> emailAddressesMappedToApplicants,
    List<AggregateResult> matchingContacts
  ) {
    Nebula.Logger.debug('attachContactsAndAlertDuplicates', matchingContacts);
    IApplicationSObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
    Set<Id> applicantsWithMultipleContactsFound = new Set<Id>();
    List<String> emailAddressAlreadyProcessed = new List<String>();

    for (AggregateResult ar : matchingContacts) {
      String contactId = (String) ar.get('Id');
      String personContactId = (String) ar.get('PersonContactId');
      String emailAddress = (String) ar.get('Email');
      List<LoanApplicant__c> relatedApplicants = emailAddressesMappedToApplicants.get(
        emailAddress
      );
      if (emailAddressAlreadyProcessed.contains(emailAddress)) {
        //skip this contact as we have already processed an earlier contact with this email address and assigned the contact to all related applicants
        continue;
      }

      Nebula.Logger.debug(
        'matchingContact: ' +
          'contactId: ' +
          contactId +
          ' personContactId: ' +
          personContactId +
          ' emailAddress: ' +
          emailAddress +
          ' relatedApplicant: ' +
          relatedApplicants
      );

      String contactIdToUse = personContactId != null
        ? personContactId
        : contactId;
      for (LoanApplicant__c relatedApplicant : relatedApplicants) {
        if (emailAddressAlreadyProcessed.contains(emailAddress)) {
          applicantsWithMultipleContactsFound.addAll(
            new Map<Id, LoanApplicant__c>(relatedApplicants).keyset()
          );
        }
        relatedApplicant.ContactId__c = contactIdToUse;
        uow.register(relatedApplicant);
        emailAddressAlreadyProcessed.add(emailAddress);
      }
    }
    for (String emailAddress : emailAddressAlreadyProcessed) {
      emailAddressesMappedToApplicants.remove(emailAddress);
    }
    if (!emailAddressesMappedToApplicants.isEmpty()) {
      List<LoanApplicant__c> applicantsWithoutAMatchingContact = new List<LoanApplicant__c>();
      for (String email : emailAddressesMappedToApplicants.keySet()) {
        applicantsWithoutAMatchingContact.addAll(
          emailAddressesMappedToApplicants.get(email)
        );
      }
      for (
        LoanApplicant__c relatedApplicant : applicantsWithoutAMatchingContact
      ) {
        Contact newContact = createContact(relatedApplicant);
        uow.register(newContact);
        uow.register(
          relatedApplicant,
          LoanApplicant__c.ContactId__c,
          newContact
        );
      }
    }
    uow.commitwork();
    if (!applicantsWithMultipleContactsFound.isEmpty()) {
      Nebula.Logger.Error(
        'applicantsWithMultipleContactsFound: ' +
        applicantsWithMultipleContactsFound
      );
      GlobalUtilities.sendErrorEmail(
        JSON.serialize(applicantsWithMultipleContactsFound)
      );
    }
    Nebula.Logger.saveLog();
  }

  private Contact createContact(LoanApplicant__c relatedApplicant) {
    Contact newContact = new Contact(
      firstname = relatedApplicant.FirstName__c,
      Lastname = relatedApplicant?.LastName__c == null
        ? 'Unknown'
        : relatedApplicant.LastName__c,
      email = relatedApplicant.EmailAddress__c,
      MobilePhone = relatedApplicant?.Mobile__c
    );
    return newContact;
  }
}
