class DTMoreBean {
  int? code;
  String? msg;
  Data? data;

  DTMoreBean({this.code, this.msg, this.data});

  DTMoreBean.fromJson(Map<String, dynamic> json) {
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
  NoteInfo? noteInfo;
  CurUserInfo? curUserInfo;

  Data({this.noteInfo, this.curUserInfo});

  Data.fromJson(Map<String, dynamic> json) {
    noteInfo = json['note_info'] != null
        ? new NoteInfo.fromJson(json['note_info'])
        : null;
    curUserInfo = json['cur_user_info'] != null
        ? new CurUserInfo.fromJson(json['cur_user_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.noteInfo != null) {
      data['note_info'] = this.noteInfo!.toJson();
    }
    if (this.curUserInfo != null) {
      data['cur_user_info'] = this.curUserInfo!.toJson();
    }
    return data;
  }
}

class NoteInfo {
  int? isHi;
  int? isLike;
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
  String? avatar;
  String? nickname;
  int? gender;
  String? city;
  int? age;
  String? constellation;
  List<String>? imgUrl;
  int? liveStatus;
  int? type;
  List<CommentList>? commentList;

  NoteInfo(
      {this.isHi,
        this.isLike,
        this.id,
        this.uid,
        this.text,
        this.imgId,
        this.like,
        this.comment,
        this.auditStatus,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.avatar,
        this.nickname,
        this.gender,
        this.city,
        this.age,
        this.constellation,
        this.imgUrl,
        this.liveStatus,
        this.type,
        this.commentList});

  NoteInfo.fromJson(Map<String, dynamic> json) {
    isHi = json['is_hi'];
    isLike = json['is_like'];
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
    avatar = json['avatar'];
    nickname = json['nickname'];
    gender = json['gender'];
    city = json['city'];
    age = json['age'];
    type = json['type'];
    constellation = json['constellation'];
    imgUrl = json['img_url'].cast<String>();
    liveStatus = json['live_status'];
    if (json['comment_list'] != null) {
      commentList = <CommentList>[];
      json['comment_list'].forEach((v) {
        commentList!.add(new CommentList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_hi'] = this.isHi;
    data['is_like'] = this.isLike;
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
    data['avatar'] = this.avatar;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['age'] = this.age;
    data['type'] = this.type;
    data['constellation'] = this.constellation;
    data['img_url'] = this.imgUrl;
    data['live_status'] = this.liveStatus;
    if (this.commentList != null) {
      data['comment_list'] = this.commentList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentList {
  int? id;
  int? noteId;
  int? uid;
  String? content;
  String? addTime;
  int? editTime;
  int? dataStatus;
  String? nickname;
  String? avatar;
  int? number;
  int? gender;
  String? city;

  CommentList(
      {this.id,
        this.noteId,
        this.uid,
        this.content,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.nickname,
        this.avatar,
        this.number,
        this.gender,
        this.city});

  CommentList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    uid = json['uid'];
    content = json['content'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    number = json['number'];
    gender = json['gender'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note_id'] = this.noteId;
    data['uid'] = this.uid;
    data['content'] = this.content;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['nickname'] = this.nickname;
    data['avatar'] = this.avatar;
    data['number'] = this.number;
    data['gender'] = this.gender;
    data['city'] = this.city;
    return data;
  }
}

class CurUserInfo {
  int? uid;

  CurUserInfo({this.uid});

  CurUserInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    return data;
  }
}
