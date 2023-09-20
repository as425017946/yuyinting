import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';

import '../../../utils/my_utils.dart';
import '../../shouchong/shouchong_page.dart';
/// 首充弹窗
class TSSCPage extends StatefulWidget {
  const TSSCPage({super.key});

  @override
  State<TSSCPage> createState() => _TSSCPageState();
}

class _TSSCPageState extends State<TSSCPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: ((){
              MyUtils.goTransparentPageCom(context, const ShouChongPage());
              Navigator.pop(context);
            }),
            child: SizedBox(
              height: 500.h,
              width: double.infinity,
              child: const SVGASimpleImage(assetsName: 'assets/svga/gp/ts_sc.svga',),
            ),
          ),
          WidgetUtils.commonSizedBox(30.h, 0),
          GestureDetector(
            onTap: ((){
              Navigator.pop(context);
            }),
            child: WidgetUtils.showImages(
                'assets/images/car/car_guanbi.png', 70.h, 70.h),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
