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
  UserInfo? userInfo;
  GiftList? giftList;

  Data({this.userInfo, this.giftList});

  Data.fromJson(Map<String, dynamic> json) {
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
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

class UserInfo {
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
  String? constellation;
  String? avatarUrl;
  String? voiceCardUrl;
  int? age;
  String? label;
  String? voiceLabelName;
  List<String>? photoUrl;
  String? avatarFrameImg;
  String? avatarFrameGifImg;
  int? level;

  UserInfo(
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
        this.constellation,
        this.avatarUrl,
        this.voiceCardUrl,
        this.age,
        this.label,
        this.voiceLabelName,
        this.photoUrl,
        this.avatarFrameGifImg,
        this.avatarFrameImg,
        this.level});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    constellation = json['constellation'];
    avatarUrl = json['avatar_url'];
    voiceCardUrl = json['voice_card_url'];
    age = json['age'];
    label = json['label'];
    voiceLabelName = json['voice_label_name'];
    photoUrl = json['photo_url'].cast<String>();
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
    level = json['level'];
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
    data['constellation'] = this.constellation;
    data['avatar_url'] = this.avatarUrl;
    data['voice_card_url'] = this.voiceCardUrl;
    data['age'] = this.age;
    data['label'] = this.label;
    data['voice_label_name'] = this.voiceLabelName;
    data['photo_url'] = this.photoUrl;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    data['level'] = this.level;
    return data;
  }
}

class GiftList {
  List<ReceiveGift>? receiveGift;
  int? receiveGiftType;
  List<AllGiftArr>? allGiftArr;
  int? allGiftType;

  GiftList(
      {this.receiveGift,
        this.receiveGiftType,
        this.allGiftArr,
        this.allGiftType});

  GiftList.fromJson(Map<String, dynamic> json) {
    if (json['receive_gift'] != null) {
      receiveGift = <ReceiveGift>[];
      json['receive_gift'].forEach((v) {
        receiveGift!.add(new ReceiveGift.fromJson(v));
      });
    }
    receiveGiftType = json['receive_gift_type'];
    if (json['all_gift_arr'] != null) {
      allGiftArr = <AllGiftArr>[];
      json['all_gift_arr'].forEach((v) {
        allGiftArr!.add(new AllGiftArr.fromJson(v));
      });
    }
    allGiftType = json['all_gift_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.receiveGift != null) {
      data['receive_gift'] = this.receiveGift!.map((v) => v.toJson()).toList();
    }
    data['receive_gift_type'] = this.receiveGiftType;
    if (this.allGiftArr != null) {
      data['all_gift_arr'] = this.allGiftArr!.map((v) => v.toJson()).toList();
    }
    data['all_gift_type'] = this.allGiftType;
    return data;
  }
}

class ReceiveGift {
  String? img;
  int? count;

  ReceiveGift({this.img, this.count});

  ReceiveGift.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['count'] = this.count;
    return data;
  }
}

class AllGiftArr {
  String? img;
  String? name;
  int? status;
  int? count;

  AllGiftArr({this.img, this.name, this.status, this.count});

  AllGiftArr.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    name = json['name'];
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['name'] = this.name;
    data['status'] = this.status;
    data['count'] = this.count;
    return data;
  }
}
