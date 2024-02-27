import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bean/mofangJCBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 魔方奖池
class MoFangJiangChiPage extends StatefulWidget {
  String type;
  MoFangJiangChiPage({super.key, required this.type});

  @override
  State<MoFangJiangChiPage> createState() => _MoFangJiangChiPageState();
}

class _MoFangJiangChiPageState extends State<MoFangJiangChiPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRoulettePrizeList();
  }
  Widget jiangChiWidget(BuildContext context, int i){
    return Container(
      height: 266.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mofang_jc_bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          WidgetUtils.showImagesNet(
              list[i].img!, 100.h, 100.h),
          WidgetUtils.commonSizedBox(10.h, 0),
          WidgetUtils.onlyTextCenter(
              '${list[i].price!}V豆',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.loginBlue2, fontSize: 18.sp)),
          WidgetUtils.commonSizedBox(5.h, 0),
          WidgetUtils.onlyTextCenter(
              list[i].name!,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.zpGZYellow, fontSize: 22.sp)),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: 380.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/room_tc1.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetUtils.commonSizedBox(0, 20.h),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/back_white.png', 30.h, 20.h),
                    ),
                    const Spacer(),
                    WidgetUtils.onlyTextCenter(
                        '奖池一览',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.loginBlue2, fontSize: 36.sp)),
                    const Spacer(),
                    WidgetUtils.commonSizedBox(0, 40.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: OptionGridView(
                      padding: EdgeInsets.only(left: 20.h, right: 20.h),
                      itemCount: list.length,
                      rowCount: 3,
                      mainAxisSpacing: 10.h,
                      // 上下间距
                      crossAxisSpacing: 20.h,
                      //左右间距
                      itemBuilder: jiangChiWidget,
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
  List<Data> list = [];
  /// 魔方奖池
  Future<void> doPostRoulettePrizeList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'price_id': widget.type, //1小金额 2大金额
    };
    try {
      mofangJCBean bean = await DataUtils.postRoulettePrizeList(params);
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
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
