class roomDataBean {
  int? code;
  String? msg;
  Data? data;

  roomDataBean({this.code, this.msg, this.data});

  roomDataBean.fromJson(Map<String, dynamic> json) {
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
  String? spending;
  int? joinNum;
  int? consumeNum;
  String? remainRate;
  String? consumeRate;
  int? joinFirstNum;
  int? consumeFirstNum;
  String? consumeFirstRate;

  Data(
      {this.spending,
        this.joinNum,
        this.consumeNum,
        this.remainRate,
        this.consumeRate,
        this.joinFirstNum,
        this.consumeFirstNum,
        this.consumeFirstRate});

  Data.fromJson(Map<String, dynamic> json) {
    spending = json['spending'];
    joinNum = json['join_num'];
    consumeNum = json['consume_num'];
    remainRate = json['remain_rate'];
    consumeRate = json['consume_rate'];
    joinFirstNum = json['join_firstNum'];
    consumeFirstNum = json['consume_first_num'];
    consumeFirstRate = json['consume_first_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spending'] = this.spending;
    data['join_num'] = this.joinNum;
    data['consume_num'] = this.consumeNum;
    data['remain_rate'] = this.remainRate;
    data['consume_rate'] = this.consumeRate;
    data['join_firstNum'] = this.joinFirstNum;
    data['consume_first_num'] = this.consumeFirstNum;
    data['consume_first_rate'] = this.consumeFirstRate;
    return data;
  }
}
