class managerBean {
  int? code;
  String? msg;
  List<Data>? data;

  managerBean({this.code, this.msg, this.data});

  managerBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? uid;
  String? nickname;
  String? avatar;

  Data({this.uid, this.nickname, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nickname = json['nickname'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    return data;
  }
}
