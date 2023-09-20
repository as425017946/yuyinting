import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/game/car_page.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../../utils/widget_utils.dart';
/// 赛车弹窗
class TSCarPage extends StatefulWidget {
  const TSCarPage({super.key});

  @override
  State<TSCarPage> createState() => _TSCarPageState();
}

class _TSCarPageState extends State<TSCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: ((){
              MyUtils.goTransparentPageCom(context, const Carpage());
              Navigator.pop(context);
            }),
            child: SizedBox(
              height: 500.h,
              width: double.infinity,
              child: WidgetUtils.showImages('assets/images/ts_car.png', 500.h, double.infinity),
            ),
          ),
          WidgetUtils.commonSizedBox(30.h, 0),
          GestureDetector(
            onTap: (() {
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
