
class charmMHBean {
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
  String? boxId;
  String? number;

  charmMHBean(
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
        this.boxId,
        this.number});

  charmMHBean.fromJson(Map<dynamic, dynamic> json) {
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
    boxId = json['box_id'];
    number = json['number'];
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
    data['box_id'] = this.boxId;
    data['number'] = this.number;
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
  String? nickName;
  List<GiftList>? giftList;

  GiftInfo({this.nickName, this.giftList});

  GiftInfo.fromJson(Map<String, dynamic> json) {
    nickName = json['nickname'];
    if (json['gift_list'] != null) {
      giftList = <GiftList>[];
      json['gift_list'].forEach((v) {
        giftList!.add(new GiftList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.giftList != null) {
      data['gift_list'] = this.giftList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class GiftList {
  String? giftName;
  String? giftImg;
  int? giftPrice;
  int? giftNumber;

  GiftList({this.giftName, this.giftImg, this.giftPrice, this.giftNumber});

  GiftList.fromJson(Map<String, dynamic> json) {
    giftName = json['gift_name'];
    giftImg = json['gift_img'];
    giftPrice = json['gift_price'];
    giftNumber = json['gift_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_name'] = this.giftName;
    data['gift_img'] = this.giftImg;
    data['gift_price'] = this.giftPrice;
    data['gift_number'] = this.giftNumber;
    return data;
  }
}