class LoginBean {
  int? code;
  String? msg;
  Data? data;

  LoginBean({this.code, this.msg, this.data});

  LoginBean.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? nickname;
  int? gender;
  int? avatar;
  String? avatarUrl;
  int? number;
  int? isSetPwd;
  String? phone;
  String? areaCode;
  int? uid;
  String? emPwd;
  String? emToken;

  Data(
      {this.token,
        this.nickname,
        this.gender,
        this.avatar,
        this.avatarUrl,
        this.number,
        this.isSetPwd,
        this.phone,
        this.areaCode,
        this.uid,
        this.emPwd,
        this.emToken});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    nickname = json['nickname'];
    gender = json['gender'];
    avatar = json['avatar'];
    avatarUrl = json['avatar_url'];
    number = json['number'];
    isSetPwd = json['is_set_pwd'];
    phone = json['phone'];
    areaCode = json['area_code'];
    uid = json['uid'];
    emPwd = json['em_pwd'];
    emToken = json['em_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['avatar_url'] = this.avatarUrl;
    data['number'] = this.number;
    data['is_set_pwd'] = this.isSetPwd;
    data['phone'] = this.phone;
    data['area_code'] = this.areaCode;
    data['uid'] = this.uid;
    data['em_pwd'] = this.emPwd;
    data['em_token'] = this.emToken;
    return data;
  }
}
