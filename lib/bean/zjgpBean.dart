import 'package:yuyinting/utils/log_util.dart';

class zjgpBean {
  String? roomId;
  String? roomName;
  String? gameName;
  int? uid;
  String? nickName;
  String? type;
  List<GiftInfo>? giftInfo;
  String? amount;
  zjgpBean(
      {
        this.roomId,
        this.roomName,
        this.gameName,
        this.uid,
        this.nickName,
        this.type,
        this.giftInfo,
        this.amount});

  zjgpBean.fromJson(Map<dynamic, dynamic> json) {
    roomId = json['room_id'];
    roomName = json['room_name'];
    gameName = json['game_name'];
    uid = json['uid'];
    nickName = json['from_nickname'];
    type = json['type'];
    amount = json['amount'];
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
    data['room_name'] = this.roomName;
    data['game_name'] = this.gameName;
    data['uid'] = this.uid;
    data['nickname'] = this.nickName;
    data['type'] = this.type;
    data['amount'] = this.amount;
    if (this.giftInfo != null) {
      data['gift_info'] = this.giftInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GiftInfo {
  String? giftName;
  int? giftID;
  int? giftPrice;
  int? giftNumber;

  GiftInfo({this.giftName, this.giftID,this.giftPrice, this.giftNumber});

  GiftInfo.fromJson(Map<String, dynamic> json) {
    giftName = json['gift_name'];
    giftID = json['gift_id'];
    giftPrice = json['gift_price'];
    giftNumber = json['gift_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_name'] = this.giftName;
    data['gift_id'] = this.giftID;
    data['gift_price'] = this.giftPrice;
    data['gift_number'] = this.giftNumber;
    return data;
  }
}
