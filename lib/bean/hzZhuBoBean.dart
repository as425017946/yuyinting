class hzZhuBoBean {
  int? code;
  String? msg;
  Data? data;

  hzZhuBoBean({this.code, this.msg, this.data});

  hzZhuBoBean.fromJson(Map<String, dynamic> json) {
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
  List<Lists>? lists;
  int? total;

  Data({this.lists, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Lists {
  int? cid;
  int? guildId;
  int? streamerUid;
  int? number;
  String? nickname;
  String? avatar;
  int? gender;
  int? id;
  int? identity;
  String? title;
  String? ratio;
  int? liveStatus;

  Lists(
      {this.cid,
        this.guildId,
        this.streamerUid,
        this.number,
        this.nickname,
        this.avatar,
        this.gender,
        this.id,
        this.identity,
        this.title,
        this.ratio,
        this.liveStatus});

  Lists.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    guildId = json['guild_id'];
    streamerUid = json['streamer_uid'];
    number = json['number'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    gender = json['gender'];
    id = json['id'];
    identity = json['identity'];
    title = json['title'];
    ratio = json['ratio'];
    liveStatus = json['live_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['guild_id'] = this.guildId;
    data['streamer_uid'] = this.streamerUid;
    data['number'] = this.number;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['identity'] = this.identity;
    data['title'] = this.title;
    data['ratio'] = this.ratio;
    data['live_status'] = this.liveStatus;
    return data;
  }
}
