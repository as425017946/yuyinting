class roomLiuShuiBean {
  int? code;
  String? msg;
  Data? data;

  roomLiuShuiBean({this.code, this.msg, this.data});

  roomLiuShuiBean.fromJson(Map<String, dynamic> json) {
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
  List<Lists>? lists;
  String? guildName;

  Data({this.lists, this.guildName});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
      });
    }
    guildName = json['guild_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    data['guild_name'] = this.guildName;
    return data;
  }
}

class Lists {
  int? id;
  int? roomNumber;
  String? roomName;
  String? coverImg;
  String? beanSum;
  String? gbDirectSpend;
  String? packSpend;

  Lists(
      {this.id,
        this.roomNumber,
        this.roomName,
        this.coverImg,
        this.beanSum,
        this.gbDirectSpend,
        this.packSpend});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomNumber = json['room_number'];
    roomName = json['room_name'];
    coverImg = json['cover_img'];
    beanSum = json['bean_sum'];
    gbDirectSpend = json['gb_direct_spend'];
    packSpend = json['pack_spend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_number'] = this.roomNumber;
    data['room_name'] = this.roomName;
    data['cover_img'] = this.coverImg;
    data['bean_sum'] = this.beanSum;
    data['gb_direct_spend'] = this.gbDirectSpend;
    data['pack_spend'] = this.packSpend;
    return data;
  }
}
