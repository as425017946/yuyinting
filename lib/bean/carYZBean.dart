class carYZBean {
  int? code;
  String? msg;
  Data? data;

  carYZBean({this.code, this.msg, this.data});

  carYZBean.fromJson(Map<String, dynamic> json) {
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
  int? curType;

  Data({this.curType});

  Data.fromJson(Map<String, dynamic> json) {
    curType = json['cur_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cur_type'] = this.curType;
    return data;
  }
}
