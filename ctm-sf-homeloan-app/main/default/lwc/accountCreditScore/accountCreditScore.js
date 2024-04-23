import { LightningElement, api, wire } from "lwc";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import chartjs from "@salesforce/resourceUrl/chartJs";
import { getRecord } from "lightning/uiRecordApi";

const fields = ["Account.Name", "Account.Id", "Account.CreditScore__c"];

export default class LibsChartjs extends LightningElement {
  error;
  chart;
  config;
  chartjsInitialized = false;

  @api recordId;
  @wire(getRecord, { recordId: "$recordId", fields })
  wiredAccount({ error, data }) {
    if (data) {
      console.log(data);
      this.config = {
        type: "doughnut",
        data: {
          datasets: [
            {
              data: [
                data.fields.CreditScore__c.value,
                1000 - data.fields.CreditScore__c.value
              ],
              backgroundColor: ["rgb(0,128,0)", "rgb(245,245,245)"],
              label: "Dataset 1"
            }
          ]
          //labels: ['Credit Score', data.fields.Name.value]
        },
        options: {
          responsive: true,
          cutoutPercentage: 75,
          circumference: Math.PI + 1,
          rotation: -Math.PI - 0.5,
          legend: {
            position: "left"
          },
          animation: {
            animateScale: true,
            animateRotate: true
          },
          title: {
            display: true,
            text: data.fields.CreditScore__c.value,
            position: "bottom",
            fontSize: 60,
            padding: 0.2
          }
        }
      };
    } else if (error) {
      this.error = error;
    }
  }

  renderedCallback() {
    if (this.chartjsInitialized) {
      return;
    }
    this.chartjsInitialized = true;

    Promise.all([
      loadScript(this, chartjs + "/Chart.min.js"),
      loadStyle(this, chartjs + "/Chart.min.css")
    ])
      .then(() => {
        // disable Chart.js CSS injection
        window.Chart.platform.disableCSSInjection = true;

        const canvas = document.createElement("canvas");
        this.template.querySelector("div.chart").appendChild(canvas);
        const ctx = canvas.getContext("2d");
        this.chart = new window.Chart(ctx, this.config);
      })
      .catch((error) => {
        this.error = error;
      });
  }
}