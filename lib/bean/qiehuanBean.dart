class qiehuanBean {
  int? code;
  String? msg;
  Data? data;

  qiehuanBean({this.code, this.msg, this.data});

  qiehuanBean.fromJson(Map<String, dynamic> json) {
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
  String? identity;
  String? emPwd;

  Data({this.uid, this.identity});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    identity = json['identity'];
    emPwd = json['em_pwd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['identity'] = this.identity;
    data['em_pwd'] = this.emPwd;
    return data;
  }
}
