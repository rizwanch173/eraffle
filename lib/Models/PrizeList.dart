class PrizeList {
  int? id;
  String? prizeDetail;

  PrizeList({required this.id, required this.prizeDetail});

  PrizeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prizeDetail = json['prize_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prize_detail'] = this.prizeDetail;
    return data;
  }
}
