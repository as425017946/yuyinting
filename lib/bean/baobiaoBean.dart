class baobiaoBean {
  int? code;
  String? msg;
  List<Data>? data;

  baobiaoBean({this.code, this.msg, this.data});

  baobiaoBean.fromJson(Map<String, dynamic> json) {
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
  String? nickname;
  int? number;
  String? game;
  String? win;
  String? direct;
  String? rebateGb;
  String? rebateD;
  String? operate;

  Data(
      {this.nickname,
        this.number,
        this.game,
        this.win,
        this.direct,
        this.rebateGb,
        this.rebateD,
        this.operate});

  Data.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    number = json['number'];
    game = json['game'];
    win = json['win'];
    direct = json['direct'];
    rebateGb = json['rebate_gb'];
    rebateD = json['rebate_d'];
    operate = json['operate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['number'] = this.number;
    data['game'] = this.game;
    data['win'] = this.win;
    data['direct'] = this.direct;
    data['rebate_gb'] = this.rebateGb;
    data['rebate_d'] = this.rebateD;
    data['operate'] = this.operate;
    return data;
  }
}
