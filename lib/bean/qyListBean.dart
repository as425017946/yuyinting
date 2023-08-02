class qyListBean {
  int? code;
  String? msg;
  List<Data>? data;

  qyListBean({this.code, this.msg, this.data});

  qyListBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? guildId;
  int? streamerUid;
  int? applyStatus;
  int? addTime;
  int? editTime;
  int? dataStatus;
  String? avatar;
  String? nickname;
  int? gender;

  Data(
      {this.id,
        this.guildId,
        this.streamerUid,
        this.applyStatus,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.avatar,
        this.nickname,
        this.gender});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guildId = json['guild_id'];
    streamerUid = json['streamer_uid'];
    applyStatus = json['apply_status'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guild_id'] = this.guildId;
    data['streamer_uid'] = this.streamerUid;
    data['apply_status'] = this.applyStatus;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['avatar'] = this.avatar;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    return data;
  }
}
