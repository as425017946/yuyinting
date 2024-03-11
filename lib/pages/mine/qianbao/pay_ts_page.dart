import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../config/config_screen_util.dart';
import '../../../utils/style_utils.dart';

///充值提示
class PayTSWZPage extends StatefulWidget {
  String payUrl;
  PayTSWZPage({super.key, required this.payUrl});

  @override
  State<PayTSWZPage> createState() => _PayTSWZPageState();
}

class _PayTSWZPageState extends State<PayTSWZPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 540.h,
          width: 480.h,
          padding: EdgeInsets.only(left: 20.h, right: 20.h),
          //边框设置
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(50.h, 0),
              WidgetUtils.onlyTextCenter(
                  '提  示',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.white, fontSize: 40.sp)),
              WidgetUtils.commonSizedBox(50.h, 0),
              WidgetUtils.onlyText('请在 120 秒内完成支付。支付时请输入与APP发起充值相同的金额。',
                  TextStyle(height: 2, color: Colors.white, fontSize: 28.sp)),
              WidgetUtils.onlyText('超时支付或未输入正确金额可能会导致充值无法成功到账',
                  TextStyle(height: 2, color: Colors.white, fontSize: 28.sp)),
              WidgetUtils.commonSizedBox(30.h, 0),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: ConfigScreenUtil.autoHeight80,
                alignment: Alignment.center,
                width: 260.h,
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: MyColors.walletWZBlue,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: ConfigScreenUtil.autoHeight80,
                  splashColor: MyColors.blue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  onPressed: (() {
                    Navigator.pop(context);
                    tiaozhuan();
                  }),
                  child: Text(
                    '确认',
                    style: StyleUtils.whiteTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void>  tiaozhuan() async{
    if (widget.payUrl!.isNotEmpty) {
      await launch(widget.payUrl!, forceSafariVC: false);
    } else {
      throw 'Could not launch ${widget.payUrl}';
    }
  }
}
