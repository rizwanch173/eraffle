class RaffleModel {
  int? id;
  String? eventName;
  int? currentEntries;
  int? initialEntries;
  int? status;
  String? createdDate;

  RaffleModel(
      {this.id,
      this.eventName,
      this.currentEntries,
      this.initialEntries,
      this.status,
      this.createdDate});

  RaffleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    currentEntries = json['current_entries'];
    initialEntries = json['initial_entries'];
    status = json['status'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['event_name'] = this.eventName;
    data['current_entries'] = this.currentEntries;
    data['initial_entries'] = this.initialEntries;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    return data;
  }
}
