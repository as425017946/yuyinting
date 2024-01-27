/// 充值生成订单使用
class orderPayBean {
  int? code;
  String? msg;
  Data? data;

  orderPayBean({this.code, this.msg, this.data});

  orderPayBean.fromJson(Map<String, dynamic> json) {
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
  int? uid;
  String? rechargeMethod;
  String? rechargeCurAmount;
  String? rechargeCurType;
  String? gameCurAmount;
  String? use;
  String? gameCurType;
  String? isFirst;
  String? orderSn;
  int? orderId;
  String? payUrl;

  Data(
      {this.uid,
        this.rechargeMethod,
        this.rechargeCurAmount,
        this.rechargeCurType,
        this.gameCurAmount,
        this.use,
        this.gameCurType,
        this.isFirst,
        this.orderSn,
        this.orderId,
        this.payUrl});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    rechargeMethod = json['recharge_method'];
    rechargeCurAmount = json['recharge_cur_amount'];
    rechargeCurType = json['recharge_cur_type'];
    gameCurAmount = json['game_cur_amount'];
    use = json['use'];
    gameCurType = json['game_cur_type'];
    isFirst = json['is_first'];
    orderSn = json['order_sn'];
    orderId = json['order_id'];
    payUrl = json['pay_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['recharge_method'] = this.rechargeMethod;
    data['recharge_cur_amount'] = this.rechargeCurAmount;
    data['recharge_cur_type'] = this.rechargeCurType;
    data['game_cur_amount'] = this.gameCurAmount;
    data['use'] = this.use;
    data['game_cur_type'] = this.gameCurType;
    data['is_first'] = this.isFirst;
    data['order_sn'] = this.orderSn;
    data['order_id'] = this.orderId;
    data['pay_url'] = this.payUrl;
    return data;
  }
}
