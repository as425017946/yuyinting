class addressIPBean {
  String address;
  int code;
  String msg;
  String nodes;

  addressIPBean({required this.address, required this.code, required this.msg, required this.nodes});

  factory addressIPBean.fromJson(Map<String, dynamic> json) {
    return addressIPBean(
      address: json['address'],
      code: json['code'],
      msg: json['msg'],
      nodes: json['nodes'],
    );
  }
}