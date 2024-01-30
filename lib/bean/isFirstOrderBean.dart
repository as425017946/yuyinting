class isFirstOrderBean {
  int? code;
  String? msg;
  Data? data;

  isFirstOrderBean({this.code, this.msg, this.data});

  isFirstOrderBean.fromJson(Map<String, dynamic> json) {
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
  int? twelve;
  int? oneHundred;
  int? twoSixSix;

  Data({this.twelve, this.oneHundred, this.twoSixSix});

  Data.fromJson(Map<String, dynamic> json) {
    twelve = json['twelve'];
    oneHundred = json['one_hundred'];
    twoSixSix = json['two_six_six'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['twelve'] = this.twelve;
    data['one_hundred'] = this.oneHundred;
    data['two_six_six'] = this.twoSixSix;
    return data;
  }
}
