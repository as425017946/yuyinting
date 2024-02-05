class pushStreamerBean {
  int? code;
  String? msg;
  Data? data;

  pushStreamerBean({this.code, this.msg, this.data});

  pushStreamerBean.fromJson(Map<String, dynamic> json) {
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
  List<AnchorList>? anchorList;

  Data({this.anchorList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['anchor_list'] != null) {
      anchorList = <AnchorList>[];
      json['anchor_list'].forEach((v) {
        anchorList!.add(new AnchorList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.anchorList != null) {
      data['anchor_list'] = this.anchorList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnchorList {
  int? uid;
  String? nickname;
  int? gender;
  int? birthday;
  String? avatar;
  String? description;
  int? level;
  int? age;
  int? live;
  int? roomId;

  AnchorList(
      {this.uid,
        this.nickname,
        this.gender,
        this.birthday,
        this.avatar,
        this.description,
        this.level,
        this.age,
        this.live,
        this.roomId});

  AnchorList.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nickname = json['nickname'];
    gender = json['gender'];
    birthday = json['birthday'];
    avatar = json['avatar'];
    description = json['description'];
    level = json['level'];
    age = json['age'];
    live = json['live'];
    roomId = json['room_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['avatar'] = this.avatar;
    data['description'] = this.description;
    data['level'] = this.level;
    data['age'] = this.age;
    data['live'] = this.live;
    data['room_id'] = this.roomId;
    return data;
  }
}
