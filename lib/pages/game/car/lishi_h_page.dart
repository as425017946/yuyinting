import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 赛车横屏历史记录
class LiShiHPage extends StatefulWidget {
  const LiShiHPage({super.key});

  @override
  State<LiShiHPage> createState() => _LiShiHPageState();
}

class _LiShiHPageState extends State<LiShiHPage> {

  Widget jilu(BuildContext context, int i){
    return Column(
      children: [
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 15),
            SizedBox(
              width: 25,
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 17,
                    width: 17,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: Colors.transparent,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: const BorderRadius.all(
                          Radius.circular(13)),
                      //设置四周边框
                      border: Border.all(width: 1, color: MyColors.CarZJ),
                    ),
                    child: WidgetUtils.onlyTextCenter('${(i+1)}', StyleUtils.getCommonTextStyle(color: MyColors.CarZJ, fontSize: 10)),
                  ),
                  WidgetUtils.commonSizedBox(0, 4),
                ],
              ),
            ),
            for(int a = 0; a < 7; a++)
              Container(
                height: 15,
                width: 40,
                margin: const EdgeInsets.only(right: 2.5),
                decoration: BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: const BorderRadius.all(
                      Radius.circular(5)),
                  //设置四周边框
                  border: Border.all(width: 1, color: MyColors.CarZJ),
                ),
              )
          ],
        ),
        WidgetUtils.commonSizedBox(5, 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Row(
        children: [
          const Spacer(),
          Opacity(
            opacity: 0,
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
              Container(
                height: 310,
                width: 355,
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage('assets/images/car/car_jilu_bg.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(15, 0),
                    Container(
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car/car_jilu_title.png', 20, 200),
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 40),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t2.png', 31, 29),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t1.png', 31, 29),
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t4.png', 36, 32.5),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t3.png', 30, 30),
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t5.png', 28.5, 40),
                        ),
                        WidgetUtils.commonSizedBox(0, 3),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t6.png', 33, 30),
                        ),
                        WidgetUtils.commonSizedBox(0, 2),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: WidgetUtils.showImages(
                              'assets/images/car_jl_t7.png', 31, 29),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 2.5),
                        itemBuilder: jilu,
                        itemCount: 20,
                      ),
                    ),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyTextCenter('以上为近期比赛的获胜赛道记录序号1为上轮比赛，依次往上顺延', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 10)),
                    WidgetUtils.commonSizedBox(5, 0),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    color: Colors.transparent,
                  )),
            ],
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: double.infinity,
              width: 35,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 20),
              child: WidgetUtils.showImages(
                  'assets/images/car/car_guanbi.png', 35, 35),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
