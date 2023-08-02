class kefuBean {
  int? code;
  String? msg;
  Data? data;

  kefuBean({this.code, this.msg, this.data});

  kefuBean.fromJson(Map<String, dynamic> json) {
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
  String? online;
  String? qq;
  String? telegram;

  Data({this.online, this.qq, this.telegram});

  Data.fromJson(Map<String, dynamic> json) {
    online = json['online'];
    qq = json['qq'];
    telegram = json['telegram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['online'] = this.online;
    data['qq'] = this.qq;
    data['telegram'] = this.telegram;
    return data;
  }
}
