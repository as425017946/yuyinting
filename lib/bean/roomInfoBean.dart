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
  int? syTime;
  int? pkTime;
  int? pkStatus;
  String? blueScore;
  String? redScore;
  String? win;
  List<MikeList>? mikeList;

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
        this.lockMic,
        this.syTime,
        this.pkTime,
        this.pkStatus,
        this.blueScore,
        this.redScore,
        this.win,
        this.mikeList});

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
    syTime = json['sy_time'];
    pkTime = json['pk_time'];
    pkStatus = json['pk_status'];
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
    data['sy_time'] = this.syTime;
    data['pk_time'] = this.pkTime;
    data['pk_status'] = this.pkStatus;
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
  int? editTime;
  String? nickname;
  String? avatar;
  int? charm;
  String? identity;
  String? waveImg;
  String? waveGifImg;
  String? waveName;
  String? avatarFrameImg;
  String? avatarFrameGifImg;
  bool? isAudio;

  MikeList(
      {this.id,
        this.uid,
        this.roomId,
        this.serialNumber,
        this.isBoss,
        this.isLock,
        this.isClose,
        this.editTime,
        this.nickname,
        this.avatar,
        this.charm,
        this.identity,
        this.waveImg,
        this.waveGifImg,
        this.waveName,
        this.avatarFrameImg,
        this.avatarFrameGifImg,
        this.isAudio});

  MikeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    roomId = json['room_id'];
    serialNumber = json['serial_number'];
    isBoss = json['is_boss'];
    isLock = json['is_lock'];
    isClose = json['is_close'];
    editTime = json['edit_time'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    charm = json['charm'];
    identity = json['identity'];
    waveImg = json['wave_img'];
    waveGifImg = json['wave_gif_img'];
    waveName = json['wave_name'];
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
    isAudio = json['is_audio'];
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
    data['edit_time'] = this.editTime;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['charm'] = this.charm;
    data['identity'] = this.identity;
    data['wave_img'] = this.waveImg;
    data['wave_gif_img'] = this.waveGifImg;
    data['wave_name'] = this.waveName;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    data['is_audio'] = this.isAudio;
    return data;
  }
}

class UserInfo {
  String? role;
  String? nobleId;
  String? carDressGifImg;
  String? carDressName;
  String? nickname;
  int? level;
  int? grLevel;
  int? isPretty;
  int? isNew;
  int? newNoble;

  String? avatar;
  // ignore: non_constant_identifier_names
  String? enter_dress_gif_img;
  // ignore: non_constant_identifier_names
  String? enter_dress_name;

  UserInfo(
      {this.role,
        this.nobleId,
        this.carDressGifImg,
        this.carDressName,
        this.nickname,
        this.level,
        this.grLevel,
        this.isPretty,
        this.isNew,
        this.newNoble});

  UserInfo.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    nobleId = json['noble_id'];
    carDressGifImg = json['car_dress_gif_img'];
    carDressName = json['car_dress_name'];
    nickname = json['nickname'];
    level = json['level'];
    grLevel = json['gr_level'];
    isPretty = json['is_pretty'];
    isNew = json['is_new'];
    newNoble = json['new_noble'];
    avatar = json['avatar'] ?? '';
    enter_dress_gif_img = json['enter_dress_gif_img'] ?? '';
    enter_dress_name = json['enter_dress_name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['noble_id'] = this.nobleId;
    data['car_dress_gif_img'] = this.carDressGifImg;
    data['car_dress_name'] = this.carDressName;
    data['nickname'] = this.nickname;
    data['level'] = this.level;
    data['gr_level'] = this.grLevel;
    data['is_pretty'] = this.isPretty;
    data['is_new'] = this.isNew;
    data['new_noble'] = this.newNoble;
    data['avatar'] = this.avatar;
    data['enter_dress_gif_img'] = this.enter_dress_gif_img;
    data['enter_dress_name'] = this.enter_dress_name;
    return data;
  }// 进厅横幅名称
}
