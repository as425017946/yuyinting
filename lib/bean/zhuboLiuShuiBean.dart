class zhuboLiuShuiBean {
  int? code;
  String? msg;
  Data? data;

  zhuboLiuShuiBean({this.code, this.msg, this.data});

  zhuboLiuShuiBean.fromJson(Map<String, dynamic> json) {
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

  Data({this.lists});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['lists'] != null) {
      lists = <Lists>[];
      json['lists'].forEach((v) {
        lists!.add(new Lists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lists != null) {
      data['lists'] = this.lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  int? id;
  int? streamerUid;
  int? identity;
  int? ratio;
  int? guildId;
  String? beanSum;
  String? gbDirectSpend;
  String? packSpend;
  String? nickname;
  int? streamerNumber;
  int? msgPeople;
  int? msgNum;

  Lists(
      {this.id,
        this.streamerUid,
        this.identity,
        this.ratio,
        this.guildId,
        this.beanSum,
        this.gbDirectSpend,
        this.packSpend,
        this.nickname,
        this.streamerNumber,
        this.msgPeople,
        this.msgNum});

  Lists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    streamerUid = json['streamer_uid'];
    identity = json['identity'];
    ratio = json['ratio'];
    guildId = json['guild_id'];
    beanSum = json['bean_sum'];
    gbDirectSpend = json['gb_direct_spend'];
    packSpend = json['pack_spend'];
    nickname = json['nickname'];
    streamerNumber = json['streamer_number'];
    msgPeople = json['msg_people'];
    msgNum = json['msg_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['streamer_uid'] = this.streamerUid;
    data['identity'] = this.identity;
    data['ratio'] = this.ratio;
    data['guild_id'] = this.guildId;
    data['bean_sum'] = this.beanSum;
    data['gb_direct_spend'] = this.gbDirectSpend;
    data['pack_spend'] = this.packSpend;
    data['nickname'] = this.nickname;
    data['streamer_number'] = this.streamerNumber;
    data['msg_people'] = this.msgPeople;
    data['msg_num'] = this.msgNum;
    return data;
  }
}
