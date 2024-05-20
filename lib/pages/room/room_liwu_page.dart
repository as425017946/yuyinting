import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/bean/liwuBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_show_liwu_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/balanceBean.dart';
import '../../bean/beibaoBean.dart';
import '../../bean/onlineRoomUserBean.dart';
import '../../bean/roomInfoBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../widget/OptionGridView.dart';
import '../mine/qianbao/dou_pay_page.dart';
import 'mh_page.dart';

/// 厅内礼物
class RoomLiWuPage extends StatefulWidget {
  List<MikeList> listM;
  String uid;
  String roomID;

  RoomLiWuPage(
      {super.key,
      required this.listM,
      required this.uid,
      required this.roomID});

  @override
  State<RoomLiWuPage> createState() => _RoomLiWuPageState();
}

class _RoomLiWuPageState extends State<RoomLiWuPage>
    with SingleTickerProviderStateMixin {
  // 类型 3礼盒
  int leixing = 0;

  // 点击的礼物id
  String giftId = '';

  // 显不显示全麦按钮
  int changdu = 0;

  // 经典
  List<DataL> listC = [];
  List<bool> listCBool = [];

  // 特权
  List<DataL> listPV = [];
  List<bool> listPVBool = [];

  // 背包
  List<Gift> listPl = [];
  List<bool> listPlBool = [];

  // 礼盒
  List<Map> listLH = [
    {
      'name': '青铜礼盒',
      "url": "assets/images/room_lh_qt.png",
      "price": "66",
    },
    {
      'name': '白银礼盒',
      "url": "assets/images/room_lh_by.png",
      "price": "300",
    },
    {
      'name': '黄金礼盒',
      "url": "assets/images/room_lh_hj.png",
      "price": "660",
    },
  ];
  List<bool> listLHBool = [false, false, false];

  // 麦上有几个人是否点击了选中
  List<bool> listChoose = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int shuliang = 1;
  bool isTS = false;

  // 赠送礼物需要的图片
  String imgUrl = '';

  // 选择需要赠送的哪个人
  List<bool> listPeople = [];

  // 是否选了要送的对象(从点击个人信息送的礼物不需要判断此项)
  bool isChoosePeople = false;

  // 赠送数量
  String numbers = '';

  // 是不是点击麦上人进来的
  bool isMaiPeople = false;

  // 被送礼的人是否在麦序上
  int isUpPeopleNum = 0;

  // 是否全麦
  bool isAll = false;

  // 要送的礼物地址
  String url = '', svga = '';

  // 送人的id集合
  List<String> listUID = [];

  //是否点击送礼按钮
  bool isCheck = false;

  // 是否点击了赠送全部背包礼物
  bool isAllBeibao = false;

  // 是否正常礼物  1正常礼物 0减魅力礼物
  bool isReduce = false;

  // 贵族礼物专属提示
  String gzTitle = '送礼';

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if (listChoose[i]) {
            listChoose[i] = false;
            listPeople[listMaiXu[i].serialNumber! - 1] = false;
            listUID.remove(listMaiXu[i].uid.toString());
          } else {
            listChoose[i] = true;
            listPeople[listMaiXu[i].serialNumber! - 1] = true;
            listUID.add(listMaiXu[i].uid.toString());
          }

          int a = 0;
          for (int i = 0; i < listChoose.length; i++) {
            if (listChoose[i] == false) {
              isAll = false;
            } else {
              a++;
            }
          }
          // 是否有选中的人
          if (a > 0) {
            isChoosePeople = true;
          } else {
            isChoosePeople = false;
          }
          if (a == listChoose.length) {
            isAll = true;
          }
        });
        eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
      }),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 10.h, 0),
        height: ScreenUtil().setHeight(60),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(50),
                    ScreenUtil().setHeight(50), listMaiXu[i].avatar!),
                listChoose[i]
                    ? SizedBox(
                        height: 60.h,
                        width: 60.h,
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/r_people_choose.svga',
                        ),
                      )
                    : WidgetUtils.commonSizedBox(60.h, 60.h),
              ],
            ),
            (i == 0 && listMaiXu[i].serialNumber == 9)
                ? WidgetUtils.showImages('assets/images/room_zhuchi.png',
                    ScreenUtil().setHeight(20), ScreenUtil().setHeight(20))
                : Container(
                    width: ScreenUtil().setHeight(20),
                    height: ScreenUtil().setHeight(20),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: MyColors.roomCirle,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(width: 0.5, color: MyColors.roomTCWZ2),
                    ),
                    child: Text(
                      listMaiXu[i].serialNumber.toString(),
                      style: StyleUtils.getCommonTextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(14)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  /// 礼物
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if (leixing == 0) {
            if (listC[index].isReduce == 1) {
              isReduce = true;
            } else {
              isReduce = false;
            }
            //说明要送的人在麦序上
            if (isUpPeopleNum != 0) {
              giftId = listC[index].id.toString();
              for (int i = 0; i < listC.length; i++) {
                listCBool[i] = false;
              }
              listCBool[index] = true;
            } else {
              //点击厅内底部送礼按钮进来的
              if (isMaiPeople) {
                isAll = true;
                for (int i = 0; i < listMaiXu.length; i++) {
                  listChoose[i] = true;
                  listPeople[listMaiXu[i].serialNumber! - 1] = true;
                  isChoosePeople = true;
                  listUID.clear();
                  for (int i = 0; i < listMaiXu.length; i++) {
                    listUID.add(listMaiXu[i].uid.toString());
                  }
                }
                eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
              }
              giftId = listC[index].id.toString();
              for (int i = 0; i < listC.length; i++) {
                listCBool[i] = false;
              }
              listCBool[index] = true;
            }
            url = listC[index].img.toString();
            svga = listC[index].imgRendering.toString();
          } else if (leixing == 1) {
            setState(() {
              gzTitle = '送礼';
            });
            //说明要送的人在麦序上
            if (isUpPeopleNum != 0) {
              giftId = listPV[index].id.toString();
              for (int i = 0; i < listPV.length; i++) {
                listPVBool[i] = false;
              }
              listPVBool[index] = true;
            } else {
              //点击厅内底部送礼按钮进来的
              if (isMaiPeople) {
                isAll = true;
                for (int i = 0; i < listMaiXu.length; i++) {
                  listChoose[i] = true;
                  listPeople[listMaiXu[i].serialNumber! - 1] = true;
                  isChoosePeople = true;
                  listUID.clear();
                  for (int i = 0; i < listMaiXu.length; i++) {
                    listUID.add(listMaiXu[i].uid.toString());
                  }
                }
                eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
              }
              giftId = listPV[index].id.toString();
              for (int i = 0; i < listPV.length; i++) {
                listPVBool[i] = false;
              }
              listPVBool[index] = true;
            }
            url = listPV[index].img.toString();
            svga = listPV[index].imgRendering.toString();

            if (int.parse(sp.getString('nobleID').toString()) <
                listPV[index].nobleID!) {
              switch (listPV[index].nobleID!) {
                case 1:
                  setState(() {
                    gzTitle = '玄仙专属';
                  });
                  break;
                case 2:
                  setState(() {
                    gzTitle = '上仙专属';
                  });
                  break;
                case 3:
                  setState(() {
                    gzTitle = '金仙专属';
                  });
                  break;
                case 4:
                  setState(() {
                    gzTitle = '仙帝专属';
                  });
                  break;
                case 5:
                  setState(() {
                    gzTitle = '主神专属';
                  });
                  break;
                case 6:
                  setState(() {
                    gzTitle = '天神专属';
                  });
                  break;
                case 7:
                  setState(() {
                    gzTitle = '神王专属';
                  });
                  break;
                case 8:
                  setState(() {
                    gzTitle = '神皇专属';
                  });
                  break;
                case 9:
                  setState(() {
                    gzTitle = '天尊专属';
                  });
                  break;
                case 10:
                  setState(() {
                    gzTitle = '传说专属';
                  });
                  break;
              }
            }
          } else if (leixing == 3) {
            //说明要送的人在麦序上
            if (isUpPeopleNum != 0) {
              giftId = listC[index].id.toString();
              for (int i = 0; i < listC.length; i++) {
                listCBool[i] = false;
              }
              listCBool[index] = true;
            } else {
              //点击厅内底部送礼按钮进来的
              if (isMaiPeople) {
                isAll = true;
                for (int i = 0; i < listMaiXu.length; i++) {
                  listChoose[i] = true;
                  listPeople[listMaiXu[i].serialNumber! - 1] = true;
                  isChoosePeople = true;
                  listUID.clear();
                  for (int i = 0; i < listMaiXu.length; i++) {
                    listUID.add(listMaiXu[i].uid.toString());
                  }
                }
                eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
              }
              giftId = listC[index].id.toString();
              for (int i = 0; i < listC.length; i++) {
                listCBool[i] = false;
              }
              listCBool[index] = true;
            }
            giftId = '';
            for (int i = 0; i < listLH.length; i++) {
              listLHBool[i] = false;
            }
            listLHBool[index] = true;

            url = '';
            svga = '';
          } else {
            giftId = listPl[index].id.toString();
            for (int i = 0; i < listPl.length; i++) {
              listPlBool[i] = false;
            }
            listPlBool[index] = true;

            url = listPl[index].img.toString();
            svga = listPl[index].imgRendering.toString();
          }
        });

        _animationController.reset();
        _animationController.forward();
      }),
      child: Container(
        height: 190.h,
        width: 130.h,
        alignment: Alignment.center,
        child: leixing == 0
            ? Stack(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(190),
                    width: ScreenUtil().setHeight(130),
                    child: Column(
                      children: [
                        WidgetUtils.commonSizedBox(10.h, 0),
                        listCBool[index]
                            ? AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _animation.value,
                                    child: WidgetUtils.showImagesNet(
                                        listC[index].img!,
                                        ScreenUtil().setHeight(90),
                                        ScreenUtil().setHeight(90)),
                                  );
                                },
                              )
                            : WidgetUtils.showImagesNet(
                                listC[index].img!,
                                ScreenUtil().setHeight(90),
                                ScreenUtil().setHeight(90)),
                        WidgetUtils.onlyTextCenter(
                            listC[index].name!,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.onlyTextCenter(
                            '${listC[index].price}金豆',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ3,
                                fontSize: ScreenUtil().setSp(21))),
                      ],
                    ),
                  ),
                  listCBool[index]
                      ? WidgetUtils.showImagesFill(
                          'assets/images/room_liwu_bg.png',
                          ScreenUtil().setHeight(190),
                          ScreenUtil().setHeight(130))
                      : const Text(''),
                ],
              )
            : leixing == 1
                ? Stack(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(190),
                        width: ScreenUtil().setHeight(130),
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(10.h, 0),
                            listPVBool[index]
                                ? AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _animation.value,
                                        child: WidgetUtils.showImagesNet(
                                            listPV[index].img!,
                                            ScreenUtil().setHeight(90),
                                            ScreenUtil().setHeight(90)),
                                      );
                                    },
                                  )
                                : WidgetUtils.showImagesNet(
                                    listPV[index].img!,
                                    ScreenUtil().setHeight(90),
                                    ScreenUtil().setHeight(90)),
                            WidgetUtils.onlyTextCenter(
                                listPV[index].name!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                            WidgetUtils.onlyTextCenter(
                                '${listPV[index].price}金豆',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ3,
                                    fontSize: ScreenUtil().setSp(21))),
                          ],
                        ),
                      ),
                      int.parse(sp.getString('nobleID').toString()) <
                              listPV[index].nobleID!
                          ? Positioned(
                              top: 10.h,
                              right: 10.w,
                              child: WidgetUtils.showImages(
                                  'assets/images/tequan_white_suo.png',
                                  20.w,
                                  20.w))
                          : WidgetUtils.commonSizedBox(0, 0),
                      listPVBool[index]
                          ? WidgetUtils.showImagesFill(
                              'assets/images/room_liwu_bg.png',
                              ScreenUtil().setHeight(190),
                              ScreenUtil().setHeight(130))
                          : const Text(''),
                    ],
                  )
                : leixing == 3
                    ? Stack(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(190),
                            width: ScreenUtil().setHeight(130),
                            child: Column(
                              children: [
                                WidgetUtils.commonSizedBox(10.h, 0),
                                listLHBool[index]
                                    ? AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _animation.value,
                                            child: WidgetUtils.showImages(
                                                listLH[index]['url'],
                                                ScreenUtil().setHeight(90),
                                                ScreenUtil().setHeight(90)),
                                          );
                                        },
                                      )
                                    : WidgetUtils.showImages(
                                        listLH[index]['url'],
                                        ScreenUtil().setHeight(90),
                                        ScreenUtil().setHeight(90)),
                                WidgetUtils.onlyTextCenter(
                                    listLH[index]['name'],
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ2,
                                        fontSize: ScreenUtil().setSp(25))),
                                WidgetUtils.onlyTextCenter(
                                    '${listLH[index]['price']}金豆',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(21))),
                              ],
                            ),
                          ),
                          listLHBool[index]
                              ? WidgetUtils.showImagesFill(
                                  'assets/images/room_liwu_bg.png',
                                  ScreenUtil().setHeight(190),
                                  ScreenUtil().setHeight(130))
                              : const Text(''),
                        ],
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(190),
                            width: ScreenUtil().setHeight(130),
                            child: Column(
                              children: [
                                WidgetUtils.commonSizedBox(10.h, 0),
                                Stack(
                                  children: [
                                    listPlBool[index]
                                        ? AnimatedBuilder(
                                            animation: _animation,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: _animation.value,
                                                child:
                                                    WidgetUtils.showImagesNet(
                                                        listPl[index].img!,
                                                        ScreenUtil()
                                                            .setHeight(90),
                                                        ScreenUtil()
                                                            .setHeight(90)),
                                              );
                                            },
                                          )
                                        : WidgetUtils.showImagesNet(
                                            listPl[index].img!,
                                            ScreenUtil().setHeight(90),
                                            ScreenUtil().setHeight(90)),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(5.h),
                                          decoration: BoxDecoration(
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.h)),
                                            //设置四周边框
                                            border: Border.all(
                                                width: 1, color: MyColors.lbL),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            listPl[index].number!.toString(),
                                            style: TextStyle(
                                              color: MyColors.lbL,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                WidgetUtils.onlyTextCenter(
                                    listPl[index].name!,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ2,
                                        fontSize: ScreenUtil().setSp(25))),
                                WidgetUtils.onlyTextCenter(
                                    '${listPl[index].price}金豆',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ3,
                                        fontSize: ScreenUtil().setSp(21))),
                              ],
                            ),
                          ),
                          listPlBool[index]
                              ? WidgetUtils.showImagesFill(
                                  'assets/images/room_liwu_bg.png',
                                  ScreenUtil().setHeight(190),
                                  ScreenUtil().setHeight(130))
                              : const Text(''),
                        ],
                      ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 10; i++) {
      listPeople.add(false);
    }
    setState(() {
      for (int i = 0; i < widget.listM.length; i++) {
        listChoose.add(false);
      }
    });
    doPostBalance();
    doPostOnlineRoomUser();
    doPostGiftList();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    /// 缩小至 0.2倍大小，放大至3倍大小 非线性动画
    _animation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    eventBus.fire(ResidentBack(isBack: true));
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          for (int i = 0; i < listPeople.length; i++) {
            listPeople[i] = false;
          }
          eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
          eventBus.fire(ResidentBack(isBack: true));
          Navigator.pop(context);
          return false;
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      for (int i = 0; i < listPeople.length; i++) {
                        listPeople[i] = false;
                      }
                      eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
                      eventBus.fire(ResidentBack(isBack: true));
                      Navigator.pop(context);
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                leixing == 3
                    ? GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentPage(context, const MHPage());
                        }),
                        child: Container(
                          height: 60.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              WidgetUtils.showImagesFill(
                                  'assets/images/room_lh_sm.png',
                                  60.h,
                                  double.infinity),
                              Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 100.w),
                                  WidgetUtils.onlyText(
                                      '惊喜礼盒玩法',
                                      StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: 26.sp,
                                      )),
                                  const Spacer(),
                                  WidgetUtils.onlyText(
                                      '查看详情 》',
                                      StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: 22.sp,
                                      )),
                                  WidgetUtils.commonSizedBox(0, 100.w),
                                ],
                              )
                            ],
                          ),
                        ))
                    : const Text(''),
                Container(
                  height: isMaiPeople ? 640.h : 600.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc1.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Column(
                        children: [
                          WidgetUtils.commonSizedBox(10, 0),
                          // 全麦
                          isMaiPeople
                              ? Container(
                                  height: ScreenUtil().setHeight(60),
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: _itemPeople,
                                        itemCount: listMaiXu.length,
                                      )),
                                      changdu > 0
                                          ? GestureDetector(
                                              onTap: (() {
                                                setState(() {
                                                  for (int i = 0;
                                                      i < listMaiXu.length;
                                                      i++) {
                                                    if (isAll) {
                                                      listChoose[i] = false;
                                                      listPeople[listMaiXu[i]
                                                              .serialNumber! -
                                                          1] = false;
                                                      isChoosePeople = false;
                                                      listUID.clear();
                                                    } else {
                                                      listChoose[i] = true;
                                                      listPeople[listMaiXu[i]
                                                              .serialNumber! -
                                                          1] = true;
                                                      isChoosePeople = true;
                                                      listUID.clear();
                                                      for (int i = 0;
                                                          i < listMaiXu.length;
                                                          i++) {
                                                        listUID.add(listMaiXu[i]
                                                            .uid
                                                            .toString());
                                                      }
                                                    }
                                                  }
                                                  eventBus.fire(
                                                      ChoosePeopleBack(
                                                          listPeople:
                                                              listPeople));
                                                  isAll = !isAll;
                                                });
                                              }),
                                              child: SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(60),
                                                width:
                                                    ScreenUtil().setHeight(80),
                                                child: WidgetUtils.onlyTextCenter(
                                                    isAll ? '取消' : '全麦',
                                                    StyleUtils
                                                        .getCommonTextStyle(
                                                            color: MyColors
                                                                .roomTCWZ2,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        28))),
                                              ),
                                            )
                                          : const Text('')
                                    ],
                                  ),
                                )
                              : WidgetUtils.commonSizedBox(0, 0),
                          isMaiPeople
                              ? WidgetUtils.myLine(
                                  color: MyColors.roomTCWZ3,
                                  endIndent: 20.w,
                                  indent: 20.w,
                                  thickness: 0.5)
                              : WidgetUtils.commonSizedBox(0, 0),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    gzTitle = '送礼';
                                    isTS = false;
                                    shuliang = 1;
                                    isReduce = false;
                                    url = '';
                                    svga = '';
                                    leixing = 0;
                                    giftId = '';
                                    for (int i = 0; i < listPV.length; i++) {
                                      listPVBool[i] = false;
                                    }
                                    for (int i = 0; i < listC.length; i++) {
                                      listCBool[i] = false;
                                    }
                                    for (int i = 0; i < listPl.length; i++) {
                                      listPlBool[i] = false;
                                    }
                                  });
                                }),
                                child: Container(
                                  color: Colors.transparent,
                                  width: 80.h,
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  child: WidgetUtils.onlyTextCenter(
                                      '经典',
                                      StyleUtils.getCommonTextStyle(
                                          color: leixing == 0
                                              ? MyColors.roomTCWZ2
                                              : MyColors.roomTCWZ3,
                                          fontSize: leixing == 0
                                              ? ScreenUtil().setSp(28)
                                              : ScreenUtil().setSp(25))),
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(10),
                                width: ScreenUtil().setWidth(1),
                                color: MyColors.roomTCWZ3,
                              ),
                              sp.getInt('user_grLevel')! >= 4
                                  ? GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          gzTitle = '送礼';
                                          isTS = false;
                                          shuliang = 1;
                                          isReduce = false;
                                          url = '';
                                          svga = '';
                                          leixing = 3;
                                          giftId = '';
                                          for (int i = 0;
                                              i < listPV.length;
                                              i++) {
                                            listPVBool[i] = false;
                                          }
                                          for (int i = 0;
                                              i < listC.length;
                                              i++) {
                                            listCBool[i] = false;
                                          }
                                          for (int i = 0;
                                              i < listPl.length;
                                              i++) {
                                            listPlBool[i] = false;
                                          }
                                        });
                                      }),
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 80.h,
                                        height: 40.h,
                                        child: WidgetUtils.onlyTextCenter(
                                            '礼盒',
                                            StyleUtils.getCommonTextStyle(
                                                color: leixing == 3
                                                    ? MyColors.roomTCWZ2
                                                    : MyColors.roomTCWZ3,
                                                fontSize: leixing == 3
                                                    ? ScreenUtil().setSp(28)
                                                    : ScreenUtil().setSp(25))),
                                      ),
                                    )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              sp.getInt('user_grLevel')! >= 4
                                  ? Container(
                                      height: ScreenUtil().setHeight(10),
                                      width: ScreenUtil().setWidth(1),
                                      color: MyColors.roomTCWZ3,
                                    )
                                  : WidgetUtils.commonSizedBox(0, 0),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    gzTitle = '送礼';
                                    isReduce = false;
                                    url = '';
                                    svga = '';
                                    leixing = 1;
                                    giftId = '';
                                    for (int i = 0; i < listPV.length; i++) {
                                      listPVBool[i] = false;
                                    }
                                    for (int i = 0; i < listC.length; i++) {
                                      listCBool[i] = false;
                                    }
                                    for (int i = 0; i < listPl.length; i++) {
                                      listPlBool[i] = false;
                                    }
                                  });
                                  if (listPV.isEmpty) {
                                    doPostGiftList();
                                  }
                                }),
                                child: Container(
                                  color: Colors.transparent,
                                  width: 80.h,
                                  height: 40.h,
                                  child: WidgetUtils.onlyTextCenter(
                                      '特权',
                                      StyleUtils.getCommonTextStyle(
                                          color: leixing == 1
                                              ? MyColors.roomTCWZ2
                                              : MyColors.roomTCWZ3,
                                          fontSize: leixing == 1
                                              ? ScreenUtil().setSp(28)
                                              : ScreenUtil().setSp(25))),
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(10),
                                width: ScreenUtil().setWidth(1),
                                color: MyColors.roomTCWZ3,
                              ),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    gzTitle = '送礼';
                                    isTS = false;
                                    shuliang = 1;
                                    isReduce = false;
                                    url = '';
                                    svga = '';
                                    leixing = 2;
                                    giftId = '';
                                    for (int i = 0;
                                    i < listPV.length;
                                    i++) {
                                      listPVBool[i] = false;
                                    }
                                    for (int i = 0;
                                    i < listC.length;
                                    i++) {
                                      listCBool[i] = false;
                                    }
                                    for (int i = 0;
                                    i < listPl.length;
                                    i++) {
                                      listPlBool[i] = false;
                                    }
                                  });
                                  if (listPl.isEmpty) {
                                    doPostGiftListBB();
                                  }
                                }),
                                child: Container(
                                  color: Colors.transparent,
                                  width: 80.h,
                                  height: 40.h,
                                  child: WidgetUtils.onlyTextCenter(
                                      '背包',
                                      StyleUtils.getCommonTextStyle(
                                          color: leixing == 2
                                              ? MyColors.roomTCWZ2
                                              : MyColors.roomTCWZ3,
                                          fontSize: leixing == 2
                                              ? ScreenUtil().setSp(28)
                                              : ScreenUtil().setSp(25))),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(0, 10.w),
                              leixing == 2
                                  ? WidgetUtils.onlyTextCenter(
                                      '总价值：$zonge',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ2,
                                          fontSize: ScreenUtil().setSp(25)))
                                  : const Text(''),
                              const Spacer(),
                              leixing == 2
                                  ? GestureDetector(
                                      onTap: (() {
                                        if (MyUtils.checkClick() &&
                                            isAllBeibao == false) {
                                          setState(() {
                                            isAllBeibao = true;
                                            if (listUID.length > 1) {
                                              isAllBeibao = false;
                                              MyToastUtils.showToastBottom(
                                                  '赠送全部礼物只能选一个人');
                                              return;
                                            } else {
                                              if (listUID.isEmpty) {
                                                isAllBeibao = false;
                                                MyToastUtils.showToastBottom(
                                                    '请选择要赠送的人');
                                              } else {
                                                doPostOneClickPackageGift();
                                              }
                                            }
                                          });
                                        }
                                      }),
                                      child: WidgetUtils.onlyTextCenter(
                                          '赠送全部',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMessageYellow,
                                              fontSize:
                                                  ScreenUtil().setSp(28))),
                                    )
                                  : const Text(''),
                              WidgetUtils.commonSizedBox(0, 20.w),
                            ],
                          ),

                          /// 展示礼物-经典
                          leixing == 0
                              ? Expanded(
                                  child: SingleChildScrollView(
                                  child: OptionGridView(
                                    padding:
                                        EdgeInsets.fromLTRB(20.h, 20.h, 0, 0),
                                    itemCount: listC.length,
                                    rowCount: 4,
                                    mainAxisSpacing: 10.h,
                                    // 上下间距
                                    crossAxisSpacing: 0.h,
                                    //左右间距
                                    itemBuilder: _initlistdata,
                                  ),
                                ))
                              : leixing == 1
                                  ?

                                  /// 展示礼物-特权
                                  Expanded(
                                      child: SingleChildScrollView(
                                      child: OptionGridView(
                                        padding: EdgeInsets.fromLTRB(
                                            20.h, 20.h, 0, 0),
                                        itemCount: listPV.length,
                                        rowCount: 4,
                                        mainAxisSpacing: 10.h,
                                        // 上下间距
                                        crossAxisSpacing: 0.h,
                                        //左右间距
                                        itemBuilder: _initlistdata,
                                      ),
                                    ))
                                  : leixing == 3
                                      ?

                                      /// 展示礼物-礼盒
                                      Expanded(
                                          child: SingleChildScrollView(
                                          child: OptionGridView(
                                            padding: EdgeInsets.fromLTRB(
                                                20.h, 20.h, 0, 0),
                                            itemCount: listLH.length,
                                            rowCount: 4,
                                            mainAxisSpacing: 10.h,
                                            // 上下间距
                                            crossAxisSpacing: 0.h,
                                            //左右间距
                                            itemBuilder: _initlistdata,
                                          ),
                                        ))
                                      :

                                      /// 展示礼物-背包
                                      Expanded(
                                          child: SingleChildScrollView(
                                          child: OptionGridView(
                                            padding: EdgeInsets.fromLTRB(
                                                20.h, 20.h, 0, 0),
                                            itemCount: listPl.length,
                                            rowCount: 4,
                                            mainAxisSpacing: 10.h,
                                            // 上下间距
                                            crossAxisSpacing: 0.h,
                                            //左右间距
                                            itemBuilder: _initlistdata,
                                          ),
                                        )),

                          /// 底部送礼
                          Container(
                            height: ScreenUtil().setHeight(100),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                WidgetUtils.commonSizedBox(0, 20),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (() {
                                      MyUtils.goTransparentPageCom(
                                          context,
                                          DouPayPage(
                                            shuliang: jinbi,
                                          ));
                                    }),
                                    child: Row(
                                      children: [
                                        WidgetUtils.showImages(
                                            'assets/images/mine_wallet_dd.png',
                                            ScreenUtil().setHeight(26),
                                            ScreenUtil().setHeight(24)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyTextCenter(
                                            jinbi,
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(25))),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        //钻石处先隐藏
                                        // WidgetUtils.showImages(
                                        //     'assets/images/mine_wallet_zz.png',
                                        //     ScreenUtil().setHeight(26),
                                        //     ScreenUtil().setHeight(24)),
                                        // WidgetUtils.commonSizedBox(0, 5),
                                        // WidgetUtils.onlyTextCenter(
                                        //     zuanshi2,
                                        //     StyleUtils.getCommonTextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: ScreenUtil().setSp(25))),
                                        // WidgetUtils.commonSizedBox(0, 5),
                                        Image(
                                          image: const AssetImage(
                                              'assets/images/mine_more.png'),
                                          width: ScreenUtil().setHeight(8),
                                          height: ScreenUtil().setHeight(15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(58),
                                  width: ScreenUtil().setHeight(250),
                                  decoration: const BoxDecoration(
                                    //设置Container修饰
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage(
                                          "assets/images/room_liwu_songli.png"),
                                      fit: BoxFit.fill, //覆盖
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            isTS = !isTS;
                                          });
                                        }),
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              const Expanded(child: Text('')),
                                              WidgetUtils.onlyTextCenter(
                                                  shuliang.toString(),
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(25))),
                                              WidgetUtils.commonSizedBox(0, 10),
                                              WidgetUtils.showImages(
                                                  'assets/images/room_liwu_shang.png',
                                                  ScreenUtil().setHeight(16),
                                                  ScreenUtil().setHeight(9)),
                                              const Expanded(child: Text('')),
                                            ],
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: (() {
                                          // eventBus.fire(LiWuShowBack(url: imgUrl, listPeople: listPeople, numbers: numbers));
                                          if (isCheck == false) {
                                            setState(() {
                                              isCheck = true;
                                            });
                                            if (isMaiPeople == false) {
                                              if (leixing != 3) {
                                                if (giftId.isEmpty) {
                                                  setState(() {
                                                    isCheck = false;
                                                  });
                                                  MyToastUtils.showToastBottom(
                                                      '请选择要送的礼物');
                                                  return;
                                                } else {
                                                  doPostSendGift();
                                                }
                                              } else {
                                                doPostPlayBlindBox();
                                              }
                                            } else {
                                              if (isChoosePeople == false) {
                                                setState(() {
                                                  isCheck = false;
                                                });
                                                MyToastUtils.showToastBottom(
                                                    '请选择要送的对象');
                                                return;
                                              } else {
                                                if (leixing == 3) {
                                                  doPostPlayBlindBox();
                                                } else {
                                                  if (giftId.isEmpty) {
                                                    setState(() {
                                                      isCheck = false;
                                                    });
                                                    MyToastUtils
                                                        .showToastBottom(
                                                            '请选择要送的礼物');
                                                    return;
                                                  } else {
                                                    doPostSendGift();
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }),
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: Colors.transparent,
                                          child: WidgetUtils.onlyTextCenter(
                                              gzTitle,
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(31))),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(0, 20),
                              ],
                            ),
                          )
                        ],
                      ),
                      isTS
                          ? Container(
                              height: leixing != 3 ? 450.h : 350.h,
                              width: 250.h,
                              margin:
                                  EdgeInsets.only(right: 30.h, bottom: 90.h),
                              decoration: const BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              child: Column(
                                children: [
                                  if (leixing != 3)
                                    GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          shuliang = 1314;
                                          isTS = false;
                                        });
                                      }),
                                      child: Container(
                                        height: 50.h,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                              width: 120.h,
                                              child: WidgetUtils.onlyTextCenter(
                                                  '1314',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 24.sp,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            WidgetUtils.onlyText(
                                                '一生一世',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            WidgetUtils.commonSizedBox(0, 20.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (leixing != 3)
                                    GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          shuliang = 666;
                                          isTS = false;
                                        });
                                      }),
                                      child: Container(
                                        height: 50.h,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                              width: 120.h,
                                              child: WidgetUtils.onlyTextCenter(
                                                  '666',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 24.sp,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            WidgetUtils.onlyText(
                                                '大吉大利',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.black,
                                                    fontSize: 22.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            WidgetUtils.commonSizedBox(0, 20.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 520;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '520',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '我爱你',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 188;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '188',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '要抱抱',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 99;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '99',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '长长久久',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 66;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '66',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '六六大顺',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 10;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '10',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '十全十美',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 5;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '5',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '五福临门',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        shuliang = 1;
                                        isTS = false;
                                      });
                                    }),
                                    child: Container(
                                      height: 50.h,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 50.h,
                                            width: 120.h,
                                            child: WidgetUtils.onlyTextCenter(
                                                '1',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 24.sp,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          WidgetUtils.onlyText(
                                              '一心一意',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.commonSizedBox(0, 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Text('')
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取礼物列表
  Future<void> doPostGiftList() async {
    LogE('token ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'type': leixing,
    };
    Loading.show();
    try {
      liwuBean bean = await DataUtils.postGiftList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (leixing == 0) {
              listC.clear();
              listCBool.clear();
              listC = bean.data!;
              for (int i = 0; i < listC.length; i++) {
                listCBool.add(false);
              }
            } else if (leixing == 1) {
              listPV.clear();
              listPVBool.clear();
              listPV = bean.data!;
              for (int i = 0; i < listPV.length; i++) {
                listPVBool.add(false);
              }
            }
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

  /// 获取背包礼物
  String zonge = '';

  // 赠送全部礼物使用
  List<String> listurl = [];

  Future<void> doPostGiftListBB() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '2',
    };
    Loading.show();
    try {
      beibaoBean bean = await DataUtils.postGiftListBB(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listPl.clear();
            listPlBool.clear();
            listPl = bean.data!.gift!;
            for (int i = 0; i < listPl.length; i++) {
              listPlBool.add(false);
            }
            zonge = bean.data!.total!;

            // 添加背包的svga路径地址
            for (int i = 0; i < bean.data!.gift!.length; i++) {
              if (bean.data!.gift![i].imgRendering!.isNotEmpty) {
                listurl.add(bean.data!.gift![i].imgRendering!);
              }
            }
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

  List<DataMX> listMaiXu = [];

  /// 房间麦序在线用户
  Future<void> doPostOnlineRoomUser() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      onlineRoomUserBean bean = await DataUtils.postOnlineRoomUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listMaiXu.clear();
            for (int i = 0; i < bean.data!.length; i++) {
              if (bean.data![i].serialNumber == 9) {
                listMaiXu.add(bean.data![i]);
                break;
              }
            }
            for (int i = 0; i < bean.data!.length; i++) {
              if (bean.data![i].serialNumber != 9) {
                listMaiXu.add(bean.data![i]);
              }
            }
            changdu = listMaiXu.length;

            /// 点击礼物栏进来的
            if (widget.uid.isEmpty) {
              setState(() {
                isMaiPeople = true;
              });
            } else {
              ///点击的人进来的
              //点击麦上的人进来的送礼物，要直接写入送人的信息
              isChoosePeople = true;
              listUID.add(widget.uid);
              //判断传过来的uid是不是点击麦上的人过来的
              for (int i = 0; i < listMaiXu.length; i++) {
                //传过来的id在麦序上
                if (widget.uid == listMaiXu[i].uid.toString()) {
                  //如果送的人在麦序上
                  isUpPeopleNum++;
                  if (i == 8) {
                    listChoose[0] = true;
                  } else {
                    listChoose[i] = true;
                  }
                  setState(() {
                    isMaiPeople = true;
                  });
                  break;
                }
              }
              // 房间内选中使用
              for (int i = 0; i < widget.listM.length; i++) {
                if (widget.uid == widget.listM[i].uid.toString()) {
                  setState(() {
                    isMaiPeople = true;
                    listPeople[i] = true;
                  });
                  eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
                  break;
                }
              }
            }
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
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 送礼物
  Future<void> doPostSendGift() async {
    String toUids = '';
    setState(() {
      listUID = listUID.toSet().toList();
    });
    for (int i = 0; i < listUID.length; i++) {
      if (toUids.isEmpty) {
        toUids = listUID[i];
      } else {
        toUids = '$toUids,${listUID[i]}';
      }
    }
    if (giftId.isEmpty) {
      setState(() {
        isCheck = false;
      });
      MyToastUtils.showToastBottom('请选择要送的礼物');
      return;
    }
    if (toUids.isEmpty) {
      setState(() {
        isCheck = false;
      });
      MyToastUtils.showToastBottom('请选择要送的对象');
      return;
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'to_uids': toUids, //收礼物用户uid（多个用户,分割 2,26,32）
      'gift_id': giftId,
      'gift_number': shuliang.toString(),
      'gift_type': (leixing + 1).toString(),
    };
    try {
      CommonBean bean = await DataUtils.postSendGift(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostBalance();
          setState(() {
            isCheck = false;
          });
          MyToastUtils.showToastBottom('打赏成功~');
          if(leixing == 2){
            for (int i = 0; i < listPlBool.length; i++) {
              if(listPlBool[i] && listPl[i].number != 0){
                listPl[i].number = listPl[i].number! - shuliang;
              }
            }
          }
          // ignore: use_build_context_synchronously
          // Navigator.pop(context);
          eventBus.fire(ResidentBack(isBack: true));
          // ignore: use_build_context_synchronously
          if (svga.isEmpty) {
            listPeople[9] = true;
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context, RoomShowLiWuPage(listPeople: listPeople, url: url));
          } else {
            // for (int i = 0; i < listPeople.length; i++) {
            //   listPeople[i] = false;
            // }
            eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
            eventBus.fire(SVGABack(
                isAll: false, url: svga, listurl: listurl, isJian: isReduce));
            LogE('赠送svga礼物  $svga');
          }
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          setState(() {
            isCheck = false;
          });
          break;
      }
    } catch (e) {
      setState(() {
        isCheck = false;
      });
      // MyToastUtils.showToastBottom(e.toString());
    }
  }

  /// 一键赠送背包礼物
  Future<void> doPostOneClickPackageGift() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'to_uid': listUID[0], //收礼物用户uid
    };
    try {
      CommonBean bean = await DataUtils.postOneClickPackageGift(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(ResidentBack(isBack: true));
          setState(() {
            isAllBeibao = false;
            for (int i = 0; i < listPeople.length; i++) {
              listPeople[i] = false;
            }
            eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
          });
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // 赠送成功发通知
          eventBus.fire(
              SVGABack(isAll: true, url: url, listurl: listurl, isJian: false));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          setState(() {
            isAllBeibao = false;
          });
          break;
      }
    } catch (e) {
      setState(() {
        isAllBeibao = false;
      });
      // MyToastUtils.showToastBottom(e.toString());
    }
  }

  /// 盲盒送礼
  Future<void> doPostPlayBlindBox() async {
    String toUids = '';
    setState(() {
      listUID = listUID.toSet().toList();
    });
    for (int i = 0; i < listUID.length; i++) {
      if (toUids.isEmpty) {
        toUids = listUID[i];
      } else {
        toUids = '$toUids,${listUID[i]}';
      }
    }

    String mh = '';
    for (int i = 0; i < listLHBool.length; i++) {
      if (listLHBool[i]) {
        mh = (i + 1).toString();
      }
    }
    if (mh.isEmpty) {
      setState(() {
        isCheck = false;
      });
      MyToastUtils.showToastBottom('请选择要送的礼物');
      return;
    }
    if (toUids.isEmpty) {
      setState(() {
        isCheck = false;
      });
      MyToastUtils.showToastBottom('请选择要送的对象');
      return;
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'to_uids': toUids, //收礼物用户uid（多个用户,分割 2,26,32）
      'box_id': mh,
      'number': shuliang.toString(),
    };
    try {
      CommonBean bean = await DataUtils.postPlayBlindBox(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isCheck = false;
          });
          MyToastUtils.showToastBottom('打赏成功~');
          // // ignore: use_build_context_synchronously
          // Navigator.pop(context);
          eventBus.fire(ResidentBack(isBack: true));
          // ignore: use_build_context_synchronously
          // for (int i = 0; i < listPeople.length; i++) {
          //   listPeople[i] = false;
          // }
          eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          setState(() {
            isCheck = false;
          });
          break;
      }
    } catch (e) {
      setState(() {
        isCheck = false;
      });
      // MyToastUtils.showToastBottom(e.toString());
    }
  }

  // 金币 钻石
  String jinbi = '', jinbi2 = '', zuanshi = '', zuanshi2 = '';

  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (double.parse(bean.data!.goldBean!) > 10000) {
              jinbi = '${(double.parse(bean.data!.goldBean!) / 10000)}w';
              List<String> a = jinbi.split('.');
              LogE('余额 == ${a[1]}');
              jinbi2 = '${a[0]}.${a[1].substring(0, 2)}w';
            } else {
              jinbi = bean.data!.goldBean!;
              jinbi2 = bean.data!.goldBean!;
            }
            if (double.parse(bean.data!.diamond!) > 10000) {
              zuanshi = '${(double.parse(bean.data!.diamond!) / 10000)}w';
              List<String> a = zuanshi.split('.');
              zuanshi2 = '${a[0]}.${a[1].substring(0, 2)}w';
            } else {
              zuanshi = bean.data!.diamond!;
              zuanshi2 = bean.data!.diamond!;
            }
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
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
