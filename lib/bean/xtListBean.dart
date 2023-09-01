class xtListBean {
  int? code;
  String? msg;
  Data? data;

  xtListBean({this.code, this.msg, this.data});

  xtListBean.fromJson(Map<String, dynamic> json) {
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
  List<ListXT>? list;

  Data({this.list});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ListXT>[];
      json['list'].forEach((v) {
        list!.add(new ListXT.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListXT {
  int? id;
  int? type;
  String? title;
  String? text;
  int? img;
  String? url;
  String? addTime;
  int? editTime;
  int? dataStatus;
  String? imgUrl;

  ListXT(
      {this.id,
        this.type,
        this.title,
        this.text,
        this.img,
        this.url,
        this.addTime,
        this.editTime,
        this.dataStatus,
        this.imgUrl});

  ListXT.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    text = json['text'];
    img = json['img'];
    url = json['url'];
    addTime = json['add_time'];
    editTime = json['edit_time'];
    dataStatus = json['data_status'];
    imgUrl = json['img_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['text'] = this.text;
    data['img'] = this.img;
    data['url'] = this.url;
    data['add_time'] = this.addTime;
    data['edit_time'] = this.editTime;
    data['data_status'] = this.dataStatus;
    data['img_url'] = this.imgUrl;
    return data;
  }
}
