class maiXuBean {
  int? code;
  String? msg;
  List<Data>? data;

  maiXuBean({this.code, this.msg, this.data});

  maiXuBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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
  String? avatarFrameImg;
  String? avatarFrameGifImg;

  Data(
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
        this.avatarFrameImg,
        this.avatarFrameGifImg});

  Data.fromJson(Map<String, dynamic> json) {
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
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
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
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    return data;
  }
}
