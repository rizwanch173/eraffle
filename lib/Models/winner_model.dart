class WinnerModel {
  String? name;
  String? prizeName;
  int? initialEntries;
  int? noOfEntries;
  String? date;

  WinnerModel(
      {this.name,
      this.prizeName,
      this.initialEntries,
      this.noOfEntries,
      this.date});

  WinnerModel.fromJson(dynamic json) {
    name = json["name"];
    prizeName = json["prize_name"];
    initialEntries = json["initial_entries"];
    noOfEntries = json["no_of_entries"];
    date = json["date"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["prize_name"] = prizeName;
    map["initial_entries"] = initialEntries;
    map["no_of_entries"] = noOfEntries;
    map["date"] = date;
    return map;
  }
}
