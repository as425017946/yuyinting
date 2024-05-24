import 'package:flutter/material.dart';
import 'package:yuyinting/bean/BlackListBean.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/bean/aboutUsBean.dart';
import '../bean/CheckoutBean.dart';
import '../bean/CommonIntBean.dart';
import '../bean/CommonMyIntBean.dart';
import '../bean/DTListBean.dart';
import '../bean/DTMoreBean.dart';
import '../bean/DTTuiJianListBean.dart';
import '../bean/activity_paper_index_bean.dart';
import '../bean/addressIPBean.dart';
import '../bean/allGiftBean.dart';
import '../bean/balanceBean.dart';
import '../bean/baobiaoBean.dart';
import '../bean/beibaoBean.dart';
import '../bean/carTimerBean.dart';
import '../bean/carYZBean.dart';
import '../bean/carZJLiShiBean.dart';
import '../bean/careListBean.dart';
import '../bean/chatUserInfoBean.dart';
import '../bean/cityBean.dart';
import '../bean/commonStringBean.dart';
import '../bean/feilvBean.dart';
import '../bean/fenleiBean.dart';
import '../bean/fileUpdateBean.dart';
import '../bean/find_mate_bean.dart';
import '../bean/gameListBean.dart';
import '../bean/gameStoreBean.dart';
import '../bean/getHeadImageBean.dart';
import '../bean/getShareBean.dart';
import '../bean/ghJieSuanListBean.dart';
import '../bean/ghJieSuanListMoreBean.dart';
import '../bean/ghPeopleBean.dart';
import '../bean/ghRoomBean.dart';
import '../bean/giftListBean.dart';
import '../bean/gzBean.dart';
import '../bean/happy_wall_bean.dart';
import '../bean/homeTJBean.dart';
import '../bean/hotRoomBean.dart';
import '../bean/hzRoomBean.dart';
import '../bean/hzTingBean.dart';
import '../bean/hzZhuBoBean.dart';
import '../bean/hzghBean.dart';
import '../bean/isFirstOrderBean.dart';
import '../bean/isPayBean.dart';
import '../bean/joinRoomBean.dart';
import '../bean/kefuBean.dart';
import '../bean/labelListBean.dart';
import '../bean/liwuBean.dart';
import '../bean/liwuMoreBean.dart';
import '../bean/loginBean.dart';
import '../bean/luckInfoBean.dart';
import '../bean/luckUserBean.dart';
import '../bean/maiXuBean.dart';
import '../bean/managerBean.dart';
import '../bean/memberListBean.dart';
import '../bean/mofangJCBean.dart';
import '../bean/myFenRunBean.dart';
import '../bean/myGhBean.dart';
import '../bean/myHomeBean.dart';
import '../bean/myInfoBean.dart';
import '../bean/myShopListBean.dart';
import '../bean/onlineRoomUserBean.dart';
import '../bean/orderPayBean.dart';
import '../bean/payLsitBean.dart';
import '../bean/plBean.dart';
import '../bean/playRouletteBean.dart';
import '../bean/pushStreamerBean.dart';
import '../bean/qiehuanBean.dart';
import '../bean/quhao_bean.dart';
import '../bean/quhao_searche_bean.dart';
import '../bean/qyListBean.dart';
import '../bean/rankListBean.dart';
import '../bean/rankListGZBean.dart';
import '../bean/recommendRoomBean.dart';
import '../bean/roomBGBean.dart';
import '../bean/roomDataBean.dart';
import '../bean/roomInfoBean.dart';
import '../bean/roomInfoUserManagerBean.dart';
import '../bean/roomLiuShuiBean.dart';
import '../bean/roomTJBean.dart';
import '../bean/roomUserInfoBean.dart';
import '../bean/searchAllBean.dart';
import '../bean/searchGonghuiBean.dart';
import '../bean/shopListBean.dart';
import '../bean/shoucangBean.dart';
import '../bean/soundBean.dart';
import '../bean/svgaAllBean.dart';
import '../bean/tgMyShareBean.dart';
import '../bean/tgmBean.dart';
import '../bean/tjRoomListBean.dart';
import '../bean/userDTListBean.dart';
import '../bean/userInfoBean.dart';
import '../bean/userMaiInfoBean.dart';
import '../bean/userOnlineBean.dart';
import '../bean/userStatusBean.dart';
import '../bean/walletListBean.dart';
import '../bean/wealth_info_bean.dart';
import '../bean/whoLockMe.dart';
import '../bean/winListBean.dart';
import '../bean/xtListBean.dart';
import '../bean/zhuboLiuShuiBean.dart';
import '../bean/zonglanBean.dart';
import '../main.dart';
import '../utils/event_utils.dart';
import '../utils/getx_tools.dart';
import 'my_http_config.dart';
import 'my_http_request.dart';

class DataUtils {
  ///判断网络
  static Future<addressIPBean> postPdAddress(
      Map<String, dynamic> params) async {
    debugPrint("检查网络参数：$params");
    debugPrint("检查网络地址：${MyHttpConfig.pdAddress}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.pdAddress, {}, params);
    debugPrint("检查网络：$respons");
    return addressIPBean.fromJson(respons!);
  }

  ///判断网络
  static Future<addressIPBean> getPdAddress() async {
    debugPrint("检查网络地址：${MyHttpConfig.pdAddressGet}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.get(MyHttpConfig.pdAddressGet, {}, {});
    debugPrint("检查网络：$respons");
    return addressIPBean.fromJson(respons!);
  }

  ///更新app
  static Future<CheckoutBean> checkVersion(Map<String, dynamic> params) async {
    debugPrint("检查更新：$params");
    debugPrint("检查更新：${MyHttpConfig.checkVersion}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.checkVersion, {}, params);
    debugPrint("检查更新：$respons");
    return CheckoutBean.fromJson(respons!);
  }

  /// 登录app后预下载
  static Future<svgaAllBean> postSvgaGiftList(
      Map<String, dynamic> params) async {
    debugPrint("登录app后预下载$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.svgaGiftList, {}, params);
    debugPrint("登录app后预下载：$respons");
    return svgaAllBean.fromJson(respons!);
  }

  /// 登录app后装扮预下载
  static Future<svgaAllBean> postSvgaDressList(
      Map<String, dynamic> params) async {
    debugPrint("登录app后装扮预下载$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.svgaDressList, {}, params);
    debugPrint("登录app后装扮预下载：$respons");
    return svgaAllBean.fromJson(respons!);
  }

  /// 登录接口
  static Future<LoginBean> login(Map<String, dynamic> params) async {
    debugPrint('Ping 登录: ${MyHttpConfig.login}');
    debugPrint("登录：传参$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.login, {}, params);
    debugPrint("登录：$respons");
    return LoginBean.fromJson(respons!);
  }

  /// 发送短信验证码
  static Future<CommonBean> postLoginSms(Map<String, dynamic> params) async {
    debugPrint("发送短信验证码$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.loginSms, {}, params);
    debugPrint("发送短信验证码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 发送短信验证码-忘记密码
  static Future<CommonBean> postSendSms(Map<String, dynamic> params) async {
    debugPrint("发送短信验证码-忘记密码$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.sendSms, {}, params);
    debugPrint("发送短信验证码-忘记密码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 区号
  static Future<QuhaoBean> quhao() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.quhao, {}, {});
    debugPrint("区号：$respons");
    return QuhaoBean.fromJson(respons!);
  }

  /// 忘记密码
  static Future<CommonBean> forgetPassword(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.forgotPwd, {}, params);
    debugPrint("忘记密码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 电话区号搜索
  static Future<QuhaoSearcheBean> codeSearch(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.codeSearch, {}, params);
    debugPrint("电话区号搜索：$respons");
    return QuhaoSearcheBean.fromJson(respons!);
  }

  /// 首次填写个人信息
  static Future<CommonBean> postIsFirst(Map<String, dynamic> params) async {
    debugPrint("首次填写个人传参：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.firstFillInfo, {}, params);
    debugPrint("首次填写个人信息：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置交易密码
  static Future<CommonBean> postModifyPayPwd(
      Map<String, dynamic> params) async {
    debugPrint("设置交易密码：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.modifyPayPwd, {}, params);
    debugPrint("设置交易密码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 修改密码
  static Future<CommonBean> postUpdatePwd(Map<String, dynamic> params) async {
    debugPrint("修改密码：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.updatePwd, {}, params);
    debugPrint("修改密码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 绑定/更换手机号
  static Future<CommonBean> postChangeUserPhone(
      Map<String, dynamic> params) async {
    debugPrint("绑定/更换手机号：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.changeUserPhone, {}, params);
    debugPrint("绑定/更换手机号：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 注销
  static Future<CommonBean> postWrittenOff() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.writtenOff, {}, {});
    debugPrint("注销：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 黑名单列表
  static Future<BlackListBean> postBlackList(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.blackList, {}, params);
    debugPrint("黑名单列表：$respons");
    return BlackListBean.fromJson(respons!);
  }

  /// 解除/添加黑名单
  static Future<CommonBean> postUpdateBlack(Map<String, dynamic> params) async {
    debugPrint("黑名单：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.updateBlack, {}, params);
    debugPrint("黑名单：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 关于我们
  static Future<AboutUsBean> postUserAbout(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userAbout, {}, params);
    debugPrint("关于我们：$respons");
    return AboutUsBean.fromJson(respons!);
  }

  /// 我的详情
  static Future<MyInfoBean> postMyIfon() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.myInfo, {}, {});
    debugPrint("我的详情：$respons");
    return MyInfoBean.fromJson(respons!);
  }

  /// 切换账号验证token
  static Future<qiehuanBean> postCheckToken(Map<String, dynamic> params) async {
    debugPrint("切换账号验证token：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.checkToken, {}, params);
    debugPrint("切换账号验证token：$respons");
    return qiehuanBean.fromJson(respons!);
  }

  /// file方式上传
  static Future<fileUpdateBean> postPostFileUpload(
      Map<String, dynamic> params) async {
    debugPrint("file方式上传：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.fileUpload(MyHttpConfig.fileUpload, {}, params);
    debugPrint("file方式上传：$respons");
    return fileUpdateBean.fromJson(respons!);
  }

  /// 实名制
  static Future<CommonBean> postRealAuth(Map<String, dynamic> params) async {
    debugPrint("实名制：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.realAuth, {}, params);
    debugPrint("实名制：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 用户关注和取关列表
  static Future<careListBean> postFollowList(
      Map<String, dynamic> params) async {
    debugPrint("用户关注和取关列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.followList, {}, params);
    debugPrint("用户关注和取关列表：$respons");
    return careListBean.fromJson(respons!);
  }

  /// 关注的房间
  static Future<shoucangBean> postFollowListRoom(
      Map<String, dynamic> params) async {
    debugPrint("关注的房间：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.followList, {}, params);
    debugPrint("关注的房间：$respons");
    return shoucangBean.fromJson(respons!);
  }

  /// 用户关注和取关
  static Future<CommonBean> postFollow(Map<String, dynamic> params) async {
    debugPrint("用户关注和取关：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.follow, {}, params);
    debugPrint("用户关注和取关：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 谁看过我
  static Future<whoLockMe> postHistoryList(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.history, {}, params);
    debugPrint("谁看过我：$respons");
    return whoLockMe.fromJson(respons!);
  }

  /// 个人主页
  static Future<myHomeBean> postMyHome(Map<String, dynamic> params) async {
    debugPrint("个人主页：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.myHome, {}, params);
    debugPrint("个人主页：$respons");
    return myHomeBean.fromJson(respons!);
  }

  /// 礼物墙
  static Future<allGiftBean> postAllGiftAll(Map<String, dynamic> params) async {
    debugPrint("礼物墙：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.allGiftAll, {}, params);
    debugPrint("礼物墙：$respons");
    return allGiftBean.fromJson(respons!);
  }

  /// 查看用户详情
  static Future<userInfoBean> postUserInfo(Map<String, dynamic> params) async {
    debugPrint("查看用户详情：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userInfo, {}, params);
    debugPrint("查看用户详情：$respons");
    return userInfoBean.fromJson(respons!);
  }

  /// 礼物明细
  static Future<liwuMoreBean> postGiftDetail(
      Map<String, dynamic> params) async {
    debugPrint("礼物明细：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.giftDetail, {}, params);
    debugPrint("礼物明细：$respons");
    return liwuMoreBean.fromJson(respons!);
  }

  /// 个性标签列表
  static Future<labelListBean> postLabelList(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.labelList, {}, params);
    debugPrint("个性标签列表：$respons");
    return labelListBean.fromJson(respons!);
  }

  /// 修改个人资料
  static Future<CommonBean> postModifyUserInfo(
      Map<String, dynamic> params) async {
    debugPrint("修改个人资料：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.modifyUserInfo, {}, params);
    debugPrint("修改个人资料：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 获取城市
  static Future<cityBean> postGetCity() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getCity, {}, {});
    debugPrint("获取城市：$respons");
    return cityBean.fromJson(respons!);
  }

  /// 装扮商城列表
  static Future<shopListBean> postShopList(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.shopList, {}, params);
    debugPrint("装扮商城列表：$respons");
    return shopListBean.fromJson(respons!);
  }

  /// 装扮背包列表
  static Future<myShopListBean> postMyShopList(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.myShopList, {}, params);
    debugPrint("装扮背包列表：$respons");
    return myShopListBean.fromJson(respons!);
  }

  /// 搜索公会
  static Future<searchGonghuiBean> postSearchGuild(
      Map<String, dynamic> params) async {
    debugPrint("搜索公会*：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.searchGuild, {}, params);
    debugPrint("搜索公会：$respons");
    return searchGonghuiBean.fromJson(respons!);
  }

  /// 申请签约
  static Future<CommonBean> postApplySign(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.applySign, {}, params);
    debugPrint("申请签约：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 我的公会
  static Future<myGhBean> postMyGh() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.myGh, {}, {});
    debugPrint("我的公会：$respons");
    return myGhBean.fromJson(respons!);
  }

  /// 公会成员列表
  static Future<ghPeopleBean> postSearchGuildStreamer(
      Map<String, dynamic> params) async {
    debugPrint("公会成员列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.searchGuildStreamer, {}, params);
    debugPrint("公会成员列表：$respons");
    return ghPeopleBean.fromJson(respons!);
  }

  /// 公会房间列表
  static Future<ghRoomBean> postSearchGuildRoom(
      Map<String, dynamic> params) async {
    debugPrint("公会房间列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.searchGuildRoom, {}, params);
    debugPrint("公会房间列表：$respons");
    return ghRoomBean.fromJson(respons!);
  }

  /// 申请签约列表
  static Future<qyListBean> postApplySignList(
      Map<String, dynamic> params) async {
    debugPrint("申请签约列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.applySignList, {}, params);
    debugPrint("申请签约列表：$respons");
    return qyListBean.fromJson(respons!);
  }

  /// 签约审核
  static Future<CommonBean> postSignExamine(Map<String, dynamic> params) async {
    debugPrint("签约审核：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.signExamine, {}, params);
    debugPrint("签约审核：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 公会设置
  static Future<CommonBean> postGhSave(Map<String, dynamic> params) async {
    debugPrint("公会设置：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.ghSave, {}, params);
    debugPrint("公会设置：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 踢出公会
  static Future<CommonBean> postKickOut(Map<String, dynamic> params) async {
    debugPrint("踢出公会：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.kickOut, {}, params);
    debugPrint("踢出公会：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 客服联系方式
  static Future<kefuBean> postKefu() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.kefu, {}, {});
    debugPrint("客服联系方式：$respons");
    return kefuBean.fromJson(respons!);
  }

  /// 用户动态列表
  static Future<userDTListBean> postUserList(
      Map<String, dynamic> params) async {
    debugPrint("用户动态列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userList, {}, params);
    debugPrint("用户动态列表：$respons");
    return userDTListBean.fromJson(respons!);
  }

  /// 关注动态列表
  static Future<DTListBean> postGZFollowList(
      Map<String, dynamic> params) async {
    debugPrint("用户动态列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.gzFollowList, {}, params);
    debugPrint("用户动态列表：$respons");
    return DTListBean.fromJson(respons!);
  }

  /// 推荐动态列表
  static Future<DTTuiJianListBean> postRecommendList(
      Map<String, dynamic> params) async {
    debugPrint("推荐动态列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.recommendList, {}, params);
    debugPrint("推荐动态列表：$respons");
    return DTTuiJianListBean.fromJson(respons!);
  }

  /// 点赞
  static Future<CommonBean> postLike(Map<String, dynamic> params) async {
    debugPrint("点赞：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.like, {}, params);
    debugPrint("点赞：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 评论
  static Future<plBean> postComment(Map<String, dynamic> params) async {
    debugPrint("评论：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.comment, {}, params);
    debugPrint("评论：$respons");
    return plBean.fromJson(respons!);
  }

  /// 动态详情
  static Future<DTMoreBean> postDtDetail(Map<String, dynamic> params) async {
    debugPrint("动态详情：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.dtDetail, {}, params);
    debugPrint("动态详情：$respons");
    return DTMoreBean.fromJson(respons!);
  }

  /// 打招呼
  static Future<CommonBean> postHi(Map<String, dynamic> params) async {
    debugPrint("打招呼：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.hi, {}, params);
    debugPrint("打招呼：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 发动态
  static Future<CommonBean> postSendDT(Map<String, dynamic> params) async {
    debugPrint("发动态：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.sendDT, {}, params);
    debugPrint("发动态：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 首页 推荐房间/海报轮播
  static Future<homeTJBean> postPushRoom() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.pushRoom, {}, {});
    debugPrint("首页推荐房间：$respons");
    return homeTJBean.fromJson(respons!);
  }

  /// 推荐主播
  static Future<pushStreamerBean> postPushStreamer(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.pushStreamer, {}, params);
    debugPrint("推荐主播：$respons");
    return pushStreamerBean.fromJson(respons!);
  }

  /// 收藏页4个推荐房间
  static Future<recommendRoomBean> postRecommendRoom() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.recommendRoom, {}, {});
    debugPrint("收藏页4个推荐房间：$respons");
    return recommendRoomBean.fromJson(respons!);
  }

  /// 加入房间前
  static Future<joinRoomBean> postBeforeJoin(
      Map<String, dynamic> params) async {
    debugPrint("加入房间前：$params");
    debugPrint("加入房间前：${MyHttpConfig.beforeJoin}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.beforeJoin, {}, params);
    debugPrint("加入房间前：$respons");
    return joinRoomBean.fromJson(respons!);
  }

  /// 房间校验密码
  static Future<joinRoomBean> postCheckPwd(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.checkPwd, {}, params);
    debugPrint("房间校验密码：$respons");
    return joinRoomBean.fromJson(respons!);
  }

  /// 加入房间
  static Future<CommonBean> postRoomJoin(Map<String, dynamic> params) async {
    debugPrint("加入房间：$params");
    debugPrint("加入房间前：${MyHttpConfig.roomJoin}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomJoin, {}, params);
    debugPrint("加入房间：$respons");
    try {
      final chatRoomId = respons!['data']!['em_room_id'] as String;
      sp.setString('chatRoomId', chatRoomId);
    } catch (e) {
      debugPrint(e.toString());
    }
    return CommonBean.fromJson(respons!);
  }

  /// 在线用户
  static Future<userOnlineBean> postUserOnline(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userOnline, {}, params);
    debugPrint("在线用户：$respons");
    return userOnlineBean.fromJson(respons!);
  }

  /// 首页派对-获取分类
  static Future<fenleiBean> postRoomType() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomType, {}, {});
    debugPrint("获取分类：$respons");
    return fenleiBean.fromJson(respons!);
  }

  /// 首页派对-前5名
  static Future<hotRoomBean> postHotRoom() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.hotRoom, {}, {});
    debugPrint("前5名：$respons");
    return hotRoomBean.fromJson(respons!);
  }

  /// 首页派对-房间列表
  static Future<tjRoomListBean> postTJRoomList(
      Map<String, dynamic> params) async {
    debugPrint("房间列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.tjRoomList, {}, params);
    debugPrint("房间列表：$respons");
    return tjRoomListBean.fromJson(respons!);
  }

  /// 榜单
  static Future<rankListBean> postRankList(Map<String, dynamic> params) async {
    debugPrint("榜单：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.rankList, {}, params);
    debugPrint("榜单：$respons");
    return rankListBean.fromJson(respons!);
  }

  /// 游戏列表
  static Future<gameListBean> postGameList() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.gameList, {}, {});
    debugPrint("游戏列表：$respons");
    return gameListBean.fromJson(respons!);
  }

  /// 获取系统消息
  static Future<xtListBean> postSystemMsgList(Map<String, dynamic> params) async {
    debugPrint("获取系统消息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.systemMsgList, {}, params);
    debugPrint("获取系统消息：$respons");
    return xtListBean.fromJson(respons!);
  }

  /// 聊天获取用户信息
  static Future<chatUserInfoBean> postChatUserInfo(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.chatUserInfo, {}, params);
    debugPrint("聊天获取用户信息：$respons");
    return chatUserInfoBean.fromJson(respons!);
  }

  /// 发私聊
  static Future<CommonBean> postSendUserMsg(Map<String, dynamic> params) async {
    debugPrint("发私聊：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.sendUserMsg, {}, params);
    debugPrint("发私聊：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 用户开播、在线状态
  static Future<userStatusBean> postUserStatus(
      Map<String, dynamic> params) async {
    debugPrint("用户开播、在线状态：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userStatus, {}, params);
    debugPrint("用户开播、在线状态：$respons");
    return userStatusBean.fromJson(respons!);
  }

  /// 能否私聊
  static Future<CommonIntBean> postCanSendUser(Map<String, dynamic> params) async {
    debugPrint("能否私聊：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.canSendUser, {}, params);
    debugPrint("能否私聊：$respons");
    return CommonIntBean.fromJson(respons!);
  }

  /// 房间信息
  static Future<roomInfoBean> postRoomInfo(Map<String, dynamic> params) async {
    debugPrint("房间信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomInfo, {}, params);
    debugPrint("房间信息：$respons");
    return roomInfoBean.fromJson(respons!);
  }

  /// 房间麦上详细信息
  static Future<maiXuBean> postRoomMikeInfo(Map<String, dynamic> params) async {
    debugPrint("房间麦上详细信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomMikeInfo, {}, params);
    debugPrint("房间麦上详细信息：$respons");
    return maiXuBean.fromJson(respons!);
  }

  /// 房间在线用户列表
  static Future<memberListBean> postMemberList(
      Map<String, dynamic> params) async {
    debugPrint("房间在线用户列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.memberList, {}, params);
    debugPrint("房间在线用户列表：$respons");
    return memberListBean.fromJson(respons!);
  }

  /// 用户关注人或房间状态
  static Future<CommonStringBean> postUserFollowStatus(
      Map<String, dynamic> params) async {
    debugPrint("用户关注人或房间状态：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userFollowStatus, {}, params);
    debugPrint("用户关注人或房间状态：$respons");
    return CommonStringBean.fromJson(respons!);
  }

  /// 上麦下麦
  static Future<maiXuBean> postSetmai(Map<String, dynamic> params) async {
    debugPrint("上麦下麦：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setmai, {}, params);
    debugPrint("上麦下麦：$respons");
    return maiXuBean.fromJson(respons!);
  }

  /// 房间内用户信息
  static Future<roomUserInfoBean> postRoomUserInfo(
      Map<String, dynamic> params) async {
    debugPrint("房间内用户信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomUserInfo, {}, params);
    debugPrint("房间内用户信息：$respons");
    return roomUserInfoBean.fromJson(respons!);
  }

  /// 设置/取消房间用户禁言
  static Future<CommonBean> postSetRoomForbation(
      Map<String, dynamic> params) async {
    debugPrint("设置/取消房间用户禁言：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setRoomForbation, {}, params);
    debugPrint("设置/取消房间用户禁言：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置/取消黑名单
  static Future<CommonBean> postSetRoomBlack(
      Map<String, dynamic> params) async {
    debugPrint("设置/取消黑名单：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setRoomBlack, {}, params);
    debugPrint("设置/取消黑名单：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置/取消管理员
  static Future<CommonBean> postSetRoomAdmin(
      Map<String, dynamic> params) async {
    debugPrint("设置/取消管理员：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setRoomAdmin, {}, params);
    debugPrint("设置/取消管理员：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间用户信息
  static Future<roomInfoUserManagerBean> postRoomUserInfoManager(
      Map<String, dynamic> params) async {
    debugPrint("房间用户信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomUserInfoManager, {}, params);
    debugPrint("房间用户信息：$respons");
    return roomInfoUserManagerBean.fromJson(respons!);
  }

  /// 房间首页展示
  static Future<CommonBean> postSetShow(Map<String, dynamic> params) async {
    debugPrint("房间首页展示：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setShow, {}, params);
    debugPrint("房间首页展示：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 清除魅力值
  static Future<CommonBean> postCleanCharm(Map<String, dynamic> params) async {
    debugPrint("清除魅力值：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.cleanCharm, {}, params);
    debugPrint("清除魅力值：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 清除公屏
  static Future<CommonBean> postCleanPublicScreen(
      Map<String, dynamic> params) async {
    debugPrint("清除公屏：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.cleanPublicScreen, {}, params);
    debugPrint("清除公屏：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间老板位
  static Future<CommonBean> postSetBoss(Map<String, dynamic> params) async {
    debugPrint("房间老板位：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setBoss, {}, params);
    debugPrint("房间老板位：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置房间信息
  static Future<CommonBean> postEditRoom(Map<String, dynamic> params) async {
    debugPrint("设置房间信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.editRoom, {}, params);
    debugPrint("设置房间信息：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间单个用户麦序信息
  static Future<userMaiInfoBean> postRoomUserMikeInfo(
      Map<String, dynamic> params) async {
    debugPrint("房间单个用户麦序信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomUserMikeInfo, {}, params);
    debugPrint("房间单个用户麦序信息：$respons");
    return userMaiInfoBean.fromJson(respons!);
  }

  /// 房间管理员列表
  static Future<managerBean> postAdminList(Map<String, dynamic> params) async {
    debugPrint("房间管理员列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.adminList, {}, params);
    debugPrint("房间管理员列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间禁言列表
  static Future<managerBean> postRoomForbationList(
      Map<String, dynamic> params) async {
    debugPrint("房间禁言列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomForbationList, {}, params);
    debugPrint("房间禁言列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间黑名单列表
  static Future<managerBean> postRoomBlackList(
      Map<String, dynamic> params) async {
    debugPrint("房间黑名单列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomBlackList, {}, params);
    debugPrint("房间黑名单列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间背景图列表
  static Future<roomBGBean> postBgList(Map<String, dynamic> params) async {
    debugPrint("房间背景图列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.bgList, {}, params);
    debugPrint("房间背景图列表：$respons");
    return roomBGBean.fromJson(respons!);
  }

  /// 选择房间背景图
  static Future<CommonBean> postCheckRoomBg(Map<String, dynamic> params) async {
    debugPrint("选择房间背景图：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.checkRoomBg, {}, params);
    debugPrint("选择房间背景图：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间上传背景图
  static Future<CommonBean> postUploadBg(Map<String, dynamic> params) async {
    debugPrint("房间上传背景图：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.uploadBg, {}, params);
    debugPrint("房间上传背景图：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间闭麦
  static Future<CommonBean> postSetClose(Map<String, dynamic> params) async {
    debugPrint("房间闭麦：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setClose, {}, params);
    debugPrint("房间闭麦：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间锁麦
  static Future<CommonBean> postSetLock(Map<String, dynamic> params) async {
    debugPrint("房间锁麦：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setLock, {}, params);
    debugPrint("房间锁麦：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 获取头像信息
  static Future<getHeadImageBean> postGetAvatars(
      Map<String, dynamic> params) async {
    debugPrint("获取头像信息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getAvatars, {}, params);
    debugPrint("获取头像信息：$respons");
    return getHeadImageBean.fromJson(respons!);
  }

  /// 欢迎语
  static Future<CommonBean> postRoomWelcomeMsg(
      Map<String, dynamic> params) async {
    debugPrint("欢迎语：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomWelcomeMsg, {}, params);
    debugPrint("欢迎语：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 礼物列表
  static Future<liwuBean> postGiftList(Map<String, dynamic> params) async {
    debugPrint("礼物列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.giftList, {}, params);
    debugPrint("礼物列表：$respons");
    return liwuBean.fromJson(respons!);
  }

  /// 背包礼物
  static Future<beibaoBean> postGiftListBB(Map<String, dynamic> params) async {
    debugPrint("背包礼物：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.giftList, {}, params);
    debugPrint("背包礼物：$respons");
    return beibaoBean.fromJson(respons!);
  }

  /// 送礼物
  static Future<CommonBean> postSendGift(Map<String, dynamic> params) async {
    debugPrint("送礼物：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.sendGift, {}, params);
    debugPrint("送礼物：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 钱包明细
  static Future<walletListBean> postWalletList(
      Map<String, dynamic> params) async {
    debugPrint("钱包明细：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.walletList, {}, params);
    debugPrint("钱包明细：$respons");
    return walletListBean.fromJson(respons!);
  }

  /// 钱包余额
  static Future<balanceBean> postBalance() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.balance, {}, {});
    debugPrint("钱包余额：$respons");
    return balanceBean.fromJson(respons!);
  }

  /// 厅内发消息
  static Future<CommonBean> postRoomMessageSend(
      Map<String, dynamic> params) async {
    debugPrint("厅内发消息：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomMessageSend, {}, params);
    debugPrint("厅内发消息：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 厅内清除单个魅力
  static Future<CommonBean> postCleanCharmSingle(
      Map<String, dynamic> params) async {
    debugPrint("厅内清除单个魅力：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.cleanCharmSingle, {}, params);
    debugPrint("厅内清除单个魅力：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间麦序在线用户
  static Future<onlineRoomUserBean> postOnlineRoomUser(
      Map<String, dynamic> params) async {
    debugPrint("房间麦序在线用户：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.onlineRoomUser, {}, params);
    debugPrint("房间麦序在线用户：$respons");
    return onlineRoomUserBean.fromJson(respons!);
  }

  /// 赛车押注
  static Future<carYZBean> postCarBet(Map<String, dynamic> params) async {
    debugPrint("赛车押注：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.carBet, {}, params);
    debugPrint("赛车押注：$respons");
    return carYZBean.fromJson(respons!);
  }

  /// 赛车中奖赛道
  static Future<carTimerBean> postGetWinTrack() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getWinTrack, {}, {});
    debugPrint("赛车中奖赛道：$respons");
    return carTimerBean.fromJson(respons!);
  }

  /// 赛车中奖赛道列表历史
  static Future<carZJLiShiBean> postGetWinTrackList() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getWinTrackList, {}, {});
    debugPrint("赛车中奖赛道列表历史：$respons");
    return carZJLiShiBean.fromJson(respons!);
  }

  /// 赛车倒计时
  static Future<carTimerBean> postGetCarTimer() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getCarTimer, {}, {});
    debugPrint("赛车倒计时：$respons");
    return carTimerBean.fromJson(respons!);
  }

  /// 赛车幸运用户
  static Future<luckUserBean> postCarLuckyUser() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.carLuckyUser, {}, {});
    debugPrint("赛车幸运用户：$respons");
    return luckUserBean.fromJson(respons!);
  }

  /// 魔方转盘竞猜
  static Future<playRouletteBean> postPlayRoulette(
      Map<String, dynamic> params) async {
    debugPrint("魔方转盘竞猜：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.playRoulette, {}, params);
    debugPrint("魔方转盘竞猜：$respons");
    return playRouletteBean.fromJson(respons!);
  }

  /// 游戏商店
  static Future<gameStoreBean> postGameStore(
      Map<String, dynamic> params) async {
    debugPrint("游戏商店：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.gameStore, {}, params);
    debugPrint("游戏商店：$respons");
    return gameStoreBean.fromJson(respons!);
  }

  /// 兑换游戏商店商品
  static Future<CommonBean> postExchangeGoods(
      Map<String, dynamic> params) async {
    debugPrint("兑换游戏商店商品：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.exchangeGoods, {}, params);
    debugPrint("兑换游戏商店商品：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 魔方转盘我的中奖记录
  static Future<winListBean> postGetMineRouletteWinList(
      Map<String, dynamic> params) async {
    debugPrint("魔方转盘我的中奖记录：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(
        MyHttpConfig.getMineRouletteWinList, {}, params);
    debugPrint("魔方转盘我的中奖记录：$respons");
    return winListBean.fromJson(respons!);
  }

  /// 大转盘幸运值
  static Future<CommonIntBean> postGetGameLuck() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getGameLuck, {}, {});
    debugPrint("大转盘幸运值：$respons");
    return CommonIntBean.fromJson(respons!);
  }

  /// 魔方奖池
  static Future<mofangJCBean> postRoulettePrizeList(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roulettePrizeList, {}, params);
    debugPrint("魔方奖池：$respons");
    return mofangJCBean.fromJson(respons!);
  }

  /// 发红包
  static Future<CommonBean> postSendRedPacket(
      Map<String, dynamic> params) async {
    debugPrint("发红包：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.sendRedPacket, {}, params);
    debugPrint("发红包：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 一键赠送背包礼物
  static Future<CommonBean> postOneClickPackageGift(
      Map<String, dynamic> params) async {
    debugPrint("一键赠送背包礼物：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.oneClickPackageGift, {}, params);
    debugPrint("一键赠送背包礼物：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 我的推广
  static Future<myFenRunBean> postMyPromotion() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.myPromotion, {}, {});
    debugPrint("我的推广：$respons");
    return myFenRunBean.fromJson(respons!);
  }

  /// 领取分润
  static Future<CommonBean> postExtractRebate(
      Map<String, dynamic> params) async {
    debugPrint("领取分润：$params");
    debugPrint("领取分润地址：${MyHttpConfig.extractRebate}");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.extractRebate, {}, params);
    debugPrint("领取分润：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 推广码
  static Future<tgmBean> postGetPromotionCode() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getPromotionCode, {}, {});
    debugPrint("推广码：$respons");
    return tgmBean.fromJson(respons!);
  }

  /// 团队总览
  static Future<zonglanBean> postTeamOverview(
      Map<String, dynamic> params) async {
    debugPrint("团队总览：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.teamOverview, {}, params);
    debugPrint("团队总览：$respons");
    return zonglanBean.fromJson(respons!);
  }

  /// 团队报表
  static Future<baobiaoBean> postTeamReport(Map<String, dynamic> params) async {
    debugPrint("团队报表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.teamReport, {}, params);
    debugPrint("团队报表：$respons");
    return baobiaoBean.fromJson(respons!);
  }

  /// 手工开户
  static Future<CommonBean> postOpenAccount(Map<String, dynamic> params) async {
    debugPrint("手工开户：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.openAccount, {}, params);
    debugPrint("手工开户：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 手工开户开关
  static Future<CommonIntBean> postOaSwtich(Map<String, dynamic> params) async {
    debugPrint("手工开户开关：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.oaSwtich, {}, params);
    debugPrint("手工开户开关：$respons");
    return CommonIntBean.fromJson(respons!);
  }

  /// 结算账单列表
  static Future<ghJieSuanListBean> postSettleList(
      Map<String, dynamic> params) async {
    debugPrint("结算账单列表：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.settleList, {}, params);
    debugPrint("结算账单列表：$respons");
    return ghJieSuanListBean.fromJson(respons!);
  }

  /// 结算账单明细
  static Future<ghJieSuanListMoreBean> postSettleDetail(
      Map<String, dynamic> params) async {
    debugPrint("结算账单明细：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.settleDetail, {}, params);
    debugPrint("结算账单明细：$respons");
    return ghJieSuanListMoreBean.fromJson(respons!);
  }

  /// 房间热度
  static Future<CommonMyIntBean> postHotDegree(
      Map<String, dynamic> params) async {
    debugPrint("房间热度：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.hotDegree, {}, params);
    debugPrint("房间热度：$respons");
    return CommonMyIntBean.fromJson(respons!);
  }

  /// 是否设置了支付密码
  static Future<isPayBean> postPayPwd() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.payPwd, {}, {});
    debugPrint("是否设置了支付密码：$respons");
    return isPayBean.fromJson(respons!);
  }

  /// 提现申请
  static Future<CommonBean> postWithdrawal(Map<String, dynamic> params) async {
    debugPrint("提现申请：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.withdrawal, {}, params);
    debugPrint("提现申请：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 离开房间
  static Future<CommonBean> postLeave(Map<String, dynamic> params) async {
    debugPrint("离开房间：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.leave, {}, params);
    debugPrint("离开房间：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 删除房间背景图
  static Future<CommonBean> postRemoveRoomBg(
      Map<String, dynamic> params) async {
    debugPrint("删除房间背景图：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.removeRoomBg, {}, params);
    debugPrint("删除房间背景图：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 币转豆
  static Future<CommonBean> postExchangeCurrency(
      Map<String, dynamic> params) async {
    debugPrint("币转豆：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.exchangeCurrency, {}, params);
    debugPrint("币转豆：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 推荐页搜索房间和用户
  static Future<searchAllBean> postSearchAll(
      Map<String, dynamic> params) async {
    debugPrint("推荐页搜索房间和用户：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.searchAll, {}, params);
    debugPrint("推荐页搜索房间和用户：$respons");
    return searchAllBean.fromJson(respons!);
  }

  /// 厅内推荐房间(无密码)
  static Future<roomTJBean> postShowRoomList() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.showRoomList, {}, {});
    debugPrint("厅内推荐房间(无密码)：$respons");
    return roomTJBean.fromJson(respons!);
  }

  /// 删除动态
  static Future<CommonBean> postDelDT(Map<String, dynamic> params) async {
    debugPrint("删除动态：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.delDT, {}, params);
    debugPrint("删除动态：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 充值
  static Future<orderPayBean> postOrderCreate(
      Map<String, dynamic> params) async {
    debugPrint("充值：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.orderCreate, {}, params);
    debugPrint("充值：$respons");
    return orderPayBean.fromJson(respons!);
  }

  /// 首充
  static Future<isFirstOrderBean> postIsFirstOrder() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.isFirstOrder, {}, {});
    debugPrint("首充：$respons");
    return isFirstOrderBean.fromJson(respons!);
  }

  /// 充值方式
  static Future<payLsitBean> postGetPayment(Map<String, dynamic> params) async {
    debugPrint("充值方式：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getPayment, {}, params);
    debugPrint("充值方式：$respons");
    return payLsitBean.fromJson(respons!);
  }

  /// 首充获取金额
  static Future<payLsitBean> postGetFirstPayment() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getFirstPayment, {}, {});
    debugPrint("首充获取金额：$respons");
    return payLsitBean.fromJson(respons!);
  }

  /// 文件日志上传
  static Future<CommonBean> postFilelog(Map<String, dynamic> params) async {
    debugPrint("文件日志上传：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.filelog, {}, params);
    debugPrint("文件日志上传：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间流水
  static Future<roomLiuShuiBean> postRoomSpendingList(
      Map<String, dynamic> params) async {
    debugPrint("房间流水：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.roomSpendingList, {}, params);
    debugPrint("房间流水：$respons");
    return roomLiuShuiBean.fromJson(respons!);
  }

  /// 主播流水
  static Future<zhuboLiuShuiBean> postStreamerSpendingList(
      Map<String, dynamic> params) async {
    debugPrint("主播流水：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.streamerSpendingList, {}, params);
    debugPrint("主播流水：$respons");
    return zhuboLiuShuiBean.fromJson(respons!);
  }

  /// 设置主播分润比例
  static Future<CommonBean> postSetRatio(Map<String, dynamic> params) async {
    debugPrint("设置主播分润比例：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setRatio, {}, params);
    debugPrint("设置主播分润比例：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 会长后台-我的公会
  static Future<hzghBean> postHomepage() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.homepage, {}, {});
    debugPrint("会长后台-我的公会：$respons");
    return hzghBean.fromJson(respons!);
  }

  /// 会长后台-搜索公会成员
  static Future<hzZhuBoBean> postSearchConsortiaStreamer(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-搜索公会成员：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(
        MyHttpConfig.searchConsortiaStreamer, {}, params);
    debugPrint("会长后台-搜索公会成员：$respons");
    return hzZhuBoBean.fromJson(respons!);
  }

  /// 会长后台-搜索公会厅
  static Future<hzRoomBean> postSearchConsortiaGuild(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-搜索公会厅：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.searchConsortiaGuild, {}, params);
    debugPrint("会长后台-搜索公会厅：$respons");
    return hzRoomBean.fromJson(respons!);
  }

  /// 会长后台-设置厅分润比例
  static Future<CommonBean> postConsortiaSetRatio(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-设置厅分润比例：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.consortiaSetRatio, {}, params);
    debugPrint("会长后台-设置厅分润比例：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 会长后台-厅流水
  static Future<hzTingBean> postGuildSpendingList(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-厅流水：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.guildSpendingList, {}, params);
    debugPrint("会长后台-厅流水：$respons");
    return hzTingBean.fromJson(respons!);
  }

  /// 会长后台-房间流水
  static Future<roomLiuShuiBean> postCroomSpendingList(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-房间流水：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.croomSpendingList, {}, params);
    debugPrint("会长后台-房间流水：$respons");
    return roomLiuShuiBean.fromJson(respons!);
  }

  /// 会长后台-主播流水列表
  static Future<zhuboLiuShuiBean> postCstreamerSpendingList(
      Map<String, dynamic> params) async {
    debugPrint("会长后台-主播流水列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(
        MyHttpConfig.cstreamerSpendingList, {}, params);
    debugPrint("会长后台-主播流水列表：$respons");
    return zhuboLiuShuiBean.fromJson(respons!);
  }

  /// 提现费率
  static Future<feilvBean> postGetRate() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getRate, {}, {});
    debugPrint("提现费率：$respons");
    return feilvBean.fromJson(respons!);
  }

  /// 幸运榜单
  static Future<luckInfoBean> postGameRanking() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.gameRanking, {}, {});
    debugPrint("幸运榜单：$respons");
    return luckInfoBean.fromJson(respons!);
  }

  /// 幸运榜单
  static Future<luckInfoBean> postGameRanking2(
      Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.gameRanking, {}, params);
    debugPrint("幸运榜单：$respons");
    return luckInfoBean.fromJson(respons!);
  }

  /// 设置勿扰模式
  static Future<CommonBean> postSetDisturb(Map<String, dynamic> params) async {
    debugPrint("设置勿扰模式：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setDisturb, {}, params);
    debugPrint("设置勿扰模式：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 腾讯云id
  static Future<CommonMyIntBean> postTencentID(
      Map<String, dynamic> params) async {
    debugPrint("腾讯云id：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.tencentID, {}, params);
    debugPrint("腾讯云id：$respons");
    return CommonMyIntBean.fromJson(respons!);
  }

  /// 用户举报
  static Future<CommonBean> postUserReport(Map<String, dynamic> params) async {
    debugPrint("用户举报：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.userReport, {}, params);
    debugPrint("用户举报：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置离线模式
  static Future<CommonBean> postSetLockMic(Map<String, dynamic> params) async {
    debugPrint("设置离线模式：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setLockMic, {}, params);
    debugPrint("设置离线模式：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 邀请有礼-提交申请
  static Future<CommonBean> postYqApply(Map<String, dynamic> params) async {
    debugPrint("邀请有礼-提交申请：$params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.yqApply, {}, params);
    debugPrint("邀请有礼-提交申请：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 邀请有礼-获取分享链接
  static Future<getShareBean> postGetShareUrl() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getShareUrl, {}, {});
    debugPrint("邀请有礼-获取分享链接 $respons");
    return getShareBean.fromJson(respons!);
  }

  /// 邀请有礼-获取分享链接
  static Future<tgMyShareBean> postGetPromoUrl() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.getPromoUrl, {}, {});
    debugPrint("邀请有礼-获取分享链接 $respons");
    return tgMyShareBean.fromJson(respons!);
  }

  /// 购买装扮
  static Future<CommonBean> postBuyDress(Map<String, dynamic> params) async {
    debugPrint("购买装扮 $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.buyDress, {}, params);
    debugPrint("购买装扮 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置装扮
  static Future<CommonBean> postSetDress(Map<String, dynamic> params) async {
    debugPrint("设置装扮 $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.setDress, {}, params);
    debugPrint("设置装扮 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 爆灯
  static Future<CommonBean> postBurstLight(Map<String, dynamic> params) async {
    debugPrint("爆灯 $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.burstLight, {}, params);
    debugPrint("爆灯 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 开启pk
  static Future<CommonBean> postStartPk(Map<String, dynamic> params) async {
    debugPrint("开启pk $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.startPk, {}, params);
    debugPrint("开启pk $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 提前结束pk
  static Future<CommonBean> postAheadOver(Map<String, dynamic> params) async {
    debugPrint("提前结束pk $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.aheadOver, {}, params);
    debugPrint("提前结束pk $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 提前结束惩罚
  static Future<CommonBean> postAheadPunish(Map<String, dynamic> params) async {
    debugPrint("提前结束惩罚 $params");
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.aheadPunish, {}, params);
    debugPrint("提前结束惩罚 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 打开app
  static Future<CommonBean> postAppOpen() async {
    Map<String, dynamic>? respons =
        await MyHttpRequest.post(MyHttpConfig.appOpen, {}, {});
    debugPrint("打开app $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 获取不到ip上传日志
  static Future<CommonBean> postIpLog(Map<String, dynamic> params) async {
    debugPrint("获取不到ip上传日志 $params");
    debugPrint("获取不到ip上传日志地址 ${MyHttpConfig.ipLog}");
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.ipLog, {}, params);
    debugPrint("获取不到ip上传日志 $respons");
    return CommonBean.fromJson(respons!);
  }


  /// 盲盒礼物
  static Future<CommonBean> postPlayBlindBox(Map<String, dynamic> params) async {
    debugPrint("盲盒礼物 $params");
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.playBlindBox, {}, params);
    debugPrint("盲盒礼物 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 大客户详情
  static Future<WealthInfoBean> postWealthInfo() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/mine/wealthInfo', {}, {});
    debugPrint("大客户详情 /mine/wealthInfo $respons");
    final bean = WealthInfoBean.fromJson(respons);
    if (bean.code == MyHttpConfig.successCode && bean.data is WealthInfoBeanData) {
      final data = bean.data!;
      sp.setString("user_headimg", data.avatar);
      sp.setString("nickname", data.nickname);
      sp.setInt("user_grLevel", data.gr_level);
      if (data.gr_level >= 3) {
        eventBus.fire(SubmitButtonBack(title: '财富等级大于3级'));
      }
    }  
    return bean;
  }
  /// 领取日返
  static Future<CommonBean> postGetDayReturn() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/mine/getDayReturn', {}, {});
    debugPrint("领取日返 /mine/getDayReturn $respons");
    return CommonBean.fromJson(respons!);
  }
  /// 日返记录
  static Future<WealthDayReturnBean> postDayReturnList() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/mine/dayReturnList', {}, {});
    debugPrint("领取日返 /mine/getDayReturn $respons");
    return WealthDayReturnBean.fromJson(respons!);
  }

  /// 是否有发红包权限
  static Future<CommonBean> postCanSendRedPacket() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.canSendRedPacket, {}, {});
    debugPrint("是否有发红包权限 $respons");
    return CommonBean.fromJson(respons!);
  }

  /// 幸福墙
  static Future<HappinessWallBean> postHappinessWall() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/happinessWall', {}, {});
    debugPrint("幸福墙 /activity/happinessWall $respons");
    return HappinessWallBean.fromJson(respons!);
  }

  /// 找对象-正式
  static Future<FindMateBean> postFindMate(int? gender) async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/user/findMate', {}, {
      if (gender != null) 'gender': gender
    });
    debugPrint("找对象 /user/findMate $respons");
    return FindMateBean.fromJson(respons!);
  }

  /// 推荐声音
  static Future<soundBean> postPushSound() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.pushSound, {}, {});
    debugPrint("推荐声音 $respons");
    return soundBean.fromJson(respons!);
  }


  /// 我的贵族
  static Future<gzBean> postMyNoble() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.myNoble, {}, {});
    debugPrint("我的贵族 $respons");
    return gzBean.fromJson(respons!);
  }

  /// 贵族榜单
  static Future<rankListGZBean> postRankListGZ() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.rankListGZ, {}, {});
    debugPrint("贵族榜单 $respons");
    return rankListGZBean.fromJson(respons!);
  }

  /// 设置隐身
  static Future<CommonBean> postSetStealth(Map<String, dynamic> params) async {
    debugPrint("设置隐身：$params");
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.setStealth, {}, params);
    debugPrint("设置隐身：$respons");
    return CommonBean.fromJson(respons!);
  }

  ///告白纸条首页
  static Future<ActivityPaperIndexBean> postActivityPaperIndex() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/paperIndex', {}, {});
    debugPrint("告白纸条首页 /activity/paperIndex $respons");
    return ActivityPaperIndexBean.fromJson(respons!);
  }
  ///放入纸条
  static Future<GetBean> postActivityPutPaper(String content, String id, String type) async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/putPaper', {}, {
      'content' : content,
      'img_id' : id,
      'type' : type,
    });
    debugPrint("放入纸条 /activity/putPaper $respons");
    return GetXBean.fromJson(respons!);
  }
  ///放入纸条记录
  static Future<ActivityPutPaperListBean> postActivityPutPaperList(int page, [int pageSize = 10]) async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/putPaperList', {}, {
      'page' : page,
      'pageSize' : pageSize,
    });
    debugPrint("放入纸条记录 /activity/putPaperList $respons");
    return ActivityPutPaperListBean.fromJson(respons!);
  }
  ///抽取纸条
  static Future<ActivityGetPaperBean> postActivityGetPaper() async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/getPaper', {}, {});
    debugPrint("抽取纸条 /activity/getPaper $respons");
    return ActivityGetPaperBean.fromJson(respons!);
  }
  ///抽取纸条记录
  static Future<ActivityGetPaperListBean> postActivityGetPaperList(int page, [int pageSize = 10]) async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post('${MyHttpConfig.baseURL}/activity/getPaperList', {}, {
      'page' : page,
      'pageSize' : pageSize,
    });
    debugPrint("抽取纸条记录 /activity/getPaperList $respons");
    return ActivityGetPaperListBean.fromJson(respons!);
  }

  /// 删除纸条
  static Future<CommonBean> postDelPaper(Map<String, dynamic> params) async {
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.delPaper, {}, params);
    debugPrint("删除纸条 $respons");
    return CommonBean.fromJson(respons!);
  }


  /// 房间数据
  static Future<roomDataBean> postRoomData(Map<String, dynamic> params) async {
    debugPrint("房间数据 $params");
    Map<String, dynamic>? respons =
    await MyHttpRequest.post(MyHttpConfig.roomData, {}, params);
    debugPrint("房间数据 $respons");
    return roomDataBean.fromJson(respons!);
  }
}
