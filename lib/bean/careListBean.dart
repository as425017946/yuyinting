class careListBean {
  int? code;
  String? msg;
  Data? data;

  careListBean({this.code, this.msg, this.data});

  careListBean.fromJson(Map<String, dynamic> json) {
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
  List<Lista>? list;
  int? count;

  Data({this.list, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <Lista>[];
      json['list'].forEach((v) {
        list!.add(new Lista.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Lista {
  String? nickname;
  int? gender;
  String? description;
  String? avatar;
  int? uid;
  int? type;
  int? liveStatus;
  String? follow;

  Lista(
      {this.nickname,
        this.gender,
        this.description,
        this.avatar,
        this.uid,
        this.type,
        this.liveStatus,
        this.follow});

  Lista.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    gender = json['gender'];
    description = json['description'];
    avatar = json['avatar'];
    uid = json['uid'];
    type = json['type'];
    liveStatus = json['live_status'];
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
    data['live_status'] = this.liveStatus;
    data['follow'] = this.follow;
    return data;
  }
}
