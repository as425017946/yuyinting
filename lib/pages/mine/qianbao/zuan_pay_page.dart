import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 钻石充值
class ZuanPayPage extends StatefulWidget {
  String shuliang;
  ZuanPayPage({Key? key, required this.shuliang}) : super(key: key);

  @override
  State<ZuanPayPage> createState() => _ZuanPayPageState();
}

class _ZuanPayPageState extends State<ZuanPayPage> {
  TextEditingController controllerNumber = TextEditingController();
  var appBar;
  var gz = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('充值钻', true, context, false, 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.myLine(thickness: 10),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// 钻石
                SizedBox(
                  height: ScreenUtil().setHeight(250),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      WidgetUtils.showImagesFill(
                          'assets/images/mine_wallet_zbj.jpg',
                          ScreenUtil().setHeight(250),
                          double.infinity),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.showImages(
                              'assets/images/mine_wallet_zz.png',
                              ScreenUtil().setHeight(100),
                              ScreenUtil().setHeight(100)),
                          WidgetUtils.commonSizedBox(0, 15),
                          Expanded(
                              child: Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  Row(
                                    children: [
                                      Container(
                                        height: ScreenUtil().setHeight(250),
                                        padding: const EdgeInsets.only(top: 50),
                                        child: Text(
                                          '钻',
                                          style: StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(38)),
                                        ),
                                      ),
                                      WidgetUtils.commonSizedBox(0, 50),
                                      WidgetUtils.onlyText(
                                          widget.shuliang,
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

                      /// 兑换提示
                      Container(
                        margin: const EdgeInsets.only(right: 15, bottom: 15),
                        child: Text(
                          '钻石=充值USDT*实时汇率*10',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(21),
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(50, 20),
                Container(
                  height: ScreenUtil().setHeight(280),
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.walletGrayBG,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(30, 20),
                      Row(
                        children: [
                          WidgetUtils.onlyText('选择通道', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText('USDT-TRC20', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: ((){

                            }),
                            child: WidgetUtils.onlyText('更换', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(5, 20),
                      WidgetUtils.myLine(),
                      WidgetUtils.onlyText('充值金额', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                      Row(
                        children: [
                          Expanded(
                            child: WidgetUtils.commonTextField(
                                controllerNumber,  '请输入10~10000'),
                          ),
                          WidgetUtils.onlyText('元', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                        ],
                      ),
                      WidgetUtils.myLine(),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(50, 20),
                GestureDetector(
                  onTap: ((){
                    setState(() {
                      gz = !gz;
                    });
                  }),
                  child: Row(
                    children: [
                      const Expanded(child: Text('')),
                      WidgetUtils.showImages( gz == false ? 'assets/images/trends_r1.png' : 'assets/images/trends_r2.png', 15, 15),
                      WidgetUtils.commonSizedBox(0, 10),
                      const Text('充值代表已阅读并同意',style: TextStyle(fontSize: 13,color: MyColors.g9, ),),
                      const Text('《充值协议》',style: TextStyle(fontSize: 13,color: MyColors.walletWZBlue, ),),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(50, 20),
                WidgetUtils.commonSubmitButton2('提交', MyColors.walletWZBlue),
              ],
            ),
          )
        ],
      ),
    );
  }
}
