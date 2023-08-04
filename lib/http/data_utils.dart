import 'package:yuyinting/bean/BlackListBean.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/bean/aboutUsBean.dart';
import '../bean/DTListBean.dart';
import '../bean/DTMoreBean.dart';
import '../bean/DTTuiJianListBean.dart';
import '../bean/careListBean.dart';
import '../bean/cityBean.dart';
import '../bean/fileUpdateBean.dart';
import '../bean/ghPeopleBean.dart';
import '../bean/ghRoomBean.dart';
import '../bean/kefuBean.dart';
import '../bean/labelListBean.dart';
import '../bean/liwuMoreBean.dart';
import '../bean/loginBean.dart';
import '../bean/myGhBean.dart';
import '../bean/myHomeBean.dart';
import '../bean/myInfoBean.dart';
import '../bean/myShopListBean.dart';
import '../bean/plBean.dart';
import '../bean/quhao_bean.dart';
import '../bean/quhao_searche_bean.dart';
import '../bean/qyListBean.dart';
import '../bean/searchGonghuiBean.dart';
import '../bean/shopListBean.dart';
import '../bean/userDTListBean.dart';
import '../bean/userInfoBean.dart';
import '../bean/whoLockMe.dart';
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
  static Future<CommonBean> postUpdateList(Map<String,dynamic> params) async {
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
}