class ghJieSuanListBean {
  int? code;
  String? msg;
  Data? data;

  ghJieSuanListBean({this.code, this.msg, this.data});

  ghJieSuanListBean.fromJson(Map<String, dynamic> json) {
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
  List<Settle>? settle;
  String? guildName;

  Data({this.settle, this.guildName});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['settle'] != null) {
      settle = <Settle>[];
      json['settle'].forEach((v) {
        settle!.add(new Settle.fromJson(v));
      });
    }
    guildName = json['guild_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.settle != null) {
      data['settle'] = this.settle!.map((v) => v.toJson()).toList();
    }
    data['guild_name'] = this.guildName;
    return data;
  }
}

class Settle {
  int? id;
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

  Settle(
      {this.id,
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
        this.dataStatus});

  Settle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    return data;
  }
}
