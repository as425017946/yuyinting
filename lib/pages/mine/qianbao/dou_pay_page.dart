import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuyinting/pages/mine/qianbao/pay_ts_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import '../../../bean/balanceBean.dart';
import '../../../bean/orderPayBean.dart';
import '../../../bean/payLsitBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/pay_tool.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 充值金豆页面
class DouPayPage extends StatefulWidget {
  String shuliang;

  DouPayPage({Key? key, required this.shuliang}) : super(key: key);

  @override
  State<DouPayPage> createState() => _DouPayPageState();
}

class _DouPayPageState extends State<DouPayPage> {
  var appBar;
  TextEditingController controller = TextEditingController();
  var gz = false;

  // List<bool> isClick = [true,false,false,false,false,false,false,false,false];
  // List<String> listD = ['12','36','68','100','200','500','1000','3000','9000'];
  // List<String> listS = ['100','300','580','1000','2000','5000','10000','30000','90000'];
  List<bool> isClick = [];
  List<String> listD = [];
  List<String> listS = [];

  //支付方式 1支付宝 2云闪付 3微信 4银行卡 5QQ钱包 6 数字人民币 7抖音钱包
  int type = 1;

  //当前状态是什么
  String presentType = '';

  //支付方式 1支付宝 2云闪付 3微信 4银行卡 5QQ钱包 6 数字人民币 7抖音钱包
  bool isChoose0 = true, isChoose1 = true, isChoose2 = false, isChoose3 = false;

  // 想要充值多少钱 给多少豆子
  String money = '0', moneyDou = '0';

  ///选择金额使用
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if (listInfo[index].payType!.contains(',')) {
            type = int.parse(listInfo[index].payType!.split(',')[0]);
          } else {
            if (listInfo[index].payType!.isNotEmpty) {
              type = int.parse(listInfo[index].payType!);
            }
          }
          presentType = listInfo[index].payType!;
          //选择金额要判断显示的支付方式
          money = listD[index];
          moneyDou = listS[index];
          // 3q9q不显示云闪付
          if (listD[index] == '3000' || listD[index] == '9000') {
            isChoose1 = false;
          } else {
            isChoose1 = true;
          }
          // 300 580 显示微信
          if (listD[index] == '36' || listD[index] == '68') {
            isChoose3 = true;
          } else {
            isChoose3 = false;
          }
          // 3q9q不显示云闪付
          if (listD[index] == '12' ||
              listD[index] == '36' ||
              listD[index] == '68' ||
              listD[index] == '9000') {
            isChoose2 = false;
          } else {
            isChoose2 = true;
          }
          isClick[index] = true;
          for (int i = 0; i < 9; i++) {
            if (i != index) {
              isClick[i] = false;
            }
          }
        });
      }),
      child: Container(
        height: ScreenUtil().setHeight(125),
        width: double.infinity,
        alignment: Alignment.center,
        //边框设置
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: const BorderRadius.all(Radius.circular(13.0)),
          //设置四周边框
          border: Border.all(
              width: 1,
              color:
                  isClick[index] == true ? MyColors.walletWZBlue : MyColors.g6),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                const Expanded(child: Text('')),
                Row(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/mine_wallet_dd.png',
                        ScreenUtil().setHeight(27), ScreenUtil().setHeight(25)),
                    WidgetUtils.onlyText(
                        listS[index],
                        StyleUtils.getCommonTextStyle(
                            color: isClick[index] == true
                                ? MyColors.walletWZBlue
                                : Colors.black,
                            fontSize: ScreenUtil().setSp(33))),
                    const Expanded(child: Text('')),
                  ],
                ),
                WidgetUtils.onlyTextCenter(
                    '￥${listD[index]}',
                    StyleUtils.getCommonTextStyle(
                        color: isClick[index] == true
                            ? MyColors.walletWZBlue
                            : MyColors.g6,
                        fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
              ],
            ),
            isClick[index] == true
                ? WidgetUtils.showImages(
                    'assets/images/mine_wallet_xuanzhong.png',
                    ScreenUtil().setHeight(47),
                    ScreenUtil().setHeight(47))
                : const Text('')
          ],
        ),
      ),
    );
  }

  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostBalance();
    doPostGetPayment();
    appBar = WidgetUtils.getAppBar('充值金豆', true, context, false, 0);
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '确认充值') {
        doPostOrderCreate();
      } else if (event.title == '充值成功') {
        doPostBalance();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            WidgetUtils.myLine(thickness: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 豆子
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill(
                            'assets/images/mine_wallet_dbj.png',
                            ScreenUtil().setHeight(250),
                            double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            Container(
                              height: 100.h,
                              width: 100.h,
                              alignment: Alignment.center,
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.h)),
                              ),
                              child: WidgetUtils.showImages(
                                  'assets/images/mine_wallet_dd.png',
                                  650.h,
                                  65.h),
                            ),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(
                                child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '金豆',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(38))),
                                    const Spacer(),
                                    WidgetUtils.onlyText(
                                        jinbi,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(56),
                                            fontWeight: FontWeight.w600)),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )),
                          ],
                        ),
                        // /// 兑换提示
                        // Container(
                        //   margin: const EdgeInsets.only(right: 15,bottom: 15),
                        //   child: Text(
                        //     '10金豆=1元',
                        //     style: TextStyle(fontSize: ScreenUtil().setSp(21), color: Colors.white),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  WidgetUtils.onlyText(
                      '请选择充值金额',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(33),
                          fontWeight: FontWeight.w600)),
                  WidgetUtils.commonSizedBox(15, 20),
                  listD.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: 9,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20, //设置列间距
                            mainAxisSpacing: 20, //设置行间距
                            childAspectRatio: 16 / 9,
                          ),
                          itemBuilder: _initlistdata)
                      : const Text(''),
                  WidgetUtils.commonSizedBox(15, 20),
                  Container(
                    height: 1.h,
                    width: double.infinity,
                    color: MyColors.home_hx,
                  ),
                  presentType.contains('1')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 1;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_zfb.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '支付宝',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 1
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('1')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('2')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 2;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_ysf.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '云闪付',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 2
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('2')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('3')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 3;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_wx.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '微信',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 3
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('3')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('4')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 4;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_yl.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '银行卡',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 4
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('4')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('5')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 5;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_qq.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    'QQ钱包',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 5
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('5')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),

                  presentType.contains('6')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 6;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_szrmb.png',
                                    40.h,
                                    40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '数字人民币',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 6
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('6')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),

                  presentType.contains('7')
                      ? GestureDetector(
                          onTap: (() {
                            setState(() {
                              type = 7;
                            });
                          }),
                          child: Container(
                            height: 80.h,
                            width: double.infinity,
                            color: Colors.transparent,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/wallet_dy.png', 40.h, 40.h),
                                WidgetUtils.commonSizedBox(0, 20.w),
                                WidgetUtils.onlyText(
                                    '抖音钱包',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                                type == 7
                                    ? WidgetUtils.showImages(
                                        'assets/images/wallet_dh.png',
                                        35.h,
                                        35.h)
                                    : const Text(''),
                              ],
                            ),
                          ),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  presentType.contains('7')
                      ? Container(
                          height: 1.h,
                          width: double.infinity,
                          color: MyColors.home_hx,
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  // Container(
                  //   height: ScreenUtil().setHeight(80),
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   //边框设置
                  //   decoration: const BoxDecoration(
                  //     //背景
                  //     color: MyColors.f6,
                  //     //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  //     borderRadius: BorderRadius.all(Radius.circular(35)),
                  //   ),
                  //   child: WidgetUtils.commonTextFieldNumber(controller: controller, hintText: '请输入需要充值的金额'),
                  // ),
                  WidgetUtils.commonSizedBox(15, 20),
                  WidgetUtils.commonSubmitButton2(
                      '确认充值', MyColors.walletWZBlue),
                  WidgetUtils.commonSizedBox(15, 20),
                  // GestureDetector(
                  //   onTap: ((){
                  //     setState(() {
                  //       gz = !gz;
                  //     });
                  //   }),
                  //   child: Row(
                  //     children: [
                  //       const Expanded(child: Text('')),
                  //       WidgetUtils.showImages( gz == false ? 'assets/images/trends_r1.png' : 'assets/images/trends_r2.png', 15, 15),
                  //       WidgetUtils.commonSizedBox(0, 10),
                  //       const Text('充值代表已阅读并同意',style: TextStyle(fontSize: 13,color: MyColors.g9, ),),
                  //       const Text('《充值协议》',style: TextStyle(fontSize: 13,color: MyColors.walletWZBlue, ),),
                  //       const Expanded(child: Text('')),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 充值接口
  /// 支付方式 1支付宝 2云闪付 3微信 4银行卡 5QQ钱包 6 数字人民币 7抖音钱包
  /// 支付方式 zfb(支付宝) wx(微信) yhk(银行卡) ysf(云闪付) qq(QQ钱包) rmb(数字人民币)  dy(抖音钱包)
  /// 充值金额
  /// 充值类型 1人民币 2u币
  /// 货币类型 1金豆 2钻石
  /// 金豆数量
  /// 充值订单用途 1游戏币 2购买贵族
  /// 是否首充 1是 0否
  Future<void> doPostOrderCreate() async {
    //支付方式 1支付宝 2云闪付 3微信 4银行卡 5QQ钱包 6 数字人民币 7抖音钱包
    String payType = '';
    setState(() {
      if (type == 1) {
        payType = 'zfb';
      } else if (type == 2) {
        payType = 'ysf';
      } else if (type == 3) {
        payType = 'wx';
      } else if (type == 4) {
        payType = 'yhk';
      } else if (type == 5) {
        payType = 'qq';
      } else if (type == 6) {
        payType = 'rmb';
      } else if (type == 7) {
        payType = 'dy';
      }
    });
    Map<String, dynamic> params = <String, dynamic>{
      'recharge_method': payType,
      'recharge_cur_amount': money,
      'recharge_cur_type': '1',
      'game_cur_type': '1',
      'game_cur_amount': moneyDou,
      'use': '1',
      'is_first': '0',
      'is_agent': '0'
    };
    try {
      Loading.show();
      orderPayBean bean = await DataUtils.postOrderCreate(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // // // ignore: use_build_context_synchronously
          // // MyUtils.goTransparentPageCom(context, WebPage(url: bean.data!.payUrl!));
          if (bean.data!.payUrl!.isNotEmpty) {
            // await launch(bean.data!.payUrl!);
            await PayTool.launch(payType, bean.data!.payUrl);
          } else {
            throw 'Could not launch $bean.data!.payUrl!';
          }
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          if (bean.msg!.toString() == '当前支付金额已调整') {
            doPostGetPayment();
          }
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
    }
  }

  // 金币 钻石
  String jinbi = '', zuanshi = '', shouyi = '';

  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            // zuanshi = bean.data!.diamond!;
            shouyi = bean.data!.goldCoin!;
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {}
  }

  /// 充值方式
  List<DataCZ> listInfo = [];

  Future<void> doPostGetPayment() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'is_agent': '0',
    };
    try {
      payLsitBean bean = await DataUtils.postGetPayment(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listD.clear();
            listS.clear();
            isClick.clear();
            listInfo.clear();
            type = 1;
            if (bean.data!.isNotEmpty) {
              presentType = bean.data![0].payType!;
              money = bean.data![0].amount.toString();
              moneyDou = bean.data![0].goldBean.toString();
            }
            for (int i = 0; i < bean.data!.length; i++) {
              listInfo.add(bean.data![i]);
              listD.add(bean.data![i].amount.toString());
              listS.add(bean.data![i].goldBean.toString());
              if (i == 0) {
                isClick.add(true);
              } else {
                isClick.add(false);
              }
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
    }
  }
}
