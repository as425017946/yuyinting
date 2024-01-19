class myGhBean {
  int? code;
  String? msg;
  Data? data;

  myGhBean({this.code, this.msg, this.data});

  myGhBean.fromJson(Map<String, dynamic> json) {
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
  String? identity;
  GuildInfo? guildInfo;
  int? streamerTotal;
  List<StreamerList>? streamerList;
  int? roomTotal;
  List<RoomList>? roomList;
  int? unauditNum;
  int? kefuUid;
  String? kefUavatar;

  Data(
      {this.identity,
        this.guildInfo,
        this.streamerTotal,
        this.streamerList,
        this.roomTotal,
        this.roomList,
        this.unauditNum,
        this.kefuUid,
        this.kefUavatar});

  Data.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    guildInfo = json['guild_info'] != null
        ? new GuildInfo.fromJson(json['guild_info'])
        : null;
    streamerTotal = json['streamer_total'];
    if (json['streamer_list'] != null) {
      streamerList = <StreamerList>[];
      json['streamer_list'].forEach((v) {
        streamerList!.add(new StreamerList.fromJson(v));
      });
    }
    roomTotal = json['room_total'];
    if (json['room_list'] != null) {
      roomList = <RoomList>[];
      json['room_list'].forEach((v) {
        roomList!.add(new RoomList.fromJson(v));
      });
    }
    unauditNum = json['unaudit_num'];
    kefuUid = json['kefu_uid'];
    kefUavatar = json['kefu_avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identity'] = this.identity;
    if (this.guildInfo != null) {
      data['guild_info'] = this.guildInfo!.toJson();
    }
    data['streamer_total'] = this.streamerTotal;
    if (this.streamerList != null) {
      data['streamer_list'] =
          this.streamerList!.map((v) => v.toJson()).toList();
    }
    data['room_total'] = this.roomTotal;
    if (this.roomList != null) {
      data['room_list'] = this.roomList!.map((v) => v.toJson()).toList();
    }
    data['unaudit_num'] = this.unauditNum;
    return data;
  }
}

class GuildInfo {
  int? id;
  int? number;
  String? title;
  int? uid;
  String? logo;
  int? ad;
  String? qq;
  String? notice;
  String? addTime;
  int? editTime;
  int? dataStatus;

  GuildInfo(
      {this.id,
        this.number,
        this.title,
        this.uid,
        this.logo,
        this.ad,
        this.qq,
        this.notice,
        this.addTime,
        this.editTime,
        this.dataStatus});

  GuildInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    uid = json['uid'];
    logo = json['logo'];
    ad = json['ad'];
    qq = json['qq'];
    notice = json['notice'];
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
    data['ad'] = this.ad;
    data['qq'] = this.qq;
    data['notice'] = this.notice;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    return data;
  }
}

class StreamerList {
  int? guildId;
  int? streamerUid;
  int? number;
  String? nickname;
  String? avatar;
  int? gender;
  int? id;
  int? liveStatus;

  StreamerList(
      {this.guildId,
        this.streamerUid,
        this.number,
        this.nickname,
        this.avatar,
        this.gender,
        this.id,
        this.liveStatus});

  StreamerList.fromJson(Map<String, dynamic> json) {
    guildId = json['guild_id'];
    streamerUid = json['streamer_uid'];
    number = json['number'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    gender = json['gender'];
    id = json['id'];
    liveStatus = json['live_status'];
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
    return data;
  }
}

class RoomList {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;

  RoomList({this.id, this.roomNumber, this.roomName, this.coverImg});

  RoomList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    return data;
  }
}
