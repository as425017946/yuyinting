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
  String? identity;
  int? level;
  int? grLevel;


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
        this.emToken,
        this.identity,
        this.level,
        this.grLevel});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? '';
    nickname = json['nickname'] ?? '';
    gender = json['gender'] ?? 0;
    avatar = json['avatar'] ?? 0;
    avatarUrl = json['avatar_url'] ?? '';
    number = json['number'] ?? 0;
    isSetPwd = json['is_set_pwd'] ?? 0;
    phone = json['phone'] ?? '';
    areaCode = json['area_code'] ?? '';
    uid = json['uid'] ?? 0;
    emPwd = json['em_pwd'] ?? '';
    emToken = json['em_token'] ?? '';
    identity = json['identity'] ?? '';
    level = json['level'] ?? 1;
    grLevel = json['gr_level'] ?? 1;
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
    data['identity'] = this.identity;
    data['level'] = this.level;
    data['gr_level'] = this.grLevel;
    return data;
  }
}
