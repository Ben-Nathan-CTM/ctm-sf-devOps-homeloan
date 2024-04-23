import { LightningElement, api, wire, track } from "lwc";
import { getRelatedListRecordsBatch } from "lightning/uiRelatedListApi";
import { refreshApex } from "@salesforce/apex";
//import { ShowToastEvent } from "lightning/platformShowToastEvent";
import LOAN_APPLICANT_OBJECT from "@salesforce/schema/LoanApplicant__c";
import LOAN_APPLICANT_ISPRIMARY from "@salesforce/schema/LoanApplicant__c.IsPrimary__c";
import LOAN_APPLICANT_FIRSTNAME from "@salesforce/schema/LoanApplicant__c.FirstName__c";
import LOAN_APPLICANT_LASTNAME from "@salesforce/schema/LoanApplicant__c.LastName__c";
import LOAN_APPLICANT_MIDDLENAME from "@salesforce/schema/LoanApplicant__c.MiddleName__c";
import LOAN_APPLICANT_DOB from "@salesforce/schema/LoanApplicant__c.DateOfBirth__c";
import LOAN_APPLICANT_MARITAL_STATUS from "@salesforce/schema/LoanApplicant__c.MaritalStatus__c";
import LOAN_APPLICANT_EMAIL from "@salesforce/schema/LoanApplicant__c.EmailAddress__c";
import LOAN_APPLICANT_MOBILE from "@salesforce/schema/LoanApplicant__c.WorkPhone__c";
import LOAN_APPLICANT_AUSPERM from "@salesforce/schema/LoanApplicant__c.AusPermResidentFlag__c";
import LOAN_APPLICANT_AUSRES from "@salesforce/schema/LoanApplicant__c.AusResidentStatus__c";
import LOAN_APPLICANT_SALUTATION from "@salesforce/schema/LoanApplicant__c.Salutation__c";
import LOAN_APPLICANT_OTHERNAMES from "@salesforce/schema/LoanApplicant__c.OtherNames__c";
import LOAN_APPLICANT_PREVNAMES from "@salesforce/schema/LoanApplicant__c.PreviousName__c";
import LOAN_APPLICANT_AGE from "@salesforce/schema/LoanApplicant__c.Age__c";
import LOAN_APPLICANT_EXITSTRAT from "@salesforce/schema/LoanApplicant__c.ExitStrategyCode__c";
import LOAN_APPLICANT_REPAYSTRAT from "@salesforce/schema/LoanApplicant__c.IncomeChangeLoanRepaymentStrategy__c";
import LOAN_APPLICANT_DEPENDCOUNT from "@salesforce/schema/LoanApplicant__c.DependentCount__c";
import LOAN_APPLICANT_DEPENDAGE from "@salesforce/schema/LoanApplicant__c.DependentsAge__c";
import LOAN_APPLICANT_CURRRESADDR from "@salesforce/schema/LoanApplicant__c.CurrentResidentialAddress__c";
import LOAN_APPLICANT_MAILADDR from "@salesforce/schema/LoanApplicant__c.MaillingAddress__c";
import LOAN_APPLICANT_BILLADDR from "@salesforce/schema/LoanApplicant__c.BillingAddress__c";
import LOAN_APPLICANT_POSTSETADDR from "@salesforce/schema/LoanApplicant__c.PostSettlementAddress__c";
import LOAN_APPLICANT_ARREARS from "@salesforce/schema/LoanApplicant__c.AnyExistingDebtsInArrears__c";
import LOAN_APPLICANT_HARDSHIP from "@salesforce/schema/LoanApplicant__c.AppliedforHardshipAssistance__c";
import LOAN_APPLICANT_CREDPROBLEMS from "@salesforce/schema/LoanApplicant__c.CreditProblems__c";
import LOAN_APPLICANT_DIFFMEETING from "@salesforce/schema/LoanApplicant__c.DifficultyMeetingFinancialCommitments__c";
import LOAN_APPLICANT_JUDGEMENTS from "@salesforce/schema/LoanApplicant__c.FinancialJudgementsorlegalproceeding__c";
import LOAN_APPLICANT_GUARANTOR from "@salesforce/schema/LoanApplicant__c.guarantorToAnyLoans__c";

const EMPLOYMENT_RELATEDLIST_API = "Loan_Applicant_Employment__r";
const INCOME_RELATEDLIST_API = "Loan_Applicant_Incomes1__r";
const EXPENSE_RELATEDLIST_API = "Loan_Applicant_Expenses1__r";
const EMPLOYMENT_RECORD_API = "LoanApplicantEmployment__c";
const INCOME_RECORD_API = "LoanApplicantIncome__c";
const EXPENSE_RECORD_API = "LoanApplicantExpense__c";
const APPLICANT_DETAILS_SECTION = "Applicant Details";

const primaryEmploymentColumns = [
  {
    label: "Type",
    fieldName: "employmentTypeURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "EmploymentType__c" } },
    fixedWidth: 200
  },
  {
    label: "Employer",
    fieldName: "CompanyName__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Industry",
    fieldName: "Industry__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Occupation",
    fieldName: "OverarchingOccupationOther__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Start Date",
    fieldName: "StartDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  }
];
const secondaryEmploymentColumns = [
  {
    label: "Type",
    fieldName: "employmentTypeURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "EmploymentType__c" } },
    fixedWidth: 200
  },
  {
    label: "Employer",
    fieldName: "CompanyName__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Industry",
    fieldName: "Industry__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Occupation",
    fieldName: "OverarchingOccupationOther__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Start Date",
    fieldName: "StartDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  }
];
const previousEmploymentColumns = [
  {
    label: "Type",
    fieldName: "employmentTypeURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "EmploymentType__c" } },
    fixedWidth: 200
  },
  {
    label: "Employer",
    fieldName: "CompanyName__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Industry",
    fieldName: "Industry__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Occupation",
    fieldName: "OverarchingOccupationOther__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Start Date",
    fieldName: "StartDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  }
];
const incomeColumns = [
  {
    label: "Type",
    fieldName: "incomeTypeURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "IncomeTypeAFG__c" } },
    fixedWidth: 200
  },
  {
    label: "Description",
    fieldName: "Description__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Payor",
    fieldName: "IncomeTypeAFG__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Amount",
    fieldName: "Amount__c",
    type: "currency",
    hideDefaultActions: "true"
  },
  {
    label: "Frequency",
    fieldName: "Frequency__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const expenseColumns = [
  {
    label: "Type",
    fieldName: "expenseTypeURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "ExpenseType__c" } },
    fixedWidth: 200
  },
  {
    label: "Description",
    fieldName: "Description__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Amount",
    fieldName: "Amount__c",
    type: "currency",
    hideDefaultActions: "true"
  },
  {
    label: "Frequency",
    fieldName: "Frequency__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Balance",
    fieldName: "OutstandingAmt__c",
    type: "currency",
    hideDefaultActions: "true"
  }
];

export default class HlaApplicantsMain extends LightningElement {
  _selectedApplicantId;
  _isLoading = false;

  @api
  get selectedApplicantId() {
    return this._selectedApplicantId;
  }
  set selectedApplicantId(value) {
    this._selectedApplicantId = value;
    this._isLoading = true;
  }

  @api
  get isLoading() {
    return this._isLoading;
  }
  set isLoading(value) {
    this._isLoading = value;
  }

  applicantObjectApiName = LOAN_APPLICANT_OBJECT;
  error;
  cachedResult = {};
  formFields = [
    LOAN_APPLICANT_ISPRIMARY,
    LOAN_APPLICANT_EMAIL,
    LOAN_APPLICANT_AUSPERM,
    LOAN_APPLICANT_MOBILE,
    LOAN_APPLICANT_SALUTATION,
    LOAN_APPLICANT_DOB,
    LOAN_APPLICANT_FIRSTNAME,
    LOAN_APPLICANT_AGE,
    LOAN_APPLICANT_MIDDLENAME,
    LOAN_APPLICANT_MARITAL_STATUS,
    LOAN_APPLICANT_LASTNAME,
    LOAN_APPLICANT_AUSRES,
    LOAN_APPLICANT_OTHERNAMES,
    LOAN_APPLICANT_DEPENDCOUNT,
    LOAN_APPLICANT_PREVNAMES,
    LOAN_APPLICANT_DEPENDAGE,
    LOAN_APPLICANT_EXITSTRAT,
    LOAN_APPLICANT_CURRRESADDR,
    LOAN_APPLICANT_REPAYSTRAT,
    LOAN_APPLICANT_MAILADDR,
    LOAN_APPLICANT_BILLADDR,
    LOAN_APPLICANT_POSTSETADDR,
    LOAN_APPLICANT_ARREARS,
    LOAN_APPLICANT_HARDSHIP,
    LOAN_APPLICANT_CREDPROBLEMS,
    LOAN_APPLICANT_DIFFMEETING,
    LOAN_APPLICANT_JUDGEMENTS,
    LOAN_APPLICANT_GUARANTOR
  ];
  relatedListAPIs = new Map([
    [EMPLOYMENT_RECORD_API, {}],
    [INCOME_RECORD_API, []],
    [EXPENSE_RECORD_API, []]
  ]);
  primaryEmploymentColumns = primaryEmploymentColumns;
  secondaryEmploymentColumns = secondaryEmploymentColumns;
  previousEmploymentColumns = previousEmploymentColumns;
  incomeColumns = incomeColumns;
  expenseColumns = expenseColumns;
  relatedListRecords;
  NO_RECORDS_MESSAGE = "No Records To Display";
  activeSections = [APPLICANT_DETAILS_SECTION];

  hasEmploymentRecords = false;
  hasExpenseRecords = false;
  hasIncomeRecords = false;

  @track employmentRecords = {};
  @track incomeRecords = {};
  @track expenseRecords = {};

  @wire(getRelatedListRecordsBatch, {
    parentRecordId: "$selectedApplicantId",
    relatedListParameters: [
      {
        relatedListId: EMPLOYMENT_RELATEDLIST_API,
        fields: [
          "LoanApplicantEmployment__c.StartDate__c",
          "LoanApplicantEmployment__c.OverarchingOccupationOther__c",
          "LoanApplicantEmployment__c.Industry__c",
          "LoanApplicantEmployment__c.CompanyName__c",
          "LoanApplicantEmployment__c.IsCurrent__c",
          "LoanApplicantEmployment__c.IsAdditional__c",
          "LoanApplicantEmployment__c.EmploymentType__c"
        ]
      },
      {
        relatedListId: INCOME_RELATEDLIST_API,
        fields: [
          "LoanApplicantIncome__c.IncomeTypeAFG__c",
          "LoanApplicantIncome__c.Description__c",
          "LoanApplicantIncome__c.Amount__c",
          "LoanApplicantIncome__c.Frequency__c"
        ]
      },
      {
        relatedListId: EXPENSE_RELATEDLIST_API,
        fields: [
          "LoanApplicantExpense__c.ExpenseType__c",
          "LoanApplicantExpense__c.Description__c",
          "LoanApplicantExpense__c.Amount__c",
          "LoanApplicantExpense__c.Frequency__c",
          "LoanApplicantExpense__c.OutstandingAmt__c"
        ]
      }
    ]
  })
  listInfo(result) {
    this._isLoading = true;
    if (this.selectedApplicantId) {
      this.cachedResult[this.selectedApplicantId] = result;
    }
    if (result.data) {
      this.relatedListRecords = Object.fromEntries(this.relatedListAPIs);
      for (let relatedList of result.data.results) {
        if (relatedList.statusCode !== 200) {
          continue;
        }
        const records = relatedList.result.records;
        for (let record of records) {
          let apiName = record.apiName;
          let formattedRecord = {};
          let isCurrent = false;
          let isAdditional = false;
          formattedRecord.id = record.id;
          const fields = record.fields;
          const ownProps = Object.getOwnPropertyNames(fields);
          for (let field in fields) {
            if (ownProps.includes(field)) {
              let currentValue = fields[field].value;
              let displayValue = fields[field].displayValue;
              formattedRecord[field] = displayValue
                ? displayValue
                : currentValue;
              if (field === "IsCurrent__c" && currentValue === true) {
                isCurrent = true;
              }
              if (field === "IsAdditional__c" && currentValue === true) {
                isAdditional = true;
              }
            }
          }
          if (apiName === EMPLOYMENT_RECORD_API) {
            this.processEmploymentRecord(
              formattedRecord,
              isCurrent,
              isAdditional
            );
          } else {
            formattedRecord.incomeTypeURL = "/" + formattedRecord.id;
            formattedRecord.expenseTypeURL = "/" + formattedRecord.id;
            this.relatedListRecords[apiName].push(formattedRecord);
          }
        }
      }
      this.employmentRecords = this.relatedListRecords[EMPLOYMENT_RECORD_API];
      this.incomeRecords = this.relatedListRecords[INCOME_RECORD_API];
      this.expenseRecords = this.relatedListRecords[EXPENSE_RECORD_API];
      this.hasIncomeRecords = this.incomeRecords.length > 0;
      this.hasExpenseRecords = this.expenseRecords.length > 0;
      this.error = undefined;
    } else if (result.error) {
      this.error = result.error;
      this.relatedListRecords = undefined;
    }
    this._isLoading = false;
  }

  @api
  clearData(applicantId) {
    this.relatedListAPIs = new Map([
      [EMPLOYMENT_RECORD_API, {}],
      [INCOME_RECORD_API, []],
      [EXPENSE_RECORD_API, []]
    ]);
    this.relatedListRecords = {};
    this.employmentRecords = {};
    this.incomeRecords = {};
    this.expenseRecords = {};
    this.hasEmploymentRecords = false;
    this.hasIncomeRecords = false;
    this.hasExpenseRecords = false;
    refreshApex(this.cachedResult[applicantId]);
  }

  processEmploymentRecord(formattedRecord, isCurrent, isAdditional) {
    formattedRecord.employmentTypeURL = "/" + formattedRecord.id;
    this.hasEmploymentRecords = true;
    let recordKey = "previous";
    if (isCurrent) {
      recordKey = "primary";
      if (isAdditional) {
        recordKey = "secondary";
      }
    }
    let currentRecords =
      this.relatedListRecords[EMPLOYMENT_RECORD_API][recordKey] ?? [];
    currentRecords.push(formattedRecord);
    this.relatedListRecords[EMPLOYMENT_RECORD_API][recordKey] = currentRecords;
  }
}
