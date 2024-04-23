import LightningDatatable from "lightning/datatable";
import imageColumnTemplate from "./imageColumn.html";
import dotpointColumnTemplate from "./dotpointColumn.html";

export default class HlaCustomProductTable extends LightningDatatable {
  static customTypes = {
    imageColumn: {
      template: imageColumnTemplate,
      standardCellLayout: true,
      typeAttributes: [
        "lenderImageUrl",
        "productId",
        "title",
        "selected",
        "imageclicked"
      ]
    },
    dotpointColumn: {
      template: dotpointColumnTemplate,
      standardCellLayout: true,
      typeAttributes: ["points"]
    }
  };
}
