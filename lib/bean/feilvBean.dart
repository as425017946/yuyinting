class feilvBean {
  int? code;
  String? msg;
  Data? data;

  feilvBean({this.code, this.msg, this.data});

  feilvBean.fromJson(Map<String, dynamic> json) {
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
  String? rate;
  String? wdlMethod;
  Data({this.rate, this.wdlMethod});

  Data.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    wdlMethod = json['wdl_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['wdl_method'] = this.wdlMethod;
    return data;
  }
}
