import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/carZJLiShiBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

///历史记录
class LiShiPage extends StatefulWidget {
  const LiShiPage({super.key});

  @override
  State<LiShiPage> createState() => _LiShiPageState();
}

class _LiShiPageState extends State<LiShiPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGiftList();
  }

  Widget jilu(BuildContext context, int i){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50.h,
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    height: 26.h,
                    width: 26.h,
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
                    child: WidgetUtils.onlyTextCenter('${(i+1)}', StyleUtils.getCommonTextStyle(color: MyColors.CarZJ, fontSize: 20.sp)),
                  ),
                  WidgetUtils.commonSizedBox(0, 8.h),
                ],
              ),
            ),
            for(int a = 0; a < 7; a++)
              a == (list[i].openSn! - 1) ? Container(
                height: 28.h,
                width: 68.h,
                margin: EdgeInsets.only(right: 5.h),
                decoration: BoxDecoration(
                  //背景
                  color: MyColors.CarZJ,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: const BorderRadius.all(
                      Radius.circular(5)),
                  //设置四周边框
                  border: Border.all(width: 1, color: MyColors.CarZJ),
                ),
              ) : Container(
                height: 28.h,
                width: 68.h,
                margin: EdgeInsets.only(right: 5.h),
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
        WidgetUtils.commonSizedBox(10.h, 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.transparent,
          )),
          Container(
            height: 820.h,
            width: double.infinity,
            margin: EdgeInsets.all(15.h),
            decoration: const BoxDecoration(
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage('assets/images/car/car_jilu_bg.png'),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(50.h, 0),
                Container(
                  alignment: Alignment.center,
                  child: WidgetUtils.showImages(
                      'assets/images/car/car_jilu_title.png', 40.h, 400.h),
                ),
                WidgetUtils.commonSizedBox(30.h, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 50.h),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t1.png', 63.h, 58.h),
                    ),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t2.png', 63.h, 58.h),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t3.png', 72.h, 65.h),
                    ),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t4.png', 60.h, 60.h),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t5.png', 57.h, 76.h),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t6.png', 66.h, 60.h),
                    ),
                    Container(
                      width: 68.h,
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t7.png', 63.h, 58.h),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                    itemBuilder: jilu,
                    itemCount: list.length,
                  ),
                ),
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyTextCenter('以上为近期比赛的获胜赛道记录\n序号1为上轮比赛，依次往上顺延', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: 20.sp)),
                WidgetUtils.commonSizedBox(30.h, 0),
              ],
            ),
          ),
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: WidgetUtils.showImages(
                'assets/images/car/car_guanbi.png', 70.h, 70.h),
          ),
          Expanded(
              child: Container(
            color: Colors.transparent,
          )),
        ],
      ),
    );
  }

  List<Data> list = [];
  /// 赛车中奖赛道列表历史
  Future<void> doPostGiftList() async {

    try {
      Loading.show();
      carZJLiShiBean bean = await DataUtils.postGetWinTrackList();
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
