/// 魔方转盘中奖记录
class winListBean {
  int? code;
  String? msg;
  List<Data>? data;

  winListBean({this.code, this.msg, this.data});

  winListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? type;
  int? price;
  int? betId;
  int? uid;
  int? giftId;
  int? giftPrice;
  int? number;
  int? amount;
  int? amountType;
  String? addTime;
  String? giftName;
  String? giftImg;

  Data(
      {this.id,
        this.type,
        this.price,
        this.betId,
        this.uid,
        this.giftId,
        this.giftPrice,
        this.number,
        this.amount,
        this.amountType,
        this.addTime,
        this.giftName,
        this.giftImg});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    price = json['price'];
    betId = json['bet_id'];
    uid = json['uid'];
    giftId = json['gift_id'];
    giftPrice = json['gift_price'];
    number = json['number'];
    amount = json['amount'];
    amountType = json['amount_type'];
    addTime = json['add_time'];
    giftName = json['gift_name'];
    giftImg = json['gift_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['price'] = this.price;
    data['bet_id'] = this.betId;
    data['uid'] = this.uid;
    data['gift_id'] = this.giftId;
    data['gift_price'] = this.giftPrice;
    data['number'] = this.number;
    data['amount'] = this.amount;
    data['amount_type'] = this.amountType;
    data['add_time'] = this.addTime;
    data['gift_name'] = this.giftName;
    data['gift_img'] = this.giftImg;
    return data;
  }
}
