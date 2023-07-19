/// code : 200
/// msg : "ok"
/// data : {"msg_is_open":1,"version":"1.0.2","wechat_public":"123456789","copyright":"唐山xxxxx科技有限公司"}

class AboutUsBean {
  AboutUsBean({
      num? code, 
      String? msg, 
      Data? data,}){
    _code = code;
    _msg = msg;
    _data = data;
}

  AboutUsBean.fromJson(dynamic json) {
    _code = json['code'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _code;
  String? _msg;
  Data? _data;
AboutUsBean copyWith({  num? code,
  String? msg,
  Data? data,
}) => AboutUsBean(  code: code ?? _code,
  msg: msg ?? _msg,
  data: data ?? _data,
);
  num? get code => _code;
  String? get msg => _msg;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// msg_is_open : 1
/// version : "1.0.2"
/// wechat_public : "123456789"
/// copyright : "唐山xxxxx科技有限公司"

class Data {
  Data({
      num? msgIsOpen, 
      String? version, 
      String? wechatPublic, 
      String? copyright,}){
    _msgIsOpen = msgIsOpen;
    _version = version;
    _wechatPublic = wechatPublic;
    _copyright = copyright;
}

  Data.fromJson(dynamic json) {
    _msgIsOpen = json['msg_is_open'];
    _version = json['version'];
    _wechatPublic = json['wechat_public'];
    _copyright = json['copyright'];
  }
  num? _msgIsOpen;
  String? _version;
  String? _wechatPublic;
  String? _copyright;
Data copyWith({  num? msgIsOpen,
  String? version,
  String? wechatPublic,
  String? copyright,
}) => Data(  msgIsOpen: msgIsOpen ?? _msgIsOpen,
  version: version ?? _version,
  wechatPublic: wechatPublic ?? _wechatPublic,
  copyright: copyright ?? _copyright,
);
  num? get msgIsOpen => _msgIsOpen;
  String? get version => _version;
  String? get wechatPublic => _wechatPublic;
  String? get copyright => _copyright;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg_is_open'] = _msgIsOpen;
    map['version'] = _version;
    map['wechat_public'] = _wechatPublic;
    map['copyright'] = _copyright;
    return map;
  }

}