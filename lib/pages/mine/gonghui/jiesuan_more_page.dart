import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/ghJieSuanListMoreBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 账单明细
class JiesuanMorePage extends StatefulWidget {
  String id;
  String starTime;
  String endTime;
  JiesuanMorePage({Key? key, required this.id, required this.starTime, required this.endTime}) : super(key: key);

  @override
  State<JiesuanMorePage> createState() => _JiesuanMorePageState();
}

class _JiesuanMorePageState extends State<JiesuanMorePage> {
  var appBar;
  List<Data> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('账单明细', true, context, false, 0);
    doPostSettleList();
  }

  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 190.h
      ),
      padding: const EdgeInsets.only(left: 20, right: 20,),
      margin: const EdgeInsets.only(bottom: 10),
      color: MyColors.dailiBaobiao,
      child: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 10),
          WidgetUtils.onlyTextCenter(list[i].roomName!, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
          Row(
            children: [
              WidgetUtils.onlyText('当周总流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(list[i].weekSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              // WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              // WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              WidgetUtils.onlyText('V豆直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(list[i].gbDirectSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('背包流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(list[i].packSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              WidgetUtils.onlyText('钻石直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(list[i].dDirectSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('钻石游戏流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              WidgetUtils.onlyText(list[i].dGame!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
            ],
          ),
          // WidgetUtils.commonSizedBox(10, 10),
          // Row(
          //   children: [
          //     WidgetUtils.onlyText('扣款：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
          //     WidgetUtils.onlyText('0', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
          //     const Expanded(child: Text('')),
          //     WidgetUtils.onlyText('周分润：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
          //     WidgetUtils.onlyText('11', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
          //   ],
          // ),
          WidgetUtils.commonSizedBox(10, 10),
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
              WidgetUtils.onlyText(widget.starTime, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(35))),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(38))),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText(widget.endTime, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(35))),
              const Expanded(child: Text('')),
              // WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(35))),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              itemBuilder: _itemZhangdan,
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }


  /// 结算账单列表
  Future<void> doPostSettleList() async {
    Loading.show(MyConfig.successTitle);
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_settle_id': widget.id
      };
      ghJieSuanListMoreBean bean = await DataUtils.postSettleDetail(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            list = bean.data!;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
