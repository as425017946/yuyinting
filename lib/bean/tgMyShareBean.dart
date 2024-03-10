class tgMyShareBean {
  int? code;
  String? msg;
  Data? data;

  tgMyShareBean({this.code, this.msg, this.data});

  tgMyShareBean.fromJson(Map<String, dynamic> json) {
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
  String? url;
  String? code;

  Data({this.url, this.code});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['code'] = this.code;
    return data;
  }
}
