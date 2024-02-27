class ghPeopleBean {
  int? code;
  String? msg;
  Data? data;

  ghPeopleBean({this.code, this.msg, this.data});

  ghPeopleBean.fromJson(Map<String, dynamic> json) {
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
  List<ListP>? list;
  int? total;

  Data({this.list, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListP>[];
      json['list'].forEach((v) {
        list!.add(new ListP.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ListP {
  int? guildId;
  int? streamerUid;
  int? number;
  String? nickname;
  String? avatar;
  int? gender;
  int? id;
  int? liveStatus;
  int? identity;
  String? ratio;

  ListP(
      {this.guildId,
        this.streamerUid,
        this.number,
        this.nickname,
        this.avatar,
        this.gender,
        this.id,
        this.liveStatus,
        this.identity,
        this.ratio});

  ListP.fromJson(Map<String, dynamic> json) {
    guildId = json['guild_id'];
    streamerUid = json['streamer_uid'];
    number = json['number'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    gender = json['gender'];
    id = json['id'];
    liveStatus = json['live_status'];
    identity = json['identity'];
    ratio = json['ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guild_id'] = this.guildId;
    data['streamer_uid'] = this.streamerUid;
    data['number'] = this.number;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['live_status'] = this.liveStatus;
    data['identity'] = this.identity;
    data['ratio'] = this.ratio;
    return data;
  }
}
