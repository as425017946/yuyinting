import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';
import '../../utils/widget_utils.dart';
/// 送礼物选人用的页面
class RoomShowStatusPage extends StatefulWidget {
  const RoomShowStatusPage({super.key});

  @override
  State<RoomShowStatusPage> createState() => _RoomShowStatusPageState();
}

class _RoomShowStatusPageState extends State<RoomShowStatusPage> {
  bool m0 = false,
      m1 = false,
      m2 = false,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;
  var listen,listen2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<ResidentBack>().listen((event) {
      Navigator.pop(context);
    });
    listen2 = eventBus.on<ChoosePeopleBack>().listen((event) {
      setState(() {
        m1 = event.listPeople[0];
        m2 = event.listPeople[1];
        m3 = event.listPeople[2];
        m4 = event.listPeople[3];
        m5 = event.listPeople[4];
        m6 = event.listPeople[5];
        m7 = event.listPeople[6];
        m8 = event.listPeople[7];
        m0 = event.listPeople[8];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(81, 0),
          /// 公告 和 厅主
          Row(
            children: [
              const Expanded(child: Text('')),
              /// 厅主
              Transform.translate(
                offset: const Offset(0, -30),
                child: SizedBox(
                  width: ScreenUtil().setHeight(180),
                  height: ScreenUtil().setHeight(240),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      m0 ? Positioned(
                        top:52.h,
                        child: SizedBox(
                          height: 120.h,
                          width: 120.h,
                          child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                        ),
                      ) : const Text(''),
                    ],
                  ),
                ),
              ),
              const Expanded(child: Text('')),
            ],
          ),
          /// 麦序位
          Transform.translate(
            offset: Offset(0, -75.h),
            child: Column(
              children: [
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 10),
                     SizedBox(
                      width: ScreenUtil().setHeight(140),
                      height: ScreenUtil().setHeight(190),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m1 ? SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                          ) : const Text(''),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: ScreenUtil().setHeight(140),
                      height: ScreenUtil().setHeight(190),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m2 ? SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                          ) : const Text(''),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: ScreenUtil().setHeight(140),
                      height: ScreenUtil().setHeight(190),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m3 ? SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                          ) : const Text(''),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: ScreenUtil().setHeight(140),
                      height: ScreenUtil().setHeight(190),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m4 ? SizedBox(
                            height: 100.h,
                            width: 100.h,
                            child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                          ) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                  ],
                ),

                /// 第二排麦序
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(190),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m5 ? SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                            ) : const Text(''),
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(190),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m6 ? SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                            ) : const Text(''),
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(190),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m7 ? SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                            ) : const Text(''),
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                      SizedBox(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(190),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m8 ? SizedBox(
                              height: 100.h,
                              width: 100.h,
                              child: const SVGASimpleImage(assetsName: 'assets/svga/room_choose_people.svga',),
                            ) : const Text(''),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
