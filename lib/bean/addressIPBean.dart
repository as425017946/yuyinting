class addressIPBean {
  String address;
  int code;
  String msg;
  // String nodes;
  dynamic ips;

  addressIPBean({
    required this.address,
    required this.code,
    required this.msg,
    // required this.nodes,
    required this.ips,
  });

  factory addressIPBean.fromJson(Map<String, dynamic> json) {
    return addressIPBean(
      address: json['address'],
      code: json['code'],
      msg: json['msg'],
      // nodes: json['nodes'],
      ips: json['ips'],
    );
  }
}
