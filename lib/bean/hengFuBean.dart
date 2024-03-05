class hengFuBean {
  String? roomId;
  String? roomName;
  String? amount;
  List<Charm>? charm;
  String? toNickname;
  String? fromNickname;
  String? toUids;
  String? lv;
  String? type;
  String? title;
  String? gameName;
  int? nobleId;
  List<GiftInfo>? giftInfo;

  hengFuBean(
      {this.roomId,
      this.amount,
      this.charm,
      this.toNickname,
      this.fromNickname,
      this.toUids,
      this.lv,
      this.type,
      this.giftInfo,
      this.roomName,
      this.title,
      this.nobleId,
      this.gameName});

  hengFuBean.fromJson(Map<dynamic, dynamic> json) {
    roomId = json['room_id'];
    amount = json['amount'];
    roomName = json['room_name'];
    title = json['title'];
    nobleId = json['noble_id'];
    if (json['charm'] != null) {
      charm = <Charm>[];
      json['charm'].forEach((v) {
        charm!.add(new Charm.fromJson(v));
      });
    }
    toNickname = json['to_nickname'];
    fromNickname = json['from_nickname'];
    toUids = json['to_uids'];
    lv = json['lv'];
    type = json['type'];
    gameName = json['game_name'];
    if (json['gift_info'] != null) {
      giftInfo = <GiftInfo>[];
      json['gift_info'].forEach((v) {
        giftInfo!.add(new GiftInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['amount'] = this.amount;
    data['room_name'] = this.roomName;
    data['title'] = this.title;
    data['noble_id'] = this.nobleId;
    if (this.charm != null) {
      data['charm'] = this.charm!.map((v) => v.toJson()).toList();
    }
    data['to_nickname'] = this.toNickname;
    data['from_nickname'] = this.fromNickname;
    data['to_uids'] = this.toUids;
    data['lv'] = this.lv;
    data['type'] = this.type;
    data['game_name'] = this.gameName;
    if (this.giftInfo != null) {
      data['gift_info'] = this.giftInfo!.map((v) => v.toJson()).toList();
    }
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

  GiftInfo({this.giftName, this.giftImg, this.giftPrice, this.giftNumber});

  GiftInfo.fromJson(Map<String, dynamic> json) {
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
