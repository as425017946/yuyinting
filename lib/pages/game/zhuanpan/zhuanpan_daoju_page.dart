import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/playRouletteBean.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';

/// 展示获得的道具
class ZhuanPanDaoJuPage extends StatefulWidget {
  List<Gifts> list;
  int zonge;
  String title;

  ZhuanPanDaoJuPage(
      {super.key,
      required this.list,
      required this.zonge,
      required this.title});

  @override
  State<ZhuanPanDaoJuPage> createState() => _ZhuanPanDaoJuPageState();
}

class _ZhuanPanDaoJuPageState extends State<ZhuanPanDaoJuPage> {
  bool isShow = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.title == '心动转盘'){
      if(widget.list[0].price as int >= 1000){
        setState(() {
          isShow = true;
        });
      }
    }else{
      if(widget.list[0].price as int >= 5000){
        setState(() {
          isShow = true;
        });
      }
    }
  }

  Widget jiangChiWidget(BuildContext context, int i) {
    return Container(
      height: 170.h,
      width: 110.h,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: 110.h,
            height: 110.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/zhuanpan_dj_lw.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImagesNet(widget.list[i].img!, 100.h, 100.h),
                Positioned(
                  bottom: 5.h,
                  right: 5.h,
                  child: Container(
                    width: 50.h,
                    height: 20.h,
                    decoration: const BoxDecoration(
                      //设置Container修饰
                      image: DecorationImage(
                        //背景图片修饰
                        image:
                            AssetImage("assets/images/zhuanpan_dj_lw_sl.png"),
                        fit: BoxFit.fill, //覆盖
                      ),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        'x${widget.list[i].count}',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCYellow,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(2.h, 0),
          WidgetUtils.onlyTextCenter(
              widget.list[i].name!,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.roomTCYellow, fontSize: 22.sp)),
          WidgetUtils.commonSizedBox(2.h, 0),
          WidgetUtils.onlyTextCenter(
              widget.list[i].price.toString(),
              StyleUtils.getCommonTextStyle(
                  color: MyColors.roomTCYellow,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          Column(
            children: [
              WidgetUtils.commonSizedBox(450.h, 0),
              Container(
                height: 650.h,
                width: double.infinity,
                margin: EdgeInsets.only(
                  left: 40.h,
                  right: 40.h,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.showImagesFill(
                        widget.title == '心动转盘'
                            ? 'assets/images/zhuanpan_dj_bg.png'
                            : 'assets/images/zhuanpan_dj_bg2.png',
                        650.h,
                        650.h),
                    Container(
                      height: 550.h,
                      color: Colors.transparent,
                      padding: EdgeInsets.only(top: 200.h),
                      margin:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: OptionGridView(
                          itemCount: widget.list.length,
                          rowCount: 3,
                          mainAxisSpacing: 0.h,
                          // 上下间距
                          crossAxisSpacing: 0.h,
                          //左右间距
                          itemBuilder: jiangChiWidget,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150.h,
                      child: Container(
                          child: WidgetUtils.showImages(
                              'assets/images/zhuanpan_daoju_title.png',
                              50.h,
                              300.h)),
                    ),
                    Positioned(
                        top: 210.h,
                        child: Container(
                          child: WidgetUtils.onlyTextCenter(
                              '总价值：${widget.zonge}',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCYellow,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600)),
                        )),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(10.h, 0),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: WidgetUtils.showImagesFill(
                          'assets/images/zhuanpan_dj_colse.png', 65.h, 200.h)),
                  WidgetUtils.commonSizedBox(0, 50.h),
                  GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          Navigator.pop(context);
                          eventBus.fire(XZQuerenBack(
                              cishu: '',
                              feiyong: '',
                              title: widget.title == '心动转盘' ? '小转盘' : '大转盘'));
                        }
                      }),
                      child: WidgetUtils.showImagesFill(
                          'assets/images/zhuanpan_dj_again.png', 65.h, 200.h)),
                  const Spacer(),
                ],
              ),
            ],
          ),
          isShow ? Column(
            children: [
              Container(
                height: 500.h,
                color: Colors.black87,
              ),
              Container(
                height: 700.h,
                color: Colors.black87,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/game_title.png', 200.h, 500.h),
                    Transform.translate(
                        offset: Offset(0, -30.h),
                        child: WidgetUtils.showImagesNet(
                            widget.list[0].img!, 300.h, 300.h)),
                    WidgetUtils.showImagesFill(
                        'assets/images/game_zuo.png', 50.h, 350.h),
                    WidgetUtils.commonSizedBox(30.h, 0),
                    GestureDetector(
                        onTap: (() {
                          setState(() {
                            isShow = false;
                          });
                        }),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/game_btn.png', 65.h, 260.h)),
                  ],
                ),
              )
            ],
          ) : const Text('')
        ],
      ),
    );
  }
}
