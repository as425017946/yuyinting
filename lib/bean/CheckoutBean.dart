class CheckoutBean {
  int? code;
  String? msg;
  Data? data;

  CheckoutBean({this.code, this.msg, this.data});

  CheckoutBean.fromJson(Map<String, dynamic> json) {
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
  String? version;
  String? status;
  String? forceUpdate;
  String? summary;
  String? downloadUrl;
  int? fileSize;
  String? customUpdateNum;

  Data(
      {this.version,
        this.status,
        this.forceUpdate,
        this.summary,
        this.downloadUrl,
        this.fileSize,
        this.customUpdateNum});

  Data.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    status = json['status'];
    forceUpdate = json['force_update'];
    summary = json['summary'];
    downloadUrl = json['downloadUrl'];
    fileSize = json['fileSize'];
    customUpdateNum = json['customUpdateNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['status'] = this.status;
    data['force_update'] = this.forceUpdate;
    data['summary'] = this.summary;
    data['downloadUrl'] = this.downloadUrl;
    data['fileSize'] = this.fileSize;
    data['customUpdateNum'] = this.customUpdateNum;
    return data;
  }
}
