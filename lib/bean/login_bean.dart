/// code : 200
/// msg : "ok"
/// data : {"token":"a3ebb48841a80143508825c9958fadb3","nickname":"默认昵称2721","gender":0,"avatar":"https://img2.baidu.com/it/u=124337651,168750168&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500","is_set_pwd":1,"phone":"","area_code":"","uid":26,"em_pwd":"64a928c26efe7","em_token":"YWMtfZP2ah73Ee6F6X2fNoo332XJlMP37UsNrUbZVOvmTKu5c-ZgHW8R7peP_0zAiTrvAwMAAAGJPs6yPjeeSACqPl-vGHB35FYGgGiNwE_1o1C3tvGr4QM00aNv1fSKKQ"}

class LoginBean {
  LoginBean({
      this.code, 
      this.msg, 
      this.data,});

  LoginBean.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? code;
  String? msg;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// token : "a3ebb48841a80143508825c9958fadb3"
/// nickname : "默认昵称2721"
/// gender : 0
/// avatar : "https://img2.baidu.com/it/u=124337651,168750168&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"
/// is_set_pwd : 1
/// phone : ""
/// area_code : ""
/// uid : 26
/// em_pwd : "64a928c26efe7"
/// em_token : "YWMtfZP2ah73Ee6F6X2fNoo332XJlMP37UsNrUbZVOvmTKu5c-ZgHW8R7peP_0zAiTrvAwMAAAGJPs6yPjeeSACqPl-vGHB35FYGgGiNwE_1o1C3tvGr4QM00aNv1fSKKQ"

class Data {
  Data({
      this.token, 
      this.nickname, 
      this.gender, 
      this.avatar, 
      this.isSetPwd, 
      this.phone, 
      this.areaCode, 
      this.uid, 
      this.emPwd, 
      this.emToken,});

  Data.fromJson(dynamic json) {
    token = json['token'];
    nickname = json['nickname'];
    gender = json['gender'];
    avatar = json['avatar'];
    isSetPwd = json['is_set_pwd'];
    phone = json['phone'];
    areaCode = json['area_code'];
    uid = json['uid'];
    emPwd = json['em_pwd'];
    emToken = json['em_token'];
  }
  String? token;
  String? nickname;
  int? gender;
  String? avatar;
  int? isSetPwd;
  String? phone;
  String? areaCode;
  int? uid;
  String? emPwd;
  String? emToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['nickname'] = nickname;
    map['gender'] = gender;
    map['avatar'] = avatar;
    map['is_set_pwd'] = isSetPwd;
    map['phone'] = phone;
    map['area_code'] = areaCode;
    map['uid'] = uid;
    map['em_pwd'] = emPwd;
    map['em_token'] = emToken;
    return map;
  }

}