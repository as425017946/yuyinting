class MyHttpConfig{
  static const int connectTimeOut = 5000;//连接超时时间毫秒
  static const int receiveTimeout = 5000;//接收超时时间毫秒
  static const int successCode = 20000;//成功返回的标识
  static const int noinfoCode = 40000;//失败
  static const int errorloginCode = 40001;//登录失效

  //测试上传
  static const String uploadUrl = 'http://192.168.100.121:18089/upload';
  //测试环境
  static const String baseURL = "http://10.0.255.112:9016";
  //正式环境
  // static const String baseURL = "https://yy.sunvua.com/api";

  //登录接口
  static const String login = "$baseURL/app/open/login";
  //检查更新
  static const String checkVersion = "$baseURL/app/open/checkVersion";
  //审批流程-搜索
  static const String approvalSearch = "$baseURL/app/approval/page";
  //审批流程-详情
  static const String approvalInfo = "$baseURL/app/approval/info";
  //审批流程-部门受理
  static const String approvalAccept = "$baseURL/app/approval/accept";
  //修改密码
  static const String updatePassword = "$baseURL/app/user/changePassword";
  //流程-部门提交
  static const String approvalSubmit = "$baseURL/app/approval/submit";
  //用户关联-定位项目到具体哪个
  static const String approvalUser = '$baseURL/app/approval/user';
  //文件上传
  static const String uploadInfo = "$baseURL/app/oss/uploadInfo";
  //公告列表
  static const String noticeList = "$baseURL/app/baseNotice/list";
  //消息列表
  static const String messagesList = "$baseURL/app/userMsg/list";
  //标记已读
  static const String messagesRead = "$baseURL/app/userMsg/read";
  //删除
  static const String messagesDisabled = "$baseURL/app/userMsg/disabled";
  //全部标记已读
  static const String messagesReadAll = "$baseURL/app/userMsg/readAll";
  //未读数量
  static const String countUnRead = "$baseURL/app/userMsg/countUnRead";
}