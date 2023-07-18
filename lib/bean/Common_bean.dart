class CommonBean {
  CommonBean({
      this.code, 
      this.msg,});

  CommonBean.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
  }
  int? code;
  String? msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    return map;
  }

}