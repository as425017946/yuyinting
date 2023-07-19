/// code : 200
/// msg : "ok"
/// data : {"nickname":"默认昵称2721","number":293189,"avatar":"https://chat-st.s3.ap-southeast-1.amazonaws.com/https%3A//lmg.jj20.com/up/allimg/4k/s/02/2109250006343S5-0-lp.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZMNAWNX75QWNCG5D%2F20230718%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20230718T094127Z&X-Amz-SignedHeaders=host&X-Amz-Expires=600&X-Amz-Signature=78574f685f0d7ead009a9162ed027f811dc4138866b201fc0288d37ba9fb2291","gender":0,"follow_num":0,"is_follow_num":0,"look_num":0,"current_version":"1.0.2","status":"1","forceUpdate":"1"}

class MyInfoBean {
  MyInfoBean({
      this.code, 
      this.msg, 
      this.data,});

  MyInfoBean.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? code;
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

/// nickname : "默认昵称2721"
/// number : 293189
/// avatar : "https://chat-st.s3.ap-southeast-1.amazonaws.com/https%3A//lmg.jj20.com/up/allimg/4k/s/02/2109250006343S5-0-lp.jpg?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAZMNAWNX75QWNCG5D%2F20230718%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20230718T094127Z&X-Amz-SignedHeaders=host&X-Amz-Expires=600&X-Amz-Signature=78574f685f0d7ead009a9162ed027f811dc4138866b201fc0288d37ba9fb2291"
/// gender : 0
/// follow_num : 0
/// is_follow_num : 0
/// look_num : 0
/// current_version : "1.0.2"
/// status : "1"
/// forceUpdate : "1"

class Data {
  Data({
      this.nickname, 
      this.number, 
      this.avatar, 
      this.gender, 
      this.followNum, 
      this.isFollowNum, 
      this.lookNum, 
      this.currentVersion, 
      this.status, 
      this.forceUpdate,
      this.auditStatus});

  Data.fromJson(dynamic json) {
    nickname = json['nickname'];
    number = json['number'];
    avatar = json['avatar'];
    gender = json['gender'];
    followNum = json['follow_num'];
    isFollowNum = json['is_follow_num'];
    lookNum = json['look_num'];
    currentVersion = json['current_version'];
    status = json['status'];
    forceUpdate = json['forceUpdate'];
    auditStatus = json['audit_status'];
  }
  String? nickname;
  num? number;
  String? avatar;
  num? gender;
  num? followNum;
  num? isFollowNum;
  num? lookNum;
  String? currentVersion;
  String? status;
  String? forceUpdate;
  num? auditStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nickname'] = nickname;
    map['number'] = number;
    map['avatar'] = avatar;
    map['gender'] = gender;
    map['follow_num'] = followNum;
    map['is_follow_num'] = isFollowNum;
    map['look_num'] = lookNum;
    map['current_version'] = currentVersion;
    map['status'] = status;
    map['forceUpdate'] = forceUpdate;
    map['audit_status'] = auditStatus;
    return map;
  }

}