import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:event_bus/event_bus.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../bean/myHomeBean.dart';

EventBus eventBus = new EventBus();

///返回数据解析
class ResidentBack {
  bool isBack;

  ResidentBack({required this.isBack});
}

///提交类的按钮
class SubmitButtonBack {
  String title;
  EMMessage? msg;

  SubmitButtonBack({required this.title, this.msg});
}

///提交类的按钮
class InfoBack {
  String info;

  InfoBack({required this.info});
}

///贵族使用
class GuizuButtonBack {
  int index;
  String title;
  GuizuButtonBack({required this.index, required this.title});
}

///选择地区使用
class AddressBack {
  String info;
  AddressBack({required this.info});
}

///上传文件返回
class FileBack {
  String info;
  String id;
  int type; // 0 图片 1音频 2视频
  FileBack({required this.info, required this.id, required this.type});
}

///上传文件返回
class PhotoBack {
  List<AssetEntity>? selectAss;
  String id;
  PhotoBack({required this.selectAss, required this.id});
}

///切换魔方
class MofangBack {
  int info;
  MofangBack({required this.info});
}

///实名认证
class RenzhengBack {
  bool isBack;
  RenzhengBack({required this.isBack});
}

///关注使用
class CareBack {
  String info;
  CareBack({required this.info});
}

///打招呼使用
class HiBack {
  bool isBack;
  String index;
  HiBack({required this.isBack, required this.index});
}

///打招呼使用
class SendMessageBack {
  int type;
  String msgID;
  String uid; // uid不等于空，刷新一下
  SendMessageBack({required this.type, required this.msgID, required this.uid});
}

///登录弹窗使用
class LoginBack {
  bool isBack;
  LoginBack({required this.isBack});
}

///二次确认弹窗使用
class QuerenBack {
  String title;
  int jine;
  String index;
  QuerenBack({required this.title, required this.jine, required this.index});
}

/// 兑换商品二次确认弹窗使用
class DHQuerenBack {
  String goodsId;
  String goodsType;
  int exchangeCost;
  DHQuerenBack(
      {required this.goodsId,
      required this.goodsType,
      required this.exchangeCost});
}

/// 魔方或转盘二次确认弹窗使用
class XZQuerenBack {
  String cishu;
  String feiyong;
  String title;
  XZQuerenBack(
      {required this.cishu, required this.feiyong, required this.title});
}

/// 厅内使用
class RoomBack {
  String title;
  String? index;
  RoomBack({required this.title, required this.index});
}

/// 房间背景
class RoomBGBack {
  String bgID;
  String bgType;
  String bgImagUrl;
  bool delete;
  RoomBGBack(
      {required this.bgID,
      required this.bgType,
      required this.bgImagUrl,
      required this.delete});
}

/// 房间背景
class CheckBGBack {
  String bgType;
  String bgImagUrl;
  CheckBGBack({required this.bgType, required this.bgImagUrl});
}

/// 自定义消息
class ZDYBack {
  Map<String, String>? map;
  String type;
  ZDYBack({required this.map, required this.type});
}

/// 自定义消息 横幅
class ZDYHFBack {
  Map<String, String>? map;
  String type;
  ZDYHFBack({required this.map, required this.type});
}

/// 自定义消息 红包
class ZDYHBBack {
  Map<String, String>? map;
  ZDYHBBack({required this.map});
}

/// im进入房间
class JoinRoomYBack {
  Map<dynamic, dynamic> map;
  String type;
  JoinRoomYBack({required this.map, required this.type});
}

/// 礼物显示效果使用
class LiWuShowBack {
  //礼物图地址
  String url;
  // 送到哪里
  List<String> listPeople;
  // 赠送数量
  String numbers;
  LiWuShowBack(
      {required this.url, required this.listPeople, required this.numbers});
}

/// 选中送谁的时候使用
class ChoosePeopleBack {
  // 送到哪里
  List<bool> listPeople;
  ChoosePeopleBack({required this.listPeople});
}

/// 厅内聊天发消息
class SendRoomInfoBack {
  String info;
  SendRoomInfoBack({required this.info});
}

/// 厅内聊天发图片
class SendRoomImgBack {
  String info;
  SendRoomImgBack({required this.info});
}

/// 魔方转盘下注
class XiaZhuBack {
  int jine;
  int type; //要减那个金额 cur_type 1金豆 2钻石 3蘑菇
  XiaZhuBack({required this.jine, required this.type});
}

/// 发送包使用
class HongBaoBack {
  String info;
  HongBaoBack({required this.info});
}

/// 向厅内发送播放礼物的通知使用
class SVGABack {
  bool isAll; // 是否赠送全部
  String url; //svga地址
  List<String> listurl;
  bool isJian;
  SVGABack(
      {required this.isAll,
      required this.url,
      required this.listurl,
      required this.isJian});
}

/// 厅内礼物播放完成
class RoomSVGABack {
  bool isOK;
  RoomSVGABack({required this.isOK});
}

/// 厅内贵族播放完成
class RoomGZSVGABack {
  bool isOK;
  RoomGZSVGABack({required this.isOK});
}

/// 厅内水果机播放完成
class RoomSGJBack {
  bool isOK;
  int? index;
  RoomSGJBack({required this.isOK, required this.index});
}

/// 个人资料修改
class myInfoBack {
  MyUserInfo userInfo;
  GiftList giftList;
  myInfoBack({required this.userInfo, required this.giftList});
}

/// 收起房间和加入其他房间使用
class shouqiRoomBack {
  RtcEngine engine;
  String title;
  shouqiRoomBack({required this.engine, required this.title});
}

///返回数据解析
class DownLoadingBack {
  double jindu;
  double jinduNum;
  DownLoadingBack({required this.jindu, required this.jinduNum});
}

///返回数据解析
class GameBack {
  bool isBack;
  GameBack({required this.isBack});
}

///返回数据解析
class BiLiBack {
  int index;
  String number;
  BiLiBack({required this.index, required this.number});
}

/// 再来一次
class AgainBack {
  String title;
  AgainBack({required this.title});
}

/// 腾讯云上传成功使用
class TencentBack {
  String filePath;
  String title;
  TencentBack({required this.filePath, required this.title});
}

/// 点击横幅使用
class hfJoinBack {
  String roomID;
  String title;
  hfJoinBack({required this.roomID, required this.title});
}

/// 厅内私聊发送信息
class siliaoBack {
  String info;
  String title;
  siliaoBack({required this.info, required this.title});
}


/// 首次编辑完个人资料
class FirstInfoBack {
  bool isOk;
  FirstInfoBack({required this.isOk});
}

/// 首次编辑完个人资料
class BottomBarVisibleBack {
  bool visible;
  BottomBarVisibleBack({required this.visible});
}

///返回数据解析
class XXBack {
  int index;
  String number;
  XXBack({required this.index, required this.number});
}


///收起房间使用
class RoomCallBack {
  bool isBack;
  String title;
  RoomCallBack({required this.isBack, required this.title});
}