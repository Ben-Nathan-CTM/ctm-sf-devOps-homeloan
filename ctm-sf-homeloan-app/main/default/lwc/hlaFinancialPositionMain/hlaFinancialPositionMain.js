import { LightningElement, api, wire, track } from "lwc";
import { getRelatedListRecordsBatch } from "lightning/uiRelatedListApi";
import { formattedRecord } from "c/utils";

const ASSETS_RELATEDLIST_API = "Loan_Application_Assets__r";
const LIABILITIES_RELATEDLIST_API = "Loan_Application_Liabilities__r";
const INCOME_RELATEDLIST_API = "Loan_Application_Income__r";
const EXPENSE_RELATEDLIST_API = "Loan_Application_Expense__r";

const ASSETS_RECORD_API = "LoanApplicationAsset__c";
const LIABILITY_RECORD_API = "LoanApplicationLiability__c";
const INCOME_RECORD_API = "LoanApplicationIncome__c";
const EXPENSE_RECORD_API = "LoanApplicationExpense__c";

const NO_ASSETS_MESSAGE = "No Assets To Display";
const NO_LIABILITIES_MESSAGE = "No Liabilities To Display";
const NO_INCOME_MESSAGE = "No Income To Display";
const NO_EXPENSES_MESSAGE = "No Expenses To Display";

const ASSET_AMOUNT_COLUMN = "EstimatedValue__c";
const LIABILITIES_AMOUNT_COLUMN = "OutstandingBalance__c";
const INCOME_AMOUNT_COLUMN = "Amount__c";
const LOAN_EXPENSE_AMOUNT_COLUMN = "Amount__c";
const LOAN_INCOME_FREQUENCY_COLUMN = "Frequency__c";
const LOAN_EXPENSE_FREQUENCY_COLUMN = "Frequency__c";

const DEBT_EXPENSE_TYPE = "Debt Expense";
const LIVING_EXPENSE_TYPE = "Living Expense";

const ASSET_TOTALS = "assetTotals";
const LIABILITIES_TOTALS = "liabilitiesTotals";
const INCOME_TOTALS = "incomeTotals";
const LIVING_EXPENSE_TOTALS = "livingExpenseTotals";
const DEBT_EXPENSE_TOTALS = "debtExpenseTotals";

const WEEKLY = "Weekly";
const MONTHLY = "Monthly";
const FORTNIGHTLY = "Fortnightly";
const QUARTERLY = "Quarterly";
const HALF_YEARLY = "Half Yearly";
const ANNUALLY = "Annually";

const assetColumns = [
  {
    label: "Type",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "AssetType__c" } },
    fixedWidth: 200
  },
  {
    label: "Description",
    fieldName: "Description__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Institution",
    fieldName: "Institution__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Estimated Value",
    fieldName: "EstimatedValue__c",
    type: "text",
    hideDefaultActions: "true"
  }
];
const liabilitiesColumns = [
  {
    label: "Type",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "Type__c" } },
    fixedWidth: 200
  },
  {
    label: "Description",
    fieldName: "Description__c",
    type: "text",
    hideDefaultActions: "true"
  },
  {
    label: "Creditor",
    fieldName: "Creditor__c",
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
    label: "Balance",
    fieldName: "OutstandingBalance__c",
    type: "currency",
    hideDefaultActions: "true"
  }
];
const incomeColumns = [
  {
    label: "Type",
    fieldName: "recordURL",
    type: "url",
    hideDefaultActions: "true",
    typeAttributes: { label: { fieldName: "Type__c" } },
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
const expenseColumns = [
  {
    label: "Type",
    fieldName: "recordURL",
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
    type: "text",
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
    fieldName: "OutstandingAmount__c",
    type: "currency",
    hideDefaultActions: "true"
  }
];

const frequencyMultiplierMatrix = {
  Weekly: { Weekly: 1, Fortnightly: 1 / 2, Monthly: 1 / 4, Annually: 1 / 52 },
  Fortnightly: { Weekly: 1 / 2, Fortnightly: 1, Monthly: 2, Annually: 24 },
  Monthly: { Weekly: 4, Fortnightly: 2, Monthly: 1, Annually: 1 / 12 },
  Quarterly: { Weekly: 12, Fortnightly: 6, Monthly: 3, Annually: 1 / 4 },
  "Half Yearly": { Weekly: 26, Fortnightly: 12, Monthly: 6, Annually: 1 / 2 },
  Annually: { Weekly: 52, Fortnightly: 24, Monthly: 12, Annually: 1 }
};

export default class HlaFinancialPositionMain extends LightningElement {
  @api
  isLoading = false;

  @api
  applicationId;

  @track assetRecords = [];
  @track liabilitiesRecords = [];
  @track incomeRecords = [];
  @track debtExpenseRecords = [];
  @track livingExpenseRecords = [];

  frequencyChoices = [
    { label: "Weekly", value: WEEKLY },
    { label: "Fortnightly", value: FORTNIGHTLY },
    { label: "Monthly", value: MONTHLY },
    { label: "Quarterly", value: QUARTERLY },
    { label: "Half Yearly", value: HALF_YEARLY },
    { label: "Annually", value: ANNUALLY }
  ];

  frequencyMultiplierMatrix = frequencyMultiplierMatrix;

  relatedListRecords;
  expenseRecords;

  hasAssets = false;
  hasLiabilities = false;
  hasIncome = false;
  hasDebtExpenses = false;
  hasLivingExpenses = false;

  assetTotals;
  liabilitiesTotals;
  incomeTotals;
  debtExpenseTotals;
  livingExpenseTotals;

  error;
  cachedResult = {};
  selectedFrequency = MONTHLY;
  relatedListAPIs = new Map([
    [ASSETS_RECORD_API, new Array()],
    [LIABILITY_RECORD_API, new Array()],
    [INCOME_RECORD_API, new Array()],
    [EXPENSE_RECORD_API, new Array()]
  ]);

  assetColumns = assetColumns;
  incomeColumns = incomeColumns;
  liabilitiesColumns = liabilitiesColumns;
  expenseColumns = expenseColumns;

  NO_ASSETS_MESSAGE = NO_ASSETS_MESSAGE;
  NO_LIABILITIES_MESSAGE = NO_LIABILITIES_MESSAGE;
  NO_INCOME_MESSAGE = NO_INCOME_MESSAGE;
  NO_EXPENSES_MESSAGE = NO_EXPENSES_MESSAGE;

  @wire(getRelatedListRecordsBatch, {
    parentRecordId: "$applicationId",
    relatedListParameters: [
      {
        relatedListId: ASSETS_RELATEDLIST_API,
        fields: [
          "LoanApplicationAsset__c.AssetType__c",
          "LoanApplicationAsset__c.Description__c",
          "LoanApplicationAsset__c.Institution__c",
          "LoanApplicationAsset__c.EstimatedValue__c"
        ]
      },
      {
        relatedListId: LIABILITIES_RELATEDLIST_API,
        fields: [
          "LoanApplicationLiability__c.Type__c",
          "LoanApplicationLiability__c.Description__c",
          "LoanApplicationLiability__c.Creditor__c",
          "LoanApplicationLiability__c.CreditLimit__c",
          "LoanApplicationLiability__c.OutstandingBalance__c"
        ]
      },
      {
        relatedListId: INCOME_RELATEDLIST_API,
        fields: [
          "LoanApplicationIncome__c.Type__c",
          "LoanApplicationIncome__c.Description__c",
          "LoanApplicationIncome__c.Amount__c",
          "LoanApplicationIncome__c.Frequency__c"
        ]
      },
      {
        relatedListId: EXPENSE_RELATEDLIST_API,
        fields: [
          "LoanApplicationExpense__c.ExpenseType__c",
          "LoanApplicationExpense__c.Description__c",
          "LoanApplicationExpense__c.Amount__c",
          "LoanApplicationExpense__c.Frequency__c",
          "LoanApplicationExpense__c.OutstandingAmount__c"
        ]
      }
    ]
  })
  listInfo(result) {
    this.cachedResult = result;
    if (result.data) {
      this.loading(true);
      this.processRelatedLists(result.data.results);
      this.setInternalFields();
      this.calculateTotals();
      this.error = undefined;
    } else if (result.error) {
      console.log(JSON.stringify(result.error));
      this.error = result.error;
      this.relatedListRecords = undefined;
    }
    this.loading(false);
  }

  loading(isloading) {
    const eventName = isloading ? "loading" : "loadingdone";
    this.dispatchEvent(new CustomEvent(eventName));
  }

  processRelatedLists(relatedLists) {
    this.relatedListRecords = Object.fromEntries(this.relatedListAPIs);
    for (let relatedList of relatedLists) {
      if (relatedList.statusCode !== 200) {
        continue;
      }
      const records = relatedList.result.records;
      for (let record of records) {
        let recordApiName = record.apiName;
        let fRecord = new formattedRecord(record.id);
        const fields = record.fields;
        const ownProps = Object.getOwnPropertyNames(fields);
        for (let field in fields) {
          if (ownProps.includes(field)) {
            let currentValue = fields[field].value;
            let displayValue = fields[field].displayValue;
            fRecord[field] = displayValue ? displayValue : currentValue;
          }
        }
        this.relatedListRecords[recordApiName].push(fRecord);
      }
    }
  }

  setInternalFields() {
    this.assetRecords = this.relatedListRecords[ASSETS_RECORD_API];
    this.liabilitiesRecords = this.relatedListRecords[LIABILITY_RECORD_API];
    this.incomeRecords = this.relatedListRecords[INCOME_RECORD_API];
    this.separateExpenseRecords(this.relatedListRecords[EXPENSE_RECORD_API]);
    this.hasAssets = this.assetRecords.length > 0;
    this.hasLiabilities = this.liabilitiesRecords.length > 0;
    this.hasIncome = this.incomeRecords.length > 0;
    this.hasDebtExpenses = this.debtExpenseRecords.length > 0;
    this.hasLivingExpenses = this.livingExpenseRecords.length > 0;
  }

  separateExpenseRecords(expenseRecords) {
    if (expenseRecords) {
      for (let expense of expenseRecords) {
        if (expense.ExpenseType__c === DEBT_EXPENSE_TYPE) {
          this.debtExpenseRecords.push(expense);
        } else if (expense.ExpenseType__c === LIVING_EXPENSE_TYPE) {
          this.livingExpenseRecords.push(expense);
        }
      }
    }
  }

  calculateTotals() {
    this.assetTotals = "Total Assets: $";
    this.liabilitiesTotals = "Total Liabilities: $";
    this.incomeTotals = "Total Income: $";
    this.debtExpenseTotals = "Debt Expense Totals: $";
    this.livingExpenseTotals = "Living Expense Totals: $";

    const recordInfoArray = [
      [this.assetRecords, ASSET_AMOUNT_COLUMN, ASSET_TOTALS],
      [this.liabilitiesRecords, LIABILITIES_AMOUNT_COLUMN, LIABILITIES_TOTALS],
      [
        this.incomeRecords,
        INCOME_AMOUNT_COLUMN,
        INCOME_TOTALS,
        LOAN_INCOME_FREQUENCY_COLUMN
      ],
      [
        this.livingExpenseRecords,
        LOAN_EXPENSE_AMOUNT_COLUMN,
        LIVING_EXPENSE_TOTALS,
        LOAN_EXPENSE_FREQUENCY_COLUMN
      ],
      [
        this.debtExpenseRecords,
        LOAN_EXPENSE_AMOUNT_COLUMN,
        DEBT_EXPENSE_TOTALS,
        LOAN_EXPENSE_FREQUENCY_COLUMN
      ]
    ];

    recordInfoArray.forEach((recordInfo) => {
      let listOfrecords, columnToTotal, totalsField, frequency;
      [listOfrecords, columnToTotal, totalsField, frequency] = [...recordInfo];
      let valuesToTotal = listOfrecords?.map((record) => {
        let multiplier =
          this.frequencyMultiplierMatrix[this.selectedFrequency][
            record[frequency]
          ] ?? 1;
        let value =
          record[columnToTotal]?.replace("$", "").replace(",", "") ?? 0;
        return Object.assign({}, { value: value, multiplier: multiplier });
      });
      let columnTotal = valuesToTotal.reduce(
        (accumulator, currentValue) =>
          accumulator +
          (currentValue
            ? Number.parseFloat(currentValue.value) * currentValue.multiplier
            : 0),
        0
      );
      columnTotal = columnTotal.toLocaleString("en-US", {
        minimumFractionDigits: 2
      });
      this[totalsField] += `${columnTotal}`;
    });
  }

  handleFrequecyChange(event) {
    this.selectedFrequency = event.detail.value;
    this.calculateTotals();
  }
}
