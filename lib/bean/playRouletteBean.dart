// 魔方转盘下注返回中奖
class playRouletteBean {
  int? code;
  String? msg;
  Data? data;

  playRouletteBean({this.code, this.msg, this.data});

  playRouletteBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Gifts>? gifts;
  int? total;
  int? curType;

  Data({this.gifts, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['gifts'] != null) {
      gifts = <Gifts>[];
      json['gifts'].forEach((v) {
        gifts!.add(new Gifts.fromJson(v));
      });
    }
    total = json['total'];
    curType = json['cur_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gifts != null) {
      data['gifts'] = this.gifts!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['cur_type'] = this.curType;
    return data;
  }
}

class Gifts {
  int? giftId;
  int? count;
  int? price;
  String? img;
  String? name;

  Gifts({this.giftId, this.count, this.price, this.img, this.name});

  Gifts.fromJson(Map<String, dynamic> json) {
    giftId = json['gift_id'];
    count = json['count'];
    price = json['price'];
    img = json['img'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_id'] = this.giftId;
    data['count'] = this.count;
    data['price'] = this.price;
    data['img'] = this.img;
    data['name'] = this.name;
    return data;
  }
}
