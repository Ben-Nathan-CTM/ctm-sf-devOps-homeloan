export class formattedRecord {
  constructor(Id) {
    this.id = Id;
    // easier just to set all urls rather than lok for specific types
    this.recordURL = "/" + Id;
  }
}
