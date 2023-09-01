class MyHttpConfig{
  static const int connectTimeOut = 5000;//连接超时时间毫秒
  static const int receiveTimeout = 5000;//接收超时时间毫秒
  static const int successCode = 200;//成功返回的标识
  static const int noinfoCode = 400;//失败
  static const int errorloginCode = 401;//登录失效
  static const int errorHiCode = 20001;//
  static const int errorRoomCode = 10001;//10001需输入密码

  //测试上传
  static const String uploadUrl = 'http://192.168.100.121:18089/upload';
  //鹏飞测试环境
  static const String baseURL = "http://192.168.0.51/api";
  //赵增测试环境
  // static const String baseURL = "http://192.168.0.53/api";
  //正式环境
  // static const String baseURL = "https://yy.sunvua.com/api";

  /// 文件上传
  // file方式上传
  static const String fileUpload = '$baseURL/upload/fileUpload';



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
  //关于我们
  static const String userAbout = "$baseURL/mine/userAbout";
  //我的详情
  static const String myInfo = "$baseURL/mine/index";
  //切换账号验证token
  static const String checkToken = "$baseURL/login/checkToken";
  //实名制
  static const String realAuth = "$baseURL/mine/realAuth";
  //关注与被关注列表
  static const String followList = "$baseURL/mine/followList";
  //用户关注和取关
  static const String follow = "$baseURL/mine/follow";
  //谁看过我
  static const String history = "$baseURL/mine/history";
  //个人主页
  static const String myHome = "$baseURL/mine/home";
  //查看用户详情
  static const String userInfo = "$baseURL/mine/userInfo";
  //礼物明细
  static const String giftDetail = "$baseURL/gift/giftDetail";
  //个性标签列表
  static const String labelList = "$baseURL/mine/label";
  //修改个人资料
  static const String modifyUserInfo = "$baseURL/mine/modifyUserInfo";
  //获取城市
  static const String getCity = "$baseURL/system/getCity";
  //商城列表
  static const String shopList = "$baseURL/shop/index";
  //装扮背包列表
  static const String myShopList = "$baseURL/shop/myPackage";
  //搜索公会
  static const String searchGuild = "$baseURL/guild/searchGuild";
  //申请签约
  static const String applySign = "$baseURL/streamer/applySign";
  //我的公会
  static const String myGh = "$baseURL/guild/homepage";
  //搜索公会成员
  static const String searchGuildStreamer = "$baseURL/guild/searchGuildStreamer";
  //搜索公会房间
  static const String searchGuildRoom = "$baseURL/guild/searchGuildRoom";
  //申请签约列表
  static const String applySignList = "$baseURL/guild/applySignList";
  //签约审核
  static const String signExamine = "$baseURL/guild/signExamine";
  //踢出公会
  static const String kickOut = "$baseURL/guild/kickOut";
  //公会设置
  static const String ghSave = "$baseURL/guild/save";
  //公会设置
  static const String kefu = "$baseURL/mine/kefu";

  /// 动态模块
  //关注动态列表
  static const String gzFollowList = "$baseURL/note/followList";
  //推荐动态列表
  static const String recommendList = "$baseURL/note/recommendList";
  //用户动态列表
  static const String userList = "$baseURL/note/userList";
  //点赞
  static const String like = "$baseURL/note/like";
  //评论
  static const String comment = "$baseURL/note/comment";
  // 动态详情
  static const String dtDetail = "$baseURL/note/detail";
  //打招呼
  static const String hi = "$baseURL/chat/hi";
  //发布动态
  static const String sendDT = "$baseURL/note/post";

  /// 首页
  //推荐房间/海报轮播/推荐主播
  static const String pushRoom = "$baseURL/room/pushRoom";
  //收藏页4个推荐房间
  static const String recommendRoom = "$baseURL/mine/recommendRoom";
  //加入房间前
  static const String beforeJoin = "$baseURL/room/beforeJoin";
  //校验密码
  static const String checkPwd = "$baseURL/room/checkPwd";
  //加入房间
  static const String roomJoin = "$baseURL/room/join";
  //在线用户
  static const String userOnline = "$baseURL/user/userOnline";
  //首页派对房间列表
  static const String tjRoomList = "$baseURL/room/list";
  //首页榜单
  static const String rankList = "$baseURL/rank/list";
  //首页 游戏
  static const String gameList = "$baseURL/game/list";
  //系统消息列表
  static const String systemMsgList = "$baseURL/chat/systemMsgList";
  //聊天 获取用户动态信息
  static const String chatUserInfo = "$baseURL/chat/userInfo";
  //发私聊
  static const String sendUserMsg = "$baseURL/chat/sendUserMsg";
  //用户开播、在线状态
  static const String userStatus = "$baseURL/chat/userStatus";
  //能否发私聊
  static const String canSendUser = "$baseURL/chat/canSendUser";



}