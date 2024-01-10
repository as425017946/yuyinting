class careListBean {
  int? code;
  String? msg;
  List<Data>? data;

  careListBean({this.code, this.msg, this.data});

  careListBean.fromJson(Map<String, dynamic> json) {
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
  String? nickname;
  int? gender;
  String? description;
  String? avatar;
  int? uid;
  int? type;
  int? live;
  String? follow;

  Data(
      {this.nickname,
        this.gender,
        this.description,
        this.avatar,
        this.uid,
        this.type,
        this.live,
        this.follow});

  Data.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    gender = json['gender'];
    description = json['description'];
    avatar = json['avatar'];
    uid = json['uid'];
    type = json['type'];
    live = json['live'];
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['description'] = this.description;
    data['avatar'] = this.avatar;
    data['uid'] = this.uid;
    data['type'] = this.type;
    data['live'] = this.live;
    data['follow'] = this.follow;
    return data;
  }
}
