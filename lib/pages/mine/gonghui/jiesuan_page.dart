import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 结算账单
class JiesuanPage extends StatefulWidget {
  const JiesuanPage({Key? key}) : super(key: key);

  @override
  State<JiesuanPage> createState() => _JiesuanPageState();
}

class _JiesuanPageState extends State<JiesuanPage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('结算账单', true, context, false, 0);
  }

  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return GestureDetector(
      onTap: ((){
        Navigator.pushNamed(context, 'JiesuanMorePage');
      }),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 260.h
        ),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: const EdgeInsets.only(bottom: 10),
        color: MyColors.dailiBaobiao,
        child: Column(
          children: [
            Row(
              children: [
                WidgetUtils.onlyText('2023-06-01', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(28))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText('2023-06-07', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
            WidgetUtils.commonSizedBox(15, 10),
            Row(
              children: [
                WidgetUtils.onlyText('当周总流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText('V豆直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('背包流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText('钻石直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('钻石游戏流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText('扣款：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('0', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('周分润：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText('1200', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.onlyTextCenter('查明细>', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body:  Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              WidgetUtils.showImagesFill('assets/images/gonghui_more_bg.jpg', ScreenUtil().setHeight(300), double.infinity),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: [
                    WidgetUtils.showImages('assets/images/gonghui_jiesuan.png', ScreenUtil().setHeight(250), double.infinity),
                    SizedBox(
                      height: ScreenUtil().setHeight(250),
                      child:  Column(
                        children: [
                          const Expanded(child: Text('')),
                          Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 140),
                              SizedBox(
                                width: ScreenUtil().setHeight(200),
                                child: WidgetUtils.onlyText('直刷流水返点', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
                              ),
                              WidgetUtils.onlyText('10%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                            ],
                          ),
                          WidgetUtils.commonSizedBox(8, 5),
                          Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 140),
                              SizedBox(
                                width: ScreenUtil().setHeight(200),
                                child: WidgetUtils.onlyText('背包流水返点', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
                              ),
                              WidgetUtils.onlyText('10%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                            ],
                          ),
                          WidgetUtils.commonSizedBox(8, 5),
                          Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 140),
                              SizedBox(
                                width: ScreenUtil().setHeight(200),
                                child: WidgetUtils.onlyText('钻石游戏流水返点', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
                              ),
                              WidgetUtils.onlyText('10%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                            ],
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              itemBuilder: _itemZhangdan,
              itemCount: 15,
            ),
          ),
        ],
      ),
    );
  }
}

