class cityBean {
  int? code;
  String? msg;
  List<String>? data;

  cityBean({this.code, this.msg, this.data});

  cityBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }
}
