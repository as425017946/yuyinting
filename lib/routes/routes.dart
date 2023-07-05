import 'package:yuyinting/pages/home/ranking_page.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/pages/message/care_home_page.dart';
import 'package:yuyinting/pages/message/care_page.dart';
import 'package:yuyinting/pages/mine/daili/daili_home_page.dart';
import 'package:yuyinting/pages/mine/gonghui/jiesuan_page.dart';
import 'package:yuyinting/pages/mine/gonghui/shenhe_page.dart';
import 'package:yuyinting/pages/mine/setting/password_pay_page.dart';
import 'package:yuyinting/pages/mine/setting/qiehuan_account_page.dart';
import 'package:yuyinting/pages/mine/setting/setting_page.dart';
import 'package:yuyinting/pages/mine/setting/yinsi_page.dart';
import 'package:yuyinting/pages/mine/setting/yonghu_page.dart';
import 'package:yuyinting/pages/mine/setting/zhanghao_shezhi_page.dart';
import 'package:yuyinting/pages/mine/setting/zhuxiao_page.dart';
import 'package:yuyinting/pages/trends/trends_more_page.dart';

import '../pages/login/forgot_password_page.dart';
import '../pages/message/be_care_page.dart';
import '../pages/message/geren/people_info_page.dart';
import '../pages/message/xitong_more_page.dart';
import '../pages/mine/daili/share_tuiguang_page.dart';
import '../pages/mine/dengji_page.dart';
import '../pages/mine/gonghui/gonghui_home_page.dart';
import '../pages/mine/gonghui/gonghui_more_page.dart';
import '../pages/mine/gonghui/gonghui_people_page.dart';
import '../pages/mine/gonghui/jiesuan_more_page.dart';
import '../pages/mine/gonghui/my_gonghui_page.dart';
import '../pages/mine/gonghui/room_more_page.dart';
import '../pages/mine/gonghui/setting_gonghui_page.dart';
import '../pages/mine/kefu_page.dart';
import '../pages/mine/liwu/liwu_page.dart';
import '../pages/mine/liwu/liwu_shoudao_page.dart';
import '../pages/mine/liwu/liwu_songchu_page.dart';
import '../pages/mine/liwu/wall_page.dart';
import '../pages/mine/my/edit_audio_page.dart';
import '../pages/mine/my/edit_biaoqian_page.dart';
import '../pages/mine/my/edit_head_page.dart';
import '../pages/mine/my/edit_my_info_page.dart';
import '../pages/mine/my/my_info_page.dart';
import '../pages/mine/qianbao/bi_zhuan_dou_page.dart';
import '../pages/mine/qianbao/dou_pay_page.dart';
import '../pages/mine/qianbao/tixian_bi_page.dart';
import '../pages/mine/qianbao/tixian_zuan_page.dart';
import '../pages/mine/qianbao/wallet_more_page.dart';
import '../pages/mine/qianbao/wallet_page.dart';
import '../pages/mine/qianbao/zuan_pay_page.dart';
import '../pages/mine/setting/about_page.dart';
import '../pages/mine/setting/black_page.dart';
import '../pages/mine/setting/change_phone_page.dart';
import '../pages/mine/setting/choose_country_page.dart';
import '../pages/mine/setting/password_page.dart';
import '../pages/mine/setting/shimingzhi_card_page.dart';
import '../pages/mine/setting/shimingzhi_page.dart';
import '../pages/mine/tequan/tequan_page.dart';
import '../pages/message/geren/who_lock_me_page.dart';
import '../pages/mine/zhuangban/shop_page.dart';
import '../pages/mine/zhuangban/zhuangban_page.dart';
import '../pages/room/room_page.dart';
import '../pages/room/room_people_info_page.dart';
import '../pages/room/room_redu_page.dart';
import '../pages/room/room_ts_gonggao_page.dart';
import '../pages/trends/trends_hi_page.dart';
import '../pages/trends/trends_send_page.dart';


/// 静态路由
var staticRoutes = {
  'LoginPage':(context) => const LoginPage(),//登录
  'RankingPage':(context,{id}) =>  const RankingPage(),//排行榜
  'TrendsMorePage':(context) => const TrendsMorePage(),//动态详情
  'TrendsHiPage':(context) => const TrendsHiPage(),//动态打招呼提示框
  'TrendsSendPage':(context) => const TrendsSendPage(),// 发布动态页面
  'CareHomePage':(context) => const CareHomePage(),// 关注被关注整合页面
  'CarePage':(context) => const CarePage(),// 关注页面
  'BeCarePage':(context) => const BeCarePage(),// 被关注页面
  'PeopleInfoPage':(context) => const PeopleInfoPage(),// ta人主页
  'MyInfoPage':(context) => const MyInfoPage(),// 个人主页
  'EditMyInfoPage':(context) => const EditMyInfoPage(),// 编辑个人资料
  'EditHeadPage':(context) => const EditHeadPage(),// 编辑头像显示
  'EditBiaoqianPage':(context) => const EditBiaoqianPage(),// 编辑个人标签
  'EditAudioPage':(context) => const EditAudioPage(),// 编辑声音
  'WhoLockMePage':(context) => const WhoLockMePage(),// 谁看过我
  'LiwuPage':(context) => const LiwuPage(),// 礼物记录
  'LiwuShoudaoPage':(context) => const LiwuShoudaoPage(),// 收到礼物记录
  'LiwuSongchuPage':(context) => const LiwuSongchuPage(),// 送出礼物记录
  'WalletPage':(context) => const WalletPage(),// 我的钱包
  'DouPayPage':(context) => const DouPayPage(),// 充值豆子
  'TixianBiPage':(context) => const TixianBiPage(),// 提现金币
  'BiZhuanDouPage':(context) => const BiZhuanDouPage(),// 币转豆
  'ZuanPayPage':(context) => const ZuanPayPage(),// 钻石充值
  'TixianZuanPage':(context) => const TixianZuanPage(),// 钻石提现
  'WalletMorePage':(context) => const WalletMorePage(),// 钱包明细
  'DailiHomePage':(context) => const DailiHomePage(),// 全民代理
  'ShareTuiguangPage':(context) => const ShareTuiguangPage(),// 推广分享
  'KefuPage':(context) => const KefuPage(),// 客服中心
  'GonghuiHomePage':(context) => const GonghuiHomePage(),// 公会中心
  'GonghuiMorePage':(context) => const GonghuiMorePage(),// 无公会得详情
  'MyGonghuiPage':(context) => const MyGonghuiPage(),// 我的公会
  'SettingGonghuiPage':(context) => const SettingGonghuiPage(),// 公会设置
  'GonghuiPeoplePage':(context) => const GonghuiPeoplePage(),// 公会成员
  'ShenhePage':(context) => const ShenhePage(),// 入驻审核
  'JiesuanPage':(context) => const JiesuanPage(),// 结算账单
  'JiesuanMorePage':(context) => const JiesuanMorePage(),// 账单明细
  'RoomMorePage':(context) => const RoomMorePage(),// 公会房间列表
  'SettingPage':(context) => const SettingPage(),// 设置页面
  'ZhanghaoShezhipage':(context) => const ZhanghaoShezhipage(),// 账号设置
  'ChooseCountryPage':(context) => const ChooseCountryPage(),// 选择国家区号
  'ChangePhonePage':(context) => const ChangePhonePage(),// 更换手机号
  'PasswordPage':(context) => PasswordPage(title: '',),// 修改登录密码
  'PasswordPayPage':(context) => const PasswordPayPage(),// 修改支付密码
  'ZhuxiaoPage':(context) => const ZhuxiaoPage(),// 注销账号
  'ShimingzhiPage':(context) => const ShimingzhiPage(),// 实名制认证
  'ShimingzhiCardPage':(context) => const ShimingzhiCardPage(),// 实名制上传身份证认证
  'BlackPage':(context) => const BlackPage(),// 黑名单
  'AboutPage':(context) => const AboutPage(),// 关于
  'YinsiPage':(context) => const YinsiPage(),// 隐私协议
  'YonghuPage':(context) => const YonghuPage(),// 用户协议
  'QiehuanAccountPage':(context) => const QiehuanAccountPage(),// 切换账号
  'ForgotPasswordPage':(context) => const ForgotPasswordPage(),// 忘记密码
  'XitongMorePage':(context) => const XitongMorePage(),// 系统消息详情
  'WallPage':(context) => const WallPage(),// 礼物墙
  'ZhuangbanPage':(context) => const ZhuangbanPage(),// 礼物墙
  'ShopPage':(context) => const ShopPage(),// 装扮商城
  'TequanPage':(context) => const TequanPage(),// 特权页面
  'RoomPage':(context) => RoomPage(type: 0,),// 房间页面
  'RoomPeopleInfoPage':(context) => const RoomPeopleInfoPage(),// 房间他人信息详情
  'RoomReDuPage':(context) => const RoomReDuPage(),// 房间内的热度
  'RoomTSGongGaoPage':(context) => const RoomTSGongGaoPage(),// 房间内弹窗公告

  'DengjiPage':(context) => const DengjiPage(),// 测试等级描边


};