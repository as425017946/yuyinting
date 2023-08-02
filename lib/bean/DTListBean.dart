class DTListBean {
  int? code;
  String? msg;
  Data? data;

  DTListBean({this.code, this.msg, this.data});

  DTListBean.fromJson(Map<String, dynamic> json) {
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
  List<ListDT>? list;
  String? isEnd;

  Data({this.list, this.isEnd});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListDT>[];
      json['list'].forEach((v) {
        list!.add(new ListDT.fromJson(v));
      });
    }
    isEnd = json['is_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['is_end'] = this.isEnd;
    return data;
  }
}

class ListDT {
  int? id;
  int? uid;
  String? text;
  String? imgId;
  int? like;
  int? comment;
  int? auditStatus;
  String? addTime;
  int? editTime;
  int? dataStatus;
  String? nickname;
  String? avatar;
  int? number;
  int? age;
  String? constellation;
  int? gender;
  String? city;
  int? liveStatus;
  List<String>? imgUrl;
  int? isHi;

  ListDT(
      {this.id,
        this.uid,
        this.text,
        this.imgId,
        this.like,
        this.comment,
        this.auditStatus,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.nickname,
        this.avatar,
        this.number,
        this.age,
        this.constellation,
        this.gender,
        this.city,
        this.liveStatus,
        this.imgUrl,
        this.isHi});

  ListDT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    text = json['text'];
    imgId = json['img_id'];
    like = json['like'];
    comment = json['comment'];
    auditStatus = json['audit_status'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    number = json['number'];
    age = json['age'];
    constellation = json['constellation'];
    gender = json['gender'];
    city = json['city'];
    liveStatus = json['live_status'];
    imgUrl = json['img_url'].cast<String>();
    isHi = json['is_hi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['text'] = this.text;
    data['img_id'] = this.imgId;
    data['like'] = this.like;
    data['comment'] = this.comment;
    data['audit_status'] = this.auditStatus;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['number'] = this.number;
    data['age'] = this.age;
    data['constellation'] = this.constellation;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['live_status'] = this.liveStatus;
    data['img_url'] = this.imgUrl;
    data['is_hi'] = this.isHi;
    return data;
  }
}
