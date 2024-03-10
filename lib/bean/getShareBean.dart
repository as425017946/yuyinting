class getShareBean {
  int? code;
  String? msg;
  Data? data;

  getShareBean({this.code, this.msg, this.data});

  getShareBean.fromJson(Map<String, dynamic> json) {
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
  int? isApply;

  Data({this.url, this.isApply});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    isApply = json['is_apply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['is_apply'] = this.isApply;
    return data;
  }
}
