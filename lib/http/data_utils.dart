import 'package:yuyinting/bean/BlackListBean.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/bean/aboutUsBean.dart';
import '../bean/login_bean.dart';
import '../bean/myInfoBean.dart';
import '../bean/quhao_bean.dart';
import '../bean/quhao_searche_bean.dart';
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
  static Future<BlackListBean> postBlackList() async {
    Map<String, dynamic>? respons = await MyHttpRequest.post(MyHttpConfig.blackList, {}, {});
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

}