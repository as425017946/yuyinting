class userOnlineBean {
  int? code;
  String? msg;
  List<Data>? data;

  userOnlineBean({this.code, this.msg, this.data});

  userOnlineBean.fromJson(Map<String, dynamic> json) {
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
  int? gender;
  String? description;
  int? loginStatus;
  String? avatar;
  int? addTime;
  int? age;
  int? isNew;
  String? labelName;
  int? live;
  int? isHi;

  Data(
      {this.uid,
        this.nickname,
        this.gender,
        this.description,
        this.loginStatus,
        this.avatar,
        this.addTime,
        this.age,
        this.isNew,
        this.labelName,
        this.live,
        this.isHi});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nickname = json['nickname'];
    gender = json['gender'];
    description = json['description'];
    loginStatus = json['login_status'];
    avatar = json['avatar'];
    addTime = json['add_time'];
    age = json['age'];
    isNew = json['is_new'];
    labelName = json['label_name'];
    live = json['live'];
    isHi = json['is_hi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['description'] = this.description;
    data['login_status'] = this.loginStatus;
    data['avatar'] = this.avatar;
    data['add_time'] = this.addTime;
    data['age'] = this.age;
    data['is_new'] = this.isNew;
    data['label_name'] = this.labelName;
    data['live'] = this.live;
    data['is_hi'] = this.isHi;
    return data;
  }
}
