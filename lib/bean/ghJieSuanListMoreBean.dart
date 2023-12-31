class ghJieSuanListMoreBean {
  int? code;
  String? msg;
  List<Data>? data;

  ghJieSuanListMoreBean({this.code, this.msg, this.data});

  ghJieSuanListMoreBean.fromJson(Map<String, dynamic> json) {
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
  int? guildSettleId;
  int? roomId;
  int? guildId;
  String? beginTime;
  String? endTime;
  String? weekSp;
  String? packSp;
  String? gbDirectSp;
  String? dDirectSp;
  String? dGame;
  String? weekRebateGc;
  String? weekRebateD;
  String? unvalidSp;
  String? deductibleGc;
  String? deductibleD;
  int? settleStatus;
  int? settleAdmin;
  int? addTime;
  int? editTime;
  int? dataStatus;
  String? roomName;

  Data(
      {this.id,
        this.guildSettleId,
        this.roomId,
        this.guildId,
        this.beginTime,
        this.endTime,
        this.weekSp,
        this.packSp,
        this.gbDirectSp,
        this.dDirectSp,
        this.dGame,
        this.weekRebateGc,
        this.weekRebateD,
        this.unvalidSp,
        this.deductibleGc,
        this.deductibleD,
        this.settleStatus,
        this.settleAdmin,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.roomName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guildSettleId = json['guild_settle_id'];
    roomId = json['room_id'];
    guildId = json['guild_id'];
    beginTime = json['begin_time'];
    endTime = json['end_time'];
    weekSp = json['week_sp'];
    packSp = json['pack_sp'];
    gbDirectSp = json['gb_direct_sp'];
    dDirectSp = json['d_direct_sp'];
    dGame = json['d_game'];
    weekRebateGc = json['week_rebate_gc'];
    weekRebateD = json['week_rebate_d'];
    unvalidSp = json['unvalid_sp'];
    deductibleGc = json['deductible_gc'];
    deductibleD = json['deductible_d'];
    settleStatus = json['settle_status'];
    settleAdmin = json['settle_admin'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    roomName = json['room_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guild_settle_id'] = this.guildSettleId;
    data['room_id'] = this.roomId;
    data['guild_id'] = this.guildId;
    data['begin_time'] = this.beginTime;
    data['end_time'] = this.endTime;
    data['week_sp'] = this.weekSp;
    data['pack_sp'] = this.packSp;
    data['gb_direct_sp'] = this.gbDirectSp;
    data['d_direct_sp'] = this.dDirectSp;
    data['d_game'] = this.dGame;
    data['week_rebate_gc'] = this.weekRebateGc;
    data['week_rebate_d'] = this.weekRebateD;
    data['unvalid_sp'] = this.unvalidSp;
    data['deductible_gc'] = this.deductibleGc;
    data['deductible_d'] = this.deductibleD;
    data['settle_status'] = this.settleStatus;
    data['settle_admin'] = this.settleAdmin;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['room_name'] = this.roomName;
    return data;
  }
}
