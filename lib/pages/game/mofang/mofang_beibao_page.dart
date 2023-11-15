import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/liwuBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 厅内礼物
class MoFangBeiBaoPage extends StatefulWidget {
  const MoFangBeiBaoPage({super.key});

  @override
  State<MoFangBeiBaoPage> createState() => _MoFangBeiBaoPageState();
}

class _MoFangBeiBaoPageState extends State<MoFangBeiBaoPage> {
  int leixing = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGiftList();
  }

  /// 礼物
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setHeight(150),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(5, 0),
                  WidgetUtils.showImagesNet(listPl[index].img!,
                      ScreenUtil().setHeight(100), ScreenUtil().setHeight(140)),
                  WidgetUtils.onlyTextCenter(
                      listPl[index].name!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '${listPl[index].price!}钻',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ3,
                          fontSize: ScreenUtil().setSp(21))),
                  WidgetUtils.onlyTextCenter(
                      'x${listPl[index].number!}',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomMessageYellow2,
                          fontSize: ScreenUtil().setSp(22))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(490),
            width: double.infinity,
            padding: EdgeInsets.only(left: 30.h, right: 20.h),
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc1.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(10, 0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          leixing = 0;
                        });
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '背包',
                          StyleUtils.getCommonTextStyle(
                              color: leixing == 0
                                  ? MyColors.roomTCWZ2
                                  : MyColors.roomTCWZ3,
                              fontSize: leixing == 0
                                  ? ScreenUtil().setSp(28)
                                  : ScreenUtil().setSp(25))),
                    ),
                  ],
                ),

                /// 展示礼物
                Expanded(
                    child: SingleChildScrollView(
                  child: OptionGridView(
                    itemCount: listPl.length,
                    rowCount: 4,
                    mainAxisSpacing: 10.h,
                    // 上下间距
                    crossAxisSpacing: 0.h,
                    //左右间距
                    itemBuilder: _initlistdata,
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 背包
  List<DataL> listPl = [];

  /// 获取礼物列表
  Future<void> doPostGiftList() async {
    LogE('token ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'type': 2,
    };
    Loading.show(MyConfig.successTitle);
    try {
      liwuBean bean = await DataUtils.postGiftList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listPl.clear();
            listPl = bean.data!;
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
      LogE('错误信息提示$e');
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
