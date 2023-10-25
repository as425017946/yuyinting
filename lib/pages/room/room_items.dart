import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/pages/room/room_show_status_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../bean/roomInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/Marquee.dart';
import '../../widget/SVGASimpleImage.dart';
import '../game/car_page.dart';
import '../game/mofang_page.dart';
import '../game/zhuanpan_page.dart';
import '../shouchong/shouchong_page.dart';
import 'room_back_page.dart';
import 'room_bq_page.dart';
import 'room_gongneng.dart';
import 'room_liwu_page.dart';
import 'room_manager_page.dart';
import 'room_messages_page.dart';
import 'room_people_info_page.dart';
import 'room_redu_page.dart';
import 'room_send_info_page.dart';
import 'room_ts_gonggao_page.dart';

/// 厅内信息
class RoomItems {
  /// 互动消息
  static Widget itemMessages(
      BuildContext context, int i, String uid, String roomID, List<Map> list, List<MikeList> listm) {
    if (list[i]['type'] == '0') {
      return Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: Text(
          list[i]['info'],
          maxLines: 50,
          style: TextStyle(
            color: MyColors.jianbian2,
            height: 2,
            fontWeight: FontWeight.w600,
            fontSize: 22.sp
          ),
        ),
      );
    } else if (list[i]['type'] == '1') {
      return Container(
        margin: EdgeInsets.only(bottom: 5.h),
        child: Text(
          list[i]['info'],
          maxLines: 50,
          style: TextStyle(
              color: MyColors.peopleYellow,
              height: 2,
              fontWeight: FontWeight.w600,
              fontSize: 22.sp
          ),
        ),
      );
    } else if (list[i]['type'] == '2') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 5.h),
            padding: EdgeInsets.only( top: 5.h, bottom: 15.h, left: 10.h, right: 10.h
                ),
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
                    child: list[i]['identity'] == 'user'
                        ? const Text('')
                        : WidgetUtils.showImages(
                        'assets/images/dj/room_role_manager.png', 28.h, 28.h)),
                WidgetSpan(child: WidgetUtils.commonSizedBox(0, 2.h)),
                // 萌新/新贵/新锐 三选一
                // 不是新锐新贵，并且是萌新直接显示萌新
                WidgetSpan(
                    child: list[i]['new_noble'] == '0' && list[i]['is_new'] == '1'
                        ? WidgetUtils.showImages(
                        'assets/images/dj/room_role_common.png', 28.h, 50.h)
                        : const Text('')),
                // 不管是不是萌新，只要是新锐或者新贵就优先展示
                WidgetSpan(
                    child: list[i]['new_noble'] == '1'
                        ? WidgetUtils.showImages(
                        'assets/images/shouchong_xinrui.png', 28.h, 50.h)
                        : list[i]['is_pretty'] == '2'
                        ? WidgetUtils.showImages(
                        'assets/images/shouchong_xingui.png', 28.h, 50.h)
                        : const Text('')),
                WidgetSpan(child: WidgetUtils.commonSizedBox(0, 2.h)),
                //等级
                WidgetSpan(
                    child: SizedBox(
                      height: 28.h,
                      width: 28.h,
                      child: Stack(
                        children: [
                          list[i]['lv'] >= 1 && list[i]['lv'] <= 10
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_1-10.png', 28.h, 28.h)
                              : list[i]['lv'] >= 11 && list[i]['lv'] <= 15
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_11-15.png', 28.h, 28.h)
                              : list[i]['lv'] >= 16 && list[i]['lv'] <= 20
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_16-20.png', 28.h, 28.h)
                              : list[i]['lv'] >= 21 && list[i]['lv'] <= 25
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_21-25.png',
                              28.h,
                              28.h)
                              : list[i]['lv'] >= 26 && list[i]['lv'] <= 30
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_26-30.png',
                              28.h,
                              28.h)
                              : list[i]['lv'] >= 31 &&
                              list[i]['lv'] <= 35
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_31-35.png',
                              28.h,
                              28.h)
                              : list[i]['lv'] >= 36 &&
                              list[i]['lv'] <= 40
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_36-40.png',
                              28.h,
                              28.h)
                              : list[i]['lv'] >= 41 &&
                              list[i]['lv'] <= 45
                              ? WidgetUtils.showImages(
                              'assets/images/dj/dj_41-45.png', 28.h, 28.h)
                              : WidgetUtils.showImages('assets/images/dj/dj_46-50.png', 28.h, 28.h),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                Text(
                                  list[i]['lv'].toString(),
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Impact',
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = MyColors.djOneM),
                                ),
                                Text(
                                  list[i]['lv'].toString(),
                                  style: TextStyle(
                                      color: MyColors.djOne,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Impact'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                WidgetSpan(child: WidgetUtils.commonSizedBox(0, 2.h)),
                //贵族
                WidgetSpan(
                  child: list[i]['noble_id'] == 1
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_yongshi.png', 28.h, 28.h)
                      : list[i]['noble_id'] == 2
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_qishi.png', 28.h, 28.h)
                      : list[i]['noble_id'] == 3
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_bojue.png', 28.h, 28.h)
                      : list[i]['noble_id'] == 4
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_houjue.png', 28.h, 28.h)
                      : list[i]['noble_id'] == 5
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_gongjue.png',
                      28.h,
                      28.h)
                      : list[i]['noble_id'] == 6
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_guowang.png',
                      28.h,
                      28.h)
                      : list[i]['noble_id'] == 7
                      ? WidgetUtils.showImages(
                      'assets/images/tequan_diwang.png',
                      28.h,
                      28.h)
                      : const Text(''),
                ),
                WidgetSpan(child: WidgetUtils.commonSizedBox(0, 2.h)),
                // 靓号
                WidgetSpan(
                  child: list[i]['is_pretty'] == '0'
                      ? const Text('')
                      : WidgetUtils.showImages(
                      'assets/images/dj/lianghao.png', 28.h, 28.h),
                ),
                //用户昵称
                WidgetSpan(child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.commonSizedBox(28.h, 10.h),
                    Text(list[i]['info'],
                        style: TextStyle(
                          color: MyColors.roomMessageYellow2,
                          fontSize: 24.sp,
                          height: 2,
                        ))
                  ],
                )),
                // 进入房间
                WidgetSpan(child: Stack(
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
                WidgetSpan(child: WidgetUtils.commonSizedBox(0, 2.h)),
                WidgetSpan(
                    child: GestureDetector(
                      onTap: (() {
                        eventBus.fire(RoomBack(title: '欢迎TA', index: ''));
                      }),
                      child: Container(
                        width: ScreenUtil().setHeight(65),
                        height: ScreenUtil().setHeight(25),
                        margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            WidgetUtils.showImagesFill(
                                'assets/images/room_huanyingta.png',
                                double.infinity,
                                double.infinity),
                            Container(
                              width: ScreenUtil().setHeight(65),
                              height: ScreenUtil().setHeight(25),
                              alignment: Alignment.center,
                              child: Text(
                                '欢迎TA',
                                style: StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(16)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
              ]),
            ),
          ),
        ],
      );
    } else {
      return GestureDetector(
        onTap: (() {
          MyUtils.goTransparentPage(
              context,
              RoomPeopleInfoPage(
                uid: uid,
                index: '-1',
                roomID: roomID,
                isClose: '',
                listM: listm,
              ));
        }),
        child: Column(
          children: [
            Row(
              children: [
                //等级
                WidgetUtils.showImages(
                    'assets/images/dj/dj_1-10.png', 28.h, 28.h),
                WidgetUtils.commonSizedBox(0, 2.h),
                WidgetUtils.onlyText(
                    '昵称',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomMaiWZ,
                        fontSize: ScreenUtil().setSp(24))),
                WidgetUtils.commonSizedBox(0, 2.h),
                //贵族
                WidgetUtils.showImages(
                    'assets/images/tequan_yongshi.png', 28.h, 28.h),
                WidgetUtils.commonSizedBox(0, 2.h),
                //靓号
                WidgetUtils.showImages(
                    'assets/images/dj/lianghao.png', 28.h, 28.h),
                WidgetUtils.commonSizedBox(0, 2.h),
                //萌新
                WidgetUtils.showImages(
                    'assets/images/dj/room_role_common.png', 28.h, 40.h),
                WidgetUtils.commonSizedBox(0, 2.h),
                //厅管
                WidgetUtils.showImages(
                    'assets/images/dj/room_role_manager.png', 28.h, 28.h),
              ],
            ),
            WidgetUtils.commonSizedBox(5, 0),
            Stack(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.roomMaiLiao,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24)),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                '信息',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.transparent,
                                    fontSize: ScreenUtil().setSp(21))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.transparent,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.onlyText(
                              '信息',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(21))),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 0),
          ],
        ),
      );
    }
  }

  /// 头部信息
  static Widget roomTop(
      BuildContext context,
      String roomHeadImg,
      String roomName,
      String roomNumber,
      String follow_status,
      String hot_degree,
      String roomID) {
    return Row(
      children: [
        WidgetUtils.commonSizedBox(0, 20),
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentPage(
                context,
                RoomManagerPage(
                  type: sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader'
                      ? 1
                      : 0,
                  roomID: roomID,
                ));
          }),
          child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(55),
              ScreenUtil().setHeight(55), roomHeadImg),
        ),
        WidgetUtils.commonSizedBox(0, 5),
        Column(
          children: [
            SizedBox(
              width: ScreenUtil().setHeight(100),
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
            WidgetUtils.commonSizedBox(5, 0),
            SizedBox(
              width: ScreenUtil().setHeight(100),
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
                  eventBus.fire(RoomBack(title: '收藏', index: ''));
                }),
                child: SizedBox(
                  width: ScreenUtil().setHeight(60),
                  height: ScreenUtil().setHeight(32),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.showImagesFill(
                          'assets/images/room_shoucang.png',
                          double.infinity,
                          double.infinity),
                      Container(
                        width: ScreenUtil().setHeight(60),
                        height: ScreenUtil().setHeight(32),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(
                                ScreenUtil().setHeight(2), 0),
                            Text(
                              '收藏',
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
              )
            : GestureDetector(
                onTap: (() {
                  eventBus.fire(RoomBack(title: '取消收藏', index: ''));
                }),
                child: Stack(
                  children: [
                    Opacity(
                        opacity: 0.3,
                        child: Container(
                          width: ScreenUtil().setHeight(80),
                          height: ScreenUtil().setHeight(38),
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.roomMaiLiao,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        )),
                    Container(
                      width: ScreenUtil().setHeight(80),
                      height: ScreenUtil().setHeight(38),
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
                  width: ScreenUtil().setHeight(70),
                  height: ScreenUtil().setHeight(30),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.roomMaiLiao,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                )),
            GestureDetector(
              onTap: (() {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      //自定义路由
                      opaque: false,
                      pageBuilder: (context, a, _) => RoomReDuPage(
                        roomID: roomID,
                      ),
                      //需要跳转的页面
                      transitionsBuilder: (context, a, _, child) {
                        const begin =
                            Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                        const end = Offset.zero; //得到Offset.zero坐标值
                        const curve = Curves.ease; //这是一个曲线动画
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                        return SlideTransition(
                          //转场动画//目前我认为只能用于跳转效果
                          position: a.drive(tween), //这里将获得一个新的动画
                          child: child,
                        );
                      },
                    ),
                  );
                });
              }),
              child: SizedBox(
                width: ScreenUtil().setHeight(70),
                height: ScreenUtil().setHeight(30),
                child: Row(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImagesFill('assets/images/room_hot.png',
                        ScreenUtil().setHeight(18), ScreenUtil().setHeight(15)),
                    WidgetUtils.commonSizedBox(0, 2),
                    WidgetUtils.onlyTextCenter(
                        hot_degree,
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.roomID,
                            fontSize: ScreenUtil().setSp(18))),
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
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return const RoomBackPage();
                  }));
            });
          }),
          child: SizedBox(
              height: ScreenUtil().setHeight(32),
              width: ScreenUtil().setHeight(79),
              child: WidgetUtils.showImages('assets/images/room_dian.png',
                  ScreenUtil().setHeight(32), ScreenUtil().setHeight(7))),
        ),
      ],
    );
  }

  /// 公告厅主
  static Widget notices(BuildContext context, bool m0, String notice,
      List<MikeList> listm, String roomID) {
    return Row(
      children: [
        WidgetUtils.commonSizedBox(0, 20),
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
          offset: const Offset(0, -30),
          child: GestureDetector(
            onTap: (() {
              if (listm[8].isLock == 0) {
                if (m0 == true) {
                  if (listm[8].uid.toString() ==
                      sp.getString('user_id').toString()) {
                    eventBus.fire(RoomBack(title: '自己', index: '8'));
                  } else {
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
                } else {
                  eventBus.fire(RoomBack(title: '空位置', index: '8'));
                }
              } else {
                if (sp.getString('role').toString() == 'adminer' ||
                    sp.getString('role').toString() == 'leader') {
                  eventBus.fire(RoomBack(title: '空位置', index: '8'));
                } else {
                  MyToastUtils.showToastBottom('麦位已锁');
                }
              }
            }),
            child: SizedBox(
              width: ScreenUtil().setHeight(180),
              height: ScreenUtil().setHeight(240),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  m0 == true
                      ? SVGASimpleImage(
                          resUrl: listm[8].waveGifImg!,
                        )
                      : listm[8].isLock == 0
                          ? WidgetUtils.showImages(
                              'assets/images/room_mai.png',
                              ScreenUtil().setHeight(110),
                              ScreenUtil().setHeight(110))
                          : WidgetUtils.showImages(
                              'assets/images/room_suo.png',
                              ScreenUtil().setHeight(110),
                              ScreenUtil().setHeight(110)),
                  m0 == true
                      ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(110),
                          ScreenUtil().setHeight(110), listm[8].avatar!)
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
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    listm[8].nickname!.length > 6
                                        ? '${listm[8].nickname!.substring(0, 6)}...'
                                        : listm[8].nickname!,
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
                ],
              ),
            ),
          ),
        ),
        const Expanded(child: Text('')),
        WidgetUtils.commonSizedBox(0, 20),
      ],
    );
  }

  /// 麦序位置
  static Widget maixu(
      BuildContext context,
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
      String roomID) {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 10),
              GestureDetector(
                onTap: (() {
                  if (listm[0].isLock == 0) {
                    if (m1) {
                      if (listm[0].uid.toString() ==
                          sp.getString('user_id').toString()) {
                        eventBus.fire(RoomBack(title: '自己', index: '0'));
                      } else {
                        MyUtils.goTransparentPage(
                            context,
                            RoomPeopleInfoPage(
                                uid: listm[0].uid.toString(),
                                index: '0',
                                roomID: roomID,
                                isClose: listm[0].isClose.toString(),listM: listm,));
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '0'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader') {
                      eventBus.fire(RoomBack(title: '空位置', index: '0'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setHeight(140),
                  height: ScreenUtil().setHeight(190),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m1 == true
                          ? SVGASimpleImage(
                              resUrl: listm[0].waveGifImg!,
                            )
                          : const Text(''),
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
                      Column(
                        children: [
                          const Expanded(child: Text('')),
                          m1 == false
                              ? WidgetUtils.onlyTextCenter(
                                  '1号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == false
                              ? WidgetUtils.commonSizedBox(15, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == true
                              ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[0].nickname!.length > 6
                                            ? '${listm[0].nickname!.substring(0, 6)}...'
                                            : listm[0].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m1 == true
                              ? Row(
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
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      )
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
                        MyUtils.goTransparentPage(
                            context,
                            RoomPeopleInfoPage(
                                uid: listm[1].uid.toString(),
                                index: '1',
                                roomID: roomID,
                                isClose: listm[1].isClose.toString(),listM: listm,));
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '1'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader') {
                      eventBus.fire(RoomBack(title: '空位置', index: '1'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setHeight(140),
                  height: ScreenUtil().setHeight(190),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m2 == true
                          ? SVGASimpleImage(
                              resUrl: listm[1].waveGifImg!,
                            )
                          : const Text(''),
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
                      Column(
                        children: [
                          const Expanded(child: Text('')),
                          m2 == false
                              ? WidgetUtils.onlyTextCenter(
                                  '2号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == false
                              ? WidgetUtils.commonSizedBox(15, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == true
                              ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[1].nickname!.length > 6
                                            ? '${listm[1].nickname!.substring(0, 6)}...'
                                            : listm[1].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m2 == true
                              ? Row(
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
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      )
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
                        MyUtils.goTransparentPage(
                            context,
                            RoomPeopleInfoPage(
                                uid: listm[2].uid.toString(),
                                index: '2',
                                roomID: roomID,
                                isClose: listm[2].isClose.toString(),listM: listm,));
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '2'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader') {
                      eventBus.fire(RoomBack(title: '空位置', index: '2'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setHeight(140),
                  height: ScreenUtil().setHeight(190),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m3 == true
                          ? SVGASimpleImage(
                              resUrl: listm[2].waveGifImg!,
                            )
                          : const Text(''),
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
                      Column(
                        children: [
                          const Expanded(child: Text('')),
                          m3 == false
                              ? WidgetUtils.onlyTextCenter(
                                  '3号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == false
                              ? WidgetUtils.commonSizedBox(15, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == true
                              ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[2].nickname!.length > 6
                                            ? '${listm[2].nickname!.substring(0, 6)}...'
                                            : listm[2].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m3 == true
                              ? Row(
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
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      )
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
                        MyUtils.goTransparentPage(
                            context,
                            RoomPeopleInfoPage(
                                uid: listm[3].uid.toString(),
                                index: '3',
                                roomID: roomID,
                                isClose: listm[3].isClose.toString(),listM: listm,));
                      }
                    } else {
                      eventBus.fire(RoomBack(title: '空位置', index: '3'));
                    }
                  } else {
                    if (sp.getString('role').toString() == 'adminer' ||
                        sp.getString('role').toString() == 'leader') {
                      eventBus.fire(RoomBack(title: '空位置', index: '3'));
                    } else {
                      MyToastUtils.showToastBottom('麦位已锁');
                    }
                  }
                }),
                child: SizedBox(
                  width: ScreenUtil().setHeight(140),
                  height: ScreenUtil().setHeight(190),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      m4 == true
                          ? SVGASimpleImage(
                              resUrl: listm[3].waveGifImg!,
                            )
                          : const Text(''),
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
                      Column(
                        children: [
                          const Expanded(child: Text('')),
                          m4 == false
                              ? WidgetUtils.onlyTextCenter(
                                  '4号麦',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMaiWZ,
                                      fontSize: ScreenUtil().setSp(19)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == false
                              ? WidgetUtils.commonSizedBox(15, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == false
                              ? WidgetUtils.commonSizedBox(10, 0)
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == true
                              ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        listm[3].nickname!.length > 6
                                            ? '${listm[3].nickname!.substring(0, 6)}...'
                                            : listm[3].nickname!,
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                          m4 == true
                              ? Row(
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
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      )
                    ],
                  ),
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
                GestureDetector(
                  onTap: (() {
                    if (listm[4].isLock == 0) {
                      if (m5) {
                        if (listm[4].uid.toString() ==
                            sp.getString('user_id').toString()) {
                          eventBus.fire(RoomBack(title: '自己', index: '4'));
                        } else {
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                  uid: listm[4].uid.toString(),
                                  index: '4',
                                  roomID: roomID,
                                  isClose: listm[4].isClose.toString(),listM: listm,));
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '4'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader') {
                        eventBus.fire(RoomBack(title: '空位置', index: '4'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setHeight(140),
                    height: ScreenUtil().setHeight(190),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m5 == true
                            ? SVGASimpleImage(
                                resUrl: listm[4].waveGifImg!,
                              )
                            : const Text(''),
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
                        Column(
                          children: [
                            const Expanded(child: Text('')),
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
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[4].nickname!.length > 6
                                              ? '${listm[4].nickname!.substring(0, 6)}...'
                                              : listm[4].nickname!,
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m5 == true
                                ? Row(
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
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        )
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
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                  uid: listm[5].uid.toString(),
                                  index: '5',
                                  roomID: roomID,
                                  isClose: listm[5].isClose.toString(),listM: listm,));
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '5'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader') {
                        eventBus.fire(RoomBack(title: '空位置', index: '5'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setHeight(140),
                    height: ScreenUtil().setHeight(190),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m6 == true
                            ? SVGASimpleImage(
                                resUrl: listm[5].waveGifImg!,
                              )
                            : const Text(''),
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
                        Column(
                          children: [
                            const Expanded(child: Text('')),
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
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[5].nickname!.length > 6
                                              ? '${listm[5].nickname!.substring(0, 6)}...'
                                              : listm[5].nickname!,
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m6 == true
                                ? Row(
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
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        )
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
                          MyUtils.goTransparentPage(
                              context,
                              RoomPeopleInfoPage(
                                  uid: listm[6].uid.toString(),
                                  index: '6',
                                  roomID: roomID,
                                  isClose: listm[6].isClose.toString(),listM: listm,));
                        }
                      } else {
                        eventBus.fire(RoomBack(title: '空位置', index: '6'));
                      }
                    } else {
                      if (sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader') {
                        eventBus.fire(RoomBack(title: '空位置', index: '6'));
                      } else {
                        MyToastUtils.showToastBottom('麦位已锁');
                      }
                    }
                  }),
                  child: SizedBox(
                    width: ScreenUtil().setHeight(140),
                    height: ScreenUtil().setHeight(190),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        m7 == true
                            ? SVGASimpleImage(
                                resUrl: listm[6].waveGifImg!,
                              )
                            : const Text(''),
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
                        Column(
                          children: [
                            const Expanded(child: Text('')),
                            m7 == false
                                ? WidgetUtils.onlyTextCenter(
                                    '7号麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(19)))
                                : WidgetUtils.commonSizedBox(0, 0),
                            m7 == false
                                ? WidgetUtils.commonSizedBox(10, 0)
                                : WidgetUtils.commonSizedBox(10, 0),
                            m7 == true
                                ? Row(
                                    children: [
                                      const Expanded(child: Text('')),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          listm[6].nickname!.length > 6
                                              ? '${listm[6].nickname!.substring(0, 6)}...'
                                              : listm[6].nickname!,
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setSp(21))),
                                      const Expanded(child: Text('')),
                                    ],
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                            m7 == true
                                ? Row(
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
                                  )
                                : WidgetUtils.commonSizedBox(0, 0),
                          ],
                        )
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
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                        uid: listm[7].uid.toString(),
                                        index: '7',
                                        roomID: roomID,
                                        isClose: listm[7].isClose.toString() ,listM: listm,));
                              }
                            } else {
                              eventBus.fire(RoomBack(title: '空位置', index: '7'));
                            }
                          } else {
                            if (sp.getString('role').toString() == 'adminer' ||
                                sp.getString('role').toString() == 'leader') {
                              eventBus.fire(RoomBack(title: '空位置', index: '7'));
                            } else {
                              MyToastUtils.showToastBottom('麦位已锁');
                            }
                          }
                        }),
                        child: SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(190),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              m8 == true
                                  ? SVGASimpleImage(
                                      resUrl: listm[7].waveGifImg!,
                                    )
                                  : const Text(''),
                              m8 == true
                                  ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      listm[7].avatar!)
                                  : SizedBox(
                                      height: ScreenUtil().setHeight(80),
                                      width: ScreenUtil().setHeight(80),
                                      child: const SVGASimpleImage(
                                          assetsName:
                                              'assets/svga/laobanwei.svga'),
                                    ),
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
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
                                            WidgetUtils.commonSizedBox(0, 5),
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
                                                listm[7].nickname!.length > 6
                                                    ? '${listm[7].nickname!.substring(0, 6)}...'
                                                    : listm[7].nickname!,
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
                                      ? Row(
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
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                ],
                              )
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
                                MyUtils.goTransparentPage(
                                    context,
                                    RoomPeopleInfoPage(
                                        uid: listm[7].uid.toString(),
                                        index: '7',
                                        roomID: roomID,
                                        isClose: listm[7].isClose.toString(), listM: listm,));
                              }
                            } else {
                              eventBus.fire(RoomBack(title: '空位置', index: '7'));
                            }
                          } else {
                            if (sp.getString('role').toString() == 'adminer' ||
                                sp.getString('role').toString() == 'leader') {
                              eventBus.fire(RoomBack(title: '空位置', index: '7'));
                            } else {
                              MyToastUtils.showToastBottom('麦位已锁');
                            }
                          }
                        }),
                        child: SizedBox(
                          width: ScreenUtil().setHeight(140),
                          height: ScreenUtil().setHeight(190),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              m8 == true
                                  ? SVGASimpleImage(
                                      resUrl: listm[7].waveGifImg!,
                                    )
                                  : const Text(''),
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
                              Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  m8 == false
                                      ? WidgetUtils.onlyTextCenter(
                                          '8号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m8 == false
                                      ? WidgetUtils.commonSizedBox(10, 0)
                                      : WidgetUtils.commonSizedBox(10, 0),
                                  m8 == true
                                      ? Row(
                                          children: [
                                            const Expanded(child: Text('')),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.onlyText(
                                                listm[7].nickname!.length > 6
                                                    ? '${listm[7].nickname!.substring(0, 6)}...'
                                                    : listm[7].nickname!,
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setSp(21))),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  m8 == true
                                      ? Row(
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
                                        )
                                      : WidgetUtils.commonSizedBox(0, 0),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                WidgetUtils.commonSizedBox(0, 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 轮播图
  static Widget lunbotu1(
    BuildContext context,
    List<Map> imgList,
  ) {
    return Positioned(
      top: 10,
      right: 15,
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
            return SVGASimpleImage(assetsName: imgList[index]["url"]);
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
            // LogE('用户点击引起下标改变调用');
            if (index == 0) {
              MyUtils.goTransparentPage(context, const Carpage());
            } else if (index == 1) {
              MyUtils.goTransparentPage(context, const ShouChongPage());
            }
          },
        ),
      ),
    );
  }

  /// 轮播图2
  static Widget lunbotu2(
    BuildContext context,
    List<Map> imgList2,
  ) {
    return Positioned(
      top: 110,
      right: 15,
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
              MyUtils.goTransparentPage(context, const ZhuanPanPage());
            } else if (index == 1) {
              MyUtils.goTransparentPage(context, const MoFangPage());
            }
          },
        ),
      ),
    );
  }

  /// 厅内底部按钮
  static Widget footBtn(BuildContext context, bool isJinyiin, int isForbation,
      String roomID, int isShow, int isBoss, bool mima, List<MikeList> listM) {
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
                        if (isForbation == 0) {
                          MyUtils.goTransparentPage(
                              context, const RoomBQPage());
                        } else {
                          MyToastUtils.showToastBottom('你已被房间禁言！');
                        }
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/room_xiaolian.png',
                          ScreenUtil().setHeight(50),
                          ScreenUtil().setHeight(50)),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    GestureDetector(
                      onTap: (() {
                        if (isForbation == 0) {
                          MyUtils.goTransparentPage(
                              context,
                              RoomSendInfoPage(
                                info: '',
                              ));
                        } else {
                          MyToastUtils.showToastBottom('你已被房间禁言！');
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          '聊聊...       ',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomMaiLiao3,
                              fontSize: ScreenUtil().setSp(25))),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Expanded(child: Text('')),
          Stack(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(60),
                width: ScreenUtil().setHeight(60),
                child: const SVGASimpleImage(
                    assetsName: 'assets/svga/room_liwu.svga'),
              ),
              GestureDetector(
                onTap: (() {
                  MyUtils.goTransparentPageCom(context, const RoomShowStatusPage());
                  MyUtils.goTransparentPage(context, RoomLiWuPage(listM: listM, uid: '',));
                }),
                child: Container(
                    height: ScreenUtil().setHeight(60),
                    width: ScreenUtil().setHeight(60),
                    color: Colors.transparent),
              )
            ],
          ),
          WidgetUtils.commonSizedBox(0, 5),
          Stack(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setHeight(50),
                child: const SVGASimpleImage(
                    assetsName: 'assets/svga/room_huodong.svga'),
              ),
              GestureDetector(
                onTap: (() {

                }),
                child: Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setHeight(50),
                    color: Colors.transparent),
              )
            ],
          ),
          WidgetUtils.commonSizedBox(0, 10),
          //消息
          GestureDetector(
            onTap: (() {
              MyUtils.goTransparentPage(context, const RoomMessagesPage());
            }),
            child: WidgetUtils.showImages('assets/images/room_message.png',
                ScreenUtil().setHeight(50), ScreenUtil().setHeight(50)),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          //功能
          GestureDetector(
            onTap: (() {
              MyUtils.goTransparentPage(
                  context,
                  sp.getString('role').toString() == 'adminer' ||
                          sp.getString('role').toString() == 'leader'
                      ? RoomGongNeng(
                          type: 1,
                          roomID: roomID,
                          isShow: isShow,
                          isBoss: isBoss,
                          roomDX: true,
                          roomSY: true,
                          mima: mima,
                        )
                      : RoomGongNeng(
                          type: 0,
                          roomID: roomID,
                          isShow: isShow,
                          isBoss: isBoss,
                          roomDX: true,
                          roomSY: true,
                          mima: mima,
                        ));
            }),
            child: WidgetUtils.showImages('assets/images/room_gongneng.png',
                ScreenUtil().setHeight(50), ScreenUtil().setHeight(50)),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          //闭麦
          GestureDetector(
            onTap: (() {
              eventBus.fire(RoomBack(title: '关闭声音', index: ''));
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
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 265.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(265.h, 200.h, i)
              : const Text('');
    } else if (i == 0) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 25.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(25.h, 400.h, i)
              : const Text('');
    } else if (i == 1) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 175.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(175.h, 400.h, i)
              : const Text('');
    } else if (i == 2) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 325.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(325.h, 400.h, i)
              : const Text('');
    } else if (i == 3) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 475.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(475.h, 400.h, i)
              : const Text('');
    } else if (i == 4) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 25.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(25.h, 560.h, i)
              : const Text('');
    } else if (i == 5) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 175.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(175.h, 560.h, i)
              : const Text('');
    } else if (i == 6) {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 325.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(325.h, 560.h, i)
              : const Text('');
    } else {
      return upOrDown[i] && sp.getString('role').toString() == 'adminer' ||
              sp.getString('role').toString() == 'leader'
          ? Positioned(
              left: 475.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '上麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                      child: WidgetUtils.onlyTextCenter(
                          listM[i].isLock == 0 ? '锁麦' : '解锁',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : upOrDown[i] && sp.getString('role').toString() == 'user'
              ? shangmai(475.h, 560.h, i)
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
                eventBus.fire(RoomBack(title: '上麦', index: index.toString()));
              }),
              child: WidgetUtils.onlyTextCenter(
                  '上麦',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomTCWZ1,
                      fontSize: ScreenUtil().setSp(21))),
            )),
          ],
        ),
      ),
    );
  }

  /// 厅内麦上有人，并且是自己
  static Widget isMe(int i, List<MikeList> listm, bool isShow) {
    if (i == 8) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 265.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 0) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 25.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 1) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 175.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 2) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 325.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 3) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 475.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 4) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 25.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 5) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 175.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else if (i == 6) {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 325.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    } else {
      return listm[i].uid.toString() == sp.getString('user_id').toString() &&
              isShow
          ? Positioned(
              left: 475.h,
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
                      child: WidgetUtils.onlyTextCenter(
                          '下麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
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
                        if (listm[i].isLock == 0) {
                          eventBus.fire(
                              RoomBack(title: '闭麦1', index: i.toString()));
                        } else {
                          eventBus.fire(
                              RoomBack(title: '开麦1', index: i.toString()));
                        }
                      }),
                      child: WidgetUtils.onlyTextCenter(
                          listm[i].isLock == 0 ? '闭麦' : '开麦',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.roomTCWZ1,
                              fontSize: ScreenUtil().setSp(21))),
                    )),
                  ],
                ),
              ),
            )
          : const Text('');
    }
  }
}
