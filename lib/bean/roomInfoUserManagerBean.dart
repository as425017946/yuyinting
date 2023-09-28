class roomInfoUserManagerBean {
  int? code;
  String? msg;
  Data? data;

  roomInfoUserManagerBean({this.code, this.msg, this.data});

  roomInfoUserManagerBean.fromJson(Map<String, dynamic> json) {
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
  int? isAdmin;
  int? isForbation;
  int? isBlack;

  Data({this.isAdmin, this.isForbation, this.isBlack});

  Data.fromJson(Map<String, dynamic> json) {
    isAdmin = json['is_admin'];
    isForbation = json['is_forbation'];
    isBlack = json['is_black'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_admin'] = this.isAdmin;
    data['is_forbation'] = this.isForbation;
    data['is_black'] = this.isBlack;
    return data;
  }
}
