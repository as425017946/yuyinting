class roomInfoBean {
  int? code;
  String? msg;
  Data? data;

  roomInfoBean({this.code, this.msg, this.data});

  roomInfoBean.fromJson(Map<String, dynamic> json) {
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
  RoomInfo? roomInfo;
  UserInfo? userInfo;

  Data({this.roomInfo, this.userInfo});

  Data.fromJson(Map<String, dynamic> json) {
    roomInfo = json['room_info'] != null
        ? new RoomInfo.fromJson(json['room_info'])
        : null;
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.roomInfo != null) {
      data['room_info'] = this.roomInfo!.toJson();
    }
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class RoomInfo {
  int? roomNumber;
  String? roomName;
  int? coverImg;
  int? bg;
  int? bgType;
  String? notice;
  int? hotDegree;
  String? secondPwd;
  int? isShow;
  String? coverImgUrl;
  String? bgUrl;
  String? followStatus;
  int? isForbation;
  int? lockMic;
  int? pkTime;
  int? pkStatus;
  int? syTime;
  List<MikeList>? mikeList;
  String? blueScore;
  String? redScore;
  String? win;

  RoomInfo(
      {this.roomNumber,
        this.roomName,
        this.coverImg,
        this.bg,
        this.bgType,
        this.notice,
        this.hotDegree,
        this.secondPwd,
        this.isShow,
        this.coverImgUrl,
        this.bgUrl,
        this.followStatus,
        this.isForbation,
        this.mikeList,
        this.lockMic,
        this.pkTime,
        this.pkStatus,
        this.syTime,
        this.blueScore,
        this.redScore,
        this.win});

  RoomInfo.fromJson(Map<String, dynamic> json) {
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    bg = json['bg'];
    bgType = json['bg_type'];
    notice = json['notice'];
    hotDegree = json['hot_degree'];
    secondPwd = json['second_pwd'];
    isShow = json['is_show'];
    coverImgUrl = json['cover_img_url'];
    bgUrl = json['bg_url'];
    followStatus = json['follow_status'];
    isForbation = json['isForbation'];
    lockMic = json['lock_mic'];
    pkTime = json['pk_time'];
    pkStatus = json['pk_status'];
    syTime = json['sy_time'];
    blueScore = json['blue_score'];
    redScore = json['red_score'];
    win = json['win'];
    if (json['mike_list'] != null) {
      mikeList = <MikeList>[];
      json['mike_list'].forEach((v) {
        mikeList!.add(new MikeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['bg'] = this.bg;
    data['bg_type'] = this.bgType;
    data['notice'] = this.notice;
    data['hot_degree'] = this.hotDegree;
    data['second_pwd'] = this.secondPwd;
    data['is_show'] = this.isShow;
    data['cover_img_url'] = this.coverImgUrl;
    data['bg_url'] = this.bgUrl;
    data['follow_status'] = this.followStatus;
    data['isForbation'] = this.isForbation;
    data['lock_mic'] = this.lockMic;
    data['pk_time'] = this.pkTime;
    data['pk_status'] = this.pkStatus;
    data['sy_time'] = this.syTime;
    data['blue_score'] = this.blueScore;
    data['red_score'] = this.redScore;
    data['win'] = this.win;
    if (this.mikeList != null) {
      data['mike_list'] = this.mikeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MikeList {
  int? id;
  int? uid;
  int? roomId;
  int? serialNumber;
  int? isBoss;
  int? isLock;
  int? isClose;
  String? nickname;
  String? avatar;
  int? charm;
  String? identity;
  String? waveImg;
  String? waveGifImg;
  String? avatarFrameImg;
  String? avatarFrameGifImg;
  bool? isAudio;
  String? waveName;

  MikeList(
      {this.id,
        this.uid,
        this.roomId,
        this.serialNumber,
        this.isBoss,
        this.isLock,
        this.isClose,
        this.nickname,
        this.avatar,
        this.charm,
        this.identity,
        this.waveImg,
        this.waveGifImg,
        this.avatarFrameImg,
        this.avatarFrameGifImg,
        this.isAudio,
        this.waveName});

  MikeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    roomId = json['room_id'];
    serialNumber = json['serial_number'];
    isBoss = json['is_boss'];
    isLock = json['is_lock'];
    isClose = json['is_close'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    charm = json['charm'];
    identity = json['identity'];
    waveImg = json['wave_img'];
    waveGifImg = json['wave_gif_img'];
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
    isAudio = json['is_audio'];
    waveName = json['wave_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['room_id'] = this.roomId;
    data['serial_number'] = this.serialNumber;
    data['is_boss'] = this.isBoss;
    data['is_lock'] = this.isLock;
    data['is_close'] = this.isClose;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['charm'] = this.charm;
    data['identity'] = this.identity;
    data['wave_img'] = this.waveImg;
    data['wave_gif_img'] = this.waveGifImg;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    data['is_audio'] = this.isAudio;
    data['wave_name'] = this.waveName;
    return data;
  }
}

class UserInfo {
  String? role;
  String? nobleId;
  String? carDressGifImg;
  int? level;
  UserInfo({this.role, this.nobleId, this.carDressGifImg, this.level});

  UserInfo.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    nobleId = json['noble_id'];
    level = json['level'];
    carDressGifImg = json['car_dress_gif_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['noble_id'] = this.nobleId;;
    data['level'] = this.level;
    data['car_dress_gif_img'] = this.carDressGifImg;
    return data;
  }
}
