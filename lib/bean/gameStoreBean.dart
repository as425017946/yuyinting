// 游戏商店
class gameStoreBean {
  int? code;
  String? msg;
  Data? data;

  gameStoreBean({this.code, this.msg, this.data});

  gameStoreBean.fromJson(Map<String, dynamic> json) {
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
  List<GoodsList>? goodsList;
  int? amount;

  Data({this.goodsList, this.amount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['goods_list'] != null) {
      goodsList = <GoodsList>[];
      json['goods_list'].forEach((v) {
        goodsList!.add(new GoodsList.fromJson(v));
      });
    }
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsList != null) {
      data['goods_list'] = this.goodsList!.map((v) => v.toJson()).toList();
    }
    data['amount'] = this.amount;
    return data;
  }
}

class GoodsList {
  String? img;
  int? exchangeCost;
  String? price;
  int? goodsType;
  int? goodsId;

  GoodsList(
      {this.img, this.exchangeCost, this.price, this.goodsType, this.goodsId});

  GoodsList.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    exchangeCost = json['exchange_cost'];
    price = json['price'];
    goodsType = json['goods_type'];
    goodsId = json['goods_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['exchange_cost'] = this.exchangeCost;
    data['price'] = this.price;
    data['goods_type'] = this.goodsType;
    data['goods_id'] = this.goodsId;
    return data;
  }
}
