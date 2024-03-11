class myFenRunBean {
  int? code;
  String? msg;
  Data? data;

  myFenRunBean({this.code, this.msg, this.data});

  myFenRunBean.fromJson(Map<String, dynamic> json) {
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
  String? game;
  int? gameRate;
  String? win;
  String? direct;
  int? directRate;
  String? rebate;
  String? allRebateGb;
  String? allRebateD;
  String? canRebateGb;
  String? canRebateD;
  String? proportion;
  String? directRatio;
  String? gameRatio;
  int? getSwtich;

  Data(
      {this.allPromotionNum,
        this.promotionNum,
        this.game,
        this.gameRate,
        this.win,
        this.direct,
        this.directRate,
        this.rebate,
        this.allRebateGb,
        this.allRebateD,
        this.canRebateGb,
        this.canRebateD,
        this.proportion,
        this.getSwtich,
        this.directRatio,
        this.gameRatio});

  Data.fromJson(Map<String, dynamic> json) {
    allPromotionNum = json['all_promotion_num'];
    promotionNum = json['promotion_num'];
    game = json['game'];
    gameRate = json['game_rate'];
    win = json['win'];
    direct = json['direct'];
    directRate = json['direct_rate'];
    rebate = json['rebate'];
    allRebateGb = json['all_rebate_gb'];
    allRebateD = json['all_rebate_d'];
    canRebateGb = json['can_rebate_gb'];
    canRebateD = json['can_rebate_d'];
    proportion = json['proportion'];
    getSwtich = json['get_swtich'];
    directRatio = json['direct_ratio'];
    gameRatio = json['game_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_promotion_num'] = this.allPromotionNum;
    data['promotion_num'] = this.promotionNum;
    data['game'] = this.game;
    data['game_rate'] = this.gameRate;
    data['win'] = this.win;
    data['direct'] = this.direct;
    data['direct_rate'] = this.directRate;
    data['rebate'] = this.rebate;
    data['all_rebate_gb'] = this.allRebateGb;
    data['all_rebate_d'] = this.allRebateD;
    data['can_rebate_gb'] = this.canRebateGb;
    data['can_rebate_d'] = this.canRebateD;
    data['proportion'] = this.proportion;
    data['get_swtich'] = this.getSwtich;
    data['direct_ratio'] = this.directRatio;
    data['game_ratio'] = this.gameRatio;
    return data;
  }
}
