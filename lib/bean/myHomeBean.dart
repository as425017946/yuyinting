class myHomeBean {
  int? code;
  String? msg;
  Data? data;

  myHomeBean({this.code, this.msg, this.data});

  myHomeBean.fromJson(Map<String, dynamic> json) {
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
  MyUserInfo? userInfo;
  GiftList? giftList;

  Data({this.userInfo, this.giftList});

  Data.fromJson(Map<String, dynamic> json) {
    userInfo = json['user_info'] != null
        ? new MyUserInfo.fromJson(json['user_info'])
        : null;
    giftList = json['gift_list'] != null
        ? new GiftList.fromJson(json['gift_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo!.toJson();
    }
    if (this.giftList != null) {
      data['gift_list'] = this.giftList!.toJson();
    }
    return data;
  }
}

class MyUserInfo {
  int? number;
  String? nickname;
  int? avatar;
  int? gender;
  int? voiceCard;
  String? voiceLabel;
  int? isPretty;
  String? birthday;
  String? photoId;
  String? description;
  String? city;
  String? labelId;
  int? level;
  String? constellation;
  String? avatarUrl;
  String? voiceCardUrl;
  int? age;
  String? label;
  String? voiceLabelName;
  int? live;
  int? roomId;
  List<String>? photoUrl;
  String? avatarFrameImg;
  String? avatarFrameGifImg;
  int? isNew;
  int? newNoble;
  int? grLevel;

  MyUserInfo(
      {this.number,
        this.nickname,
        this.avatar,
        this.gender,
        this.voiceCard,
        this.voiceLabel,
        this.isPretty,
        this.birthday,
        this.photoId,
        this.description,
        this.city,
        this.labelId,
        this.level,
        this.constellation,
        this.avatarUrl,
        this.voiceCardUrl,
        this.age,
        this.label,
        this.voiceLabelName,
        this.live,
        this.roomId,
        this.photoUrl,
        this.avatarFrameImg,
        this.avatarFrameGifImg,
        this.isNew,
        this.newNoble,
        this.grLevel});

  MyUserInfo.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    gender = json['gender'];
    voiceCard = json['voice_card'];
    voiceLabel = json['voice_label'];
    isPretty = json['is_pretty'];
    birthday = json['birthday'];
    photoId = json['photo_id'];
    description = json['description'];
    city = json['city'];
    labelId = json['label_id'];
    level = json['level'];
    constellation = json['constellation'];
    avatarUrl = json['avatar_url'];
    voiceCardUrl = json['voice_card_url'];
    age = json['age'];
    label = json['label'];
    voiceLabelName = json['voice_label_name'];
    live = json['live'];
    roomId = json['room_id'];
    photoUrl = json['photo_url'].cast<String>();
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
    isNew = json['is_new'];
    newNoble = json['new_noble'];
    grLevel = json['gr_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['gender'] = this.gender;
    data['voice_card'] = this.voiceCard;
    data['voice_label'] = this.voiceLabel;
    data['is_pretty'] = this.isPretty;
    data['birthday'] = this.birthday;
    data['photo_id'] = this.photoId;
    data['description'] = this.description;
    data['city'] = this.city;
    data['label_id'] = this.labelId;
    data['level'] = this.level;
    data['constellation'] = this.constellation;
    data['avatar_url'] = this.avatarUrl;
    data['voice_card_url'] = this.voiceCardUrl;
    data['age'] = this.age;
    data['label'] = this.label;
    data['voice_label_name'] = this.voiceLabelName;
    data['live'] = this.live;
    data['room_id'] = this.roomId;
    data['photo_url'] = this.photoUrl;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    data['is_new'] = this.isNew;
    data['new_noble'] = this.newNoble;
    data['gr_level'] = this.grLevel;
    return data;
  }
}

class GiftList {
  List<ReceiveGift>? receiveGift;
  int? receiveGiftType;
  int? allGiftType;

  GiftList({this.receiveGift, this.receiveGiftType, this.allGiftType});

  GiftList.fromJson(Map<String, dynamic> json) {
    if (json['receive_gift'] != null) {
      receiveGift = <ReceiveGift>[];
      json['receive_gift'].forEach((v) {
        receiveGift!.add(new ReceiveGift.fromJson(v));
      });
    }
    receiveGiftType = json['receive_gift_type'];
    allGiftType = json['all_gift_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.receiveGift != null) {
      data['receive_gift'] = this.receiveGift!.map((v) => v.toJson()).toList();
    }
    data['receive_gift_type'] = this.receiveGiftType;
    data['all_gift_type'] = this.allGiftType;
    return data;
  }
}

class ReceiveGift {
  String? img;

  ReceiveGift({this.img});

  ReceiveGift.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
