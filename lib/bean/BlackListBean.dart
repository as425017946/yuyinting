/// code : 200
/// msg : "ok"
/// data : [{"black_uid":11,"nickname":"昵称3","number":8888,"avatar":"https://lmg.jj20.com/up/allimg/tp06/20120222122H618-0-lp.jpg"},{"black_uid":5,"nickname":"u5","number":105,"avatar":"https://lmg.jj20.com/up/allimg/4k/s/02/2109250006343S5-0-lp.jpg"}]

class BlackListBean {
  BlackListBean({
      this.code, 
      this.msg, 
      this.data,});

  BlackListBean.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  num? code;
  String? msg;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// black_uid : 11
/// nickname : "昵称3"
/// number : 8888
/// avatar : "https://lmg.jj20.com/up/allimg/tp06/20120222122H618-0-lp.jpg"

class Data {
  Data({
      this.blackUid, 
      this.nickname, 
      this.number, 
      this.avatar,});

  Data.fromJson(dynamic json) {
    blackUid = json['black_uid'];
    nickname = json['nickname'];
    number = json['number'];
    avatar = json['avatar'];
  }
  num? blackUid;
  String? nickname;
  num? number;
  String? avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['black_uid'] = blackUid;
    map['nickname'] = nickname;
    map['number'] = number;
    map['avatar'] = avatar;
    return map;
  }

}