import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/pages/room/room_youxi_page.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:get/get.dart';
import '../../bean/roomInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/Marquee.dart';
import '../../widget/SVGASimpleImage2.dart';
import '../game/car_page.dart';
import '../game/mofang_page.dart';
import '../game/zhuanpan_page.dart';
import '../shouchong/shouchong_page.dart';
import 'play/room_play_page.dart';
import 'room_gongneng.dart';
import 'room_liwu_page.dart';
import 'room_manager_page.dart';
import 'room_messages_page.dart';
import 'room_people_info_page.dart';
import 'room_redu_page.dart';
import 'room_ts_gonggao_page.dart';

/// 厅内信息
class RoomItems {
  /// 互动消息
  static Widget itemMessages(BuildContext context, int i, String roomID,
      List<Map> list, List<MikeList> listm) {
    // 系统公告
    if (list[i]['type'] == '0') {
      return Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 5.h, bottom: 15.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.jianbian2,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(10.h)),
                //设置四周边框
                border: Border.all(width: 1.h, color: MyColors.jianbian2),
              ),
              child: Opacity(
                opacity: 0,
                child: Text(
                  '【系统公告】${list[i]['info']}',
                  maxLines: 50,
                  style: TextStyle(
                      color: MyColors.jianbian2,
                      height: 2,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.only(
                top: 5.h, bottom: 15.h, left: 10.h, right: 10.h),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.transparent,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(10.h)),
              //设置四周边框
              border: Border.all(width: 0.5.h, color: MyColors.jianbian2),
            ),
            child: Text(
              '【系统公告】${list[i]['info']}',
              maxLines: 50,
              style: TextStyle(
                  color: MyColors.jianbian2, height: 2, fontSize: 24.sp),
            ),
          )
        ],
      );
    } else if (list[i]['type'] == '1') {
      // 房间公告
      return Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 5.h, bottom: 15.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.peopleYellow,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(10.h)),
                //设置四周边框
                border: Border.all(width: 1.h, color: MyColors.peopleYellow),
              ),
              child: Opacity(
                opacity: 0,
                child: Text(
                  '【房间公告】${list[i]['info']}',
                  maxLines: 50,
                  style: TextStyle(
                      color: MyColors.peopleYellow,
                      height: 2,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.only(
                top: 5.h, bottom: 15.h, left: 10.h, right: 10.h),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.transparent,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(10.h)),
              //设置四周边框
              border: Border.all(width: 0.5.h, color: MyColors.peopleYellow),
            ),
            child: Text(
              '【房间公告】${list[i]['info']}',
              maxLines: 50,
              style: TextStyle(
                  color: MyColors.peopleYellow, height: 2, fontSize: 24.sp),
            ),
          )
        ],
      );
    } else if (list[i]['type'] == '2') {
      String ZJName = '';
      if (list[i]['mount_name']
          .toString()
          .isNotEmpty &&
          list[i]['mount_name'].toString() != null) {
        ZJName = '驾着${list[i]['mount_name'].toString()}';
      } else {
        ZJName = '';
      }
      // 用户进入房间
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick() &&
              list[i]['uid'].toString() != sp.getString('user_id').toString()) {
            MyUtils.goTransparentPage(
                context,
                RoomPeopleInfoPage(
                  uid: list[i]['uid'].toString(),
                  index: '-1',
                  roomID: roomID,
                  isClose: '',
                  listM: listm,
                ));
          }
        }),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 5.h, bottom: 15.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white10,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: RichText(
                text: TextSpan(children: [
                  // 厅主或管理或主播
                  WidgetSpan(
                      child: (list[i]['identity'] == 'user' ||
                          list[i]['identity'] == 'streamer')
                          ? const Text('')
                          : list[i]['identity'] == 'leader'
                          ? WidgetUtils.showImages(
                          'assets/images/dj/room_role_director.png',
                          30.h,
                          30.h)
                          : list[i]['identity'] == 'president'
                          ? WidgetUtils.showImages(
                          'assets/images/dj/room_role_huizhang.png',
                          30.h,
                          30.h)
                          : WidgetUtils.showImages(
                          'assets/images/dj/room_role_manager.png',
                          30.h,
                          30.h)),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  // 萌新/新贵/新锐 三选一
                  // 不是新锐新贵，并且是萌新直接显示萌新
                  WidgetSpan(
                      child: list[i]['new_noble'].toString() == '0' &&
                          list[i]['is_new'].toString() == '1'
                          ? WidgetUtils.showImagesFill(
                          'assets/images/dj/room_role_common.png',
                          30.h,
                          60.h)
                          : const Text('')),
                  // 不管是不是萌新，只要是新锐或者新贵就优先展示
                  WidgetSpan(
                      child: list[i]['new_noble'].toString() == "1"
                          ? WidgetUtils.showImagesFill(
                          'assets/images/dj/room_rui.png', 26.h, 60.h)
                          : list[i]['new_noble'].toString() == "2"
                          ? WidgetUtils.showImagesFill(
                          'assets/images/dj/room_gui.png', 26.h, 60.h)
                          : list[i]['new_noble'].toString() == "3"
                          ? WidgetUtils.showImagesFill(
                          'assets/images/dj/room_qc.png',
                          30.h,
                          60.h)
                          : const Text('')),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  //等级
                  WidgetSpan(
                    child: SizedBox(
                      height: 28.h,
                      width: 28.h,
                      child: Stack(
                        children: [
                          int.parse(list[i]['lv'].toString()) >= 1 &&
                              int.parse(list[i]['lv'].toString()) <= 10
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_1-10.png', 28.h, 28.h)
                              : int.parse(list[i]['lv'].toString()) >= 11 &&
                              int.parse(list[i]['lv'].toString()) <= 15
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_11-15.png',
                              28.h,
                              28.h)
                              : int.parse(list[i]['lv'].toString()) >= 16 &&
                              int.parse(list[i]['lv'].toString()) <=
                                  20
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_16-20.png',
                              28.h,
                              28.h)
                              : int.parse(list[i]['lv'].toString()) >= 21 &&
                              int.parse(list[i]['lv'].toString()) <=
                                  25
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_21-25.png',
                              28.h,
                              28.h)
                              : int.parse(list[i]['lv'].toString()) >= 26 &&
                              int.parse(list[i]['lv'].toString()) <=
                                  30
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_26-30.png',
                              28.h,
                              28.h)
                              : int.parse(list[i]['lv'].toString()) >= 31 &&
                              int.parse(list[i]['lv'].toString()) <= 35
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_31-35.png', 28.h, 28.h)
                              : int.parse(list[i]['lv'].toString()) >= 36 &&
                              int.parse(list[i]['lv'].toString()) <= 40
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_36-40.png', 28.h, 28.h)
                              : int.parse(list[i]['lv'].toString()) >= 41 &&
                              int.parse(list[i]['lv'].toString()) <= 45
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_41-45.png', 28.h, 28.h)
                              : WidgetUtils.showImages(
                              'assets/images/dj/dj_46-50.png', 28.h, 28.h),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                Text(
                                  int.parse(list[i]['lv'].toString())
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'LR',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = MyColors.djTwoM),
                                ),
                                Text(
                                  int.parse(list[i]['lv'].toString())
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.djOne,
                                      fontSize: 18.sp,
                                      fontFamily: 'LR'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  //财富等级
                  WidgetSpan(
                    child: SizedBox(
                      height: 38.h,
                      width: 38.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          int.parse(list[i]['newLv'].toString()) >= 1 &&
                              int.parse(list[i]['newLv'].toString()) <= 9
                              ? WidgetUtils.showImages(
                              'assets/images/room_icon_1.png', 28.h, 28.h)
                              : int.parse(list[i]['newLv'].toString()) >= 10 &&
                              int.parse(list[i]['newLv'].toString()) <= 15
                              ? Transform.translate(
                            offset: Offset(0, 0.h),
                            child: WidgetUtils.showImages(
                                'assets/images/room_icon_2.png',
                                28.h,
                                28.h),
                          )
                              : int.parse(list[i]['newLv'].toString()) >= 16 &&
                              int.parse(list[i]['newLv'].toString()) <=
                                  23
                              ? Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_3.png',
                                38.h,
                                38.h),
                          )
                              : int.parse(list[i]['newLv'].toString()) >= 24 &&
                              int.parse(list[i]['newLv'].toString()) <=
                                  31
                              ? Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_4.png',
                                38.h,
                                38.h),
                          )
                              : int.parse(list[i]['newLv'].toString()) >= 32 &&
                              int.parse(list[i]['newLv'].toString()) <=
                                  36
                              ? Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_5.png',
                                38.h,
                                38.h),
                          )
                              : int.parse(list[i]['newLv'].toString()) >= 37 &&
                              int.parse(list[i]['newLv'].toString()) <= 40
                              ? Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_6.png',
                                38.h,
                                38.h),
                          )
                              : int.parse(list[i]['newLv'].toString()) >= 41 &&
                              int.parse(list[i]['newLv'].toString()) <= 46
                              ? Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_7.png',
                                38.h,
                                38.h),
                          )
                              : Transform.translate(
                            offset: Offset(0, 5.h),
                            child: WidgetUtils.showImagesFill(
                                'assets/images/room_icon_8.png',
                                35.h,
                                35.h),
                          ),
                          Positioned(
                            bottom: 0,
                            right: (int.parse(list[i]['newLv'].toString()) >=
                                1 &&
                                int.parse(list[i]['newLv'].toString()) < 10) ? 5
                                .w : 0,
                            child: Stack(
                              children: [
                                Text(
                                  int.parse(list[i]['newLv'].toString())
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'LR',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = MyColors.djTwoM),
                                ),
                                Text(
                                  int.parse(list[i]['newLv'].toString())
                                      .toString(),
                                  style: TextStyle(
                                      color: MyColors.djOne,
                                      fontSize: 18.sp,
                                      fontFamily: 'LR'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  //贵族
                  WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0, 5.h),
                        child: list[i]['noble_id'].toString() == "1"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_xuanxian.png', 38.h,
                            38.h)
                            : list[i]['noble_id'].toString() == "2"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_shangxian.png', 38.h, 38
                            .h)
                            : list[i]['noble_id'].toString() == "3"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_jinxian.png',
                            38.h,
                            38.h)
                            : list[i]['noble_id'].toString() == "4"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_xiandi.png',
                            38.h,
                            38.h)
                            : list[i]['noble_id'].toString() == "5"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_zhushen.png',
                            38.h,
                            38.h)
                            : list[i]['noble_id'].toString() == "6"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_tianshen.png',
                            38.h,
                            38.h)
                            : list[i]['noble_id'].toString() ==
                            "7"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_shenwang.png',
                            38.h,
                            38.h)
                            : list[i]['noble_id'].toString() ==
                            "8"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_shenhuang.png',
                            38.h,
                            38.h) : list[i]['noble_id'].toString() ==
                            "9"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_tianzun.png',
                            38.h,
                            38.h) : list[i]['noble_id'].toString() ==
                            "10"
                            ? WidgetUtils.showImages(
                            'assets/images/tequan_icon_chuanshuo.png',
                            38.h,
                            38.h) : const Text(''),
                      )),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  // 靓号
                  WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0, 1.h),
                        child: list[i]['is_pretty'].toString() == '0'
                            ? const Text('')
                            : WidgetUtils.showImages(
                            'assets/images/dj/lianghao.png', 30.h, 30.h),
                      )),
                  //用户昵称
                  WidgetSpan(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.commonSizedBox(28.h, 10.h),
                          Text(' ${list[i]['info'].toString()} $ZJName',
                              style: TextStyle(
                                color: MyColors.roomMessageYellow2,
                                fontSize: 24.sp,
                                height: 2,
                              ))
                        ],
                      )),
                  // 进入房间
                  WidgetSpan(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.commonSizedBox(28.h, 10.h),
                          Text('进入房间',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                height: 2,
                              ))
                        ],
                      )),
                  WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                  WidgetSpan(
                      child: sp.getString('role').toString() != 'user' &&
                          list[i]['isWelcome'] == '0'
                          ? GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            eventBus.fire(RoomBack(
                                title: '欢迎',
                                index: '${list[i]['uid']},$i'));
                          }
                        }),
                        child: Transform.translate(
                          offset: Offset(0, 5.h),
                          child: Container(
                            width: ScreenUtil().setHeight(65),
                            height: ScreenUtil().setHeight(30),
                            margin:
                            EdgeInsets.only(top: 5.h, bottom: 5.h),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.showImagesFill(
                                    'assets/images/room_huanyingta.png',
                                    double.infinity,
                                    double.infinity),
                                Container(
                                  width: ScreenUtil().setHeight(65),
                                  height: ScreenUtil().setHeight(30),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '欢迎',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(20)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                          : const Text(''))
                ]),
              ),
            ),
          ],
        ),
      );
    } else if (list[i]['type'] == '3') {
      // 点击了欢迎某某人
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              // 厅主或管理或主播
              WidgetSpan(
                  child: (list[i]['identity'] == 'user' ||
                      list[i]['identity'] == 'streamer')
                      ? const Text('')
                      : list[i]['identity'] == 'leader'
                      ? WidgetUtils.showImages(
                      'assets/images/dj/room_role_director.png',
                      30.h,
                      30.h)
                      : list[i]['identity'] == 'president'
                      ? WidgetUtils.showImages(
                      'assets/images/dj/room_role_huizhang.png',
                      30.h,
                      30.h)
                      : WidgetUtils.showImages(
                      'assets/images/dj/room_role_manager.png',
                      30.h,
                      30.h)),
              WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
              // 萌新/新贵/新锐 三选一
              // 不是新锐新贵，并且是萌新直接显示萌新
              WidgetSpan(
                  child: list[i]['new_noble'].toString() == '0' &&
                      list[i]['is_new'].toString() == '1'
                      ? WidgetUtils.showImagesFill(
                      'assets/images/dj/room_role_common.png',
                      30.h,
                      60.h)
                      : const Text('')),
              // 不管是不是萌新，只要是新锐或者新贵就优先展示
              WidgetSpan(
                  child: list[i]['new_noble'].toString() == "1"
                      ? WidgetUtils.showImagesFill(
                      'assets/images/dj/room_rui.png', 26.h, 50.h)
                      : list[i]['new_noble'].toString() == "2"
                      ? WidgetUtils.showImagesFill(
                      'assets/images/dj/room_gui.png', 26.h, 50.h)
                      : list[i]['new_noble'].toString() == "3"
                      ? WidgetUtils.showImagesFill(
                      'assets/images/dj/room_qc.png',
                      30.h,
                      50.h)
                      : const Text('')),
              WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
              //等级
              WidgetSpan(
                child: SizedBox(
                  height: 28.h,
                  width: 28.h,
                  child: Stack(
                    children: [
                      int.parse(list[i]['lv'].toString()) >= 1 &&
                          int.parse(list[i]['lv'].toString()) <= 10
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_1-10.png', 28.h, 28.h)
                          : int.parse(list[i]['lv'].toString()) >= 11 &&
                          int.parse(list[i]['lv'].toString()) <= 15
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_11-15.png',
                          28.h,
                          28.h)
                          : int.parse(list[i]['lv'].toString()) >= 16 &&
                          int.parse(list[i]['lv'].toString()) <=
                              20
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_16-20.png',
                          28.h,
                          28.h)
                          : int.parse(list[i]['lv'].toString()) >= 21 &&
                          int.parse(list[i]['lv'].toString()) <=
                              25
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_21-25.png',
                          28.h,
                          28.h)
                          : int.parse(list[i]['lv'].toString()) >= 26 &&
                          int.parse(list[i]['lv'].toString()) <=
                              30
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_26-30.png',
                          28.h,
                          28.h)
                          : int.parse(list[i]['lv'].toString()) >= 31 &&
                          int.parse(list[i]['lv'].toString()) <= 35
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_31-35.png', 28.h, 28.h)
                          : int.parse(list[i]['lv'].toString()) >= 36 &&
                          int.parse(list[i]['lv'].toString()) <= 40
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_36-40.png', 28.h, 28.h)
                          : int.parse(list[i]['lv'].toString()) >= 41 &&
                          int.parse(list[i]['lv'].toString()) <= 45
                          ? WidgetUtils.showImages(
                          'assets/images/dj/dj_41-45.png', 28.h, 28.h)
                          : WidgetUtils.showImages(
                          'assets/images/dj/dj_46-50.png', 28.h, 28.h),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Stack(
                          children: [
                            Text(
                              int.parse(list[i]['lv'].toString())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'LR',
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = MyColors.djTwoM),
                            ),
                            Text(
                              int.parse(list[i]['lv'].toString())
                                  .toString(),
                              style: TextStyle(
                                  color: MyColors.djOne,
                                  fontSize: 18.sp,
                                  fontFamily: 'LR'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
              //财富等级
              WidgetSpan(
                child: SizedBox(
                  height: 38.h,
                  width: 38.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      int.parse(list[i]['newLv'].toString()) >= 1 &&
                          int.parse(list[i]['newLv'].toString()) <= 9
                          ? WidgetUtils.showImages(
                          'assets/images/room_icon_1.png', 28.h, 28.h)
                          : int.parse(list[i]['newLv'].toString()) >= 10 &&
                          int.parse(list[i]['newLv'].toString()) <= 15
                          ? Transform.translate(
                        offset: Offset(0, 0.h),
                        child: WidgetUtils.showImages(
                            'assets/images/room_icon_2.png',
                            28.h,
                            28.h),
                      )
                          : int.parse(list[i]['newLv'].toString()) >= 16 &&
                          int.parse(list[i]['newLv'].toString()) <=
                              23
                          ? Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_3.png',
                            38.h,
                            38.h),
                      )
                          : int.parse(list[i]['newLv'].toString()) >= 24 &&
                          int.parse(list[i]['newLv'].toString()) <=
                              31
                          ? Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_4.png',
                            38.h,
                            38.h),
                      )
                          : int.parse(list[i]['newLv'].toString()) >= 32 &&
                          int.parse(list[i]['newLv'].toString()) <=
                              36
                          ? Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_5.png',
                            38.h,
                            38.h),
                      )
                          : int.parse(list[i]['newLv'].toString()) >= 37 &&
                          int.parse(list[i]['newLv'].toString()) <= 40
                          ? Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_6.png',
                            38.h,
                            38.h),
                      )
                          : int.parse(list[i]['newLv'].toString()) >= 41 &&
                          int.parse(list[i]['newLv'].toString()) <= 46
                          ? Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_7.png',
                            38.h,
                            38.h),
                      )
                          : Transform.translate(
                        offset: Offset(0, 5.h),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/room_icon_8.png',
                            35.h,
                            35.h),
                      ),
                      Positioned(
                        bottom: 0,
                        right: (int.parse(list[i]['newLv'].toString()) >= 1 &&
                            int.parse(list[i]['newLv'].toString()) < 10)
                            ? 5.w
                            : 0,
                        child: Stack(
                          children: [
                            Text(
                              int.parse(list[i]['newLv'].toString())
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'LR',
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2
                                    ..color = MyColors.djTwoM),
                            ),
                            Text(
                              int.parse(list[i]['newLv'].toString())
                                  .toString(),
                              style: TextStyle(
                                  color: MyColors.djOne,
                                  fontSize: 18.sp,
                                  fontFamily: 'LR'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
              //贵族
              WidgetSpan(
                  child: Transform.translate(
                    offset: Offset(0, 5.h),
                    child: list[i]['noble_id'].toString() == "1"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_xuanxian.png', 38.h,
                        38.h)
                        : list[i]['noble_id'].toString() == "2"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_shangxian.png', 38.h, 38
                        .h)
                        : list[i]['noble_id'].toString() == "3"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_jinxian.png',
                        38.h,
                        38.h)
                        : list[i]['noble_id'].toString() == "4"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_xiandi.png',
                        38.h,
                        38.h)
                        : list[i]['noble_id'].toString() == "5"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_zhushen.png',
                        38.h,
                        38.h)
                        : list[i]['noble_id'].toString() == "6"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_tianshen.png',
                        38.h,
                        38.h)
                        : list[i]['noble_id'].toString() ==
                        "7"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_shenwang.png',
                        38.h,
                        38.h)
                        : list[i]['noble_id'].toString() ==
                        "8"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_shenhuang.png',
                        38.h,
                        38.h) : list[i]['noble_id'].toString() ==
                        "9"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_tianzun.png',
                        38.h,
                        38.h) : list[i]['noble_id'].toString() ==
                        "10"
                        ? WidgetUtils.showImages(
                        'assets/images/tequan_icon_chuanshuo.png',
                        38.h,
                        38.h) : const Text(''),
                  )),
              WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
              // 靓号
              WidgetSpan(
                  child: Transform.translate(
                    offset: Offset(0, 1.h),
                    child: list[i]['is_pretty'].toString() == '0'
                        ? const Text('')
                        : WidgetUtils.showImages(
                        'assets/images/dj/lianghao.png', 30.h, 30.h),
                  )),
              //用户昵称
              WidgetSpan(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.commonSizedBox(28.h, 10.h),
                      Text(' ${list[i]['info']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            height: 2,
                          ))
                    ],
                  )),
            ]),
          ),
          WidgetUtils.commonSizedBox(5.h, 0),
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick() &&
                  list[i]['uid'].toString() !=
                      sp.getString('user_id').toString()) {
                MyUtils.goTransparentPage(
                    context,
                    RoomPeopleInfoPage(
                      uid: list[i]['uid'].toString(),
                      index: '-1',
                      roomID: roomID,
                      isClose: '',
                      listM: listm,
                    ));
              }
            }),
            child: list[i]['bubble_img']
                .toString()
                .isNotEmpty ?
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              // constraints: BoxConstraints(maxWidth: double.infinity - 130.w),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    centerSlice:  const Rect.fromLTWH(18, 17, 1, 1),
                    // image: AssetImage('assets/images/cj/chat_text.png'),
                    image: CachedNetworkImageProvider(
                        list[i]['bubble_img']),
                    scale: 2,
                  )
              ),
              child: RichText(
                text: TextSpan(
                    text: '@',
                    style: StyleUtils.getCommonTextStyle(
                        color: Colors.white, fontSize: 24.sp),
                    children: [
                      TextSpan(
                          text: list[i]['content'].toString().split(',')[0],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.roomMessageYellow2,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: list[i]['content'].toString().split(',')[1],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
            ) : Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white10,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: RichText(
                text: TextSpan(
                    text: '@',
                    style: StyleUtils.getCommonTextStyle(
                        color: Colors.white, fontSize: 24.sp),
                    children: [
                      TextSpan(
                          text: list[i]['content'].toString().split(',')[0],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.roomMessageYellow2,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: list[i]['content'].toString().split(',')[1],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
            ),
          ),
        ],
      );
    } else if (list[i]['type'] == '5') {
      // 直刷和背包单个礼物赠送使用
      List<String> infos = list[i]['content'].toString().split(';');
      List<String> listName = infos[3].toString().split(',');
      String name = '';
      for (int i = 0; i < listName.length; i++) {
        if (name.isEmpty) {
          name = listName[i];
        } else {
          name = '$name,${listName[i]}';
        }
      }
      // 厅内送出礼物推送
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick() &&
                  list[i]['uid'].toString() !=
                      sp.getString('user_id').toString()) {
                MyUtils.goTransparentPage(
                    context,
                    RoomPeopleInfoPage(
                      uid: list[i]['uid'].toString(),
                      index: '-1',
                      roomID: roomID,
                      isClose: '',
                      listM: listm,
                    ));
              }
            }),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.black26,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: RichText(
                text: TextSpan(
                    text: infos[0],
                    style: StyleUtils.getCommonTextStyle(
                      color: MyColors.jianbian2,
                      fontSize: 24.sp,
                    ),
                    children: [
                      TextSpan(
                          text: infos[1],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[2],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[3],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[4],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.jianbian2,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
            ),
          ),
        ],
      );
    } else if (list[i]['type'] == '6') {
      // 背包礼物一键赠送使用
      List<String> infos = list[i]['content'].toString().split(';');
      // 厅内送出礼物推送
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick() &&
                  list[i]['uid'].toString() !=
                      sp.getString('user_id').toString()) {
                MyUtils.goTransparentPage(
                    context,
                    RoomPeopleInfoPage(
                      uid: list[i]['uid'].toString(),
                      index: '-1',
                      roomID: roomID,
                      isClose: '',
                      listM: listm,
                    ));
              }
            }),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.black26,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: RichText(
                text: TextSpan(
                    text: infos[0],
                    style: StyleUtils.getCommonTextStyle(
                      color: MyColors.jianbian2,
                      fontSize: 24.sp,
                    ),
                    children: [
                      TextSpan(
                          text: infos[1],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[2],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.jianbian2,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[3],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[4],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.jianbian2,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
            ),
          ),
        ],
      );
    } else if (list[i]['type'] == '7') {
      // 收藏房间
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick() &&
              list[i]['uid'].toString() != sp.getString('user_id').toString()) {
            MyUtils.goTransparentPage(
                context,
                RoomPeopleInfoPage(
                  uid: list[i]['uid'].toString(),
                  index: '-1',
                  roomID: roomID,
                  isClose: '',
                  listM: listm,
                ));
          }
        }),
        child: Text(list[i]['content'],
            style: StyleUtils.getCommonTextStyle(
                color: MyColors.jianbian2, fontSize: 24.sp)),
      );
    } else if (list[i]['type'] == '8') {
      // 跟随主播进入房间
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick() &&
              list[i]['uid'].toString() != sp.getString('user_id').toString()) {
            MyUtils.goTransparentPage(
                context,
                RoomPeopleInfoPage(
                  uid: list[i]['uid'].toString(),
                  index: '-1',
                  roomID: roomID,
                  isClose: '',
                  listM: listm,
                ));
          }
        }),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 15.h, bottom: 15.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white10,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: RichText(
                text: TextSpan(
                    text: list[i]['info'],
                    style: StyleUtils.getCommonTextStyle(
                      color: MyColors.peopleYellow,
                      fontSize: 24.sp,
                    ),
                    children: [
                      TextSpan(
                          text: '跟随',
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: list[i]['content'],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: '进入房间',
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
            ),
          ],
        ),
      );
    } else if (list[i]['type'] == '9') {
      // 厅内用户抽奖
      List<String> infos = list[i]['content'].toString().split(';');
      // LogE('游戏=== ${infos.length}');
      int startIndex = infos[4].indexOf('(') + 1;
      int endIndex = infos[4].indexOf(')');
      String jine = '';
      if(list[i]['content'].toString().contains('赛车')){
        jine = infos[4];
      }else{
        jine = infos[4].substring(startIndex, endIndex);
      }
      // 厅内送出礼物推送
      return Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 5.h, bottom: 10.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.blue,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: Opacity(
                opacity: 0,
                child: RichText(
                  text: TextSpan(
                      text: infos[0],
                      style: StyleUtils.getCommonTextStyle(
                        color: MyColors.roomMessageYellow2,
                        fontSize: 24.sp,
                      ),
                      children: [
                        TextSpan(
                            text: infos[1],
                            style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                            )),
                        TextSpan(
                            text: infos[2],
                            style: StyleUtils.getCommonTextStyle(
                              color: MyColors.loginPink,
                              fontSize: 24.sp,
                            )),
                        TextSpan(
                            text: infos[3],
                            style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                            )),
                        TextSpan(
                            text: infos[4],
                            style: StyleUtils.getCommonTextStyle(
                              color: MyColors.loginPink,
                              fontSize: 24.sp,
                            )),
                      ]),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick() &&
                  list[i]['uid'].toString() !=
                      sp.getString('user_id').toString()) {
                MyUtils.goTransparentPage(
                    context,
                    RoomPeopleInfoPage(
                      uid: list[i]['uid'].toString(),
                      index: '-1',
                      roomID: roomID,
                      isClose: '',
                      listM: listm,
                    ));
              }
            }),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 5.h, bottom: 10.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.transparent,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: RichText(
                text: TextSpan(
                    text: infos[0],
                    style: StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMessageYellow2,
                      fontSize: 24.sp,
                    ),
                    children: [
                      TextSpan(
                          text: infos[1],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[2],
                          style: StyleUtils.getCommonTextStyle(
                            color: MyColors.roomMessageYellow2,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[3],
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                          )),
                      TextSpan(
                          text: infos[4],
                          style: StyleUtils.getCommonTextStyle(
                            color: (int.parse(jine) >= 10 &&
                                int.parse(jine) < 5001)
                                ? MyColors.zjZ1
                                : (int.parse(jine) >= 5001 &&
                                int.parse(jine) < 30001)
                                ? MyColors.zjZ2
                                : (int.parse(jine) >= 30001 &&
                                int.parse(jine) < 50001)
                                ? MyColors.zjZ3
                                : MyColors.zjZ4,
                            fontSize: 24.sp,
                          )),
                    ]),
              ),
              // child: Wrap(
              //   children: [
              //     Text(infos[0], style: StyleUtils.getCommonTextStyle(
              //       color: MyColors.roomMessageYellow2, fontSize: 24.sp,)),
              //     Text(infos[1], style: StyleUtils.getCommonTextStyle(
              //         color: Colors.white, fontSize: 24.sp)),
              //     Text(infos[2], style: StyleUtils.getCommonTextStyle(
              //         color: MyColors.loginPink, fontSize: 24.sp)),
              //     Text(infos[3], style: StyleUtils.getCommonTextStyle(
              //         color: Colors.white, fontSize: 24.sp)),
              //     Text(infos[4], maxLines: 20, style: StyleUtils.getCommonTextStyle(
              //         color: MyColors.loginPink, fontSize: 24.sp)),
              //   ],
              // ),
            ),
          )
        ],
      );
    } else {
      // 厅内正常发送消息
      return GestureDetector(
        onTap: (() {
          if (MyUtils.checkClick() &&
              list[i]['uid'].toString() != sp.getString('user_id').toString()) {
            MyUtils.goTransparentPage(
                context,
                RoomPeopleInfoPage(
                  uid: list[i]['uid'].toString(),
                  index: '-1',
                  roomID: roomID,
                  isClose: '',
                  listM: listm,
                ));
          }
        }),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(children: [
                    // 厅主或管理或主播
                    WidgetSpan(
                        child: (list[i]['identity'] == 'user' ||
                            list[i]['identity'] == 'streamer')
                            ? const Text('')
                            : list[i]['identity'] == 'leader'
                            ? WidgetUtils.showImages(
                            'assets/images/dj/room_role_director.png',
                            30.h,
                            30.h)
                            : list[i]['identity'] == 'president'
                            ? WidgetUtils.showImages(
                            'assets/images/dj/room_role_huizhang.png',
                            30.h,
                            30.h)
                            : WidgetUtils.showImages(
                            'assets/images/dj/room_role_manager.png',
                            30.h,
                            30.h)),
                    WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                    // 萌新/新贵/新锐 三选一
                    // 不是新锐新贵，并且是萌新直接显示萌新
                    WidgetSpan(
                        child: list[i]['new_noble'].toString() == '0' &&
                            list[i]['is_new'].toString() == '1'
                            ? WidgetUtils.showImagesFill(
                            'assets/images/dj/room_role_common.png',
                            30.h,
                            60.h)
                            : const Text('')),
                    // 不管是不是萌新，只要是新锐或者新贵就优先展示
                    WidgetSpan(
                        child: list[i]['new_noble'].toString() == "1"
                            ? WidgetUtils.showImagesFill(
                            'assets/images/dj/room_rui.png', 26.h, 60.h)
                            : list[i]['new_noble'].toString() == "2"
                            ? WidgetUtils.showImagesFill(
                            'assets/images/dj/room_gui.png', 26.h, 60.h)
                            : list[i]['new_noble'].toString() == "3"
                            ? WidgetUtils.showImagesFill(
                            'assets/images/dj/room_qc.png',
                            30.h,
                            60.h)
                            : const Text('')),
                    WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                    //等级
                    WidgetSpan(
                      child: SizedBox(
                        height: 28.h,
                        width: 28.h,
                        child: Stack(
                          children: [
                            int.parse(list[i]['lv'].toString()) >= 1 &&
                                int.parse(list[i]['lv'].toString()) <= 10
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_1-10.png', 28.h, 28.h)
                                : int.parse(list[i]['lv'].toString()) >= 11 &&
                                int.parse(list[i]['lv'].toString()) <= 15
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_11-15.png',
                                28.h,
                                28.h)
                                : int.parse(list[i]['lv'].toString()) >= 16 &&
                                int.parse(list[i]['lv'].toString()) <=
                                    20
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_16-20.png',
                                28.h,
                                28.h)
                                : int.parse(list[i]['lv'].toString()) >= 21 &&
                                int.parse(list[i]['lv'].toString()) <=
                                    25
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_21-25.png',
                                28.h,
                                28.h)
                                : int.parse(list[i]['lv'].toString()) >= 26 &&
                                int.parse(list[i]['lv'].toString()) <=
                                    30
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_26-30.png',
                                28.h,
                                28.h)
                                : int.parse(list[i]['lv'].toString()) >= 31 &&
                                int.parse(list[i]['lv'].toString()) <= 35
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_31-35.png', 28.h, 28.h)
                                : int.parse(list[i]['lv'].toString()) >= 36 &&
                                int.parse(list[i]['lv'].toString()) <= 40
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_36-40.png', 28.h, 28.h)
                                : int.parse(list[i]['lv'].toString()) >= 41 &&
                                int.parse(list[i]['lv'].toString()) <= 45
                                ? WidgetUtils.showImages(
                                'assets/images/dj/dj_41-45.png', 28.h, 28.h)
                                : WidgetUtils.showImages(
                                'assets/images/dj/dj_46-50.png', 28.h, 28.h),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Stack(
                                children: [
                                  Text(
                                    int.parse(list[i]['lv'].toString())
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: 'LR',
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2
                                          ..color = MyColors.djTwoM),
                                  ),
                                  Text(
                                    int.parse(list[i]['lv'].toString())
                                        .toString(),
                                    style: TextStyle(
                                        color: MyColors.djOne,
                                        fontSize: 18.sp,
                                        fontFamily: 'LR'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                    //财富等级
                    WidgetSpan(
                      child: SizedBox(
                        height: 38.h,
                        width: 38.h,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            int.parse(list[i]['newLv'].toString()) >= 1 &&
                                int.parse(list[i]['newLv'].toString()) <= 9
                                ? WidgetUtils.showImages(
                                'assets/images/room_icon_1.png', 28.h, 28.h)
                                : int.parse(list[i]['newLv'].toString()) >=
                                10 &&
                                int.parse(list[i]['newLv'].toString()) <= 15
                                ? Transform.translate(
                              offset: Offset(0, 0.h),
                              child: WidgetUtils.showImages(
                                  'assets/images/room_icon_2.png',
                                  28.h,
                                  28.h),
                            )
                                : int.parse(list[i]['newLv'].toString()) >=
                                16 &&
                                int.parse(list[i]['newLv'].toString()) <=
                                    23
                                ? Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_3.png',
                                  38.h,
                                  38.h),
                            )
                                : int.parse(list[i]['newLv'].toString()) >=
                                24 &&
                                int.parse(list[i]['newLv'].toString()) <=
                                    31
                                ? Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_4.png',
                                  38.h,
                                  38.h),
                            )
                                : int.parse(list[i]['newLv'].toString()) >=
                                32 &&
                                int.parse(list[i]['newLv'].toString()) <=
                                    36
                                ? Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_5.png',
                                  38.h,
                                  38.h),
                            )
                                : int.parse(list[i]['newLv'].toString()) >=
                                37 &&
                                int.parse(list[i]['newLv'].toString()) <= 40
                                ? Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_6.png',
                                  38.h,
                                  38.h),
                            )
                                : int.parse(list[i]['newLv'].toString()) >=
                                41 &&
                                int.parse(list[i]['newLv'].toString()) <= 46
                                ? Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_7.png',
                                  38.h,
                                  38.h),
                            )
                                : Transform.translate(
                              offset: Offset(0, 5.h),
                              child: WidgetUtils.showImagesFill(
                                  'assets/images/room_icon_8.png',
                                  35.h,
                                  35.h),
                            ),
                            Positioned(
                              bottom: 0,
                              right: (int.parse(list[i]['newLv'].toString()) >=
                                  1 &&
                                  int.parse(list[i]['newLv'].toString()) < 10)
                                  ? 5.w
                                  : 0,
                              child: Stack(
                                children: [
                                  Text(
                                    int.parse(list[i]['newLv'].toString())
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontFamily: 'LR',
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2
                                          ..color = MyColors.djTwoM),
                                  ),
                                  Text(
                                    int.parse(list[i]['newLv'].toString())
                                        .toString(),
                                    style: TextStyle(
                                        color: MyColors.djOne,
                                        fontSize: 18.sp,
                                        fontFamily: 'LR'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                    //贵族
                    WidgetSpan(
                        child: Transform.translate(
                          offset: Offset(0, 5.h),
                          child: list[i]['noble_id'].toString() == "1"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_xuanxian.png', 38.h,
                              38.h)
                              : list[i]['noble_id'].toString() == "2"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_shangxian.png', 38.h,
                              38
                                  .h)
                              : list[i]['noble_id'].toString() == "3"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_jinxian.png',
                              38.h,
                              38.h)
                              : list[i]['noble_id'].toString() == "4"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_xiandi.png',
                              38.h,
                              38.h)
                              : list[i]['noble_id'].toString() == "5"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_zhushen.png',
                              38.h,
                              38.h)
                              : list[i]['noble_id'].toString() == "6"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_tianshen.png',
                              38.h,
                              38.h)
                              : list[i]['noble_id'].toString() ==
                              "7"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_shenwang.png',
                              38.h,
                              38.h)
                              : list[i]['noble_id'].toString() ==
                              "8"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_shenhuang.png',
                              38.h,
                              38.h) : list[i]['noble_id'].toString() ==
                              "9"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_tianzun.png',
                              38.h,
                              38.h) : list[i]['noble_id'].toString() ==
                              "10"
                              ? WidgetUtils.showImages(
                              'assets/images/tequan_icon_chuanshuo.png',
                              38.h,
                              38.h) : const Text(''),
                        )),
                    WidgetSpan(child: WidgetUtils.commonSizedBox(0, 4.h)),
                    // 靓号
                    WidgetSpan(
                        child: Transform.translate(
                          offset: Offset(0, 1.h),
                          child: list[i]['is_pretty'].toString() == '0'
                              ? const Text('')
                              : WidgetUtils.showImages(
                              'assets/images/dj/lianghao.png', 30.h, 30.h),
                        )),
                    //用户昵称
                    WidgetSpan(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            WidgetUtils.commonSizedBox(28.h, 10.h),
                            Text(' ${list[i]['info']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  height: 2,
                                ))
                          ],
                        )),
                  ]),
                )
              ],
            ),
            WidgetUtils.commonSizedBox(5, 0),

            /// 如果有顿号说明是发的3个svga
            list[i]['image'].toString().contains('、')
                ? Stack(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: 100.h,
                      child: list[i]['isOk'] == 'true'
                          ? WidgetUtils.showImages(
                          list[i]['image']
                              .toString()
                              .split(',')[1]
                              .split('、')[0],
                          double.infinity,
                          double.infinity)
                          : SVGASimpleImage2(
                          assetsName: list[i]['image']
                              .toString()
                              .split(',')[0]
                              .split('、')[0],
                          isOk: list[i]['isOk'],
                          index: i),
                    ),
                    Transform.translate(
                      offset: Offset(-20.h, 0.h),
                      child: SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: list[i]['isOk'] == 'true'
                            ? Transform.translate(
                          offset: Offset(2.h, 0.h),
                          child: WidgetUtils.showImages(
                              list[i]['image']
                                  .toString()
                                  .split(',')[1]
                                  .split('、')[1],
                              double.infinity,
                              double.infinity),
                        )
                            : SVGASimpleImage2(
                            assetsName: list[i]['image']
                                .toString()
                                .split(',')[0]
                                .split('、')[1],
                            isOk: list[i]['isOk'],
                            index: i),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-40.h, 0.h),
                      child: SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: list[i]['isOk'] == 'true'
                            ? Transform.translate(
                          offset: Offset(2.h, 0.h),
                          child: WidgetUtils.showImages(
                              list[i]['image']
                                  .toString()
                                  .split(',')[1]
                                  .split('、')[2],
                              double.infinity,
                              double.infinity),
                        )
                            : SVGASimpleImage2(
                            assetsName: list[i]['image']
                                .toString()
                                .split(',')[0]
                                .split('、')[2],
                            isOk: list[i]['isOk'],
                            index: i),
                      ),
                    )
                  ],
                ),
              ],
            )
                : (list[i]['content']
                .toString()
                .isNotEmpty && list[i]['bubble_img']
                .toString()
                .length > 0) ?
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              // constraints: BoxConstraints(maxWidth: double.infinity - 130.w),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    // centerSlice: sp.getString('isEmulation') == '1' ? Rect
                    //     .fromLTWH(20.h, 20.h, 1, 1) : Rect.fromLTWH(40.w, 40.w
                    //     , 1, 1),
                    centerSlice: const Rect.fromLTWH(18, 17, 1, 1),
                    // image: AssetImage('assets/images/cj/chat_text.png'),
                    image: CachedNetworkImageProvider(
                        list[i]['bubble_img'].toString()),
                    scale: 2,
                  )
              ),
              child: Text(
                list[i]['content'], maxLines: 2, style: TextStyle(
                color: Colors.white, fontSize: 24.sp,
              ),),
            ) : (list[i]['content']
                .toString()
                .isNotEmpty && list[i]['bubble_img']
                .toString()
                .length == 0) ? Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.only(
                  top: 15.h, bottom: 15.h, left: 10.h, right: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white10,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Text(
                list[i]['content'], maxLines: 2, style: TextStyle(
                color: Colors.white, fontSize: 24.sp,
              ),),
            ) : Container(
              margin: EdgeInsets.only(bottom: 10.h),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.transparent,
              ),
              child: list[i]['image'].toString().contains('svga')
                  ? SizedBox(
                height:
                !list[i]['image'].toString().contains('vc')
                    ? 100.h
                    : 80.h,
                width:
                !list[i]['image'].toString().contains('vc')
                    ? 100.h
                    : 80.h,
                child: list[i]['isOk'] == 'true'
                    ? Transform.translate(
                  offset: Offset(2.h, 0.h),
                  child: WidgetUtils.showImages(
                      list[i]['image']
                          .toString()
                          .split(',')[1],
                      double.infinity,
                      double.infinity),
                )
                    : SVGASimpleImage2(
                    assetsName: list[i]['image']
                        .toString()
                        .split(',')[0],
                    isOk: list[i]['isOk'],
                    index: i),
              )
                  : list[i]['image'].toString().contains('gif')
                  ? WidgetUtils.showImages(
                  list[i]['image'], 80.h, 80.h)
                  : WidgetUtils.showImages(
                  list[i]['image'], 50.h, 50.h),
            ),
            WidgetUtils.commonSizedBox(10.h, 0),
          ],
        ),
      );
    }
  }

  /// 头部信息
  static Widget roomTop(BuildContext context,
      String roomHeadImg,
      String roomName,
      String roomNumber,
      String follow_status,
      String hot_degree,
      String roomID,
      List<MikeList> listm,
      String role) {
    return Row(
      children: [
        WidgetUtils.commonSizedBox(0, 20 * 2.w),
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentPage(
                context,
                RoomManagerPage(
                  type: (sp.getString('role').toString() == 'adminer' ||
                      sp.getString('role').toString() == 'leader' ||
                      sp.getString('role').toString() == 'president')
                      ? 1
                      : 0,
                  roomID: roomID,
                ));
          }),
          child: WidgetUtils.CircleHeadImage(ScreenUtil().setWidth(55 * 1.25),
              ScreenUtil().setWidth(55 * 1.25), roomHeadImg),
        ),
        WidgetUtils.commonSizedBox(0, 5 * 2.w),
        Column(
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(100 * 1.25),
              child: roomName.length <= 5
                  ? WidgetUtils.onlyText(
                  roomName,
                  StyleUtils.getCommonTextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(21),
                      fontWeight: FontWeight.w600))
                  : Marquee(
                speed: 10,
                child: Text(
                  roomName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(21)),
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(5 * 2.w, 0),
            SizedBox(
              width: ScreenUtil().setWidth(100 * 1.25),
              child: WidgetUtils.onlyText(
                  'ID $roomNumber',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomID,
                      fontSize: ScreenUtil().setSp(18))),
            ),
          ],
        ),
        follow_status == '0'
            ? GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              eventBus.fire(RoomBack(title: '收藏', index: ''));
            }
          }),
          child: SizedBox(
            width: ScreenUtil().setWidth(80 * 1.25),
            height: ScreenUtil().setWidth(38 * 1.25),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.showImagesFill(
                    'assets/images/room_shoucang.png',
                    double.infinity,
                    double.infinity),
                Container(
                  width: ScreenUtil().setWidth(80 * 1.25),
                  height: ScreenUtil().setWidth(38 * 1.25),
                  alignment: Alignment.center,
                  child: Text(
                    '收藏',
                    style: StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(21)),
                  ),
                )
              ],
            ),
          ),
        )
            : GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              eventBus.fire(RoomBack(title: '取消收藏', index: ''));
            }
          }),
          child: Stack(
            children: [
              Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: ScreenUtil().setWidth(80 * 1.25),
                    height: ScreenUtil().setWidth(38 * 1.25),
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.roomMaiLiao,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(
                          ScreenUtil().setWidth(38 * 1.25) / 2)),
                    ),
                  )),
              Container(
                width: ScreenUtil().setWidth(80 * 1.25),
                height: ScreenUtil().setWidth(38 * 1.25),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '已收藏',
                      style: StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(21)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Expanded(child: Text('')),

        /// 热度
        Stack(
          children: [
            Opacity(
                opacity: 0.3,
                child: Container(
                  width: ScreenUtil().setWidth(130 * 1.25),
                  height: ScreenUtil().setWidth(30 * 1.25),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: MyColors.roomMaiLiao,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(30 * 1.25) / 2)),
                  ),
                )),
            GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  MyUtils.goTransparentPage(
                      context,
                      RoomReDuPage(
                        roomID: roomID,
                        listm: listm,
                        role: role,
                      ));
                }
              }),
              child: Container(
                width: ScreenUtil().setWidth(130 * 1.25),
                height: ScreenUtil().setWidth(30 * 1.25),
                color: Colors.transparent,
                child: Row(
                  children: [
                    const Expanded(child: Text('')),
                    // WidgetUtils.showImagesFill('assets/images/room_hot.png',
                    //     ScreenUtil().setHeight(18), ScreenUtil().setHeight(15)),
                    // WidgetUtils.onlyText('热度', StyleUtils.getCommonTextStyle(
                    //     color: Colors.white,
                    //     fontSize: ScreenUtil().setSp(18))),
                    Text(
                      '热度',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          color: Colors.white,
                          fontFamily: 'YOUSHEBIAOTIHEI'),
                    ),
                    WidgetUtils.commonSizedBox(0, 2 * 2.w),
                    Text(
                      double.parse(hot_degree) > 9999
                          ? '${(double.parse(hot_degree) / 10000)
                          .toStringAsFixed(2)}w'
                          : hot_degree,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          color: Colors.white,
                          fontFamily: 'YOUSHEBIAOTIHEI'),
                    ),
                    // WidgetUtils.onlyTextCenter(
                    //     double.parse(hot_degree) > 9999 ? '${(double.parse(hot_degree) / 10000).toStringAsFixed(2)}w' : hot_degree,
                    //     StyleUtils.getCommonTextStyle(
                    //         color: Colors.white,
                    //         fontSize: ScreenUtil().setSp(18))),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            )
          ],
        ),

        /// 退出的点
        GestureDetector(
          onTap: (() {
            eventBus.fire(RoomBack(title: '点击房间关闭', index: ''));
          }),
          child: SizedBox(
              height: ScreenUtil().setWidth(32 * 1.25),
              width: ScreenUtil().setWidth(79 * 1.25),
              child: WidgetUtils.showImages(
                  'assets/images/room_dian.png',
                  ScreenUtil().setWidth(32 * 1.25),
                  ScreenUtil().setWidth(7 * 1.25))),
        ),
        WidgetUtils.commonSizedBox(0, 10.w),
      ],
    );
  }

  /// 公告厅主
  static Widget notices(BuildContext context,
      bool m0,
      String notice,
      List<MikeList> listm,
      String roomID,
      String wherePeople,
      List<bool> listPeople,
      bool audio9, String jianLiWu,
      SVGAAnimationController animationControllerJL) {
    return Row(
      children: [
        WidgetUtils.commonSizedBox(0, 20 * 2.w),
        Expanded(
            child: Row(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(240),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentPageCom(
                              context,
                              RoomTSGongGaoPage(
                                notice: notice,
                              ));
                        }),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.3,
                              child: Container(
                                width: ScreenUtil().setHeight(80),
                                height: ScreenUtil().setHeight(30),
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.roomMaiLiao,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setHeight(80),
                              height: ScreenUtil().setHeight(30),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImagesFill(
                                      'assets/images/room_gonggao.png',
                                      ScreenUtil().setHeight(30),
                                      ScreenUtil().setHeight(30)),
                                  WidgetUtils.onlyTextCenter(
                                      '公告',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomID,
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            )),

        /// 厅主
        Transform.translate(
          offset: Offset(0, -30 * 2.w),
          child: GestureDetector(
            onTap: (() {
              if (listm[8].isLock == 0) {
                if (m0 == true) {
                  if (listm[8].uid.toString() ==
                      sp.getString('user_id').toString()) {
                    eventBus.fire(RoomBack(title: '自己', index: '8'));
                  } else {
                    if (MyUtils.checkClick() &&
                        listm[8].uid.toString() !=
                            sp.getString('user_id').toString()) {
                      MyUtils.goTransparentPage(
                          context,
                          RoomPeopleInfoPage(
                            uid: listm[8].uid.toString(),
                            index: '8',
                            roomID: roomID,
                            isClose: listm[8].isClose.toString(),
                            listM: listm,
                          ));
                    }
                  }
                } else {
                  eventBus.fire(RoomBack(title: '空位置', index: '8'));
                }
              } else {
                if (sp.getString('role').toString() == 'adminer' ||
                    sp.getString('role').toString() == 'leader' ||
                    sp.getString('role').toString() == 'president') {
                  eventBus.fire(RoomBack(title: '空位置', index: '8'));
                } else {
                  MyToastUtils.showToastBottom('麦位已锁');
                }
              }
            }),
            child: SizedBox(
              width: ScreenUtil().setHeight(240),
              height: ScreenUtil().setHeight(240),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  m0 == true
                      ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(95),
                      ScreenUtil().setHeight(95), listm[8].avatar!)
                      : listm[8].isLock == 0
                      ? WidgetUtils.showImages(
                      'assets/images/room_mai.png',
                      ScreenUtil().setHeight(95),
                      ScreenUtil().setHeight(95))
                      : WidgetUtils.showImages(
                      'assets/images/room_suo.png',
                      ScreenUtil().setHeight(95),
                      ScreenUtil().setHeight(95)),
                  // 声波
                  (listm[8].isClose == 0 && audio9 == true)
                      ? SizedBox(
                    height: (listm[8].waveName.toString() == '电音点点' ||
                        listm[8].waveName.toString() == '蓝色电音')
                        ? 200.h
                        : 180.h,
                    width: 180.h,
                    child: listm[8].waveGifImg!.isNotEmpty
                        ? SVGASimpleImage(
                      resUrl: listm[8].waveGifImg!,
                    )
                        : const SVGASimpleImage(
                      assetsName: 'assets/svga/room_shengbo.svga',
                    ),
                  )
                      : const Text(''),
                  //头像框静态图
                  (listm[8].avatarFrameGifImg!.isEmpty &&
                      listm[8].avatarFrameImg!.isNotEmpty)
                      ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(150),
                      ScreenUtil().setHeight(150), listm[0].avatarFrameImg!)
                      : const Text(''),
                  listm[8].avatarFrameGifImg!.isNotEmpty
                      ? SizedBox(
                    height: 130.h,
                    width: 130.h,
                    child: SVGASimpleImage(
                      resUrl: listm[8].avatarFrameGifImg!,
                    ),
                  )
                      : const Text(''),
                  Column(
                    children: [
                      const Expanded(child: Text('')),
                      m0 == false
                          ? WidgetUtils.onlyTextCenter(
                          '主持麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomMaiWZ,
                              fontSize: ScreenUtil().setSp(21)))
                          : Row(
                        children: [
                          const Expanded(child: Text('')),
                          listm[8].nobleID! > 4 ? ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [MyColors.gz3, MyColors.gz4],
                              ).createShader(Offset.zero & bounds.size);
                            },
                            blendMode: BlendMode.srcATop,
                            child: Text(
                              listm[8].nickname! ?? '',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(21),
                                  color: const Color(0xffffffff)),
                            ),
                          ) :
                          WidgetUtils.onlyText(
                              listm[8].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(21))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                      m0
                          ? Row(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.showImages(
                              'assets/images/room_xin.png',
                              ScreenUtil().setHeight(17),
                              ScreenUtil().setHeight(15)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText(
                              listm[8].charm.toString(),
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(21))),
                          const Expanded(child: Text('')),
                        ],
                      )
                          : const Text('')
                    ],
                  ),
                  wherePeople == "9"
                      ? Positioned(
                    top: 70.h,
                    child: Container(
                      height: 100.h,
                      width: 100.h,
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.h),
                      ),
                      child: const SVGASimpleImage(
                        assetsName: 'assets/svga/baodeng.svga',
                      ),
                    ),
                  )
                      : const Text(''),
                  listPeople[8]
                      ? Positioned(
                    child: Container(
                      height: 180.h,
                      width: 180.h,
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.h),
                      ),
                      child: const SVGASimpleImage(
                        assetsName: 'assets/svga/room_choose_people.svga',
                      ),
                    ),
                  )
                      : const Text(''),
                  jianLiWu.contains('9')
                      ? Positioned(
                    top: 70.h,
                    child: Container(
                      height: 100.h,
                      width: 100.h,
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.h),
                      ),
                      child: SVGAImage(
                        animationControllerJL,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  )
                      : const Text(''),
                  // Positioned(
                  //   child: Container(
                  //     height: 180.h,
                  //     width: 180.h,
                  //     //超出部分，可裁剪
                  //     clipBehavior: Clip.hardEdge,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50.h),
                  //     ),
                  //     child: const SVGASimpleImage(
                  //       assetsName: 'assets/svga/db.svga',),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        const Expanded(child: Text('')),
        WidgetUtils.commonSizedBox(0, 20 * 2.w),
      ],
    );
  }

  /// 麦序位置
  static Widget maixu(BuildContext context,
      bool m1,
      bool m2,
      bool m3,
      bool m4,
      bool m5,
      bool m6,
      bool m7,
      bool m8,
      bool isBoss,
      List<MikeList> listm,
      String roomID,
      List<String> wherePeople,
      List<bool> listPeople,
      bool audio1,
      bool audio2,
      bool audio3,
      bool audio4,
      bool audio5,
      bool audio6,
      bool audio7,
      bool audio8, String whoWin, String jianLiWu,
      SVGAAnimationController animationControllerJL) {
    return Transform.translate(
      offset: Offset(0, (-60 * 2 / 1.25).h),
      child: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 10 * 2.w),
              GestureDetector(
                onTap: (() {
                  if (listm[0].isLock == 0) {
                    if (m1) {
                      if (listm[0].uid.toString() ==
                          sp.getString('user_id').toString()) {
                        eventBus.fire(RoomBack(title: '自己', index: '0'));
                      } else {
                        if (MyUtils.checkClick() &&
                            listm[0].uid.toString() !=
                                sp.getString('user_id').toString()) {
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                uid: listm[0].uid.toString(),
                                index: '0',
                                roomID: roomID,
                                isClose: listm[0].isClose.toString(),
                                listM: listm,
                              ));
                        }
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '0'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader' ||
                        sp.getString('role').toString() == 'president') {
                      eventBus.fire(RoomBack(title: '空位置', index: '0'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setWidth(140 * 1.25),
                  height: ScreenUtil().setHeight(230),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m1 == true
                          ? WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80),
                          listm[0].avatar!)
                          : listm[0].isLock == 0
                          ? WidgetUtils.showImages(
                          'assets/images/room_mai.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80))
                          : WidgetUtils.showImages(
                          'assets/images/room_suo.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80)),
                      (listm[0].isClose == 0 && audio1 == true)
                          ? Container(
                        height: 140.h,
                        width: 140.h,
                        alignment: Alignment.center,
                        child: listm[0].waveGifImg!.isNotEmpty
                            ? SVGASimpleImage(
                          resUrl: listm[0].waveGifImg!,
                        )
                            : const SVGASimpleImage(
                          assetsName:
                          'assets/svga/room_shengbo.svga',
                        ),
                      )
                          : const Text(''),
                      // 头像框静态图
                      (listm[0].avatarFrameGifImg!.isEmpty &&
                          listm[0].avatarFrameImg!.isNotEmpty)
                          ? WidgetUtils.CircleHeadImage(
                          110.h,
                          110.h,
                          listm[0].avatarFrameImg!)
                          : const Text(''),
                      // 头像框动态图
                      listm[0].avatarFrameGifImg!.isNotEmpty
                          ? SizedBox(
                        height: 110.h,
                        width: 110.h,
                        child: SVGASimpleImage(
                          resUrl: listm[0].avatarFrameGifImg!,
                        ),
                      )
                          : const Text(''),
                      Column(
                        children: [
                          m1 == false
                              ? WidgetUtils.commonSizedBox(180.h, 0)
                              : WidgetUtils.commonSizedBox(160.h, 0),
                          m1 == false
                              ? WidgetUtils.onlyTextCenter(
                              '1号麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomMaiWZ,
                                  fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == true
                              ? Row(
                            children: [
                              const Expanded(child: Text('')),
                              listm[0].nobleID! > 4 ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [MyColors.gz3, MyColors.gz4],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                blendMode: BlendMode.srcATop,
                                child: Text(
                                  listm[0].nickname! ?? '',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(21),
                                      color: const Color(0xffffffff)),
                                ),
                              ) :
                              WidgetUtils.onlyText(
                                  listm[0].nickname!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(21))),
                              const Expanded(child: Text('')),
                            ],
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == true
                              ? SizedBox(
                            height: 20.h,
                            child: Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_xin.png',
                                    ScreenUtil().setHeight(17),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    listm[0].charm.toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      ),
                      wherePeople[0] == "1"
                          ? Container(
                        height: 80.h,
                        width: 80.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/baodeng.svga',
                        ),
                      )
                          : const Text(''),
                      listPeople[0]
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_choose_people.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      //pk失败方显示猪头
                      whoWin == 'red'
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/pk/room_pk_loser.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      jianLiWu.contains('1')
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: SVGAImage(
                            animationControllerJL,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
              const Expanded(child: Text('')),
              GestureDetector(
                onTap: (() {
                  if (listm[1].isLock == 0) {
                    if (m2) {
                      if (listm[1].uid.toString() ==
                          sp.getString('user_id').toString()) {
                        eventBus.fire(RoomBack(title: '自己', index: '1'));
                      } else {
                        if (MyUtils.checkClick() &&
                            listm[1].uid.toString() !=
                                sp.getString('user_id').toString()) {
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                uid: listm[1].uid.toString(),
                                index: '1',
                                roomID: roomID,
                                isClose: listm[1].isClose.toString(),
                                listM: listm,
                              ));
                        }
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '1'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader' ||
                        sp.getString('role').toString() == 'president') {
                      eventBus.fire(RoomBack(title: '空位置', index: '1'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setWidth(140 * 1.25),
                  height: ScreenUtil().setHeight(230),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m2 == true
                          ? WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80),
                          listm[1].avatar!)
                          : listm[1].isLock == 0
                          ? WidgetUtils.showImages(
                          'assets/images/room_mai.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80))
                          : WidgetUtils.showImages(
                          'assets/images/room_suo.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80)),
                      (listm[1].isClose == 0 && audio2 == true)
                          ? Container(
                        height: 140.h,
                        width: 140.h,
                        alignment: Alignment.center,
                        child: listm[1].waveGifImg!.isNotEmpty
                            ? SVGASimpleImage(
                          resUrl: listm[1].waveGifImg!,
                        )
                            : const SVGASimpleImage(
                          assetsName:
                          'assets/svga/room_shengbo.svga',
                        ),
                      )
                          : const Text(''),
                      // 头像框静态图
                      (listm[1].avatarFrameGifImg!.isEmpty &&
                          listm[1].avatarFrameImg!.isNotEmpty)
                          ? WidgetUtils.CircleHeadImage(
                          110.h,
                          110.h,
                          listm[1].avatarFrameImg!)
                          : const Text(''),
                      // 头像框动态图
                      listm[1].avatarFrameGifImg!.isNotEmpty
                          ? SizedBox(
                        height: 110.h,
                        width: 110.h,
                        child: SVGASimpleImage(
                          resUrl: listm[1].avatarFrameGifImg!,
                        ),
                      )
                          : const Text(''),
                      Column(
                        children: [
                          m2 == false
                              ? WidgetUtils.commonSizedBox(180.h, 0)
                              : WidgetUtils.commonSizedBox(160.h, 0),
                          m2 == false
                              ? WidgetUtils.onlyTextCenter(
                              '2号麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomMaiWZ,
                                  fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == true
                              ? Row(
                            children: [
                              const Expanded(child: Text('')),
                              listm[1].nobleID! > 4 ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [MyColors.gz3, MyColors.gz4],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                blendMode: BlendMode.srcATop,
                                child: Text(
                                  listm[1].nickname! ?? '',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(21),
                                      color: const Color(0xffffffff)),
                                ),
                              ) :
                              WidgetUtils.onlyText(
                                  listm[1].nickname!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(21))),
                              const Expanded(child: Text('')),
                            ],
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == true
                              ? SizedBox(
                            height: 20.h,
                            child: Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_xin.png',
                                    ScreenUtil().setHeight(17),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    listm[1].charm.toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      ),
                      wherePeople[1] == "2"
                          ? Container(
                        height: 80.h,
                        width: 80.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/baodeng.svga',
                        ),
                      )
                          : const Text(''),
                      listPeople[1]
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_choose_people.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      //pk失败方显示猪头
                      whoWin == 'red'
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/pk/room_pk_loser.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      jianLiWu.contains('2')
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: SVGAImage(
                            animationControllerJL,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
              const Expanded(child: Text('')),
              GestureDetector(
                onTap: (() {
                  if (listm[2].isLock == 0) {
                    if (m3) {
                      if (listm[2].uid.toString() ==
                          sp.getString('user_id').toString()) {
                        eventBus.fire(RoomBack(title: '自己', index: '2'));
                      } else {
                        if (MyUtils.checkClick() &&
                            listm[2].uid.toString() !=
                                sp.getString('user_id').toString()) {
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                uid: listm[2].uid.toString(),
                                index: '2',
                                roomID: roomID,
                                isClose: listm[2].isClose.toString(),
                                listM: listm,
                              ));
                        }
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '2'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader' ||
                        sp.getString('role').toString() == 'president') {
                      eventBus.fire(RoomBack(title: '空位置', index: '2'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setWidth(140 * 1.25),
                  height: ScreenUtil().setHeight(230),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m3 == true
                          ? WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80),
                          listm[2].avatar!)
                          : listm[2].isLock == 0
                          ? WidgetUtils.showImages(
                          'assets/images/room_mai.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80))
                          : WidgetUtils.showImages(
                          'assets/images/room_suo.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80)),
                      (listm[2].isClose == 0 && audio3 == true)
                          ? Container(
                        height: 140.h,
                        width: 140.h,
                        alignment: Alignment.center,
                        child: listm[2].waveGifImg!.isNotEmpty
                            ? SVGASimpleImage(
                          resUrl: listm[2].waveGifImg!,
                        )
                            : const SVGASimpleImage(
                          assetsName:
                          'assets/svga/room_shengbo.svga',
                        ),
                      )
                          : const Text(''),
                      // 头像框静态图
                      (listm[2].avatarFrameGifImg!.isEmpty &&
                          listm[2].avatarFrameImg!.isNotEmpty)
                          ? WidgetUtils.CircleHeadImage(
                          110.h,
                          110.h,
                          listm[2].avatarFrameImg!)
                          : const Text(''),
                      // 头像框动态图
                      listm[2].avatarFrameGifImg!.isNotEmpty
                          ? SizedBox(
                        height: 110.h,
                        width: 110.h,
                        child: SVGASimpleImage(
                          resUrl: listm[2].avatarFrameGifImg!,
                        ),
                      )
                          : const Text(''),
                      Column(
                        children: [
                          m3 == false
                              ? WidgetUtils.commonSizedBox(180.h, 0)
                              : WidgetUtils.commonSizedBox(160.h, 0),
                          m3 == false
                              ? WidgetUtils.onlyTextCenter(
                              '3号麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomMaiWZ,
                                  fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == true
                              ? Row(
                            children: [
                              const Expanded(child: Text('')),
                              listm[2].nobleID! > 4 ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [MyColors.gz3, MyColors.gz4],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                blendMode: BlendMode.srcATop,
                                child: Text(
                                  listm[2].nickname! ?? '',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(21),
                                      color: const Color(0xffffffff)),
                                ),
                              ) :
                              WidgetUtils.onlyText(
                                  listm[2].nickname!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(21))),
                              const Expanded(child: Text('')),
                            ],
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == true
                              ? Container(
                            height: 20.h,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_xin.png',
                                    ScreenUtil().setHeight(17),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    listm[2].charm.toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      ),
                      wherePeople[2] == "3"
                          ? Container(
                        height: 80.h,
                        width: 80.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/baodeng.svga',
                        ),
                      )
                          : const Text(''),
                      listPeople[2]
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_choose_people.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      //pk失败方显示猪头
                      whoWin == 'blue'
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/pk/room_pk_loser.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      jianLiWu.contains('3')
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: SVGAImage(
                            animationControllerJL,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
              const Expanded(child: Text('')),
              GestureDetector(
                onTap: (() {
                  if (listm[3].isLock == 0) {
                    if (m4) {
                      if (listm[3].uid.toString() ==
                          sp.getString('user_id').toString()) {
                        eventBus.fire(RoomBack(title: '自己', index: '3'));
                      } else {
                        if (MyUtils.checkClick() &&
                            listm[3].uid.toString() !=
                                sp.getString('user_id').toString()) {
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                uid: listm[3].uid.toString(),
                                index: '3',
                                roomID: roomID,
                                isClose: listm[3].isClose.toString(),
                                listM: listm,
                              ));
                        }
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '3'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader' ||
                        sp.getString('role').toString() == 'president') {
                      eventBus.fire(RoomBack(title: '空位置', index: '3'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setWidth(140 * 1.25),
                  height: ScreenUtil().setHeight(230),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m4 == true
                          ? WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80),
                          listm[3].avatar!)
                          : listm[3].isLock == 0
                          ? WidgetUtils.showImages(
                          'assets/images/room_mai.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80))
                          : WidgetUtils.showImages(
                          'assets/images/room_suo.png',
                          ScreenUtil().setHeight(80),
                          ScreenUtil().setHeight(80)),
                      (listm[3].isClose == 0 && audio4 == true)
                          ? Container(
                        height: 140.h,
                        width: 140.h,
                        alignment: Alignment.center,
                        child: listm[3].waveGifImg!.isNotEmpty
                            ? SVGASimpleImage(
                          resUrl: listm[3].waveGifImg!,
                        )
                            : const SVGASimpleImage(
                          assetsName:
                          'assets/svga/room_shengbo.svga',
                        ),
                      )
                          : const Text(''),
                      // 头像框静态图
                      (listm[3].avatarFrameGifImg!.isEmpty &&
                          listm[3].avatarFrameImg!.isNotEmpty)
                          ? WidgetUtils.CircleHeadImage(
                          110.h,
                          110.h,
                          listm[3].avatarFrameImg!)
                          : const Text(''),
                      // 头像框动态图
                      listm[3].avatarFrameGifImg!.isNotEmpty
                          ? SizedBox(
                        height: 110.h,
                        width: 110.h,
                        child: SVGASimpleImage(
                          resUrl: listm[3].avatarFrameGifImg!,
                        ),
                      )
                          : const Text(''),
                      Column(
                        children: [
                          m4 == false
                              ? WidgetUtils.commonSizedBox(180.h, 0)
                              : WidgetUtils.commonSizedBox(160.h, 0),
                          m4 == false
                              ? WidgetUtils.onlyTextCenter(
                              '4号麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomMaiWZ,
                                  fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == true
                              ? Row(
                            children: [
                              const Expanded(child: Text('')),
                              listm[3].nobleID! > 4 ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [MyColors.gz3, MyColors.gz4],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                blendMode: BlendMode.srcATop,
                                child: Text(
                                  listm[3].nickname! ?? '',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(21),
                                      color: const Color(0xffffffff)),
                                ),
                              ) :
                              WidgetUtils.onlyText(
                                  listm[3].nickname!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(21))),
                              const Expanded(child: Text('')),
                            ],
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == true
                              ? SizedBox(
                            height: 20.h,
                            child: Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/room_xin.png',
                                    ScreenUtil().setHeight(17),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    listm[3].charm.toString(),
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      ),
                      wherePeople[3] == "4"
                          ? Container(
                        height: 80.h,
                        width: 80.h,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.h),
                        ),
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/baodeng.svga',
                        ),
                      )
                          : const Text(''),
                      listPeople[3]
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_choose_people.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      //pk失败方显示猪头
                      whoWin == 'blue'
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName:
                            'assets/svga/pk/room_pk_loser.svga',
                          ),
                        ),
                      )
                          : const Text(''),
                      jianLiWu.contains('4')
                          ? Positioned(
                        child: Container(
                          height: 130.h,
                          width: 130.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: SVGAImage(
                            animationControllerJL,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      )
                          : const Text(''),
                    ],
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(0, 10 * 2.w),
            ],
          ),

          /// 第二排麦序
          Transform.translate(
            offset: Offset(0, (-40 * 2 / 1.25).h),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10 * 2.w),
                GestureDetector(
                  onTap: (() {
                    if (listm[4].isLock == 0) {
                      if (m5) {
                        if (listm[4].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus.fire(RoomBack(title: '自己', index: '4'));
                        } else {
                          if (MyUtils.checkClick() &&
                              listm[4].uid.toString() !=
                                  sp.getString('user_id').toString()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomPeopleInfoPage(
                                  uid: listm[4].uid.toString(),
                                  index: '4',
                                  roomID: roomID,
                                  isClose: listm[4].isClose.toString(),
                                  listM: listm,
                                ));
                          }
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '4'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader' ||
                          sp.getString('role').toString() == 'president') {
                        eventBus.fire(RoomBack(title: '空位置', index: '4'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setWidth(140 * 1.25),
                    height: ScreenUtil().setHeight(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m5 == true
                            ? WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80),
                            listm[4].avatar!)
                            : listm[4].isLock == 0
                            ? WidgetUtils.showImages(
                            'assets/images/room_mai.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80))
                            : WidgetUtils.showImages(
                            'assets/images/room_suo.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80)),
                        (listm[4].isClose == 0 && audio5 == true)
                            ? Container(
                          height: 140.h,
                          width: 140.h,
                          alignment: Alignment.center,
                          child: listm[4].waveGifImg!.isNotEmpty
                              ? SVGASimpleImage(
                            resUrl: listm[4].waveGifImg!,
                          )
                              : const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_shengbo.svga',
                          ),
                        )
                            : const Text(''),
                        // 头像框静态图
                        (listm[4].avatarFrameGifImg!.isEmpty &&
                            listm[4].avatarFrameImg!.isNotEmpty)
                            ? WidgetUtils.CircleHeadImage(
                            110.h,
                            110.h,
                            listm[4].avatarFrameImg!)
                            : const Text(''),
                        // 头像框动态图
                        listm[4].avatarFrameGifImg!.isNotEmpty
                            ? SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: SVGASimpleImage(
                            resUrl: listm[4].avatarFrameGifImg!,
                          ),
                        )
                            : const Text(''),
                        Column(
                          children: [
                            m5 == false
                                ? WidgetUtils.commonSizedBox(180.h, 0)
                                : WidgetUtils.commonSizedBox(160.h, 0),
                            m5 == false
                                ? WidgetUtils.onlyTextCenter(
                                '5号麦',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomMaiWZ,
                                    fontSize: ScreenUtil().setSp(19)))
                                : WidgetUtils.commonSizedBox(0, 0),
                            m5 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(0, 0),
                            m5 == true
                                ? Row(
                              children: [
                                const Expanded(child: Text('')),
                                listm[4].nobleID! > 4 ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [MyColors.gz3, MyColors.gz4],
                                    ).createShader(Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    listm[4].nickname! ?? '',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(21),
                                        color: const Color(0xffffffff)),
                                  ),
                                ) :
                                WidgetUtils.onlyText(
                                    listm[4].nickname!,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m5 == true
                                ? SizedBox(
                              height: 20.h,
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/room_xin.png',
                                      ScreenUtil().setHeight(17),
                                      ScreenUtil().setHeight(15)),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText(
                                      listm[4].charm.toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize:
                                          ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        ),
                        wherePeople[4] == "5"
                            ? Container(
                          height: 80.h,
                          width: 80.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/baodeng.svga',
                          ),
                        )
                            : const Text(''),
                        listPeople[4]
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_choose_people.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        //pk失败方显示猪头
                        whoWin == 'red'
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/pk/room_pk_loser.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        jianLiWu.contains('5')
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: SVGAImage(
                              animationControllerJL,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: (() {
                    if (listm[5].isLock == 0) {
                      if (m6) {
                        if (listm[5].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus.fire(RoomBack(title: '自己', index: '5'));
                        } else {
                          if (MyUtils.checkClick() &&
                              listm[5].uid.toString() !=
                                  sp.getString('user_id').toString()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomPeopleInfoPage(
                                  uid: listm[5].uid.toString(),
                                  index: '5',
                                  roomID: roomID,
                                  isClose: listm[5].isClose.toString(),
                                  listM: listm,
                                ));
                          }
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '5'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader' ||
                          sp.getString('role').toString() == 'president') {
                        eventBus.fire(RoomBack(title: '空位置', index: '5'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setWidth(140 * 1.25),
                    height: ScreenUtil().setHeight(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m6 == true
                            ? WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80),
                            listm[5].avatar!)
                            : listm[5].isLock == 0
                            ? WidgetUtils.showImages(
                            'assets/images/room_mai.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80))
                            : WidgetUtils.showImages(
                            'assets/images/room_suo.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80)),
                        (listm[5].isClose == 0 && audio6 == true)
                            ? Container(
                          height: 140.h,
                          width: 140.h,
                          alignment: Alignment.center,
                          child: listm[5].waveGifImg!.isNotEmpty
                              ? SVGASimpleImage(
                            resUrl: listm[5].waveGifImg!,
                          )
                              : const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_shengbo.svga',
                          ),
                        )
                            : const Text(''),
                        // 头像框静态图
                        (listm[5].avatarFrameGifImg!.isEmpty &&
                            listm[5].avatarFrameImg!.isNotEmpty)
                            ? WidgetUtils.CircleHeadImage(
                            110.h,
                            110.h,
                            listm[5].avatarFrameImg!)
                            : const Text(''),
                        // 头像框动态图
                        listm[5].avatarFrameGifImg!.isNotEmpty
                            ? SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: SVGASimpleImage(
                            resUrl: listm[5].avatarFrameGifImg!,
                          ),
                        )
                            : const Text(''),
                        Column(
                          children: [
                            m6 == false
                                ? WidgetUtils.commonSizedBox(180.h, 0)
                                : WidgetUtils.commonSizedBox(160.h, 0),
                            m6 == false
                                ? WidgetUtils.onlyTextCenter(
                                '6号麦',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomMaiWZ,
                                    fontSize: ScreenUtil().setSp(19)))
                                : WidgetUtils.commonSizedBox(0, 0),
                            m6 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(0, 0),
                            m6 == true
                                ? Row(
                              children: [
                                const Expanded(child: Text('')),
                                listm[5].nobleID! > 4 ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [MyColors.gz3, MyColors.gz4],
                                    ).createShader(Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    listm[5].nickname! ?? '',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(21),
                                        color: const Color(0xffffffff)),
                                  ),
                                ) :
                                WidgetUtils.onlyText(
                                    listm[5].nickname!,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m6 == true
                                ? SizedBox(
                              height: 20.h,
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/room_xin.png',
                                      ScreenUtil().setHeight(17),
                                      ScreenUtil().setHeight(15)),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText(
                                      listm[5].charm.toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize:
                                          ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        ),
                        wherePeople[5] == "6"
                            ? Container(
                          height: 80.h,
                          width: 80.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/baodeng.svga',
                          ),
                        )
                            : const Text(''),
                        listPeople[5]
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_choose_people.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        //pk失败方显示猪头
                        whoWin == 'red'
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/pk/room_pk_loser.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        jianLiWu.contains('6')
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: SVGAImage(
                              animationControllerJL,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: (() {
                    if (listm[6].isLock == 0) {
                      if (m7) {
                        if (listm[6].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus.fire(RoomBack(title: '自己', index: '6'));
                        } else {
                          if (MyUtils.checkClick() &&
                              listm[6].uid.toString() !=
                                  sp.getString('user_id').toString()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomPeopleInfoPage(
                                  uid: listm[6].uid.toString(),
                                  index: '6',
                                  roomID: roomID,
                                  isClose: listm[6].isClose.toString(),
                                  listM: listm,
                                ));
                          }
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '6'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader' ||
                          sp.getString('role').toString() == 'president') {
                        eventBus.fire(RoomBack(title: '空位置', index: '6'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setWidth(140 * 1.25),
                    height: ScreenUtil().setHeight(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m7 == true
                            ? WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80),
                            listm[6].avatar!)
                            : listm[6].isLock == 0
                            ? WidgetUtils.showImages(
                            'assets/images/room_mai.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80))
                            : WidgetUtils.showImages(
                            'assets/images/room_suo.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80)),
                        (listm[6].isClose == 0 && audio7 == true)
                            ? Container(
                          height: 140.h,
                          width: 140.h,
                          alignment: Alignment.center,
                          child: listm[6].waveGifImg!.isNotEmpty
                              ? SVGASimpleImage(
                            resUrl: listm[6].waveGifImg!,
                          )
                              : const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_shengbo.svga',
                          ),
                        )
                            : const Text(''),
                        // 头像框静态图
                        (listm[6].avatarFrameGifImg!.isEmpty &&
                            listm[6].avatarFrameImg!.isNotEmpty)
                            ? WidgetUtils.CircleHeadImage(
                            110.h,
                            110.h,
                            listm[6].avatarFrameImg!)
                            : const Text(''),
                        // 头像框动态图
                        listm[6].avatarFrameGifImg!.isNotEmpty
                            ? SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: SVGASimpleImage(
                            resUrl: listm[6].avatarFrameGifImg!,
                          ),
                        )
                            : const Text(''),
                        Column(
                          children: [
                            m7 == false
                                ? WidgetUtils.commonSizedBox(180.h, 0)
                                : WidgetUtils.commonSizedBox(160.h, 0),
                            m7 == false
                                ? WidgetUtils.onlyTextCenter(
                                '7号麦',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomMaiWZ,
                                    fontSize: ScreenUtil().setSp(19)))
                                : WidgetUtils.commonSizedBox(0, 0),
                            m7 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(0, 0),
                            m7 == true
                                ? Row(
                              children: [
                                const Expanded(child: Text('')),
                                listm[6].nobleID! > 4 ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [MyColors.gz3, MyColors.gz4],
                                    ).createShader(Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    listm[6].nickname! ?? '',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(21),
                                        color: const Color(0xffffffff)),
                                  ),
                                ) :
                                WidgetUtils.onlyText(
                                    listm[6].nickname!,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize:
                                        ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m7 == true
                                ? SizedBox(
                              height: 20.h,
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/room_xin.png',
                                      ScreenUtil().setHeight(17),
                                      ScreenUtil().setHeight(15)),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText(
                                      listm[6].charm.toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize:
                                          ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        ),
                        wherePeople[6] == "7"
                            ? Container(
                          height: 80.h,
                          width: 80.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/baodeng.svga',
                          ),
                        )
                            : const Text(''),
                        listPeople[6]
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_choose_people.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        //pk失败方显示猪头
                        whoWin == 'blue'
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/pk/room_pk_loser.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        jianLiWu.contains('7')
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: SVGAImage(
                              animationControllerJL,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
                isBoss == true
                    ? GestureDetector(
                  onTap: (() {
                    if (listm[7].isLock == 0) {
                      if (m8) {
                        if (listm[7].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus
                              .fire(RoomBack(title: '自己', index: '7'));
                        } else {
                          if (MyUtils.checkClick() &&
                              listm[7].uid.toString() !=
                                  sp.getString('user_id').toString()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomPeopleInfoPage(
                                  uid: listm[7].uid.toString(),
                                  index: '7',
                                  roomID: roomID,
                                  isClose: listm[7].isClose.toString(),
                                  listM: listm,
                                ));
                          }
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '7'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader' ||
                          sp.getString('role').toString() ==
                              'president') {
                        eventBus.fire(RoomBack(title: '空位置', index: '7'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setWidth(140 * 1.25),
                    height: ScreenUtil().setHeight(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m8 == true
                            ? WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80),
                            listm[7].avatar!)
                            : listm[7].isLock == 1
                            ? WidgetUtils.showImages(
                            'assets/images/room_suo.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80))
                            : Container(
                          height: ScreenUtil().setHeight(80),
                          width: ScreenUtil().setHeight(80),
                          color: Colors.transparent,
                          child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/laobanwei.svga'),
                        ),
                        (listm[7].isClose == 0 && audio8 == true)
                            ? Container(
                          height: 140.h,
                          width: 140.h,
                          alignment: Alignment.center,
                          child: listm[7].waveGifImg!.isNotEmpty
                              ? SVGASimpleImage(
                            resUrl: listm[7].waveGifImg!,
                          )
                              : const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_shengbo.svga',
                          ),
                        )
                            : const Text(''),
                        // 头像框静态图
                        (listm[7].avatarFrameGifImg!.isEmpty &&
                            listm[7].avatarFrameImg!.isNotEmpty)
                            ? WidgetUtils.CircleHeadImage(
                            110.h,
                            110.h,
                            listm[7].avatarFrameImg!)
                            : const Text(''),
                        // 头像框动态图
                        listm[7].avatarFrameGifImg!.isNotEmpty
                            ? SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: SVGASimpleImage(
                            resUrl: listm[7].avatarFrameGifImg!,
                          ),
                        )
                            : const Text(''),
                        Column(
                          children: [
                            m8 == false
                                ? WidgetUtils.commonSizedBox(180.h, 0)
                                : WidgetUtils.commonSizedBox(160.h, 0),
                            m8 == false
                                ? ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF6ffffd),
                                    Color(0xFFf8fec4)
                                  ],
                                ).createShader(
                                    Offset.zero & bounds.size);
                              },
                              blendMode: BlendMode.srcATop,
                              child: Text(
                                "老板位",
                                style: TextStyle(
                                    fontSize:
                                    ScreenUtil().setSp(19),
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == true
                                ? Row(
                              children: [
                                const Expanded(child: Text('')),
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF6ffffd),
                                        Color(0xFFf8fec4)
                                      ],
                                    ).createShader(
                                        Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    listm[7].nickname!,
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setSp(21),
                                        color:
                                        const Color(0xffffffff),
                                        fontWeight:
                                        FontWeight.w700),
                                  ),
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == true
                                ? SizedBox(
                              height: 20.h,
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/room_xin.png',
                                      ScreenUtil().setHeight(17),
                                      ScreenUtil().setHeight(15)),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText(
                                      listm[7].charm.toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil()
                                              .setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        ),
                        wherePeople[7] == "8"
                            ? Container(
                          height: 80.h,
                          width: 80.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/baodeng.svga',
                          ),
                        )
                            : const Text(''),
                        listPeople[7]
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_choose_people.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        //pk失败方显示猪头
                        whoWin == 'blue'
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/pk/room_pk_loser.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        jianLiWu.contains('8')
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: SVGAImage(
                              animationControllerJL,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                            : const Text(''),
                      ],
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: (() {
                    if (listm[7].isLock == 0) {
                      if (m8) {
                        if (listm[7].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus
                              .fire(RoomBack(title: '自己', index: '7'));
                        } else {
                          if (MyUtils.checkClick() &&
                              listm[7].uid.toString() !=
                                  sp.getString('user_id').toString()) {
                            MyUtils.goTransparentPage(
                                context,
                                RoomPeopleInfoPage(
                                  uid: listm[7].uid.toString(),
                                  index: '7',
                                  roomID: roomID,
                                  isClose: listm[7].isClose.toString(),
                                  listM: listm,
                                ));
                          }
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '7'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader' ||
                          sp.getString('role').toString() ==
                              'president') {
                        eventBus.fire(RoomBack(title: '空位置', index: '7'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setWidth(140 * 1.25),
                    height: ScreenUtil().setHeight(230),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m8 == true
                            ? WidgetUtils.CircleHeadImage(
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80),
                            listm[7].avatar!)
                            : listm[7].isLock == 0
                            ? WidgetUtils.showImages(
                            'assets/images/room_mai.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80))
                            : WidgetUtils.showImages(
                            'assets/images/room_suo.png',
                            ScreenUtil().setHeight(80),
                            ScreenUtil().setHeight(80)),
                        (listm[7].isClose == 0 && audio8 == true)
                            ? Container(
                          height: 140.h,
                          width: 140.h,
                          alignment: Alignment.center,
                          child: listm[7].waveGifImg!.isNotEmpty
                              ? SVGASimpleImage(
                            resUrl: listm[7].waveGifImg!,
                          )
                              : const SVGASimpleImage(
                            assetsName:
                            'assets/svga/room_shengbo.svga',
                          ),
                        )
                            : const Text(''),
                        // 头像框静态图
                        (listm[7].avatarFrameGifImg!.isEmpty &&
                            listm[7].avatarFrameImg!.isNotEmpty)
                            ? WidgetUtils.CircleHeadImage(
                            110.h,
                            110.h,
                            listm[7].avatarFrameImg!)
                            : const Text(''),
                        // 头像框动态图
                        listm[7].avatarFrameGifImg!.isNotEmpty
                            ? SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: SVGASimpleImage(
                            resUrl: listm[7].avatarFrameGifImg!,
                          ),
                        )
                            : const Text(''),
                        Column(
                          children: [
                            m8 == false
                                ? WidgetUtils.commonSizedBox(180.h, 0)
                                : WidgetUtils.commonSizedBox(160.h, 0),
                            m8 == false
                                ? WidgetUtils.onlyTextCenter(
                                '8号麦',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomMaiWZ,
                                    fontSize: ScreenUtil().setSp(19)))
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == true
                                ? Row(
                              children: [
                                const Expanded(child: Text('')),
                                listm[7].nobleID! > 4 ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [MyColors.gz3, MyColors.gz4],
                                    ).createShader(Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    listm[7].nickname! ?? '',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(21),
                                        color: const Color(0xffffffff)),
                                  ),
                                ) :
                                WidgetUtils.onlyText(
                                    listm[7].nickname!,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil()
                                            .setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m8 == true
                                ? SizedBox(
                              height: 20.h,
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/room_xin.png',
                                      ScreenUtil().setHeight(17),
                                      ScreenUtil().setHeight(15)),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.onlyText(
                                      listm[7].charm.toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil()
                                              .setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        ),
                        wherePeople[7] == "8"
                            ? Container(
                          height: 80.h,
                          width: 80.h,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(50.h),
                          ),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/baodeng.svga',
                          ),
                        )
                            : const Text(''),
                        listPeople[7]
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_choose_people.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        //pk失败方显示猪头
                        whoWin == 'blue'
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName:
                              'assets/svga/pk/room_pk_loser.svga',
                            ),
                          ),
                        )
                            : const Text(''),
                        jianLiWu.contains('8')
                            ? Positioned(
                          child: Container(
                            height: 130.h,
                            width: 130.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: SVGAImage(
                              animationControllerJL,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10 * 2.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 房间pk麦序使用
  static Widget maixuPK(BuildContext context,
      bool m1,
      bool m2,
      bool m3,
      bool m4,
      bool m5,
      bool m6,
      bool m7,
      bool m8,
      bool isBoss,
      List<MikeList> listm,
      String roomID,
      List<String> wherePeople,
      List<bool> listPeople,
      bool audio1,
      bool audio2,
      bool audio3,
      bool audio4,
      bool audio5,
      bool audio6,
      bool audio7,
      bool audio8, String whoWin, String jianLiWu,
      SVGAAnimationController animationControllerJL) {
    return Transform.translate(
      offset: Offset(0, (-60 * 2 / 1.25).h),
      child: Column(
        children: [
          Transform.translate(
            offset: Offset(-70.w, 0),
            child: Transform.scale(
                scaleX:0.8,
              scaleY: 0.8,
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 10 * 2.w),
                  GestureDetector(
                    onTap: (() {
                      if (listm[0].isLock == 0) {
                        if (m1) {
                          if (listm[0].uid.toString() ==
                              sp.getString('user_id').toString()) {
                            eventBus.fire(RoomBack(title: '自己', index: '0'));
                          } else {
                            if (MyUtils.checkClick() &&
                                listm[0].uid.toString() !=
                                    sp.getString('user_id').toString()) {
                              MyUtils.goTransparentPage(
                                  context,
                                  RoomPeopleInfoPage(
                                    uid: listm[0].uid.toString(),
                                    index: '0',
                                    roomID: roomID,
                                    isClose: listm[0].isClose.toString(),
                                    listM: listm,
                                  ));
                            }
                          }
                        } else {
                          eventBus.fire(RoomBack(title: '空位置', index: '0'));
                        }
                      } else {
                        if (sp.getString('role').toString() == 'adminer' ||
                            sp.getString('role').toString() == 'leader' ||
                            sp.getString('role').toString() == 'president') {
                          eventBus.fire(RoomBack(title: '空位置', index: '0'));
                        } else {
                          MyToastUtils.showToastBottom('麦位已锁');
                        }
                      }
                    }),
                    child: SizedBox(
                      width: ScreenUtil().setWidth(140 * 1.25),
                      height: ScreenUtil().setHeight(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m1 == true
                              ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80),
                              listm[0].avatar!)
                              : listm[0].isLock == 0
                              ? WidgetUtils.showImages(
                              'assets/images/room_mai.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80))
                              : WidgetUtils.showImages(
                              'assets/images/room_suo.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80)),
                          (listm[0].isClose == 0 && audio1 == true)
                              ? Container(
                            height: 140.h,
                            width: 140.h,
                            alignment: Alignment.center,
                            child: listm[0].waveGifImg!.isNotEmpty
                                ? SVGASimpleImage(
                              resUrl: listm[0].waveGifImg!,
                            )
                                : const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_shengbo.svga',
                            ),
                          )
                              : const Text(''),
                          // 头像框静态图
                          (listm[0].avatarFrameGifImg!.isEmpty &&
                              listm[0].avatarFrameImg!.isNotEmpty)
                              ? WidgetUtils.CircleHeadImage(
                              110.h,
                              110.h,
                              listm[0].avatarFrameImg!)
                              : const Text(''),
                          // 头像框动态图
                          listm[0].avatarFrameGifImg!.isNotEmpty
                              ? SizedBox(
                            height: 110.h,
                            width: 110.h,
                            child: SVGASimpleImage(
                              resUrl: listm[0].avatarFrameGifImg!,
                            ),
                          )
                              : const Text(''),
                          Column(
                            children: [
                              m1 == false
                                  ? WidgetUtils.commonSizedBox(180.h, 0)
                                  : WidgetUtils.commonSizedBox(160.h, 0),
                              m1 == false
                                  ? WidgetUtils.onlyTextCenter(
                                  '1号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m1 == false
                                  ? WidgetUtils.commonSizedBox(10, 0)
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m1 == true
                                  ? Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  listm[0].nobleID! > 4 ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [MyColors.gz3, MyColors.gz4],
                                      ).createShader(Offset.zero & bounds.size);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: Text(
                                      listm[0].nickname! ?? '',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(21),
                                          color: const Color(0xffffffff)),
                                    ),
                                  ) :
                                  WidgetUtils.onlyText(
                                      listm[0].nickname!,
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m1 == true
                                  ? SizedBox(
                                height: 20.h,
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_xin.png',
                                        ScreenUtil().setHeight(17),
                                        ScreenUtil().setHeight(15)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[0].charm.toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                            ],
                          ),
                          wherePeople[0] == "1"
                              ? Container(
                            height: 80.h,
                            width: 80.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/baodeng.svga',
                            ),
                          )
                              : const Text(''),
                          listPeople[0]
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_choose_people.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          //pk失败方显示猪头
                          whoWin == 'red'
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/pk/room_pk_loser.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          jianLiWu.contains('1')
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: SVGAImage(
                                animationControllerJL,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      if (listm[1].isLock == 0) {
                        if (m2) {
                          if (listm[1].uid.toString() ==
                              sp.getString('user_id').toString()) {
                            eventBus.fire(RoomBack(title: '自己', index: '1'));
                          } else {
                            if (MyUtils.checkClick() &&
                                listm[1].uid.toString() !=
                                    sp.getString('user_id').toString()) {
                              MyUtils.goTransparentPage(
                                  context,
                                  RoomPeopleInfoPage(
                                    uid: listm[1].uid.toString(),
                                    index: '1',
                                    roomID: roomID,
                                    isClose: listm[1].isClose.toString(),
                                    listM: listm,
                                  ));
                            }
                          }
                        } else {
                          eventBus.fire(RoomBack(title: '空位置', index: '1'));
                        }
                      } else {
                        if (sp.getString('role').toString() == 'adminer' ||
                            sp.getString('role').toString() == 'leader' ||
                            sp.getString('role').toString() == 'president') {
                          eventBus.fire(RoomBack(title: '空位置', index: '1'));
                        } else {
                          MyToastUtils.showToastBottom('麦位已锁');
                        }
                      }
                    }),
                    child: SizedBox(
                      width: ScreenUtil().setWidth(140 * 1.25),
                      height: ScreenUtil().setHeight(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m2 == true
                              ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80),
                              listm[1].avatar!)
                              : listm[1].isLock == 0
                              ? WidgetUtils.showImages(
                              'assets/images/room_mai.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80))
                              : WidgetUtils.showImages(
                              'assets/images/room_suo.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80)),
                          (listm[1].isClose == 0 && audio2 == true)
                              ? Container(
                            height: 140.h,
                            width: 140.h,
                            alignment: Alignment.center,
                            child: listm[1].waveGifImg!.isNotEmpty
                                ? SVGASimpleImage(
                              resUrl: listm[1].waveGifImg!,
                            )
                                : const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_shengbo.svga',
                            ),
                          )
                              : const Text(''),
                          // 头像框静态图
                          (listm[1].avatarFrameGifImg!.isEmpty &&
                              listm[1].avatarFrameImg!.isNotEmpty)
                              ? WidgetUtils.CircleHeadImage(
                              110.h,
                              110.h,
                              listm[1].avatarFrameImg!)
                              : const Text(''),
                          // 头像框动态图
                          listm[1].avatarFrameGifImg!.isNotEmpty
                              ? SizedBox(
                            height: 110.h,
                            width: 110.h,
                            child: SVGASimpleImage(
                              resUrl: listm[1].avatarFrameGifImg!,
                            ),
                          )
                              : const Text(''),
                          Column(
                            children: [
                              m2 == false
                                  ? WidgetUtils.commonSizedBox(180.h, 0)
                                  : WidgetUtils.commonSizedBox(160.h, 0),
                              m2 == false
                                  ? WidgetUtils.onlyTextCenter(
                                  '2号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m2 == false
                                  ? WidgetUtils.commonSizedBox(10, 0)
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m2 == true
                                  ? Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  listm[1].nobleID! > 4 ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [MyColors.gz3, MyColors.gz4],
                                      ).createShader(Offset.zero & bounds.size);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: Text(
                                      listm[1].nickname! ?? '',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(21),
                                          color: const Color(0xffffffff)),
                                    ),
                                  ) :
                                  WidgetUtils.onlyText(
                                      listm[1].nickname!,
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m2 == true
                                  ? SizedBox(
                                height: 20.h,
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_xin.png',
                                        ScreenUtil().setHeight(17),
                                        ScreenUtil().setHeight(15)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[1].charm.toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                            ],
                          ),
                          wherePeople[1] == "2"
                              ? Container(
                            height: 80.h,
                            width: 80.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/baodeng.svga',
                            ),
                          )
                              : const Text(''),
                          listPeople[1]
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_choose_people.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          //pk失败方显示猪头
                          whoWin == 'red'
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/pk/room_pk_loser.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          jianLiWu.contains('2')
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: SVGAImage(
                                animationControllerJL,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      if (listm[2].isLock == 0) {
                        if (m3) {
                          if (listm[2].uid.toString() ==
                              sp.getString('user_id').toString()) {
                            eventBus.fire(RoomBack(title: '自己', index: '2'));
                          } else {
                            if (MyUtils.checkClick() &&
                                listm[2].uid.toString() !=
                                    sp.getString('user_id').toString()) {
                              MyUtils.goTransparentPage(
                                  context,
                                  RoomPeopleInfoPage(
                                    uid: listm[2].uid.toString(),
                                    index: '2',
                                    roomID: roomID,
                                    isClose: listm[2].isClose.toString(),
                                    listM: listm,
                                  ));
                            }
                          }
                        } else {
                          eventBus.fire(RoomBack(title: '空位置', index: '2'));
                        }
                      } else {
                        if (sp.getString('role').toString() == 'adminer' ||
                            sp.getString('role').toString() == 'leader' ||
                            sp.getString('role').toString() == 'president') {
                          eventBus.fire(RoomBack(title: '空位置', index: '2'));
                        } else {
                          MyToastUtils.showToastBottom('麦位已锁');
                        }
                      }
                    }),
                    child: SizedBox(
                      width: ScreenUtil().setWidth(140 * 1.25),
                      height: ScreenUtil().setHeight(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m3 == true
                              ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80),
                              listm[2].avatar!)
                              : listm[2].isLock == 0
                              ? WidgetUtils.showImages(
                              'assets/images/room_mai.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80))
                              : WidgetUtils.showImages(
                              'assets/images/room_suo.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80)),
                          (listm[2].isClose == 0 && audio3 == true)
                              ? Container(
                            height: 140.h,
                            width: 140.h,
                            alignment: Alignment.center,
                            child: listm[2].waveGifImg!.isNotEmpty
                                ? SVGASimpleImage(
                              resUrl: listm[2].waveGifImg!,
                            )
                                : const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_shengbo.svga',
                            ),
                          )
                              : const Text(''),
                          // 头像框静态图
                          (listm[2].avatarFrameGifImg!.isEmpty &&
                              listm[2].avatarFrameImg!.isNotEmpty)
                              ? WidgetUtils.CircleHeadImage(
                              110.h,
                              110.h,
                              listm[2].avatarFrameImg!)
                              : const Text(''),
                          // 头像框动态图
                          listm[2].avatarFrameGifImg!.isNotEmpty
                              ? SizedBox(
                            height: 110.h,
                            width: 110.h,
                            child: SVGASimpleImage(
                              resUrl: listm[2].avatarFrameGifImg!,
                            ),
                          )
                              : const Text(''),
                          Column(
                            children: [
                              m3 == false
                                  ? WidgetUtils.commonSizedBox(180.h, 0)
                                  : WidgetUtils.commonSizedBox(160.h, 0),
                              m3 == false
                                  ? WidgetUtils.onlyTextCenter(
                                  '3号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m3 == false
                                  ? WidgetUtils.commonSizedBox(10, 0)
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m3 == true
                                  ? Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  listm[2].nobleID! > 4 ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [MyColors.gz3, MyColors.gz4],
                                      ).createShader(Offset.zero & bounds.size);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: Text(
                                      listm[2].nickname! ?? '',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(21),
                                          color: const Color(0xffffffff)),
                                    ),
                                  ) :
                                  WidgetUtils.onlyText(
                                      listm[2].nickname!,
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m3 == true
                                  ? Container(
                                height: 20.h,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_xin.png',
                                        ScreenUtil().setHeight(17),
                                        ScreenUtil().setHeight(15)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[2].charm.toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                            ],
                          ),
                          wherePeople[2] == "3"
                              ? Container(
                            height: 80.h,
                            width: 80.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/baodeng.svga',
                            ),
                          )
                              : const Text(''),
                          listPeople[2]
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_choose_people.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          //pk失败方显示猪头
                          whoWin == 'blue'
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/pk/room_pk_loser.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          jianLiWu.contains('3')
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: SVGAImage(
                                animationControllerJL,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      if (listm[3].isLock == 0) {
                        if (m4) {
                          if (listm[3].uid.toString() ==
                              sp.getString('user_id').toString()) {
                            eventBus.fire(RoomBack(title: '自己', index: '3'));
                          } else {
                            if (MyUtils.checkClick() &&
                                listm[3].uid.toString() !=
                                    sp.getString('user_id').toString()) {
                              MyUtils.goTransparentPage(
                                  context,
                                  RoomPeopleInfoPage(
                                    uid: listm[3].uid.toString(),
                                    index: '3',
                                    roomID: roomID,
                                    isClose: listm[3].isClose.toString(),
                                    listM: listm,
                                  ));
                            }
                          }
                        } else {
                          eventBus.fire(RoomBack(title: '空位置', index: '3'));
                        }
                      } else {
                        if (sp.getString('role').toString() == 'adminer' ||
                            sp.getString('role').toString() == 'leader' ||
                            sp.getString('role').toString() == 'president') {
                          eventBus.fire(RoomBack(title: '空位置', index: '3'));
                        } else {
                          MyToastUtils.showToastBottom('麦位已锁');
                        }
                      }
                    }),
                    child: SizedBox(
                      width: ScreenUtil().setWidth(140 * 1.25),
                      height: ScreenUtil().setHeight(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          m4 == true
                              ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80),
                              listm[3].avatar!)
                              : listm[3].isLock == 0
                              ? WidgetUtils.showImages(
                              'assets/images/room_mai.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80))
                              : WidgetUtils.showImages(
                              'assets/images/room_suo.png',
                              ScreenUtil().setHeight(80),
                              ScreenUtil().setHeight(80)),
                          (listm[3].isClose == 0 && audio4 == true)
                              ? Container(
                            height: 140.h,
                            width: 140.h,
                            alignment: Alignment.center,
                            child: listm[3].waveGifImg!.isNotEmpty
                                ? SVGASimpleImage(
                              resUrl: listm[3].waveGifImg!,
                            )
                                : const SVGASimpleImage(
                              assetsName:
                              'assets/svga/room_shengbo.svga',
                            ),
                          )
                              : const Text(''),
                          // 头像框静态图
                          (listm[3].avatarFrameGifImg!.isEmpty &&
                              listm[3].avatarFrameImg!.isNotEmpty)
                              ? WidgetUtils.CircleHeadImage(
                              110.h,
                              110.h,
                              listm[3].avatarFrameImg!)
                              : const Text(''),
                          // 头像框动态图
                          listm[3].avatarFrameGifImg!.isNotEmpty
                              ? SizedBox(
                            height: 110.h,
                            width: 110.h,
                            child: SVGASimpleImage(
                              resUrl: listm[3].avatarFrameGifImg!,
                            ),
                          )
                              : const Text(''),
                          Column(
                            children: [
                              m4 == false
                                  ? WidgetUtils.commonSizedBox(180.h, 0)
                                  : WidgetUtils.commonSizedBox(160.h, 0),
                              m4 == false
                                  ? WidgetUtils.onlyTextCenter(
                                  '4号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m4 == false
                                  ? WidgetUtils.commonSizedBox(10, 0)
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m4 == true
                                  ? Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  listm[3].nobleID! > 4 ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [MyColors.gz3, MyColors.gz4],
                                      ).createShader(Offset.zero & bounds.size);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: Text(
                                      listm[3].nickname! ?? '',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(21),
                                          color: const Color(0xffffffff)),
                                    ),
                                  ) :
                                  WidgetUtils.onlyText(
                                      listm[3].nickname!,
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(21))),
                                  const Expanded(child: Text('')),
                                ],
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              m4 == true
                                  ? SizedBox(
                                height: 20.h,
                                child: Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_xin.png',
                                        ScreenUtil().setHeight(17),
                                        ScreenUtil().setHeight(15)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[3].charm.toString(),
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                              )
                                  : WidgetUtils.commonSizedBox(0, 0),
                            ],
                          ),
                          wherePeople[3] == "4"
                              ? Container(
                            height: 80.h,
                            width: 80.h,
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.h),
                            ),
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/baodeng.svga',
                            ),
                          )
                              : const Text(''),
                          listPeople[3]
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_choose_people.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          //pk失败方显示猪头
                          whoWin == 'blue'
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName:
                                'assets/svga/pk/room_pk_loser.svga',
                              ),
                            ),
                          )
                              : const Text(''),
                          jianLiWu.contains('4')
                              ? Positioned(
                            child: Container(
                              height: 130.h,
                              width: 130.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: SVGAImage(
                                animationControllerJL,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                              : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10 * 2.w),
                ],
              ),
            ),
          ),

          /// 第二排麦序
          Transform.translate(
            offset: Offset(0, (-50 * 2 / 1.25).h),
            child: Transform.translate(
              offset: Offset(-70.w, 0),
              child: Transform.scale(
                scaleX:0.8,
                scaleY: 0.8,
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 10 * 2.w),
                    GestureDetector(
                      onTap: (() {
                        if (listm[4].isLock == 0) {
                          if (m5) {
                            if (listm[4].uid.toString() ==
                                sp.getString('user_id').toString()) {
                              eventBus.fire(RoomBack(title: '自己', index: '4'));
                            } else {
                              if (MyUtils.checkClick() &&
                                  listm[4].uid.toString() !=
                                      sp.getString('user_id').toString()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                      uid: listm[4].uid.toString(),
                                      index: '4',
                                      roomID: roomID,
                                      isClose: listm[4].isClose.toString(),
                                      listM: listm,
                                    ));
                              }
                            }
                          } else {
                            eventBus.fire(RoomBack(title: '空位置', index: '4'));
                          }
                        } else {
                          if (sp.getString('role').toString() == 'adminer' ||
                              sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() == 'president') {
                            eventBus.fire(RoomBack(title: '空位置', index: '4'));
                          } else {
                            MyToastUtils.showToastBottom('麦位已锁');
                          }
                        }
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(140 * 1.25),
                        height: ScreenUtil().setHeight(230),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m5 == true
                                ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80),
                                listm[4].avatar!)
                                : listm[4].isLock == 0
                                ? WidgetUtils.showImages(
                                'assets/images/room_mai.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80))
                                : WidgetUtils.showImages(
                                'assets/images/room_suo.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80)),
                            (listm[4].isClose == 0 && audio5 == true)
                                ? Container(
                              height: 140.h,
                              width: 140.h,
                              alignment: Alignment.center,
                              child: listm[4].waveGifImg!.isNotEmpty
                                  ? SVGASimpleImage(
                                resUrl: listm[4].waveGifImg!,
                              )
                                  : const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_shengbo.svga',
                              ),
                            )
                                : const Text(''),
                            // 头像框静态图
                            (listm[4].avatarFrameGifImg!.isEmpty &&
                                listm[4].avatarFrameImg!.isNotEmpty)
                                ? WidgetUtils.CircleHeadImage(
                                110.h,
                                110.h,
                                listm[4].avatarFrameImg!)
                                : const Text(''),
                            // 头像框动态图
                            listm[4].avatarFrameGifImg!.isNotEmpty
                                ? SizedBox(
                              height: 110.h,
                              width: 110.h,
                              child: SVGASimpleImage(
                                resUrl: listm[4].avatarFrameGifImg!,
                              ),
                            )
                                : const Text(''),
                            Column(
                              children: [
                                m5 == false
                                    ? WidgetUtils.commonSizedBox(180.h, 0)
                                    : WidgetUtils.commonSizedBox(160.h, 0),
                                m5 == false
                                    ? WidgetUtils.onlyTextCenter(
                                    '5号麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m5 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m5 == true
                                    ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    listm[4].nobleID! > 4 ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [MyColors.gz3, MyColors.gz4],
                                        ).createShader(Offset.zero & bounds.size);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Text(
                                        listm[4].nickname! ?? '',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(21),
                                            color: const Color(0xffffffff)),
                                      ),
                                    ) :
                                    WidgetUtils.onlyText(
                                        listm[4].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m5 == true
                                    ? SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImages(
                                          'assets/images/room_xin.png',
                                          ScreenUtil().setHeight(17),
                                          ScreenUtil().setHeight(15)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[4].charm.toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            ),
                            wherePeople[4] == "5"
                                ? Container(
                              height: 80.h,
                              width: 80.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/baodeng.svga',
                              ),
                            )
                                : const Text(''),
                            listPeople[4]
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/room_choose_people.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            //pk失败方显示猪头
                            whoWin == 'red'
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/pk/room_pk_loser.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            jianLiWu.contains('5')
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: SVGAImage(
                                  animationControllerJL,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        if (listm[5].isLock == 0) {
                          if (m6) {
                            if (listm[5].uid.toString() ==
                                sp.getString('user_id').toString()) {
                              eventBus.fire(RoomBack(title: '自己', index: '5'));
                            } else {
                              if (MyUtils.checkClick() &&
                                  listm[5].uid.toString() !=
                                      sp.getString('user_id').toString()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                      uid: listm[5].uid.toString(),
                                      index: '5',
                                      roomID: roomID,
                                      isClose: listm[5].isClose.toString(),
                                      listM: listm,
                                    ));
                              }
                            }
                          } else {
                            eventBus.fire(RoomBack(title: '空位置', index: '5'));
                          }
                        } else {
                          if (sp.getString('role').toString() == 'adminer' ||
                              sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() == 'president') {
                            eventBus.fire(RoomBack(title: '空位置', index: '5'));
                          } else {
                            MyToastUtils.showToastBottom('麦位已锁');
                          }
                        }
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(140 * 1.25),
                        height: ScreenUtil().setHeight(230),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m6 == true
                                ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80),
                                listm[5].avatar!)
                                : listm[5].isLock == 0
                                ? WidgetUtils.showImages(
                                'assets/images/room_mai.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80))
                                : WidgetUtils.showImages(
                                'assets/images/room_suo.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80)),
                            (listm[5].isClose == 0 && audio6 == true)
                                ? Container(
                              height: 140.h,
                              width: 140.h,
                              alignment: Alignment.center,
                              child: listm[5].waveGifImg!.isNotEmpty
                                  ? SVGASimpleImage(
                                resUrl: listm[5].waveGifImg!,
                              )
                                  : const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_shengbo.svga',
                              ),
                            )
                                : const Text(''),
                            // 头像框静态图
                            (listm[5].avatarFrameGifImg!.isEmpty &&
                                listm[5].avatarFrameImg!.isNotEmpty)
                                ? WidgetUtils.CircleHeadImage(
                                110.h,
                                110.h,
                                listm[5].avatarFrameImg!)
                                : const Text(''),
                            // 头像框动态图
                            listm[5].avatarFrameGifImg!.isNotEmpty
                                ? SizedBox(
                              height: 110.h,
                              width: 110.h,
                              child: SVGASimpleImage(
                                resUrl: listm[5].avatarFrameGifImg!,
                              ),
                            )
                                : const Text(''),
                            Column(
                              children: [
                                m6 == false
                                    ? WidgetUtils.commonSizedBox(180.h, 0)
                                    : WidgetUtils.commonSizedBox(160.h, 0),
                                m6 == false
                                    ? WidgetUtils.onlyTextCenter(
                                    '6号麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m6 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m6 == true
                                    ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    listm[5].nobleID! > 4 ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [MyColors.gz3, MyColors.gz4],
                                        ).createShader(Offset.zero & bounds.size);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Text(
                                        listm[5].nickname! ?? '',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(21),
                                            color: const Color(0xffffffff)),
                                      ),
                                    ) :
                                    WidgetUtils.onlyText(
                                        listm[5].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m6 == true
                                    ? SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImages(
                                          'assets/images/room_xin.png',
                                          ScreenUtil().setHeight(17),
                                          ScreenUtil().setHeight(15)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[5].charm.toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            ),
                            wherePeople[5] == "6"
                                ? Container(
                              height: 80.h,
                              width: 80.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/baodeng.svga',
                              ),
                            )
                                : const Text(''),
                            listPeople[5]
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/room_choose_people.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            //pk失败方显示猪头
                            whoWin == 'red'
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/pk/room_pk_loser.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            jianLiWu.contains('6')
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: SVGAImage(
                                  animationControllerJL,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        if (listm[6].isLock == 0) {
                          if (m7) {
                            if (listm[6].uid.toString() ==
                                sp.getString('user_id').toString()) {
                              eventBus.fire(RoomBack(title: '自己', index: '6'));
                            } else {
                              if (MyUtils.checkClick() &&
                                  listm[6].uid.toString() !=
                                      sp.getString('user_id').toString()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                      uid: listm[6].uid.toString(),
                                      index: '6',
                                      roomID: roomID,
                                      isClose: listm[6].isClose.toString(),
                                      listM: listm,
                                    ));
                              }
                            }
                          } else {
                            eventBus.fire(RoomBack(title: '空位置', index: '6'));
                          }
                        } else {
                          if (sp.getString('role').toString() == 'adminer' ||
                              sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() == 'president') {
                            eventBus.fire(RoomBack(title: '空位置', index: '6'));
                          } else {
                            MyToastUtils.showToastBottom('麦位已锁');
                          }
                        }
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(140 * 1.25),
                        height: ScreenUtil().setHeight(230),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m7 == true
                                ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80),
                                listm[6].avatar!)
                                : listm[6].isLock == 0
                                ? WidgetUtils.showImages(
                                'assets/images/room_mai.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80))
                                : WidgetUtils.showImages(
                                'assets/images/room_suo.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80)),
                            (listm[6].isClose == 0 && audio7 == true)
                                ? Container(
                              height: 140.h,
                              width: 140.h,
                              alignment: Alignment.center,
                              child: listm[6].waveGifImg!.isNotEmpty
                                  ? SVGASimpleImage(
                                resUrl: listm[6].waveGifImg!,
                              )
                                  : const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_shengbo.svga',
                              ),
                            )
                                : const Text(''),
                            // 头像框静态图
                            (listm[6].avatarFrameGifImg!.isEmpty &&
                                listm[6].avatarFrameImg!.isNotEmpty)
                                ? WidgetUtils.CircleHeadImage(
                                110.h,
                                110.h,
                                listm[6].avatarFrameImg!)
                                : const Text(''),
                            // 头像框动态图
                            listm[6].avatarFrameGifImg!.isNotEmpty
                                ? SizedBox(
                              height: 110.h,
                              width: 110.h,
                              child: SVGASimpleImage(
                                resUrl: listm[6].avatarFrameGifImg!,
                              ),
                            )
                                : const Text(''),
                            Column(
                              children: [
                                m7 == false
                                    ? WidgetUtils.commonSizedBox(180.h, 0)
                                    : WidgetUtils.commonSizedBox(160.h, 0),
                                m7 == false
                                    ? WidgetUtils.onlyTextCenter(
                                    '7号麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m7 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m7 == true
                                    ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    listm[6].nobleID! > 4 ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [MyColors.gz3, MyColors.gz4],
                                        ).createShader(Offset.zero & bounds.size);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Text(
                                        listm[6].nickname! ?? '',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(21),
                                            color: const Color(0xffffffff)),
                                      ),
                                    ) :
                                    WidgetUtils.onlyText(
                                        listm[6].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m7 == true
                                    ? SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImages(
                                          'assets/images/room_xin.png',
                                          ScreenUtil().setHeight(17),
                                          ScreenUtil().setHeight(15)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[6].charm.toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            ),
                            wherePeople[6] == "7"
                                ? Container(
                              height: 80.h,
                              width: 80.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/baodeng.svga',
                              ),
                            )
                                : const Text(''),
                            listPeople[6]
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/room_choose_people.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            //pk失败方显示猪头
                            whoWin == 'blue'
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/pk/room_pk_loser.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            jianLiWu.contains('7')
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: SVGAImage(
                                  animationControllerJL,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: Text('')),
                    isBoss == true
                        ? GestureDetector(
                      onTap: (() {
                        if (listm[7].isLock == 0) {
                          if (m8) {
                            if (listm[7].uid.toString() ==
                                sp.getString('user_id').toString()) {
                              eventBus
                                  .fire(RoomBack(title: '自己', index: '7'));
                            } else {
                              if (MyUtils.checkClick() &&
                                  listm[7].uid.toString() !=
                                      sp.getString('user_id').toString()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                      uid: listm[7].uid.toString(),
                                      index: '7',
                                      roomID: roomID,
                                      isClose: listm[7].isClose.toString(),
                                      listM: listm,
                                    ));
                              }
                            }
                          } else {
                            eventBus.fire(RoomBack(title: '空位置', index: '7'));
                          }
                        } else {
                          if (sp.getString('role').toString() == 'adminer' ||
                              sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() ==
                                  'president') {
                            eventBus.fire(RoomBack(title: '空位置', index: '7'));
                          } else {
                            MyToastUtils.showToastBottom('麦位已锁');
                          }
                        }
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(140 * 1.25),
                        height: ScreenUtil().setHeight(230),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m8 == true
                                ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80),
                                listm[7].avatar!)
                                : listm[7].isLock == 1
                                ? WidgetUtils.showImages(
                                'assets/images/room_suo.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80))
                                : Container(
                              height: ScreenUtil().setHeight(80),
                              width: ScreenUtil().setHeight(80),
                              color: Colors.transparent,
                              child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/laobanwei.svga'),
                            ),
                            (listm[7].isClose == 0 && audio8 == true)
                                ? Container(
                              height: 140.h,
                              width: 140.h,
                              alignment: Alignment.center,
                              child: listm[7].waveGifImg!.isNotEmpty
                                  ? SVGASimpleImage(
                                resUrl: listm[7].waveGifImg!,
                              )
                                  : const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_shengbo.svga',
                              ),
                            )
                                : const Text(''),
                            // 头像框静态图
                            (listm[7].avatarFrameGifImg!.isEmpty &&
                                listm[7].avatarFrameImg!.isNotEmpty)
                                ? WidgetUtils.CircleHeadImage(
                                110.h,
                                110.h,
                                listm[7].avatarFrameImg!)
                                : const Text(''),
                            // 头像框动态图
                            listm[7].avatarFrameGifImg!.isNotEmpty
                                ? SizedBox(
                              height: 110.h,
                              width: 110.h,
                              child: SVGASimpleImage(
                                resUrl: listm[7].avatarFrameGifImg!,
                              ),
                            )
                                : const Text(''),
                            Column(
                              children: [
                                m8 == false
                                    ? WidgetUtils.commonSizedBox(180.h, 0)
                                    : WidgetUtils.commonSizedBox(160.h, 0),
                                m8 == false
                                    ? ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF6ffffd),
                                        Color(0xFFf8fec4)
                                      ],
                                    ).createShader(
                                        Offset.zero & bounds.size);
                                  },
                                  blendMode: BlendMode.srcATop,
                                  child: Text(
                                    "老板位",
                                    style: TextStyle(
                                        fontSize:
                                        ScreenUtil().setSp(19),
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == true
                                    ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF6ffffd),
                                            Color(0xFFf8fec4)
                                          ],
                                        ).createShader(
                                            Offset.zero & bounds.size);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Text(
                                        listm[7].nickname!,
                                        style: TextStyle(
                                            fontSize:
                                            ScreenUtil().setSp(21),
                                            color:
                                            const Color(0xffffffff),
                                            fontWeight:
                                            FontWeight.w700),
                                      ),
                                    ),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == true
                                    ? SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImages(
                                          'assets/images/room_xin.png',
                                          ScreenUtil().setHeight(17),
                                          ScreenUtil().setHeight(15)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[7].charm.toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil()
                                                  .setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            ),
                            wherePeople[7] == "8"
                                ? Container(
                              height: 80.h,
                              width: 80.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/baodeng.svga',
                              ),
                            )
                                : const Text(''),
                            listPeople[7]
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/room_choose_people.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            //pk失败方显示猪头
                            whoWin == 'blue'
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/pk/room_pk_loser.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            jianLiWu.contains('8')
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: SVGAImage(
                                  animationControllerJL,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: (() {
                        if (listm[7].isLock == 0) {
                          if (m8) {
                            if (listm[7].uid.toString() ==
                                sp.getString('user_id').toString()) {
                              eventBus
                                  .fire(RoomBack(title: '自己', index: '7'));
                            } else {
                              if (MyUtils.checkClick() &&
                                  listm[7].uid.toString() !=
                                      sp.getString('user_id').toString()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                      uid: listm[7].uid.toString(),
                                      index: '7',
                                      roomID: roomID,
                                      isClose: listm[7].isClose.toString(),
                                      listM: listm,
                                    ));
                              }
                            }
                          } else {
                            eventBus.fire(RoomBack(title: '空位置', index: '7'));
                          }
                        } else {
                          if (sp.getString('role').toString() == 'adminer' ||
                              sp.getString('role').toString() == 'leader' ||
                              sp.getString('role').toString() ==
                                  'president') {
                            eventBus.fire(RoomBack(title: '空位置', index: '7'));
                          } else {
                            MyToastUtils.showToastBottom('麦位已锁');
                          }
                        }
                      }),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(140 * 1.25),
                        height: ScreenUtil().setHeight(230),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m8 == true
                                ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80),
                                listm[7].avatar!)
                                : listm[7].isLock == 0
                                ? WidgetUtils.showImages(
                                'assets/images/room_mai.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80))
                                : WidgetUtils.showImages(
                                'assets/images/room_suo.png',
                                ScreenUtil().setHeight(80),
                                ScreenUtil().setHeight(80)),
                            (listm[7].isClose == 0 && audio8 == true)
                                ? Container(
                              height: 140.h,
                              width: 140.h,
                              alignment: Alignment.center,
                              child: listm[7].waveGifImg!.isNotEmpty
                                  ? SVGASimpleImage(
                                resUrl: listm[7].waveGifImg!,
                              )
                                  : const SVGASimpleImage(
                                assetsName:
                                'assets/svga/room_shengbo.svga',
                              ),
                            )
                                : const Text(''),
                            // 头像框静态图
                            (listm[7].avatarFrameGifImg!.isEmpty &&
                                listm[7].avatarFrameImg!.isNotEmpty)
                                ? WidgetUtils.CircleHeadImage(
                                110.h,
                                110.h,
                                listm[7].avatarFrameImg!)
                                : const Text(''),
                            // 头像框动态图
                            listm[7].avatarFrameGifImg!.isNotEmpty
                                ? SizedBox(
                              height: 110.h,
                              width: 110.h,
                              child: SVGASimpleImage(
                                resUrl: listm[7].avatarFrameGifImg!,
                              ),
                            )
                                : const Text(''),
                            Column(
                              children: [
                                m8 == false
                                    ? WidgetUtils.commonSizedBox(180.h, 0)
                                    : WidgetUtils.commonSizedBox(160.h, 0),
                                m8 == false
                                    ? WidgetUtils.onlyTextCenter(
                                    '8号麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(19)))
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == false
                                    ? WidgetUtils.commonSizedBox(10, 0)
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == true
                                    ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    listm[7].nobleID! > 4 ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [MyColors.gz3, MyColors.gz4],
                                        ).createShader(Offset.zero & bounds.size);
                                      },
                                      blendMode: BlendMode.srcATop,
                                      child: Text(
                                        listm[7].nickname! ?? '',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(21),
                                            color: const Color(0xffffffff)),
                                      ),
                                    ) :
                                    WidgetUtils.onlyText(
                                        listm[7].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil()
                                                .setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                                m8 == true
                                    ? SizedBox(
                                  height: 20.h,
                                  child: Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.showImages(
                                          'assets/images/room_xin.png',
                                          ScreenUtil().setHeight(17),
                                          ScreenUtil().setHeight(15)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[7].charm.toString(),
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil()
                                                  .setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                )
                                    : WidgetUtils.commonSizedBox(0, 0),
                              ],
                            ),
                            wherePeople[7] == "8"
                                ? Container(
                              height: 80.h,
                              width: 80.h,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(50.h),
                              ),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/baodeng.svga',
                              ),
                            )
                                : const Text(''),
                            listPeople[7]
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/room_choose_people.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            //pk失败方显示猪头
                            whoWin == 'blue'
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: const SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/pk/room_pk_loser.svga',
                                ),
                              ),
                            )
                                : const Text(''),
                            jianLiWu.contains('8')
                                ? Positioned(
                              child: Container(
                                height: 130.h,
                                width: 130.h,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                                child: SVGAImage(
                                  animationControllerJL,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10 * 2.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 轮播图
  static Widget lunbotu1(BuildContext context,
      List<Map> imgList,) {
    return Positioned(
      top: 10 * 2.w,
      right: 15 * 2.w,
      child: Container(
        height: ScreenUtil().setHeight(130),
        width: ScreenUtil().setHeight(130),
        //超出部分，可裁剪
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            final String url = imgList[index]["url"];
            // 配置图片地址
            if (imgList[index]["type"] == "svga") {
              return SVGASimpleImage(assetsName: url);
            }
            return Padding(
              padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 40.h),
              child: Image.asset(url),
            );
          },
          // 配置图片数量
          itemCount: imgList.length,
          // 无限循环
          loop: true,
          // 自动轮播
          autoplay: true,
          autoplayDelay: 3000,
          duration: 1000,
          onIndexChanged: (index) {
            // LogE('用户拖动或者自动播放引起下标改变调用');
          },
          onTap: (index) {
            switch (imgList[index]["content"]) {
              case 'sc':
                MyUtils.goTransparentPage(context, const ShouChongPage());
                break;
              case 'wf':
                Get.bottomSheet(RoomPlayPage());
                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }

  /// 轮播图2
  static Widget lunbotu2(BuildContext context, List<Map> imgList2,
      String roomid) {
    return Positioned(
      top: 110 * 2.w,
      right: 15 * 2.w,
      child: Container(
        height: ScreenUtil().setHeight(130),
        width: ScreenUtil().setHeight(130),
        //超出部分，可裁剪
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            // 配置图片地址
            return SVGASimpleImage(assetsName: imgList2[index]["url"]);
          },
          // 配置图片数量
          itemCount: imgList2.length,
          // 无限循环
          loop: true,
          // 自动轮播
          autoplay: true,
          autoplayDelay: 2500,
          duration: 1000,
          onIndexChanged: (index) {
            // LogE('用户拖动或者自动播放引起下标改变调用');
          },
          onTap: (index) {
            // LogE('用户点击引起下标改变调用');
            if (index == 0) {
              // 转盘
              MyUtils.goTransparentPage(
                  context,
                  ZhuanPanPage(
                    roomId: roomid,
                  ));
            } else if (index == 1) {
              // 魔方
              MyUtils.goTransparentPage(
                  context,
                  MoFangPage(
                    roomID: roomid,
                  ));
            } else if (index == 2) {
              // 马里奥
              MyUtils.goTransparentPage(context, const Carpage());
            }
          },
        ),
      ),
    );
  }

  /// 厅内底部按钮
  static Widget footBtn(BuildContext context,
      bool isJinyiin,
      int isForbation,
      String roomID,
      int isShow,
      int isBoss,
      bool mima,
      List<MikeList> listM,
      bool roomDX,
      bool roomSY,
      bool isRed,
      bool isMeUp,
      String mxIndex,
      int lixian) {
    // LogE('*** 是否闭麦 $isJinyiin');
    return SizedBox(
      height: ScreenUtil().setHeight(90),
      child: Row(
        children: [
          WidgetUtils.commonSizedBox(0, 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.3,
                child: Row(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setHeight(200),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.roomMaiLiao,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setHeight(200),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          eventBus.fire(SubmitButtonBack(title: '表情'));
                        }
                      }),
                      child: Container(
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/room_xiaolian.png',
                            ScreenUtil().setHeight(50),
                            ScreenUtil().setHeight(50)),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          eventBus.fire(SubmitButtonBack(title: '聊天'));
                        }
                      }),
                      child: Container(
                        width: 100.h,
                        height: 50.h,
                        color: Colors.transparent,
                        child: WidgetUtils.onlyTextCenter(
                            '聊聊...       ',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white70,
                                fontSize: ScreenUtil().setSp(25))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Expanded(child: Text('')),
          Stack(
            children: [
              Container(
                height: ScreenUtil().setHeight(60),
                width: ScreenUtil().setHeight(60),
                color: Colors.transparent,
                child: const SVGASimpleImage(
                    assetsName: 'assets/svga/room_liwu.svga'),
              ),
              GestureDetector(
                onTap: (() {
                  MyUtils.goTransparentPage(
                      context,
                      RoomLiWuPage(
                        listM: listM,
                        uid: '',
                        roomID: roomID,
                      ));
                }),
                child: Container(
                    height: ScreenUtil().setHeight(60),
                    width: ScreenUtil().setHeight(60),
                    color: Colors.transparent),
              )
            ],
          ),
          WidgetUtils.commonSizedBox(0, 5),
          sp.getInt('user_grLevel')! >= 4
              ? Stack(
            children: [
              Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setHeight(50),
                color: Colors.transparent,
                child: const SVGASimpleImage(
                  assetsName: 'assets/svga/room_huodong.svga',
                ),
              ),
              GestureDetector(
                onTap: (() {
                  MyUtils.goTransparentPageCom(
                      context, RoomYouXiPage(roomID: roomID));
                }),
                child: Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setHeight(50),
                    color: Colors.transparent),
              )
            ],
          )
              : const Text(''),
          sp.getInt('user_grLevel')! >= 4
              ? WidgetUtils.commonSizedBox(0, 10)
              : const Text(''),
          //消息
          GestureDetector(
            onTap: (() {
              eventBus.fire(SubmitButtonBack(title: '清空红点'));
              MyUtils.goTransparentPage(context, const RoomMessagesPage());
            }),
            child: Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setHeight(50),
              color: Colors.transparent,
              child: Stack(
                children: [
                  WidgetUtils.showImages('assets/images/room_message.png',
                      ScreenUtil().setHeight(50), ScreenUtil().setHeight(50)),
                  isRed
                      ? Positioned(
                      top: 5.h,
                      right: 5.w,
                      child: Container(
                        width: 15.h,
                        height: 15.h,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: Colors.red,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius:
                          BorderRadius.all(Radius.circular(15.0)),
                        ),
                        alignment: Alignment.center,
                      ))
                      : const Text(''),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          //功能
          GestureDetector(
            onTap: (() {
              MyUtils.goTransparentPage(
                  context,
                  (sp.getString('role').toString() == 'adminer' ||
                      sp.getString('role').toString() == 'leader' ||
                      sp.getString('role').toString() == 'president')
                      ? RoomGongNeng(
                    type: 1,
                    roomID: roomID,
                    isShow: isShow,
                    isBoss: isBoss,
                    roomDX: roomDX,
                    roomSY: roomSY,
                    mima: mima,
                    isLiXian: lixian,
                  )
                      : RoomGongNeng(
                    type: 0,
                    roomID: roomID,
                    isShow: isShow,
                    isBoss: isBoss,
                    roomDX: roomDX,
                    roomSY: roomSY,
                    mima: mima,
                    isLiXian: 0,
                  ));
            }),
            child: Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setHeight(50),
              color: Colors.transparent,
              child: WidgetUtils.showImages('assets/images/room_gongneng.png',
                  ScreenUtil().setHeight(50), ScreenUtil().setHeight(50)),
            ),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          //闭麦
          GestureDetector(
            onTap: (() {
              //如果上麦的人有自己
              if (isMeUp) {
                eventBus.fire(RoomBack(
                    title: '关闭声音',
                    index: (int.parse(mxIndex) - 1).toString()));
              } else {
                MyToastUtils.showToastBottom('不在麦序，无需开启');
              }
            }),
            child: WidgetUtils.showImages(
                isJinyiin
                    ? 'assets/images/room_yin_off.png'
                    : 'assets/images/room_yin_on.png',
                ScreenUtil().setHeight(50),
                ScreenUtil().setHeight(50)),
          ),
          WidgetUtils.commonSizedBox(0, 10),
        ],
      ),
    );
  }

  /// 厅内麦上无人
  static Widget noPeople(List<bool> upOrDown, int i, List<MikeList> listM) {
    if (i == 8) {
      return upOrDown[i] == true &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 300.w,
        top: 200.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(300.w, 200.h, i)
          : const Text('');
    } else if (i == 0) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 35.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(35.w, 400.h, i)
          : const Text('');
    } else if (i == 1) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 215.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(215.w, 400.h, i)
          : const Text('');
    } else if (i == 2) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 390.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(390.w, 400.h, i)
          : const Text('');
    } else if (i == 3) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 570.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(570.w, 400.h, i)
          : const Text('');
    } else if (i == 4) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 35.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(35.w, 560.h, i)
          : const Text('');
    } else if (i == 5) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 215.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(215.w, 560.h, i)
          : const Text('');
    } else if (i == 6) {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 390.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(390.w, 560.h, i)
          : const Text('');
    } else {
      return upOrDown[i] &&
          (sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader' ||
              sp.getString('role').toString() == 'president')
          ? Positioned(
        left: 570.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '上麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listM[i].isLock == 0) {
                        eventBus
                            .fire(RoomBack(title: '锁麦', index: i.toString()));
                      } else {
                        eventBus
                            .fire(RoomBack(title: '解锁', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : upOrDown[i] &&
          (sp.getString('role').toString() == 'user' ||
              sp.getString('role').toString() == 'streamer')
          ? shangmai(570.w, 560.h, i)
          : const Text('');
    }
  }

  ///上麦
  static Widget shangmai(double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setHeight(117),
        decoration: const BoxDecoration(
          //背景
          color: Colors.black87,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          children: [
            Expanded(
                child: GestureDetector(
                  onTap: (() {
                    eventBus.fire(
                        RoomBack(title: '上麦', index: index.toString()));
                  }),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: WidgetUtils.onlyTextCenter(
                        '上麦',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomTCWZ1,
                            fontSize: ScreenUtil().setSp(21))),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  /// 厅内麦上有人，并且是自己
  static Widget isMe(int i, List<MikeList> listm, bool isShow) {
    if (i == 8) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 300.w,
        top: 200.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 0) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 35.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 1) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 215.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 2) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 390.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 3) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 570.w,
        top: 400.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 4) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 35.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 5) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 215.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else if (i == 6) {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 390.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    } else {
      return (listm[i].uid.toString() == sp.getString('user_id').toString() &&
          isShow)
          ? Positioned(
        left: 570.w,
        top: 560.h,
        child: Container(
          height: ScreenUtil().setHeight(104),
          width: ScreenUtil().setHeight(117),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      eventBus
                          .fire(RoomBack(title: '下麦', index: i.toString()));
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
              Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(1),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setHeight(10)),
                color: MyColors.roomTCWZ1,
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (listm[i].isClose == 0) {
                        eventBus.fire(
                            RoomBack(title: '闭麦1', index: i.toString()));
                      } else {
                        eventBus.fire(
                            RoomBack(title: '开麦1', index: i.toString()));
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isClose == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    ),
                  )),
            ],
          ),
        ),
      )
          : const Text('');
    }
  }
}
