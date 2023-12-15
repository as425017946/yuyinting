class roomUserInfoBean {
  int? code;
  String? msg;
  Data? data;

  roomUserInfoBean({this.code, this.msg, this.data});

  roomUserInfoBean.fromJson(Map<String, dynamic> json) {
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
  int? uid;
  int? number;
  String? nickname;
  int? gender;
  String? avatar;
  String? description;
  String? city;
  int? level;
  int? birthday;
  String? age;
  int? isHi;
  String? followStatus;
  String? avatarFrameImg;
  String? avatarFrameGifImg;

  Data(
      {this.uid,
        this.number,
        this.nickname,
        this.gender,
        this.avatar,
        this.description,
        this.city,
        this.level,
        this.birthday,
        this.age,
        this.isHi,
        this.followStatus,
        this.avatarFrameGifImg,
        this.avatarFrameImg});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    number = json['number'];
    nickname = json['nickname'];
    gender = json['gender'];
    avatar = json['avatar'];
    description = json['description'];
    city = json['city'];
    level = json['level'];
    birthday = json['birthday'];
    age = json['age'];
    isHi = json['is_hi'];
    followStatus = json['follow_status'];
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['number'] = this.number;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['description'] = this.description;
    data['city'] = this.city;
    data['level'] = this.level;
    data['birthday'] = this.birthday;
    data['age'] = this.age;
    data['is_hi'] = this.isHi;
    data['follow_status'] = this.followStatus;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    return data;
  }
}
