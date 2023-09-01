import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 币转豆 页面
class BiZhuanDouPage extends StatefulWidget {
  const BiZhuanDouPage({Key? key}) : super(key: key);

  @override
  State<BiZhuanDouPage> createState() => _BiZhuanDouPageState();
}

class _BiZhuanDouPageState extends State<BiZhuanDouPage> {
  TextEditingController controllerNumber = TextEditingController();
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('币转豆', true, context, false, 0);
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
                /// 豆子
                SizedBox(
                  height: ScreenUtil().setHeight(250),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      WidgetUtils.showImagesFill(
                          'assets/images/mine_wallet_bbj.jpg',
                          ScreenUtil().setHeight(250),
                          double.infinity),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.showImages(
                              'assets/images/mine_wallet_bb.png',
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
                                          '币',
                                          style: StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(38)),
                                        ),
                                      ),
                                      WidgetUtils.commonSizedBox(0, 50),
                                      WidgetUtils.onlyText(
                                          '1000000',
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
                          '1币=1豆',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(21),
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(20, 20),
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
                      WidgetUtils.onlyText('提取V币', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                      Row(
                        children: [
                          WidgetUtils.showImages('assets/images/mine_wallet_jinbi.png', ScreenUtil().setHeight(48), ScreenUtil().setHeight(48)),
                          WidgetUtils.commonSizedBox(0, 20),
                          Expanded(
                            child: WidgetUtils.commonTextField(
                                controllerNumber,  '请输入币数量'),
                          ),
                          GestureDetector(
                            onTap: ((){

                            }),
                            child: WidgetUtils.onlyText('全部', StyleUtils.getCommonTextStyle(color: MyColors.walletWZBlue, fontSize: ScreenUtil().setSp(32))),
                          ),
                        ],
                      ),
                      WidgetUtils.myLine(),
                      WidgetUtils.commonSizedBox(20, 20),
                      Row(
                        children: [
                          WidgetUtils.onlyText('到账豆', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(32))),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.onlyText('￥0', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32), fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(20, 20),
                WidgetUtils.commonSubmitButton2('确认兑换', MyColors.walletWZBlue),
              ],
            ),
          )
        ],
      ),
    );
  }
}
