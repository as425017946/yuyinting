class tgmBean {
  int? code;
  String? msg;
  Data? data;

  tgmBean({this.code, this.msg, this.data});

  tgmBean.fromJson(Map<String, dynamic> json) {
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
  String? qrCode;
  String? url;

  Data({this.qrCode, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    qrCode = json['qr_code'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qr_code'] = this.qrCode;
    data['url'] = this.url;
    return data;
  }
}
