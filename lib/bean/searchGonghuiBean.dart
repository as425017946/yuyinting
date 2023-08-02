class searchGonghuiBean {
  int? code;
  String? msg;
  Data? data;

  searchGonghuiBean({this.code, this.msg, this.data});

  searchGonghuiBean.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? number;
  String? title;
  int? uid;
  String? logo;
  int? ad;
  String? qq;
  String? notice;
  String? addTime;
  int? editTime;
  int? dataStatus;
  int? leaderUid;
  int? leaderNumber;
  String? leaderNickname;
  String? leaderAvatar;
  int? isApply;
  String? signNotice;

  Data(
      {this.id,
        this.number,
        this.title,
        this.uid,
        this.logo,
        this.ad,
        this.qq,
        this.notice,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.leaderUid,
        this.leaderNumber,
        this.leaderNickname,
        this.leaderAvatar,
        this.isApply,
        this.signNotice});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    uid = json['uid'];
    logo = json['logo'];
    ad = json['ad'];
    qq = json['qq'];
    notice = json['notice'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    leaderUid = json['leader_uid'];
    leaderNumber = json['leader_number'];
    leaderNickname = json['leader_nickname'];
    leaderAvatar = json['leader_avatar'];
    isApply = json['is_apply'];
    signNotice = json['sign_notice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['logo'] = this.logo;
    data['ad'] = this.ad;
    data['qq'] = this.qq;
    data['notice'] = this.notice;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['leader_uid'] = this.leaderUid;
    data['leader_number'] = this.leaderNumber;
    data['leader_nickname'] = this.leaderNickname;
    data['leader_avatar'] = this.leaderAvatar;
    data['is_apply'] = this.isApply;
    data['sign_notice'] = this.signNotice;
    return data;
  }
}
