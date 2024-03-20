import '../main.dart';

class MyHttpConfig{
  static const int connectTimeOut = 10000;//连接超时时间毫秒
  static const int receiveTimeout = 10000;//接收超时时间毫秒
  static const int successCode = 200;//成功返回的标识
  static const int noinfoCode = 400;//失败
  static const int errorloginCode = 401;//登录失效
  static const int errorHiCode = 20001;//
  static const int errorRoomCode = 10001;//10001需输入密码

  //鹏飞测试环境
  // static  String baseURL = "http://192.168.0.51/api";
  //赵增测试环境
  // static  String baseURL = "http://192.168.0.53/api";
  // //测试环境
  // static  String baseURL = "http://18.162.113.63:8080/api";
  // 修改后的测试环境
  static  String baseURL = "http://${sp.getString('isDian').toString()}:8081/api";

  //正式环境
  // static  String baseURL = sp.getString('isDian').toString().isEmpty ? "http://43.198.138.251:8080/api" : "http://${sp.getString('isDian').toString()}:8080/api";

  // 正式环境
  // static  String baseURL = "http://www.aa986.com:8080/api";
  /// 文件上传
  // file方式上传`
  static String fileUpload = '$baseURL/upload/fileUpload';

  //上传用户声网日志测试
  // static  String filelog = "http://18.162.113.63:8080/api/upload/filelog";
  // //上传用户声网日志正式
  static  String filelog = sp.getString('isDian').toString().isEmpty ? "http://43.198.138.251:8080/api/upload/filelog" : "http://${sp.getString('isDian').toString()}:8080/api/upload/filelog";
  //存一下没有获取到ip的用户
  static  String ipLog = "http://118.195.228.131:8301/log";
  //判断网络 测试
  static  String pdAddress = "http://119.45.157.111:8300/address";
  //判断网络
  static  String pdAddressGet = "http://119.45.157.111:8081/address/address?type=go";
  //预下载接口
  static  String svgaGiftList = "$baseURL/gift/svgaGiftList";
  //登录接口
  static  String login = "$baseURL/login/login";
  //发送短信验证码
  static  String loginSms = "$baseURL/login/loginSms";
  //发送短信验证码-忘记密码
  static  String sendSms = "$baseURL/login/forgetSms";
  //检查更新
  static  String checkVersion = "$baseURL/system/versionRequire";
  //获取电话区号
  static  String quhao = "$baseURL/area/code";
  //忘记密码
  static  String forgotPwd = "$baseURL/login/forgotPwd";
  //电话区号搜索
  static  String codeSearch = "$baseURL/area/codeSearch";
  //首次填写个人信息
  static  String firstFillInfo = "$baseURL/user/firstFillInfo";

  /// 设置模块
  //设置交易密码
  static  String modifyPayPwd = "$baseURL/mine/modifyPayPwd";
  //修改密码
  static  String updatePwd = "$baseURL/mine/updatePwd";
  //绑定/更换手机号
  static  String changeUserPhone = "$baseURL/mine/changeUserPhone";
  //注销账号
  static  String writtenOff = "$baseURL/mine/writtenOff";
  //黑名单列表
  static  String blackList = "$baseURL/mine/blackList";
  //解除/添加黑名单
  static  String updateBlack = "$baseURL/mine/black";
  //关于我们
  static  String userAbout = "$baseURL/mine/userAbout";
  //我的详情
  static  String myInfo = "$baseURL/mine/index";
  //切换账号验证token
  static  String checkToken = "$baseURL/login/checkToken";
  //实名制
  static  String realAuth = "$baseURL/mine/realAuth";
  //关注与被关注列表
  static  String followList = "$baseURL/mine/followList";
  //用户关注和取关
  static  String follow = "$baseURL/mine/follow";
  //谁看过我
  static  String history = "$baseURL/mine/history";
  //个人主页
  static  String myHome = "$baseURL/mine/home";
  //礼物墙
  static  String allGiftAll = "$baseURL/mine/allGiftAll";
  //查看用户详情
  static  String userInfo = "$baseURL/mine/userInfo";
  //礼物明细
  static  String giftDetail = "$baseURL/gift/giftDetail";
  //个性标签列表
  static  String labelList = "$baseURL/mine/label";
  //修改个人资料
  static  String modifyUserInfo = "$baseURL/mine/modifyUserInfo";
  //获取城市
  static  String getCity = "$baseURL/system/getCity";
  //商城列表
  static  String shopList = "$baseURL/shop/index";
  //装扮背包列表
  static  String myShopList = "$baseURL/shop/myPackage";
  //搜索公会
  static  String searchGuild = "$baseURL/guild/searchGuild";
  //申请签约
  static  String applySign = "$baseURL/streamer/applySign";
  //我的公会
  static  String myGh = "$baseURL/guild/homepage";
  //搜索公会成员
  static  String searchGuildStreamer = "$baseURL/guild/searchGuildStreamer";
  //搜索公会房间
  static  String searchGuildRoom = "$baseURL/guild/searchGuildRoom";
  //申请签约列表
  static  String applySignList = "$baseURL/guild/applySignList";
  //签约审核
  static  String signExamine = "$baseURL/guild/signExamine";
  //踢出公会
  static  String kickOut = "$baseURL/guild/kickOut";
  //公会设置
  static  String ghSave = "$baseURL/guild/save";
  //公会设置
  static  String kefu = "$baseURL/mine/kefu";
  //房间流水
  static  String roomSpendingList = "$baseURL/guild/roomSpendingList";
  //主播流水
  static  String streamerSpendingList = "$baseURL/guild/streamerSpendingList";
  //设置主播分润比例
  static  String setRatio = "$baseURL/guild/setRatio";
  //会长后台-我的公会
  static  String homepage = "$baseURL/consortia/homepage";
  //会长后台-搜索公会成员
  static  String searchConsortiaStreamer = "$baseURL/consortia/searchConsortiaStreamer";
  //会长后台-搜索公会厅
  static  String searchConsortiaGuild = "$baseURL/consortia/searchConsortiaGuild";
  //会长后台-搜索公会厅
  static  String consortiaSetRatio = "$baseURL/consortia/setRatio";
  //会长后台-厅流水列表
  static  String guildSpendingList = "$baseURL/consortia/guildSpendingList";
  //会长后台-厅-房间流水列表
  static  String croomSpendingList = "$baseURL/consortia/roomSpendingList";
  //会长后台-主播流水列表
  static  String cstreamerSpendingList = "$baseURL/consortia/streamerSpendingList";

  /// 动态模块
  //关注动态列表
  static  String gzFollowList = "$baseURL/note/followList";
  //推荐动态列表
  static  String recommendList = "$baseURL/note/recommendList";
  //用户动态列表
  static  String userList = "$baseURL/note/userList";
  //点赞
  static  String like = "$baseURL/note/like";
  //评论
  static  String comment = "$baseURL/note/comment";
  // 动态详情
  static  String dtDetail = "$baseURL/note/detail";
  //打招呼
  static  String hi = "$baseURL/chat/hi";
  //发布动态
  static  String sendDT = "$baseURL/note/post";
  //删除动态
  static  String delDT = "$baseURL/note/del";

  /// 首页
  //推荐房间/海报轮播
  static  String pushRoom = "$baseURL/room/pushRoom";
  // 推荐主播
  static  String pushStreamer = "$baseURL/room/pushStreamer";
  //收藏页4个推荐房间
  static  String recommendRoom = "$baseURL/mine/recommendRoom";
  //加入房间前
  static  String beforeJoin = "$baseURL/room/beforeJoin";
  //校验密码
  static  String checkPwd = "$baseURL/room/checkPwd";
  //加入房间
  static  String roomJoin = "$baseURL/room/join";
  //在线用户
  static  String userOnline = "$baseURL/user/userOnline";
  //首页派对获取分类
  static  String roomType = "$baseURL/room/roomType";
  //首页派对房间列表 前5名
  static  String hotRoom = "$baseURL/room/hotRoom";
  //首页派对房间列表
  static  String tjRoomList = "$baseURL/room/list";
  //首页榜单
  static  String rankList = "$baseURL/rank/list";
  //首页 游戏
  static  String gameList = "$baseURL/game/list";
  //系统消息列表
  static  String systemMsgList = "$baseURL/chat/systemMsgList";
  //聊天 获取用户动态信息
  static  String chatUserInfo = "$baseURL/chat/userInfo";
  //发私聊
  static  String sendUserMsg = "$baseURL/chat/sendUserMsg";
  //用户开播、在线状态
  static  String userStatus = "$baseURL/chat/userStatus";
  //能否发私聊
  static  String canSendUser = "$baseURL/chat/canSendUser";
  /// 厅内
  //房间信息
  static  String roomInfo = "$baseURL/room/info";
  //房间在线用户列表
  static  String memberList = "$baseURL/room/memberList";
  //用户关注人或房间状态
  static  String userFollowStatus = "$baseURL/mine/userFollowStatus";
  //上麦下麦
  static  String setmai = "$baseURL/room/setmai";
  //设置/取消管理员
  static  String setRoomAdmin = "$baseURL/room/setRoomAdmin";
  //用户信息
  static  String roomUserInfo = "$baseURL/room/userInfo";
  //设置/取消黑名单
  static  String setRoomBlack = "$baseURL/room/setRoomBlack";
  //设置/取消房间用户禁言
  static  String setRoomForbation = "$baseURL/room/setRoomForbation";
  //房间用户信息
  static  String roomUserInfoManager = "$baseURL/room/roomUserInfo";
  //房间首页展示
  static  String setShow = "$baseURL/room/setShow";
  //清除魅力值
  static  String cleanCharm = "$baseURL/room/cleanCharm";
  //清除公屏
  static  String cleanPublicScreen = "$baseURL/room/cleanPublicScreen";
  //房间老板位
  static  String setBoss = "$baseURL/room/setBoss";
  //设置房间信息
  static  String editRoom = "$baseURL/room/editRoom";
  //房间单个用户麦序信息
  static  String roomUserMikeInfo = "$baseURL/room/roomUserMikeInfo";
  //房间管理员列表
  static  String adminList = "$baseURL/room/adminList";
  //房间禁言列表
  static  String roomForbationList = "$baseURL/room/roomForbationList";
  //房间黑名单列表
  static  String roomBlackList = "$baseURL/room/roomBlackList";
  //房间背景图列表
  static  String bgList = "$baseURL/room/bgList";
  //选择房间背景图
  static  String checkRoomBg = "$baseURL/room/checkRoomBg";
  //房间上传背景图
  static  String uploadBg = "$baseURL/room/uploadBg";
  //房间闭麦
  static  String setClose = "$baseURL/room/setClose";
  //房间锁麦
  static  String setLock = "$baseURL/room/setLock";
  //获取头像信息
  static  String getAvatars = "$baseURL/login/getAvatars";
  //欢迎语
  static  String roomWelcomeMsg = "$baseURL/room/roomWelcomeMsg";
  //礼物列表
  static  String giftList = "$baseURL/gift/list";
  //送礼物
  static  String sendGift = "$baseURL/gift/sendGift";
  //钱包明细
  static  String walletList = "$baseURL/user/walletList";
  //钱包余额
  static  String balance = "$baseURL/user/balance";
  //厅内发消息
  static  String roomMessageSend = "$baseURL/room/roomMessageSend";
  //房间麦序在线用户
  static  String onlineRoomUser = "$baseURL/room/onlineRoomUser";
  //房间清除单个麦序
  static  String cleanCharmSingle = "$baseURL/room/cleanCharmSingle";
  //赛车押注
  static  String carBet = "$baseURL/game/carBet";
  //赛车中奖赛道
  static  String getWinTrack = "$baseURL/game/getWinTrack";
  //赛车中奖赛道列表历史记录
  static  String getWinTrackList = "$baseURL/game/getWinTrackList";
  //赛车倒计时
  static  String getCarTimer = "$baseURL/game/getCarTimer";
  //赛车幸运用户
  static  String carLuckyUser = "$baseURL/game/carLuckyUser";
  //魔方转盘竞猜
  static  String playRoulette = "$baseURL/game/playRoulette";
  //游戏商店 1小转盘 2大转盘 3蘑菇
  static  String gameStore = "$baseURL/game/gameStore";
  //兑换游戏商店商品 1转盘 2大转盘 3赛车
  static  String exchangeGoods = "$baseURL/game/exchangeGoods";
  //魔方转盘我的中奖记录
  static  String getMineRouletteWinList = "$baseURL/game/getMineRouletteWinList";
  //大转盘幸运值
  static  String getGameLuck = "$baseURL/game/getGameLuck";
  //魔方奖池
  static  String roulettePrizeList = "$baseURL/game/roulettePrizeList";
  // 发红包
  static  String sendRedPacket = "$baseURL/user/sendRedPacket";
  // 一键赠送背包礼物
  static  String oneClickPackageGift = "$baseURL/gift/oneClickPackageGift";
  // 我的推广
  static  String myPromotion = "$baseURL/agent/myPromotion";
  // 领取分润
  static  String extractRebate = "$baseURL/agent/extractRebate";
  // 推广码
  static  String getPromotionCode = "$baseURL/agent/getPromotionCode";
  // 团队总览
  static  String teamOverview = "$baseURL/agent/teamOverview";
  // 团队报表
  static  String teamReport = "$baseURL/agent/teamReport";
  // 手工开户
  static  String openAccount = "$baseURL/agent/openAccount";
  // 手工开户开关
  static  String oaSwtich = "$baseURL/agent/oaSwtich";
  // 结算账单列表
  static  String settleList = "$baseURL/guild/settleList";
  // 结算账单明细
  static  String settleDetail = "$baseURL/guild/settleDetail";
  // 房间热度
  static  String hotDegree = "$baseURL/room/hotDegree";
  // 是否设置了支付密码
  static  String payPwd = "$baseURL/user/payPwd";
  // 提现申请
  static  String withdrawal = "$baseURL/user/withdrawal";
  // 离开房间
  static  String leave = "$baseURL/room/leave";
  // 删除房间背景图
  static  String removeRoomBg = "$baseURL/room/removeRoomBg";
  // 币转豆
  static  String exchangeCurrency = "$baseURL/user/exchangeCurrency";
  // 房间内在麦上的人
  static  String roomMikeInfo = "$baseURL/room/roomMikeInfo";
  // 推荐页搜索房间和用户
  static  String searchAll = "$baseURL/search/all";
  // 推荐页搜索房间和用户
  static  String showRoomList = "$baseURL/room/showRoomList";
  // 充值
  static  String orderCreate = "$baseURL/order/create";
  // 首充
  static  String isFirstOrder = "$baseURL/order/isFirstOrder";
  // 充值方式
  static  String getPayment = "$baseURL/order/getPayment";
  // 首充获取金额
  static  String getFirstPayment = "$baseURL/order/getFirstPayment";
  // 提现费率
  static  String getRate = "$baseURL/user/getRate";
  // 游戏榜单
  static  String gameRanking = "$baseURL/game/gameRanking";
  // 设置勿扰模式
  static  String setDisturb = "$baseURL/mine/setDisturb";
  // 腾讯云查看文件id
  static  String tencentID = "$baseURL/upload/save";
  // 举报用户
  static  String userReport = "$baseURL/chat/userReport";
  // 设置离线模式
  static  String setLockMic = "$baseURL/room/setLockMic";
  // 邀请有礼-提交申请
  static  String yqApply = "$baseURL/agent/apply";
  // 邀请有礼-获取分享链接
  static  String getShareUrl = "$baseURL/agent/getShareUrl";
  // 全民代理-获取推广链接
  static  String getPromoUrl = "$baseURL/agent/getPromoUrl";
  // 购买装扮
  static  String buyDress = "$baseURL/shop/buyDress";
  // 设置装扮
  static  String setDress = "$baseURL/shop/setDress";
  // 爆灯
  static  String burstLight = "$baseURL/room/burstLight";
  // 开启pk
  static  String startPk = "$baseURL/pk/startPk";



}