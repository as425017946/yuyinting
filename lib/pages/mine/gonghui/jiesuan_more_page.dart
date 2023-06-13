import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 账单明细
class JiesuanMorePage extends StatefulWidget {
  const JiesuanMorePage({Key? key}) : super(key: key);

  @override
  State<JiesuanMorePage> createState() => _JiesuanMorePageState();
}

class _JiesuanMorePageState extends State<JiesuanMorePage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('账单明细', true, context, false, 0);
  }

  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(190),
      padding: const EdgeInsets.only(left: 20, right: 20,),
      margin: const EdgeInsets.only(bottom: 10),
      color: MyColors.dailiBaobiao,
      child: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 10),
          WidgetUtils.onlyTextCenter('房间名字', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
          Row(
            children: [
              WidgetUtils.onlyText('周流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              WidgetUtils.onlyText('背包流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              WidgetUtils.onlyText('砖石游戏：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('周分润：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.onlyText('2023-06-01', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(35))),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(38))),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('2023-06-07', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(35))),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(35))),
              WidgetUtils.commonSizedBox(0, 20),
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
