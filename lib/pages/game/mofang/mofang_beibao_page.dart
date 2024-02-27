import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/beibaoBean.dart';
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
              height: ScreenUtil().setHeight(190),
              width: ScreenUtil().setHeight(130),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10.h, 0),
                  Stack(
                    children: [
                      WidgetUtils.showImagesNet(
                          listPl[index].img!,
                          ScreenUtil().setHeight(90),
                          ScreenUtil().setHeight(90)),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(5.h),
                            decoration: BoxDecoration(
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(10.h)),
                              //设置四周边框
                              border: Border.all(width: 1, color: MyColors.lbL),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              listPl[index].number!.toString(),
                              style: TextStyle(
                                color: MyColors.lbL,
                                fontSize: 16.sp,
                              ),
                            ),
                          ))
                    ],
                  ),
                  WidgetUtils.onlyTextCenter(
                      listPl[index].name!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '${listPl[index].price}V豆',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ3,
                          fontSize: ScreenUtil().setSp(21))),
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
                  child: listPl.isNotEmpty ? OptionGridView(
                    itemCount: listPl.length,
                    rowCount: 4,
                    mainAxisSpacing: 10.h,
                    // 上下间距
                    crossAxisSpacing: 0.h,
                    //左右间距
                    itemBuilder: _initlistdata,
                  ) : Container(
                    height: 400.h,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Expanded(child: Text('')),
                        WidgetUtils.showImages(
                            'assets/images/no_have.png', 100, 100),
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.onlyTextCenter(
                            '暂无背包礼物',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(26))),
                        const Expanded(child: Text('')),
                      ],
                    ),
                  ),
                )),
                WidgetUtils.commonSizedBox(20.h, 0),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 背包
  List<Gift> listPl = [];

  /// 获取礼物列表
  Future<void> doPostGiftList() async {
    LogE('token ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'type': "2",
    };
    Loading.show(MyConfig.successTitle);
    try {
      beibaoBean bean = await DataUtils.postGiftListBB(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listPl.clear();
            listPl = bean.data!.gift!;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
