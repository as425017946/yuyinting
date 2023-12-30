import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/gameStoreBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../../../widget/duihuan_queren_page.dart';
import '../../../widget/queren_page.dart';

/// 转盘的奖池说明
class ZhuanPanShuoMing2Page extends StatefulWidget {
  const ZhuanPanShuoMing2Page({super.key});

  @override
  State<ZhuanPanShuoMing2Page> createState() => _ZhuanPanJiangChiPageState();
}

class _ZhuanPanJiangChiPageState extends State<ZhuanPanShuoMing2Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
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
            height: 820.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_jc_bg2.png'),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetUtils.commonSizedBox(180.h, 0),
                //标题
                Container(
                    alignment: Alignment.center,
                    child: WidgetUtils.showImages(
                        'assets/images/zhuanpan_jc_sm_title.png', 32.h, 320.h)),
                WidgetUtils.commonSizedBox(20.h, 0),
                Padding(
                  padding: EdgeInsets.only(left: 60.w, right: 60.w),
                  child: Text(
                    '参与“心动转盘”和“超级转盘”赢得的“心之钥”和“星之钥”可在兑换商城内兑换多种礼物。 \n兑换的礼物将自动发送至您的“礼物背包”内俩种钥匙均为 3 日有效期，例如：今日12时您获得的钥匙，将在 3 日后的0时消失。',
                    style: TextStyle(
                        color: Colors.white, fontSize: 26.sp, height: 2),
                  ),
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        alignment: Alignment.center,
                        child: WidgetUtils.showImages(
                            'assets/images/zhuanpan_jc_sm_ys1.png',
                            350.h,
                            double.infinity)),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                      }),
                      child: Container(
                          margin: EdgeInsets.only(left: 100.w, right: 100.w),
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/zhuanpan_jc_sm_back.png',
                              80.h,
                              double.infinity)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
