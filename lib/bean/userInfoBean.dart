class userInfoBean {
  int? code;
  String? msg;
  Data? data;

  userInfoBean({this.code, this.msg, this.data});

  userInfoBean.fromJson(Map<String, dynamic> json) {
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
  int? live;
  int? roomID;
  List<String>? photoUrl;
  int? isHi;
  String? isFollow;
  String? avatarFrameImg;
  String? avatarFrameGifImg;

  Data(
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
        this.live,
        this.roomID,
        this.photoUrl,
        this.isHi,
        this.isFollow,
        this.avatarFrameGifImg,
        this.avatarFrameImg});

  Data.fromJson(Map<String, dynamic> json) {
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
    live = json['live'];
    roomID = json['room_id'];
    photoUrl = json['photo_url'].cast<String>();
    isHi = json['is_hi'];
    isFollow = json['is_follow'];
    avatarFrameImg = json['avatar_frame_img'];
    avatarFrameGifImg = json['avatar_frame_gif_img'];
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
    data['live'] = this.live;
    data['photo_url'] = this.photoUrl;
    data['is_hi'] = this.isHi;
    data['avatar_frame_img'] = this.avatarFrameImg;
    data['avatar_frame_gif_img'] = this.avatarFrameGifImg;
    return data;
  }
}
