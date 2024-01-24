class pdAddressBean {
  int? code;
  String? msg;
  int? type;

  pdAddressBean({this.code, this.msg, this.type});

  pdAddressBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['type'] = this.type;
    return data;
  }
}
