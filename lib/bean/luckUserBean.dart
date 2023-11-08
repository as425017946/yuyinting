class luckUserBean {
  int? code;
  String? msg;
  Data? data;

  luckUserBean({this.code, this.msg, this.data});

  luckUserBean.fromJson(Map<String, dynamic> json) {
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
  List<LuckyList>? luckyList;
  Wallet? wallet;

  Data({this.luckyList, this.wallet});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lucky_list'] != null) {
      luckyList = <LuckyList>[];
      json['lucky_list'].forEach((v) {
        luckyList!.add(new LuckyList.fromJson(v));
      });
    }
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.luckyList != null) {
      data['lucky_list'] = this.luckyList!.map((v) => v.toJson()).toList();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    return data;
  }
}

class LuckyList {
  int? uid;
  int? amount;
  int? amountType;
  String? avatar;

  LuckyList({this.uid, this.amount, this.amountType, this.avatar});

  LuckyList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    amount = json['amount'];
    amountType = json['amount_type'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['amount'] = this.amount;
    data['amount_type'] = this.amountType;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Wallet {
  String? goldBean;
  String? diamond;
  String? mushroom;

  Wallet({this.goldBean, this.diamond, this.mushroom});

  Wallet.fromJson(Map<String, dynamic> json) {
    goldBean = json['gold_bean'];
    diamond = json['diamond'];
    mushroom = json['mushroom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gold_bean'] = this.goldBean;
    data['diamond'] = this.diamond;
    data['mushroom'] = this.mushroom;
    return data;
  }
}
