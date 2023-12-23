class isPayBean {
  int? code;
  String? msg;
  Data? data;

  isPayBean({this.code, this.msg, this.data});

  isPayBean.fromJson(Map<String, dynamic> json) {
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
  int? isSet;

  Data({this.isSet});

  Data.fromJson(Map<String, dynamic> json) {
    isSet = json['is_set'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_set'] = this.isSet;
    return data;
  }
}
