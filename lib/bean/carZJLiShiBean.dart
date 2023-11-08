class carZJLiShiBean {
  int? code;
  String? msg;
  List<Data>? data;

  carZJLiShiBean({this.code, this.msg, this.data});

  carZJLiShiBean.fromJson(Map<String, dynamic> json) {
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
  int? round;
  int? openSn;

  Data({this.round, this.openSn});

  Data.fromJson(Map<String, dynamic> json) {
    round = json['round'];
    openSn = json['open_sn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['round'] = this.round;
    data['open_sn'] = this.openSn;
    return data;
  }
}
