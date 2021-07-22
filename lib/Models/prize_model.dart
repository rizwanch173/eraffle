class PrizeModel {
  int? id;
  String? prizeDetail;
  int? value;
  int? costEachEntry;
  int? raffleId;

  PrizeModel(
      {this.id,
      this.prizeDetail,
      this.value,
      this.costEachEntry,
      this.raffleId});

  PrizeModel.fromJson(dynamic json) {
    id = json["id"];
    prizeDetail = json["prize_detail"];
    raffleId = json["raffle_id"];
    value = json["value"];
    costEachEntry = json["costEachEntry"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["prize_detail"] = prizeDetail;
    map["raffle_id"] = raffleId;
    map["value"] = value;
    map["costEachEntry"] = costEachEntry;
    return map;
  }
}
