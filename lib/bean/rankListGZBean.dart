class rankListGZBean {
  int? code;
  String? msg;
  Data? data;

  rankListGZBean({this.code, this.msg, this.data});

  rankListGZBean.fromJson(Map<String, dynamic> json) {
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
  List<Rank>? rank;

  Data({this.rank});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rank'] != null) {
      rank = <Rank>[];
      json['rank'].forEach((v) {
        rank!.add(new Rank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rank != null) {
      data['rank'] = this.rank!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rank {
  int? uid;
  String? avatar;
  String? nickname;
  int? nobleID;

  Rank({this.uid, this.avatar, this.nickname, this.nobleID});

  Rank.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    nobleID = json['noble_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['avatar'] = this.avatar;
    data['nickname'] = this.nickname;
    data['noble_id'] = this.nobleID;
    return data;
  }
}
