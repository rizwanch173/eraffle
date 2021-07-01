class PrizeModel {
  int? id;
  String? prizeDetail;
  int? raffleId;

  PrizeModel({this.id, this.prizeDetail, this.raffleId});

  PrizeModel.fromJson(dynamic json) {
    id = json["id"];
    prizeDetail = json["prize_detail"];
    raffleId = json["raffle_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["prize_detail"] = prizeDetail;
    map["raffle_id"] = raffleId;
    return map;
  }
}
