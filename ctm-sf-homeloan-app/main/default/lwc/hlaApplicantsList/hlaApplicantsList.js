import { LightningElement, api } from "lwc";

const columns = [
  {
    label: "Primary",
    fieldName: "IsPrimary__c",
    type: "boolean",
    hideDefaultActions: "true",
    fixedWidth: 100
  },
  {
    label: "Title",
    fieldName: "Salutation__c",
    type: "text",
    hideDefaultActions: "true",
    fixedWidth: 80
  },
  {
    label: "First Name",
    fieldName: "nameURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "FirstName__c" } }
  },
  {
    label: "Middle Name",
    fieldName: "MiddleName__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Last Name",
    fieldName: "LastName__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "DOB",
    fieldName: "DateOfBirth__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Marital Status",
    fieldName: "MaritalStatus__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Email",
    fieldName: "EmailAddress__c",
    type: "email",
    hideDefaultActions: "true"
  },
  {
    label: "Mobile",
    fieldName: "PersonMobilePhone",
    type: "text",
    hideDefaultActions: "true"
  }
];

export default class HlaApplicantsList extends LightningElement {
  applicantsFormatted = false;
  columns = columns;
  _formattedApplicantData = [];

  @api primaryApplicantId = [];

  @api
  get applicants() {
    return this._formattedApplicantData;
  }
  set applicants(applicantRecords) {
    this._formattedApplicantData = this.formatApplicantData(applicantRecords);
    this.applicantsFormatted = true;
  }

  formatApplicantData(applicantRecords) {
    return applicantRecords.map((applicant) => {
      let formattedApplicant = {};
      formattedApplicant.id = applicant.id;
      formattedApplicant.nameURL = "/" + applicant.id;
      const fields = applicant.fields;
      const ownProps = Object.getOwnPropertyNames(fields);
      for (let field in fields) {
        if (ownProps.includes(field)) {
          this.mapFieldData(field, fields, formattedApplicant);
        }
      }
      return this.clearNonPrimaryData(formattedApplicant);
    });
  }

  mapFieldData(field, fields, formattedApplicant) {
    let currentField = field;
    let currentFieldValue = fields[field];
    if (currentField.endsWith("__r")) {
      let currentFields;
      let newFields;
      const traverseRelationshipRecursively = (fieldsToCheck) => {
        currentFields = fieldsToCheck?.value?.fields
          ? fieldsToCheck.value.fields
          : fieldsToCheck;
        if (currentFields) {
          for (const [fieldName, fieldValue] of Object.entries(currentFields)) {
            currentField = fieldName;
            currentFieldValue = fieldValue;
            if (currentField.endsWith("__r")) {
              newFields = currentFieldValue?.value?.fields;
              traverseRelationshipRecursively(newFields);
            }
          }
        }
      };
      traverseRelationshipRecursively(currentFieldValue);
    }
    formattedApplicant[currentField] = currentFieldValue.displayValue
      ? currentFieldValue.displayValue
      : currentFieldValue.value;
  }

  clearNonPrimaryData(formattedApplicant) {
    return formattedApplicant.IsPrimary__c
      ? formattedApplicant
      : Object.assign({}, formattedApplicant, {
          PersonMobilePhone: null
        });
  }

  handleRowSelect(event) {
    const selectedId = event.detail.selectedRows[0].id;
    const selectEvent = new CustomEvent("select", {
      detail: { applicantId: selectedId }
    });
    this.dispatchEvent(selectEvent);
  }
}
