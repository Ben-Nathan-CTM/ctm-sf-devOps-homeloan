import { api, LightningElement, wire, track } from "lwc";
import { refreshApex } from "@salesforce/apex";
import getFilteredSNotes from "@salesforce/apex/HLA_SNotesService.getFilteredSNoteData";
import HlaSNoteFlowModal from "c/hlaSNoteFlowModal";

const columns = [
  {
    label: "Date",
    fieldName: "Date",
    type: "date"
  },
  { label: "Title", fieldName: "Title" },
  {
    label: "Note",
    fieldName: "TextPreview"
  }
];

export default class HLASnoteWithFocusedTab extends LightningElement {
  @api
  currentFocusedTab;
  @api
  recordId;

  @track data = [];
  columns = columns;
  @track inputVariables = [];
  error;
  wiredSnotes;

  @wire(getFilteredSNotes, {
    relatedRecordId: "$recordId",
    filter: "$currentFocusedTab"
  })
  filteredSnotes(value) {
    this.wiredSnotes = value;
    const { data, error } = value;
    if (data) {
      this.data = data.map((record) => {
        return {
          id: record.id,
          Date: record.ContentDocument.CreatedDate,
          Title: record.ContentDocument.Title,
          TextPreview: record.ContentDocument.LatestPublishedVersion.TextPreview
        };
      });
    } else if (error) {
      this.error = error;
      this.data = undefined;
    }
  }

  async launchFlow() {
    this.inputVariables = [
      {
        name: "recordId",
        type: "String",
        value: this.recordId
      },
      {
        name: "relatedTabFromButton",
        type: "String",
        value: this.currentFocusedTab
      }
    ];

    await HlaSNoteFlowModal.open({
      size: "large",
      inputVariables: this.inputVariables
    }).then(() => {
      refreshApex(this.wiredSnotes);
    });
  }
}
