import '../utils/log_util.dart';

class charmBean {
  String? giftNumber;
  String? roomId;
  String? roomName;
  String? amount;
  List<Charm>? charm;
  String? toNickname;
  String? giftId;
  String? fromNickname;
  String? toUids;
  String? giftName;
  String? lv;
  String? type;

  charmBean(
      {this.giftNumber,
        this.roomId,
        this.roomName,
        this.amount,
        this.charm,
        this.toNickname,
        this.giftId,
        this.fromNickname,
        this.toUids,
        this.giftName,
        this.lv,
        this.type});

  charmBean.fromJson(Map<dynamic, dynamic> json) {
    giftNumber = json['gift_number'];
    roomId = json['room_id'];
    roomName = json['room_name'];
    amount = json['amount'];
    LogE('*******${json['charm'].toString()}');
    if (json['charm'] != null) {
      charm = <Charm>[];
      json['charm'].forEach((v) {
        charm!.add(new Charm.fromJson(v));
      });
    }
    toNickname = json['to_nickname'];
    giftId = json['gift_id'];
    fromNickname = json['from_nickname'];
    toUids = json['to_uids'];
    giftName = json['gift_name'];
    lv = json['lv'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gift_number'] = this.giftNumber;
    data['room_id'] = this.roomId;
    data['room_name'] = this.roomName;
    data['amount'] = this.amount;
    if (this.charm != null) {
      data['charm'] = this.charm!.map((v) => v.toJson()).toList();
    }
    data['to_nickname'] = this.toNickname;
    data['gift_id'] = this.giftId;
    data['from_nickname'] = this.fromNickname;
    data['to_uids'] = this.toUids;
    data['gift_name'] = this.giftName;
    data['lv'] = this.lv;
    data['type'] = this.type;
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
