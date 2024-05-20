import { LightningElement, api, wire } from "lwc";
import { getRelatedListRecords } from "lightning/uiRelatedListApi";

const LOAN_APPLICANTS_RELATEDLIST_API = "Loan_Applicants__r";

export default class HlaApplicantDetailsTab extends LightningElement {
  error;
  primaryApplicantId = [];
  loanApplicants = [];
  selectedApplicantId;
  isLoading = true;

  @api recordId;

  @wire(getRelatedListRecords, {
    parentRecordId: "$recordId",
    relatedListId: LOAN_APPLICANTS_RELATEDLIST_API,
    fields: [
      "LoanApplicant__c.IsPrimary__c",
      "LoanApplicant__c.FirstName__c",
      "LoanApplicant__c.LastName__c",
      "LoanApplicant__c.MiddleName__c",
      "LoanApplicant__c.DateOfBirth__c",
      "LoanApplicant__c.MaritalStatus__c",
      "LoanApplicant__c.EmailAddress__c",
      "LoanApplicant__c.Salutation__c",
      "LoanApplicant__c.ResidentialLoanApplication__r.Account__r.PersonMobilePhone"
    ]
  })
  LoanApplicantInfo({ error, data }) {
    this.setLoading(true);
    if (data) {
      this.loanApplicants = data.records;
      for (let applicant of data.records) {
        const fields = applicant.fields;
        let Id = applicant.id;
        if (fields.IsPrimary__c.value === true) {
          this.primaryApplicantId = [Id];
          this.selectedApplicantId = Id;
        }
      }
      this.initializeValuesIfRequired();
      this.error = undefined;
    } else if (error) {
      console.log("error " + JSON.stringify(error));
      this.error = error;
      this.loanApplicants = undefined;
    }
    this.setLoading(false);
  }

  initializeValuesIfRequired() {
    this.selectedApplicantId =
      this.selectedApplicantId || this.loanApplicants[0]?.id;
    this.primaryApplicantId =
      this.primaryApplicantId?.length > 0
        ? this.primaryApplicantId
        : [this.loanApplicants[0]?.id];
  }

  handleApplicantSelected(event) {
    this.setLoading(true);
    this.template
      .querySelector("c-hla-applicants-main")
      .clearData(this.selectedApplicantId);
    const selectedId = event.detail.applicantId;
    this.selectedApplicantId = selectedId;

    // this.setLoading(false);
  }

  setLoading(value) {
    this.isLoading = value;
  }
}
