class zonglanBean {
  int? code;
  String? msg;
  Data? data;

  zonglanBean({this.code, this.msg, this.data});

  zonglanBean.fromJson(Map<String, dynamic> json) {
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
  int? allPromotionNum;
  int? promotionNum;
  int? rechargeNum;
  int? rechargeAmount;
  String? game;
  String? win;
  String? direct;
  String? rebateGb;
  String? rebateD;
  String? operate;

  Data(
      {this.allPromotionNum,
        this.promotionNum,
        this.rechargeNum,
        this.rechargeAmount,
        this.game,
        this.win,
        this.direct,
        this.rebateGb,
        this.rebateD,
        this.operate});

  Data.fromJson(Map<String, dynamic> json) {
    allPromotionNum = json['all_promotion_num'];
    promotionNum = json['promotion_num'];
    rechargeNum = json['recharge_num'];
    rechargeAmount = json['recharge_amount'];
    game = json['game'];
    win = json['win'];
    direct = json['direct'];
    rebateGb = json['rebate_gb'];
    rebateD = json['rebate_d'];
    operate = json['operate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_promotion_num'] = this.allPromotionNum;
    data['promotion_num'] = this.promotionNum;
    data['recharge_num'] = this.rechargeNum;
    data['recharge_amount'] = this.rechargeAmount;
    data['game'] = this.game;
    data['win'] = this.win;
    data['direct'] = this.direct;
    data['rebate_gb'] = this.rebateGb;
    data['rebate_d'] = this.rebateD;
    data['operate'] = this.operate;
    return data;
  }
}
