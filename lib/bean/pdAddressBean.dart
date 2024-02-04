class pdAddressBean {
  int? code;
  String? msg;
  String? nodes;

  pdAddressBean({this.code, this.msg, this.nodes});

  pdAddressBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    nodes = json['nodes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['nodes'] = this.nodes;
    return data;
  }
}
