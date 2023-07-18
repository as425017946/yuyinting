/// code : 200
/// msg : "ok"
/// data : [{"city":"中国大陆","code":"+86"},{"city":"中国香港","code":"+852"},{"city":"中国澳门","code":"+853"},{"city":"中国台湾","code":"+886"},{"city":"中非共和国","code":"+236"}]

class QuhaoSearcheBean {
  QuhaoSearcheBean({
      this.code, 
      this.msg, 
      this.data,});

  QuhaoSearcheBean.fromJson(dynamic json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataSearch.fromJson(v));
      });
    }
  }
  num? code;
  String? msg;
  List<DataSearch>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['msg'] = msg;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// city : "中国大陆"
/// code : "+86"

class DataSearch {
  DataSearch({
      this.city, 
      this.code,});

  DataSearch.fromJson(dynamic json) {
    city = json['city'];
    code = json['code'];
  }
  String? city;
  String? code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['code'] = code;
    return map;
  }

}