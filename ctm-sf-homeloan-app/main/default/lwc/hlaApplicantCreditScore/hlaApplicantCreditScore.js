import { LightningElement, api, wire } from "lwc";
import { formattedRecord } from "c/utils";
import { gql, graphql } from "lightning/uiGraphQLApi";
import { NavigationMixin } from "lightning/navigation";

const BANKRUPTCY_ACTIONS_RELATED_LIST = "Bankruptcy_Actions__r";
const CREDIT_ACCOUNTS_RELATED_LIST = "Credit_Accounts__r";
const CREDIT_DEFAULTS_RELATED_LIST = "Credit_Defaults__r";
const CREDIT_ENQUIRIES_RELATED_LIST = "Credit_Enquiries__r";
const COURT_ACTIONS_RELATED_LIST = "Court_Actions__r";
const LATE_PAYMENTS_RELATED_LIST = "Late_Payments__r";
const CREDIT_SCORE_RELATED_LIST = "Credit_Score__r";

const BANKRUPTCY_ACTIONS_OBJECT_API = "BankruptcyAction__c";
const CREDIT_ACCOUNTS_OBJECT_API = "CreditAccount__c";
const CREDIT_DEFAULTS_OBJECT_API = "CreditDefault__c";
const CREDIT_ENQUIRIES_OBJECT_API = "CreditEnquiry__c";
const COURT_ACTIONS_OBJECT_API = "CourtAction__c";
const LATE_PAYMENTS_OBJECT_API = "LatePayment__c";
const CREDITSCORE_OBJECT_API = "CreditScore__c";

const creditAccountColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Ref",
    fieldName: "AccountRef__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Type",
    fieldName: "AccountType__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Limit",
    fieldName: "CreditLimit__c",
    type: "currency",
    hideDefaultActions: "true"
  },
  {
    label: "Reported",
    fieldName: "LastReported__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Opened",
    fieldName: "OpenDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Pay Terms",
    fieldName: "PaymentTerms__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text",
    hideDefaultActions: "true",
    fixedWidth: 100
  }
];
const creditEnquiriesColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Industry",
    fieldName: "Industry__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Type",
    fieldName: "Type__c",
    type: "text",
    hideDefaultActions: "true",
    fixedWidth: 100
  },
  {
    label: "Amount",
    fieldName: "Amount__c",
    type: "currency",
    hideDefaultActions: "true"
  },
  {
    label: "Date",
    fieldName: "Date__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Purpose",
    fieldName: "Purpose__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const creditDefaultsColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Ref",
    fieldName: "RefNumber__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Type",
    fieldName: "AccountType__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Amount",
    fieldName: "DefaultAmount__c",
    type: "currency",
    hideDefaultActions: "true"
  },

  {
    label: "Date",
    fieldName: "Date__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Bank",
    fieldName: "Bank__c",
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
    label: "Status",
    fieldName: "Status__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const latePaymentsColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Ref",
    fieldName: "AccountRef__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Type",
    fieldName: "AccountType__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Limit",
    fieldName: "CreditLimit__c",
    type: "currency",
    hideDefaultActions: "true"
  },
  {
    label: "Reported",
    fieldName: "LastReported__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Opened",
    fieldName: "OpenDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Bank",
    fieldName: "Bank__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Pay Terms",
    fieldName: "PaymentTerms__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const courtActionColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Court",
    fieldName: "CourtDetails__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Plantiff",
    fieldName: "Plaintiff__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Plantiff Num",
    fieldName: "PlaintiffNumber__c",
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
    label: "Reported",
    fieldName: "DateReported__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Court Types",
    fieldName: "PublicActionTypes__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const bankruptcyActionsColumns = [
  {
    label: "Name",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: {
      label: { fieldName: "Name" }
    },
    fixedWidth: 180
  },
  {
    label: "Ref",
    fieldName: "RefNumber__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Type",
    fieldName: "Type__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Date",
    fieldName: "Date__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Start Date",
    fieldName: "StartDate__c",
    type: "date-local",
    hideDefaultActions: "true"
  },
  {
    label: "Trustee",
    fieldName: "TrusteeNumber__c",
    type: "number",
    hideDefaultActions: "true"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text",
    hideDefaultActions: "true"
  }
];

export default class HlaApplicantCreditScore extends NavigationMixin(
  LightningElement
) {
  _creditScoreId;
  _isLoading = true;

  @api
  get isLoading() {
    return this._isLoading;
  }

  set isLoading(value) {
    this._isLoading = value;
  }
  @api recordId;
  cachedResult = {};

  creditScore;
  creditScorePerThousand;
  hasCreditScore = false;

  creditAccountColumns = creditAccountColumns;
  creditEnquiriesColumns = creditEnquiriesColumns;
  creditDefaultsColumns = creditDefaultsColumns;
  latePaymentsColumns = latePaymentsColumns;
  courtActionColumns = courtActionColumns;
  bankruptcyActionsColumns = bankruptcyActionsColumns;

  numOfCreditAccounts;
  numOfCreditEnquiries;
  numOfCreditDefaults;
  numOfLatePayments;
  numOfBankruptcyActions;
  numOfCourtActions;

  get hasCreditAccounts() {
    return this.numOfCreditAccounts > 0;
  }
  get hasCreditEnquiries() {
    return this.numOfCreditEnquiries > 0;
  }
  get hasCreditDefaults() {
    return this.numOfCreditDefaults > 0;
  }
  get hasLatePayments() {
    return this.numOfLatePayments > 0;
  }
  get hasCourtActions() {
    return this.numOfCourtActions > 0;
  }
  get hasBankruptcyActions() {
    return this.numOfBankruptcyActions > 0;
  }

  creditAccountRecords;
  creditEnquiriesRecords;
  creditDefaultsRecords;
  latePaymentsRecords;
  courtActionRecords;
  bankruptcyActionsRecords;

  objectApiMap = {
    [BANKRUPTCY_ACTIONS_RELATED_LIST]: BANKRUPTCY_ACTIONS_OBJECT_API,
    [CREDIT_ACCOUNTS_RELATED_LIST]: CREDIT_ACCOUNTS_OBJECT_API,
    [CREDIT_DEFAULTS_RELATED_LIST]: CREDIT_DEFAULTS_OBJECT_API,
    [CREDIT_ENQUIRIES_RELATED_LIST]: CREDIT_ENQUIRIES_OBJECT_API,
    [COURT_ACTIONS_RELATED_LIST]: COURT_ACTIONS_OBJECT_API,
    [LATE_PAYMENTS_RELATED_LIST]: LATE_PAYMENTS_OBJECT_API,
    [CREDIT_SCORE_RELATED_LIST]: CREDITSCORE_OBJECT_API
  };

  relatedListRecords;

  @wire(graphql, {
    query: gql`
      query loanApplicantCreditInfo($loanApplicantId: ID) {
        uiapi {
          query {
            CreditScore__c(
              where: { LoanApplicant__c: { eq: $loanApplicantId } }
            ) {
              edges {
                cursor
                node {
                  Id
                  CreditScore__c {
                    value
                  }
                  Bankruptcy_Actions__r {
                    edges {
                      node {
                        Id
                        Name {
                          value
                        }
                        ExternalId__c {
                          value
                        }
                        Date__c {
                          value
                        }
                        RefNumber__c {
                          value
                        }
                        StartDate__c {
                          value
                        }
                        TrusteeNumber__c {
                          value
                        }
                        Type__c {
                          value
                        }
                        Status__c {
                          value
                        }
                      }
                    }
                  }
                  Credit_Accounts__r {
                    edges {
                      node {
                        Id
                        AccountRef__c {
                          value
                        }
                        AccountType__c {
                          value
                        }
                        Name {
                          value
                        }
                        CreditLimit__c {
                          value
                        }
                        LastReported__c {
                          value
                        }
                        OpenDate__c {
                          value
                        }
                        PaymentTerms__c {
                          value
                        }
                        Status__c {
                          value
                        }
                      }
                    }
                  }
                  Credit_Defaults__r {
                    edges {
                      node {
                        Id
                        Name {
                          value
                        }
                        ExternalId__c {
                          value
                        }
                        RefNumber__c {
                          value
                        }
                        AccountType__c {
                          value
                        }
                        Bank__c {
                          value
                        }
                        Date__c {
                          value
                        }
                        DefaultAmount__c {
                          value
                        }
                        Industry__c {
                          value
                        }
                        Status__c {
                          value
                        }
                      }
                    }
                  }
                  Credit_Enquiries__r {
                    edges {
                      node {
                        Id
                        Name {
                          value
                        }
                        ExternalId__c {
                          value
                        }
                        Amount__c {
                          value
                        }
                        Date__c {
                          value
                        }
                        Industry__c {
                          value
                        }
                        Purpose__c {
                          value
                        }
                        Type__c {
                          value
                        }
                      }
                    }
                  }
                  Court_Actions__r {
                    edges {
                      node {
                        Id
                        Name {
                          value
                        }
                        ExternalId__c {
                          value
                        }
                        Amount__c {
                          value
                        }
                        CourtDetails__c {
                          value
                        }
                        DateReported__c {
                          value
                        }
                        Plaintiff__c {
                          value
                        }
                        PlaintiffNumber__c {
                          value
                        }
                        PublicActionTypes__c {
                          value
                        }
                        Status__c {
                          value
                        }
                      }
                    }
                  }
                  Late_Payments__r {
                    edges {
                      node {
                        Id
                        Name {
                          value
                        }
                        ExternalId__c {
                          value
                        }
                        AccountRef__c {
                          value
                        }
                        AccountType__c {
                          value
                        }
                        Bank__c {
                          value
                        }
                        CreditLimit__c {
                          value
                        }
                        LastReported__c {
                          value
                        }
                        OpenDate__c {
                          value
                        }
                        PaymentTerms__c {
                          value
                        }
                        Status__c {
                          value
                        }
                      }
                    }
                  }
                }
              }
              totalCount
              pageInfo {
                hasNextPage
                hasPreviousPage
                startCursor
                endCursor
              }
            }
          }
        }
      }
    `,
    variables: "$variables" // Use a getter function to make the variables reactive
  })
  graphqlQueryResult(result) {
    if (result) {
      this.clearData();
      this.cachedResult = result;
      this.loading(true);
      if (result.data) {
        this.processGraphResults(
          result.data?.uiapi?.query[CREDITSCORE_OBJECT_API]
        );
        this.calculateRecordsAndProperties();
        this.error = undefined;
        this.loading(false);
      } else if (result.error) {
        console.error(JSON.stringify(result.error));
        this.error = result.error;
        this.relatedListRecords = undefined;
        this.loading(false);
      }
    }
  }

  get variables() {
    return {
      loanApplicantId: this.recordId
    };
  }

  loading(isLoading) {
    this._isLoading = isLoading;
  }

  processGraphResults(graphResults) {
    let nodes = graphResults?.edges?.map((edge) => edge.node);
    let nodeObj = this.getAndThenRemoveCreditScoreFields(nodes[0]);
    const ownProps = Object.getOwnPropertyNames(nodeObj);
    for (let node in nodeObj) {
      if (ownProps.includes(node)) {
        let relatedListApiName = node;
        let innerNode = nodeObj[node]?.edges?.map((edge) => edge.node);
        for (let record of innerNode) {
          let fRecord = new formattedRecord(record?.Id);
          const recordOwnProps = Object.getOwnPropertyNames(record);
          for (let field in record) {
            if (recordOwnProps.includes(field)) {
              let rawValue = record[field];
              let currentValue = record[field]?.value;
              let displayValue = record[field]?.displayValue;
              fRecord[field] = displayValue
                ? displayValue
                : currentValue
                ? currentValue
                : rawValue;
            }
          }
          let currentObjectAPI = this.objectApiMap[relatedListApiName];
          this.relatedListRecords[currentObjectAPI]?.push(fRecord);
        }
      }
    }
  }

  getAndThenRemoveCreditScoreFields(nodeObj) {
    let processedNodeObj = Object.assign({}, nodeObj);
    if (nodeObj?.Id) {
      this.hasCreditScore = true;
      this._creditScoreId = nodeObj?.Id;
      this.creditScore = nodeObj?.CreditScore__c?.value || 0;
      this.creditScorePerThousand = (this.creditScore / 1000) * 100;
      delete processedNodeObj.Id;
      delete processedNodeObj.CreditScore__c;
    }
    return processedNodeObj;
  }

  calculateRecordsAndProperties() {
    this.creditAccountRecords =
      this.relatedListRecords[CREDIT_ACCOUNTS_OBJECT_API];
    this.creditEnquiriesRecords =
      this.relatedListRecords[CREDIT_ENQUIRIES_OBJECT_API];
    this.creditDefaultsRecords =
      this.relatedListRecords[CREDIT_DEFAULTS_OBJECT_API];
    this.latePaymentsRecords =
      this.relatedListRecords[LATE_PAYMENTS_OBJECT_API];
    this.bankruptcyActionsRecords =
      this.relatedListRecords[BANKRUPTCY_ACTIONS_OBJECT_API];
    this.courtActionRecords = this.relatedListRecords[COURT_ACTIONS_OBJECT_API];

    this.numOfCreditAccounts = this.creditAccountRecords?.length;
    this.numOfCreditEnquiries = this.creditEnquiriesRecords?.length;
    this.numOfCreditDefaults = this.creditDefaultsRecords?.length;
    this.numOfLatePayments = this.latePaymentsRecords?.length;
    this.numOfBankruptcyActions = this.bankruptcyActionsRecords?.length;
    this.numOfCourtActions = this.courtActionRecords?.length;
  }

  clearData() {
    this.relatedListRecords = Object.assign(
      {},
      Object.fromEntries(this.relatedListAPIsMap())
    );
    this.creditScore = null;
    this.creditScorePerThousand = null;
    this.hasCreditScore = false;

    this.creditAccountRecords = null;
    this.creditEnquiriesRecords = null;
    this.creditDefaultsRecords = null;
    this.latePaymentsRecords = null;
    this.bankruptcyActionsRecords = null;
    this.courtActionRecords = null;

    this.numOfCreditAccounts = 0;
    this.numOfCreditEnquiries = 0;
    this.numOfCreditDefaults = 0;
    this.numOfLatePayments = 0;
    this.numOfBankruptcyActions = 0;
    this.numOfCourtActions = 0;
  }

  relatedListAPIsMap() {
    return new Map([
      [BANKRUPTCY_ACTIONS_OBJECT_API, new Array()],
      [CREDIT_ACCOUNTS_OBJECT_API, new Array()],
      [CREDIT_DEFAULTS_OBJECT_API, new Array()],
      [CREDIT_ENQUIRIES_OBJECT_API, new Array()],
      [COURT_ACTIONS_OBJECT_API, new Array()],
      [LATE_PAYMENTS_OBJECT_API, new Array()]
    ]);
  }

  handleCreditScoreClick(event) {
    event.preventDefault();
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this._creditScoreId,
        objectApiName: CREDITSCORE_OBJECT_API,
        actionName: "view"
      }
    });
  }
}
