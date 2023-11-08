import 'package:yuyinting/bean/BlackListBean.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/bean/aboutUsBean.dart';
import '../bean/DTListBean.dart';
import '../bean/DTMoreBean.dart';
import '../bean/DTTuiJianListBean.dart';
import '../bean/carTimerBean.dart';
import '../bean/carZJLiShiBean.dart';
import '../bean/careListBean.dart';
import '../bean/chatUserInfoBean.dart';
import '../bean/cityBean.dart';
import '../bean/commonStringBean.dart';
import '../bean/fileUpdateBean.dart';
import '../bean/gameListBean.dart';
import '../bean/getHeadImageBean.dart';
import '../bean/ghPeopleBean.dart';
import '../bean/ghRoomBean.dart';
import '../bean/giftListBean.dart';
import '../bean/homeTJBean.dart';
import '../bean/kefuBean.dart';
import '../bean/labelListBean.dart';
import '../bean/liwuBean.dart';
import '../bean/liwuMoreBean.dart';
import '../bean/loginBean.dart';
import '../bean/luckUserBean.dart';
import '../bean/managerBean.dart';
import '../bean/memberListBean.dart';
import '../bean/myGhBean.dart';
import '../bean/myHomeBean.dart';
import '../bean/myInfoBean.dart';
import '../bean/myShopListBean.dart';
import '../bean/onlineRoomUserBean.dart';
import '../bean/plBean.dart';
import '../bean/quhao_bean.dart';
import '../bean/quhao_searche_bean.dart';
import '../bean/qyListBean.dart';
import '../bean/rankListBean.dart';
import '../bean/recommendRoomBean.dart';
import '../bean/roomBGBean.dart';
import '../bean/roomInfoBean.dart';
import '../bean/roomInfoUserManagerBean.dart';
import '../bean/roomUserInfoBean.dart';
import '../bean/searchGonghuiBean.dart';
import '../bean/shopListBean.dart';
import '../bean/shoucangBean.dart';
import '../bean/tjRoomListBean.dart';
import '../bean/userDTListBean.dart';
import '../bean/userInfoBean.dart';
import '../bean/userOnlineBean.dart';
import '../bean/userStatusBean.dart';
import '../bean/whoLockMe.dart';
import '../bean/xtListBean.dart';
import 'my_http_config.dart';
import 'my_http_request.dart';

class DataUtils{
  // ///更新app
  // static Future<CheckoutBean> checkVersion(Map<String,dynamic> params) async {
  //   // print("检查更新：${params}");
  //   Map<String, dynamic>? respons = await MyHttpRequest.get(MyHttpConfig.checkVersion,
  //       {}, params);
  //   print("检查更新：${respons}");
  //   return CheckoutBean.fromJson(respons!);
  // }
  //
  /// 登录接口
  static Future<LoginBean> login(Map<String,dynamic> params) async {
    print("登录：传参${params}");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.login, {}, params);
    print("登录：${respons}");
    return LoginBean.fromJson(respons!);
  }

  /// 区号
  static Future<QuhaoBean> quhao() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.quhao, {}, {});
    print("区号：${respons}");
    return QuhaoBean.fromJson(respons!);
  }

  /// 忘记密码
  static Future<CommonBean> forgetPassword(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.forgotPwd, {}, params);
    print("忘记密码：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 电话区号搜索
  static Future<QuhaoSearcheBean> codeSearch(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.codeSearch, {}, params);
    print("电话区号搜索：${respons}");
    return QuhaoSearcheBean.fromJson(respons!);
  }

  /// 首次填写个人信息
  static Future<CommonBean> postIsFirst(Map<String,dynamic> params) async {
    print("首次填写个人传参：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.firstFillInfo, {}, params);
    print("首次填写个人信息：${respons}");
    return CommonBean.fromJson(respons!);
  }


  /// 设置交易密码
  static Future<CommonBean> postModifyPayPwd(Map<String,dynamic> params) async {
    print("设置交易密码：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.modifyPayPwd, {}, params);
    print("设置交易密码：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 修改密码
  static Future<CommonBean> postUpdatePwd(Map<String,dynamic> params) async {
    print("修改密码：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.updatePwd, {}, params);
    print("修改密码：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 绑定/更换手机号
  static Future<CommonBean> postChangeUserPhone(Map<String,dynamic> params) async {
    print("绑定/更换手机号：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.changeUserPhone, {}, params);
    print("绑定/更换手机号：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 注销
  static Future<CommonBean> postWrittenOff() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.writtenOff, {}, {});
    print("注销：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 黑名单列表
  static Future<BlackListBean> postBlackList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.blackList, {}, params);
    print("黑名单列表：${respons}");
    return BlackListBean.fromJson(respons!);
  }

  /// 解除/添加黑名单
  static Future<CommonBean> postUpdateBlack(Map<String,dynamic> params) async {
    print("黑名单：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.updateBlack, {}, params);
    print("黑名单：${respons}");
    return CommonBean.fromJson(respons!);
  }

  /// 关于我们
  static Future<AboutUsBean> postUserAbout(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userAbout, {}, params);
    print("关于我们：${respons}");
    return AboutUsBean.fromJson(respons!);
  }

  /// 我的详情
  static Future<MyInfoBean> postMyIfon(Map<String,dynamic> params) async {
    print("我的详情：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.myInfo, {}, params);
    print("我的详情：${respons}");
    return MyInfoBean.fromJson(respons!);
  }

  /// 切换账号验证token
  static Future<CommonBean> postCheckToken() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.checkToken, {}, {});
    print("切换账号验证token：${respons}");
    return CommonBean.fromJson(respons!);
  }


  /// file方式上传
  static Future<fileUpdateBean> postPostFileUpload(Map<String,dynamic> params) async {
    print("file方式上传：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.fileUpload(MyHttpConfig.fileUpload, {}, params);
    print("file方式上传：$respons");
    return fileUpdateBean.fromJson(respons!);
  }

  /// 实名制
  static Future<CommonBean> postRealAuth(Map<String,dynamic> params) async {
    print("实名制：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.realAuth, {}, params);
    print("实名制：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 用户关注和取关列表
  static Future<careListBean> postFollowList(Map<String,dynamic> params) async {
    print("用户关注和取关列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.followList, {}, params);
    print("用户关注和取关列表：$respons");
    return careListBean.fromJson(respons!);
  }

  /// 关注的房间
  static Future<shoucangBean> postFollowListRoom(Map<String,dynamic> params) async {
    print("关注的房间：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.followList, {}, params);
    print("关注的房间：$respons");
    return shoucangBean.fromJson(respons!);
  }

  /// 用户关注和取关
  static Future<CommonBean> postFollow(Map<String,dynamic> params) async {
    print("用户关注和取关：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.follow, {}, params);
    print("用户关注和取关：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 谁看过我
  static Future<whoLockMe> postHistoryList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.history, {}, params);
    print("谁看过我：$respons");
    return whoLockMe.fromJson(respons!);
  }

  /// 用户个人主页详情
  static Future<myHomeBean> postMyHome(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.myHome, {}, params);
    print("用户个人主页详情：$respons");
    return myHomeBean.fromJson(respons!);
  }

  /// 用户个人主页详情
  static Future<userInfoBean> postUserInfo(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userInfo, {}, params);
    print("用户个人主页详情：$respons");
    return userInfoBean.fromJson(respons!);
  }

  /// 礼物明细
  static Future<liwuMoreBean> postGiftDetail(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.giftDetail, {}, params);
    print("礼物明细：$respons");
    return liwuMoreBean.fromJson(respons!);
  }

  /// 个性标签列表
  static Future<labelListBean> postLabelList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.labelList, {}, params);
    print("个性标签列表：$respons");
    return labelListBean.fromJson(respons!);
  }

  /// 修改个人资料
  static Future<CommonBean> postModifyUserInfo(Map<String,dynamic> params) async {
    print("修改个人资料：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.modifyUserInfo, {}, params);
    print("修改个人资料：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 获取城市
  static Future<cityBean> postGetCity() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.getCity, {}, {});
    print("获取城市：$respons");
    return cityBean.fromJson(respons!);
  }

  /// 装扮商城列表
  static Future<shopListBean> postShopList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.shopList, {}, params);
    print("装扮商城列表：$respons");
    return shopListBean.fromJson(respons!);
  }


  /// 装扮背包列表
  static Future<myShopListBean> postMyShopList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.myShopList, {}, params);
    print("装扮背包列表：$respons");
    return myShopListBean.fromJson(respons!);
  }

  /// 搜索公会
  static Future<searchGonghuiBean> postSearchGuild(Map<String,dynamic> params) async {
    print("搜索公会*：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.searchGuild, {}, params);
    print("搜索公会：$respons");
    return searchGonghuiBean.fromJson(respons!);
  }

  /// 申请签约
  static Future<CommonBean> postApplySign(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.applySign, {}, params);
    print("申请签约：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 我的公会
  static Future<myGhBean> postMyGh() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.myGh, {}, {});
    print("我的公会：$respons");
    return myGhBean.fromJson(respons!);
  }

  /// 公会成员列表
  static Future<ghPeopleBean> postSearchGuildStreamer(Map<String,dynamic> params) async {
    print("公会成员列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.searchGuildStreamer, {}, params);
    print("公会成员列表：$respons");
    return ghPeopleBean.fromJson(respons!);
  }

  /// 公会房间列表
  static Future<ghRoomBean> postSearchGuildRoom(Map<String,dynamic> params) async {
    print("公会房间列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.searchGuildRoom, {}, params);
    print("公会房间列表：$respons");
    return ghRoomBean.fromJson(respons!);
  }

  /// 申请签约列表
  static Future<qyListBean> postApplySignList(Map<String,dynamic> params) async {
    print("申请签约列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.applySignList, {}, params);
    print("申请签约列表：$respons");
    return qyListBean.fromJson(respons!);
  }

  /// 签约审核
  static Future<CommonBean> postSignExamine(Map<String,dynamic> params) async {
    print("签约审核：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.signExamine, {}, params);
    print("签约审核：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 公会设置
  static Future<CommonBean> postGhSave(Map<String,dynamic> params) async {
    print("公会设置：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.ghSave, {}, params);
    print("公会设置：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 踢出公会
  static Future<CommonBean> postKickOut(Map<String,dynamic> params) async {
    print("踢出公会：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.kickOut, {}, params);
    print("踢出公会：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 客服联系方式
  static Future<kefuBean> postKefu() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.kefu, {}, {});
    print("客服联系方式：$respons");
    return kefuBean.fromJson(respons!);
  }

  /// 用户动态列表
  static Future<userDTListBean> postUserList(Map<String,dynamic> params) async {
    print("用户动态列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userList, {}, params);
    print("用户动态列表：$respons");
    return userDTListBean.fromJson(respons!);
  }

  /// 关注动态列表
  static Future<DTListBean> postGZFollowList(Map<String,dynamic> params) async {
    print("用户动态列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.gzFollowList, {}, params);
    print("用户动态列表：$respons");
    return DTListBean.fromJson(respons!);
  }

  /// 推荐动态列表
  static Future<DTTuiJianListBean> postRecommendList(Map<String,dynamic> params) async {
    print("推荐动态列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.recommendList, {}, params);
    print("推荐动态列表：$respons");
    return DTTuiJianListBean.fromJson(respons!);
  }


  /// 点赞
  static Future<CommonBean> postLike(Map<String,dynamic> params) async {
    print("点赞：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.like, {}, params);
    print("点赞：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 评论
  static Future<plBean> postComment(Map<String,dynamic> params) async {
    print("评论：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.comment, {}, params);
    print("评论：$respons");
    return plBean.fromJson(respons!);
  }

  /// 动态详情
  static Future<DTMoreBean> postDtDetail(Map<String,dynamic> params) async {
    print("动态详情：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.dtDetail, {}, params);
    print("动态详情：$respons");
    return DTMoreBean.fromJson(respons!);
  }

  /// 打招呼
  static Future<CommonBean> postHi(Map<String,dynamic> params) async {
    print("打招呼：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.hi, {}, params);
    print("打招呼：$respons");
    return CommonBean.fromJson(respons!);
  }


  /// 发动态
  static Future<CommonBean> postSendDT(Map<String,dynamic> params) async {
    print("发动态：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.sendDT, {}, params);
    print("发动态：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 首页 推荐房间/海报轮播/推荐主播
  static Future<homeTJBean> postPushRoom() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.pushRoom, {}, {});
    print("首页推荐房间：$respons");
    return homeTJBean.fromJson(respons!);
  }

  /// 收藏页4个推荐房间
  static Future<recommendRoomBean> postRecommendRoom() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.recommendRoom, {}, {});
    print("收藏页4个推荐房间：$respons");
    return recommendRoomBean.fromJson(respons!);
  }

  /// 加入房间前
  static Future<CommonBean> postBeforeJoin(Map<String,dynamic> params) async {
    print("加入房间前：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.beforeJoin, {}, params);
    print("加入房间前：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间校验密码
  static Future<CommonBean> postCheckPwd(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.checkPwd, {}, params);
    print("房间校验密码：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 加入房间
  static Future<CommonBean> postRoomJoin(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomJoin, {}, params);
    print("加入房间：$respons");
    return CommonBean.fromJson(respons!);
  }


  /// 在线用户
  static Future<userOnlineBean> postUserOnline(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userOnline, {}, params);
    print("在线用户：$respons");
    return userOnlineBean.fromJson(respons!);
  }


  /// 首页派对-房间列表
  static Future<tjRoomListBean> postTJRoomList(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.tjRoomList, {}, params);
    print("房间列表：$respons");
    return tjRoomListBean.fromJson(respons!);
  }


  /// 榜单
  static Future<rankListBean> postRankList(Map<String,dynamic> params) async {
    print("榜单：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.rankList, {}, params);
    print("榜单：$respons");
    return rankListBean.fromJson(respons!);
  }


  /// 游戏列表
  static Future<gameListBean> postGameList() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.gameList, {}, {});
    print("游戏列表：$respons");
    return gameListBean.fromJson(respons!);
  }


  /// 获取系统消息
  static Future<xtListBean> postSystemMsgList() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.systemMsgList, {}, {});
    print("获取系统消息：$respons");
    return xtListBean.fromJson(respons!);
  }


  /// 聊天获取用户信息
  static Future<chatUserInfoBean> postChatUserInfo(Map<String,dynamic> params) async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.chatUserInfo, {}, params);
    print("聊天获取用户信息：$respons");
    return chatUserInfoBean.fromJson(respons!);
  }

  /// 发私聊
  static Future<CommonBean> postSendUserMsg(Map<String,dynamic> params) async {
    print("发私聊：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.sendUserMsg, {}, params);
    print("发私聊：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 用户开播、在线状态
  static Future<userStatusBean> postUserStatus(Map<String,dynamic> params) async {
    print("用户开播、在线状态：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userStatus, {}, params);
    print("用户开播、在线状态：$respons");
    return userStatusBean.fromJson(respons!);
  }

  /// 能否私聊
  static Future<CommonBean> postCanSendUser(Map<String,dynamic> params) async {
    print("能否私聊：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.canSendUser, {}, params);
    print("能否私聊：$respons");
    return CommonBean.fromJson(respons!);
  }


  /// 房间信息
  static Future<roomInfoBean> postRoomInfo(Map<String,dynamic> params) async {
    print("房间信息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomInfo, {}, params);
    print("房间信息：$respons");
    return roomInfoBean.fromJson(respons!);
  }


  /// 房间在线用户列表
  static Future<memberListBean> postMemberList(Map<String,dynamic> params) async {
    print("房间在线用户列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.memberList, {}, params);
    print("房间在线用户列表：$respons");
    return memberListBean.fromJson(respons!);
  }

  /// 用户关注人或房间状态
  static Future<CommonStringBean> postUserFollowStatus(Map<String,dynamic> params) async {
    print("用户关注人或房间状态：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.userFollowStatus, {}, params);
    print("用户关注人或房间状态：$respons");
    return CommonStringBean.fromJson(respons!);
  }


  /// 上麦下麦
  static Future<CommonBean> postSetmai(Map<String,dynamic> params) async {
    print("上麦下麦：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setmai, {}, params);
    print("上麦下麦：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间内用户信息
  static Future<roomUserInfoBean> postRoomUserInfo(Map<String,dynamic> params) async {
    print("房间内用户信息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomUserInfo, {}, params);
    print("房间内用户信息：$respons");
    return roomUserInfoBean.fromJson(respons!);
  }

  /// 设置/取消房间用户禁言
  static Future<CommonBean> postSetRoomForbation(Map<String,dynamic> params) async {
    print("设置/取消房间用户禁言：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setRoomForbation, {}, params);
    print("设置/取消房间用户禁言：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置/取消黑名单
  static Future<CommonBean> postSetRoomBlack(Map<String,dynamic> params) async {
    print("设置/取消黑名单：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setRoomBlack, {}, params);
    print("设置/取消黑名单：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置/取消管理员
  static Future<CommonBean> postSetRoomAdmin(Map<String,dynamic> params) async {
    print("设置/取消管理员：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setRoomAdmin, {}, params);
    print("设置/取消管理员：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间用户信息
  static Future<roomInfoUserManagerBean> postRoomUserInfoManager(Map<String,dynamic> params) async {
    print("房间用户信息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomUserInfoManager, {}, params);
    print("房间用户信息：$respons");
    return roomInfoUserManagerBean.fromJson(respons!);
  }

  /// 房间首页展示
  static Future<CommonBean> postSetShow(Map<String,dynamic> params) async {
    print("房间首页展示：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setShow, {}, params);
    print("房间首页展示：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间老板位
  static Future<CommonBean> postSetBoss(Map<String,dynamic> params) async {
    print("房间老板位：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setBoss, {}, params);
    print("房间老板位：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 设置房间信息
  static Future<CommonBean> postEditRoom(Map<String,dynamic> params) async {
    print("设置房间信息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.editRoom, {}, params);
    print("设置房间信息：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间管理员列表
  static Future<managerBean> postAdminList(Map<String,dynamic> params) async {
    print("房间管理员列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.adminList, {}, params);
    print("房间管理员列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间禁言列表
  static Future<managerBean> postRoomForbationList(Map<String,dynamic> params) async {
    print("房间禁言列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomForbationList, {}, params);
    print("房间禁言列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间黑名单列表
  static Future<managerBean> postRoomBlackList(Map<String,dynamic> params) async {
    print("房间黑名单列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomBlackList, {}, params);
    print("房间黑名单列表：$respons");
    return managerBean.fromJson(respons!);
  }

  /// 房间背景图列表
  static Future<roomBGBean> postBgList(Map<String,dynamic> params) async {
    print("房间背景图列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.bgList, {}, params);
    print("房间背景图列表：$respons");
    return roomBGBean.fromJson(respons!);
  }

  /// 选择房间背景图
  static Future<CommonBean> postCheckRoomBg(Map<String,dynamic> params) async {
    print("选择房间背景图：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.checkRoomBg, {}, params);
    print("选择房间背景图：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间上传背景图
  static Future<CommonBean> postUploadBg(Map<String,dynamic> params) async {
    print("房间上传背景图：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.uploadBg, {}, params);
    print("房间上传背景图：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间闭麦
  static Future<CommonBean> postSetClose(Map<String,dynamic> params) async {
    print("房间闭麦：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setClose, {}, params);
    print("房间闭麦：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 房间锁麦
  static Future<CommonBean> postSetLock(Map<String,dynamic> params) async {
    print("房间锁麦：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.setLock, {}, params);
    print("房间锁麦：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 获取头像信息
  static Future<getHeadImageBean> postGetAvatars(Map<String,dynamic> params) async {
    print("获取头像信息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.getAvatars, {}, params);
    print("获取头像信息：$respons");
    return getHeadImageBean.fromJson(respons!);
  }

  /// 欢迎语
  static Future<CommonBean> postRoomWelcomeMsg(Map<String,dynamic> params) async {
    print("欢迎语：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomWelcomeMsg, {}, params);
    print("欢迎语：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 礼物列表
  static Future<liwuBean> postGiftList(Map<String,dynamic> params) async {
    print("礼物列表：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.giftList, {}, params);
    print("礼物列表：$respons");
    return liwuBean.fromJson(respons!);
  }


  /// 厅内发消息
  static Future<CommonBean> postRoomMessageSend(Map<String,dynamic> params) async {
    print("厅内发消息：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.roomMessageSend, {}, params);
    print("厅内发消息：$respons");
    return CommonBean.fromJson(respons!);
  }


  /// 房间麦序在线用户
  static Future<onlineRoomUserBean> postOnlineRoomUser(Map<String,dynamic> params) async {
    print("房间麦序在线用户：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.onlineRoomUser, {}, params);
    print("房间麦序在线用户：$respons");
    return onlineRoomUserBean.fromJson(respons!);
  }

  /// 赛车押注
  static Future<CommonBean> postCarBet(Map<String,dynamic> params) async {
    print("赛车押注：$params");
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.carBet, {}, params);
    print("赛车押注：$respons");
    return CommonBean.fromJson(respons!);
  }

  /// 赛车中奖赛道
  static Future<carTimerBean> postGetWinTrack() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.getWinTrack, {}, {});
    print("赛车中奖赛道：$respons");
    return carTimerBean.fromJson(respons!);
  }

  /// 赛车中奖赛道列表历史
  static Future<carZJLiShiBean> postGetWinTrackList() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.getWinTrackList, {}, {});
    print("赛车中奖赛道列表历史：$respons");
    return carZJLiShiBean.fromJson(respons!);
  }

  /// 赛车倒计时
  static Future<carTimerBean> postGetCarTimer() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.getCarTimer, {}, {});
    print("赛车倒计时：$respons");
    return carTimerBean.fromJson(respons!);
  }

  /// 赛车幸运用户
  static Future<luckUserBean> postCarLuckyUser() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.carLuckyUser, {}, {});
    print("赛车幸运用户：$respons");
    return luckUserBean.fromJson(respons!);
  }
}