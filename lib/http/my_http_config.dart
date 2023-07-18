class MyHttpConfig{
  static const int connectTimeOut = 5000;//连接超时时间毫秒
  static const int receiveTimeout = 5000;//接收超时时间毫秒
  static const int successCode = 200;//成功返回的标识
  static const int noinfoCode = 400;//失败
  static const int errorloginCode = 401;//登录失效

  //测试上传
  static const String uploadUrl = 'http://192.168.100.121:18089/upload';
  //鹏飞测试环境
  static const String baseURL = "http://192.168.0.51/api";
  //赵增测试环境
  // static const String baseURL = "http://192.168.0.53/api";
  //正式环境
  // static const String baseURL = "https://yy.sunvua.com/api";

  //登录接口
  static const String login = "$baseURL/login/login";
  //检查更新
  static const String checkVersion = "$baseURL/app/open/checkVersion";
  //获取电话区号
  static const String quhao = "$baseURL/area/code";
  //忘记密码
  static const String forgotPwd = "$baseURL/login/forgotPwd";
  //电话区号搜索
  static const String codeSearch = "$baseURL/area/codeSearch";
  //首次填写个人信息
  static const String firstFillInfo = "$baseURL/user/firstFillInfo";

  /// 设置模块
  //设置交易密码
  static const String modifyPayPwd = "$baseURL/mine/modifyPayPwd";
  //修改密码
  static const String updatePwd = "$baseURL/mine/updatePwd";
  //绑定/更换手机号
  static const String changeUserPhone = "$baseURL/mine/changeUserPhone";
  //注销账号
  static const String writtenOff = "$baseURL/mine/writtenOff";
  //黑名单列表
  static const String blackList = "$baseURL/mine/blackList";
  //解除/添加黑名单
  static const String updateBlack = "$baseURL/mine/black";



}