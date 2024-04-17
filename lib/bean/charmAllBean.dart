class charmAllBean {
  String? roomId;
  String? roomName;
  String? amount;
  List<Charm>? charm;
  String? toNickname;
  String? fromNickname;
  String? fromUid;
  String? toUids;
  String? avatar;
  String? lv;
  String? type;
  List<GiftInfo>? giftInfo;
  String? blueScore;
  String? redScore;
  String? recordToNickname;

  charmAllBean(
      {
        this.roomId,
        this.amount,
        this.charm,
        this.toNickname,
        this.fromNickname,
        this.toUids,
        this.lv,
        this.type,
        this.giftInfo,
        this.roomName,
        this.fromUid,
        this.avatar,
        this.blueScore,
        this.redScore,
        this.recordToNickname});

  charmAllBean.fromJson(Map<dynamic, dynamic> json) {
    roomId = json['room_id'];
    amount = json['amount'];
    if (json['charm'] != null) {
      charm = <Charm>[];
      json['charm'].forEach((v) {
        charm!.add(new Charm.fromJson(v));
      });
    }
    toNickname = json['to_nickname'];
    fromNickname = json['from_nickname'];
    fromUid = json['from_uid'];
    toUids = json['to_uids'];
    avatar = json['avatar'];
    lv = json['lv'];
    type = json['type'];
    blueScore = json['blue_score'];
    redScore = json['red_score'];
    if (json['gift_info'] != null) {
      giftInfo = <GiftInfo>[];
      json['gift_info'].forEach((v) {
        giftInfo!.add(new GiftInfo.fromJson(v));
      });
    }
    roomName = json['room_name'];
    recordToNickname = json['record_to_nickname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['amount'] = this.amount;
    if (this.charm != null) {
      data['charm'] = this.charm!.map((v) => v.toJson()).toList();
    }
    data['to_nickname'] = this.toNickname;
    data['from_nickname'] = this.fromNickname;
    data['from_uid'] = this.fromUid;
    data['to_uids'] = this.toUids;
    data['avatar'] = this.avatar;
    data['lv'] = this.lv;
    data['type'] = this.type;
    data['blue_score'] = this.blueScore;
    data['red_score'] = this.redScore;
    if (this.giftInfo != null) {
      data['gift_info'] = this.giftInfo!.map((v) => v.toJson()).toList();
    }
    data['room_name'] = this.roomName;
    data['record_to_nickname'] = this.recordToNickname;
    return data;
  }
}

class Charm {
  String? uid;
  int? charm;

  Charm({this.uid, this.charm});

  Charm.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    charm = json['charm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['charm'] = this.charm;
    return data;
  }
}

class GiftInfo {
  String? giftName;
  String? giftImg;
  int? giftPrice;
  int? giftNumber;
  String? giftImgStatic;

  GiftInfo({this.giftName, this.giftImg,this.giftPrice, this.giftNumber, this.giftImgStatic});

  GiftInfo.fromJson(Map<String, dynamic> json) {
    giftName = json['gift_name'];
    giftImg = json['gift_img'];
    giftPrice = json['gift_price'];
    giftNumber = json['gift_number'];
    giftImgStatic = json['gift_img_static'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_name'] = this.giftName;
    data['gift_img'] = this.giftImg;
    data['gift_price'] = this.giftPrice;
    data['gift_number'] = this.giftNumber;
    data['gift_img_static'] = this.giftImgStatic;
    return data;
  }
}
