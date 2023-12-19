// 钱包余额
class balanceBean {
  int? code;
  String? msg;
  Data? data;

  balanceBean({this.code, this.msg, this.data});

  balanceBean.fromJson(Map<String, dynamic> json) {
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
  String? goldBean;
  String? goldCoin;
  String? diamond;
  String? mushroom;

  Data({this.goldBean, this.goldCoin, this.diamond, this.mushroom});

  Data.fromJson(Map<String, dynamic> json) {
    goldBean = json['gold_bean'];
    goldCoin = json['gold_coin'];
    diamond = json['diamond'];
    mushroom = json['mushroom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gold_bean'] = this.goldBean;
    data['gold_coin'] = this.goldCoin;
    data['diamond'] = this.diamond;
    data['mushroom'] = this.mushroom;
    return data;
  }
}
