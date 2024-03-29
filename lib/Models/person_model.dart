class PersonModel {
  int? id;
  String? name;
  int? noOfEntries;
  int? initialEntries;
  String? phoneNo;
  String? prizeType;
  int? raffleId;

  PersonModel(
      {this.id,
      this.name,
      this.noOfEntries,
      this.phoneNo,
      this.initialEntries,
      this.prizeType,
      this.raffleId});

  PersonModel.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    noOfEntries = json["no_of_entries"];
    initialEntries = json["initial_entries"];
    phoneNo = json["phone_no"];
    prizeType = json["prize_type"].toString();
    raffleId = json["raffle_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["no_of_entries"] = noOfEntries;
    map["initial_entries"] = initialEntries;
    map["phone_no"] = phoneNo;
    map["prize_type"] = prizeType;
    map["raffle_id"] = raffleId;
    return map;
  }
}
