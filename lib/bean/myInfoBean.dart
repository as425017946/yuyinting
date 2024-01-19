class MyInfoBean {
  int? code;
  String? msg;
  Data? data;

  MyInfoBean({this.code, this.msg, this.data});

  MyInfoBean.fromJson(Map<String, dynamic> json) {
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
  String? nickname;
  int? number;
  String? avatar;
  int? gender;
  int? nobleId;
  int? followNum;
  int? isFollowNum;
  int? lookNum;
  int? auditStatus;
  String? forceUpdate;
  String? identity;
  String? avatarFrameImg;
  String? avatarFrameGifImg;
  int? uid;
  int? level;
  int? unauditNum;
  int? kefuUid;
  String? kefuAvatar;
  int? isAgent;

  Data(
      {this.nickname,
        this.number,
        this.avatar,
        this.gender,
        this.nobleId,
        this.followNum,
        this.isFollowNum,
        this.lookNum,
        this.auditStatus,
        this.forceUpdate,
        this.identity,
        this.avatarFrameImg,
        this.avatarFrameGifImg,
        this.uid,
        this.level,
        this.unauditNum,
        this.kefuUid,
        this.kefuAvatar,
        this.isAgent});

  Data.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    number = json['number'];
    avatar = json['avatar'];
    gender = json['gender'];
    nobleId = json['noble_id'];
    followNum = json['follow_num'];
    isFollowNum = json['is_follow_num'];
    lookNum = json['look_num'];
    auditStatus = json['audit_status'];
    forceUpdate = json['force_update'];
    identity = json['identity'];
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
    uid = json['uid'];
    level = json['level'];
    unauditNum = json['unaudit_num'];
    kefuUid = json['kefu_uid'];
    kefuAvatar = json['kefu_avatar'];
    isAgent = json['is_agent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickname'] = this.nickname;
    data['number'] = this.number;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['noble_id'] = this.nobleId;
    data['follow_num'] = this.followNum;
    data['is_follow_num'] = this.isFollowNum;
    data['look_num'] = this.lookNum;
    data['audit_status'] = this.auditStatus;
    data['force_update'] = this.forceUpdate;
    data['identity'] = this.identity;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    data['uid'] = this.uid;
    data['level'] = this.level;
    data['unaudit_num'] = this.unauditNum;
    data['kefu_uid'] = this.kefuUid;
    data['kefu_avatar'] = this.kefuAvatar;
    data['is_agent'] = this.isAgent;
    return data;
  }
}
