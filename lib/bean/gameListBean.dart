class gameListBean {
  int? code;
  String? msg;
  List<Data>? data;

  gameListBean({this.code, this.msg, this.data});

  gameListBean.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? couverImg;
  String? content;
  int? isShow;

  Data({this.id, this.title, this.couverImg, this.content, this.isShow});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    couverImg = json['couver_img'];
    content = json['content'];
    isShow = json['is_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['couver_img'] = this.couverImg;
    data['content'] = this.content;
    data['is_show'] = this.isShow;
    return data;
  }
}
