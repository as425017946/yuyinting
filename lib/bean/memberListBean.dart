class memberListBean {
  int? code;
  String? msg;
  Data? data;

  memberListBean({this.code, this.msg, this.data});

  memberListBean.fromJson(Map<String, dynamic> json) {
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
  List<ListOn>? list;
  String? isEnd;
  String? total;

  Data({this.list, this.isEnd, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListOn>[];
      json['list'].forEach((v) {
        list!.add(new ListOn.fromJson(v));
      });
    }
    isEnd = json['is_end'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['is_end'] = this.isEnd;
    data['total'] = this.total;
    return data;
  }
}

class ListOn {
  int? uid;
  int? number;
  String? nickname;
  int? gender;
  String? avatar;
  int? isOnMic;

  ListOn({this.uid, this.number, this.nickname, this.gender, this.avatar});

  ListOn.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    number = json['number'];
    nickname = json['nickname'];
    gender = json['gender'];
    avatar = json['avatar'];
    isOnMic = json['isOnMic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['number'] = this.number;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['isOnMic'] = this.isOnMic;
    return data;
  }
}
