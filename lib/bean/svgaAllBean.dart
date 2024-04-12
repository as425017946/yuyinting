class svgaAllBean {
  int? code;
  String? msg;
  Data? data;

  svgaAllBean({this.code, this.msg, this.data});

  svgaAllBean.fromJson(Map<String, dynamic> json) {
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
  List<ImgList>? imgList;
  int? total;
  int? nextResourceId;

  Data({this.imgList, this.total,this.nextResourceId});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['img_list'] != null) {
      imgList = <ImgList>[];
      json['img_list'].forEach((v) {
        imgList!.add(new ImgList.fromJson(v));
      });
    }
    total = json['total'];
    nextResourceId = json['next_resource_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imgList != null) {
      data['img_list'] = this.imgList!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['next_resource_id'] = this.nextResourceId;
    return data;
  }
}

class ImgList {
  String? path;
  int? addTime;

  ImgList({this.path, this.addTime});

  ImgList.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    addTime = json['add_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['add_time'] = this.addTime;
    return data;
  }
}
