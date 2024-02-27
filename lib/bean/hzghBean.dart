class hzghBean {
  int? code;
  String? msg;
  Data? data;

  hzghBean({this.code, this.msg, this.data});

  hzghBean.fromJson(Map<String, dynamic> json) {
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
  ConsortiaInfo? consortiaInfo;
  int? streamerTotal;
  List<StreamerList>? streamerList;
  int? guildTotal;
  List<GuildList>? guildList;
  int? kefuUid;
  String? kefuAvatar;

  Data(
      {this.consortiaInfo,
        this.streamerTotal,
        this.streamerList,
        this.guildTotal,
        this.guildList,
        this.kefuUid,
        this.kefuAvatar});

  Data.fromJson(Map<String, dynamic> json) {
    consortiaInfo = json['consortia_info'] != null
        ? new ConsortiaInfo.fromJson(json['consortia_info'])
        : null;
    streamerTotal = json['streamer_total'];
    if (json['streamer_list'] != null) {
      streamerList = <StreamerList>[];
      json['streamer_list'].forEach((v) {
        streamerList!.add(new StreamerList.fromJson(v));
      });
    }
    guildTotal = json['guild_total'];
    if (json['guild_list'] != null) {
      guildList = <GuildList>[];
      json['guild_list'].forEach((v) {
        guildList!.add(new GuildList.fromJson(v));
      });
    }
    kefuUid = json['kefu_uid'];
    kefuAvatar = json['kefu_avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consortiaInfo != null) {
      data['consortia_info'] = this.consortiaInfo!.toJson();
    }
    data['streamer_total'] = this.streamerTotal;
    if (this.streamerList != null) {
      data['streamer_list'] =
          this.streamerList!.map((v) => v.toJson()).toList();
    }
    data['guild_total'] = this.guildTotal;
    if (this.guildList != null) {
      data['guild_list'] = this.guildList!.map((v) => v.toJson()).toList();
    }
    data['kefu_uid'] = this.kefuUid;
    data['kefu_avatar'] = this.kefuAvatar;
    return data;
  }
}

class ConsortiaInfo {
  int? id;
  int? number;
  String? title;
  int? uid;
  String? logo;
  String? addTime;
  int? editTime;
  int? dataStatus;

  ConsortiaInfo(
      {this.id,
        this.number,
        this.title,
        this.uid,
        this.logo,
        this.addTime,
        this.editTime,
        this.dataStatus});

  ConsortiaInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    uid = json['uid'];
    logo = json['logo'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['logo'] = this.logo;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    return data;
  }
}

class StreamerList {
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

  StreamerList(
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

  StreamerList.fromJson(Map<String, dynamic> json) {
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

class GuildList {
  int? id;
  int? number;
  String? title;
  int? uid;
  String? ratio;
  String? logo;
  String? leaderNickname;

  GuildList(
      {this.id,
        this.number,
        this.title,
        this.uid,
        this.ratio,
        this.logo,
        this.leaderNickname});

  GuildList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    uid = json['uid'];
    ratio = json['ratio'];
    logo = json['logo'];
    leaderNickname = json['leader_nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['ratio'] = this.ratio;
    data['logo'] = this.logo;
    data['leader_nickname'] = this.leaderNickname;
    return data;
  }
}
