import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/pages/home/paidui_list_page.dart';
import 'package:yuyinting/pages/home/wall/happy_wall_page.dart';
import 'package:yuyinting/utils/SVGASimpleImage3.dart';

import '../../bean/Common_bean.dart';
import '../../bean/fenleiBean.dart';
import '../../bean/homeTJBean.dart';
import '../../bean/hotRoomBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/tjRoomListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

///派对页面
class PaiduiPage extends StatefulWidget {
  const PaiduiPage({Key? key}) : super(key: key);

  @override
  State<PaiduiPage> createState() => _PaiduiPageState();
}

class _PaiduiPageState extends State<PaiduiPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _souSuoName = TextEditingController();

  //2女厅 3男厅 4新厅 5游戏厅 6交友 7相亲 8点唱
  int index = 2;
  String roomType = '女神';
  List<DataHot> list = [];
  List<DataPH> list2 = [];
  List<DataPH> list3 = [];
  List<DataPH> list4 = [];
  List<DataPH> list5 = [];
  List<DataPH> list6 = [];
  List<DataPH> list7 = [];
  List<DataPH> list8 = [];
  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isUp = true; //是否允许上拉
  bool isDown = true; //是否允许下拉
  bool isOK = false;
  bool isList = sp.getBool('paidui_list_type') ?? true;

  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      sp.setBool('joinRoom', false);
      isUp = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostRoomType();
    doPostPushRoom();
    doPostTJRoomList2('$index');
  }

  void _onLoading() async {
    setState(() {
      sp.setBool('joinRoom', false);
      isDown = false;
    });
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostRoomType();
    doPostPushRoom();
    doPostTJRoomList2('$index');
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRoomType();
    doPostPushRoom();
    // 2女厅 3男厅 4新厅 5游戏厅
    doPostTJRoomList2('2');
  }

  Widget _itemPaihang(BuildContext context, int i) {
    int hotDegree = index == 2
        ? list2[i].hotDegree as int
        : index == 3
            ? list3[i].hotDegree as int
            : index == 4
                ? list4[i].hotDegree as int
                : index == 5
                    ? list5[i].hotDegree as int
                    : index == 6
                        ? list6[i].hotDegree as int
                        : index == listFL[0].type as int
                            ? list7[i].hotDegree as int
                            : list8[i].hotDegree as int;

    //2女厅 3男厅 4新厅 5游戏厅
    if (index == 2) {
      roomType = '女神';
    } else if (index == 3) {
      roomType = '男神';
    } else if (index == 4) {
      roomType = '新厅';
    } else if (index == 5) {
      roomType = '游戏厅';
    } else if (index == 6) {
      roomType = '交友';
    } else if (index == listFL[0].type as int) {
      roomType = listFL[0].title!;
    } else if (index == listFL[1].type as int) {
      roomType = listFL[1].title!;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
              setState(() {
                sp.setBool('joinRoom', true);
              });
              if (index == 2) {
                doPostBeforeJoin(list2[i].id.toString());
              } else if (index == 3) {
                doPostBeforeJoin(list3[i].id.toString());
              } else if (index == 4) {
                doPostBeforeJoin(list4[i].id.toString());
              } else if (index == 5) {
                doPostBeforeJoin(list5[i].id.toString());
              } else if (index == 6) {
                doPostBeforeJoin(list6[i].id.toString());
              } else if (index == listFL[0].type as int) {
                doPostBeforeJoin(list7[i].id.toString());
              } else if (index == listFL[1].type as int) {
                doPostBeforeJoin(list8[i].id.toString());
              }
            }
          }),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(160),
            //边框设置
            decoration: BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // 阴影偏移量
                ),
              ],
            ),
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10),
                SizedBox(
                  height: 140.h,
                  width: 140.h,
                  child: Stack(
                    children: [
                      WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(140),
                          ScreenUtil().setHeight(140),
                          10,
                          index == 2
                              ? list2[i].coverImg!
                              : index == 3
                                  ? list3[i].coverImg!
                                  : index == 4
                                      ? list4[i].coverImg!
                                      : index == 5
                                          ? list5[i].coverImg!
                                          : index == 6
                                              ? list6[i].coverImg!
                                              : index == listFL[0].type as int
                                                  ? list7[i].coverImg!
                                                  : list8[i].coverImg!),
                      (index == 2 && list2[i].pkStatus == 1)
                          ? const SVGASimpleImage3(
                              assetsName: 'assets/svga/pk/room_pk_qj.svga',
                            )
                          : (index == 3 && list3[i].pkStatus == 1)
                              ? const SVGASimpleImage3(
                                  assetsName: 'assets/svga/pk/room_pk_qj.svga',
                                )
                              : (index == 4 && list4[i].pkStatus == 1)
                                  ? const SVGASimpleImage3(
                                      assetsName:
                                          'assets/svga/pk/room_pk_qj.svga',
                                    )
                                  : (index == 5 && list5[i].pkStatus == 1)
                                      ? const SVGASimpleImage3(
                                          assetsName:
                                              'assets/svga/pk/room_pk_qj.svga',
                                        )
                                      : (index == 6 && list6[i].pkStatus == 1)
                                          ? const SVGASimpleImage3(
                                              assetsName:
                                                  'assets/svga/pk/room_pk_qj.svga',
                                            )
                                          : (index == 7 &&
                                                  list7[i].pkStatus == 1)
                                              ? const SVGASimpleImage3(
                                                  assetsName:
                                                      'assets/svga/pk/room_pk_qj.svga',
                                                )
                                              : (index == 8 &&
                                                      list8[i].pkStatus == 1)
                                                  ? const SVGASimpleImage3(
                                                      assetsName:
                                                          'assets/svga/pk/room_pk_qj.svga',
                                                    )
                                                  : const Text('')
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(10, 0),
                      Row(
                        children: [
                          Expanded(
                              child: WidgetUtils.onlyText(
                                  index == 2
                                      ? list2[i].roomName!
                                      : index == 3
                                          ? list3[i].roomName!
                                          : index == 4
                                              ? list4[i].roomName!
                                              : index == 5
                                                  ? list5[i].roomName!
                                                  : index == 6
                                                      ? list6[i].roomName!
                                                      : index ==
                                                              listFL[0].type
                                                                  as int
                                                          ? list7[i].roomName!
                                                          : list8[i].roomName!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: (14 * 2).sp))),
                          // index == 4
                          //     ? WidgetUtils.showImages(
                          //         'assets/images/room_xinting_tj.png',
                          //         30.h,
                          //         100.h)
                          //     : const Text('')
                        ],
                      ),
                      const Expanded(child: Text('')),
                      Row(
                        children: [
                          WidgetUtils.showImages( index == 2
                              ? 'assets/images/paidui_nvshen.png'
                              : index == 3
                              ? 'assets/images/paidui_nanshen.png'
                              : index == 4
                              ? 'assets/images/paidui_xinting.png'
                              : index == 5
                              ? 'assets/images/paidui_youxi.png'
                              : index == 6
                              ? 'assets/images/paidui_jiaoyou.png'
                              : index ==
                              listFL[0].type as int
                              ? 'assets/images/paidui_xiangqin.png'
                              : 'assets/images/paidui_dianchang.png', 36.h, 72.w),
                          WidgetUtils.commonSizedBox(0, 10),
                          index == 5
                              ? WidgetUtils.onlyText(
                                  list5[i].notice!,
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.paiduiPurple,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(18)))
                              : const Text('')
                        ],
                      ),
                      const Expanded(child: Text('')),
                      roomInfo(i, hotDegree),
                      WidgetUtils.commonSizedBox(10, 0),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10),
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(10, 0),
      ],
    );
  }

  Widget roomInfo(i, hotDegree) {
    if (index == 2) {
      return Row(
        children: [
          list2[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list2[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list2[i].hostInfo!.isNotEmpty
                ? Text(
                    list2[i].hostInfo![0].length > 2
                        ? '${list2[i].hostInfo![0].substring(0, 2)}...'
                        : list2[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list2[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              // WidgetUtils.showImages(
              //     'assets/images/paidui_redu.png', 40.h, 20.h),
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.onlyText(
              //     hotDegree > 9999
              //         ? '${(hotDegree / 10000).toStringAsFixed(2)}w'
              //         : hotDegree.toString(),
              //     StyleUtils.getCommonTextStyle(
              //         color: MyColors.g6, fontSize: ScreenUtil().setSp(24)))
            ],
          ),
        ],
      );
    } else if (index == 3) {
      return Row(
        children: [
          list3[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list3[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list3[i].hostInfo!.isNotEmpty
                ? Text(
                    list3[i].hostInfo![0].length > 2
                        ? '${list3[i].hostInfo![0].substring(0, 2)}...'
                        : list3[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list3[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    } else if (index == 4) {
      return Row(
        children: [
          list4[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list4[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list4[i].hostInfo!.isNotEmpty
                ? Text(
                    list4[i].hostInfo![0].length > 2
                        ? '${list4[i].hostInfo![0].substring(0, 2)}...'
                        : list4[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list4[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    } else if (index == 5) {
      return Row(
        children: [
          list5[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list5[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list5[i].hostInfo!.isNotEmpty
                ? Text(
                    list5[i].hostInfo![0].length > 2
                        ? '${list5[i].hostInfo![0].substring(0, 2)}...'
                        : list5[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list5[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    } else if (index == 6) {
      return Row(
        children: [
          list6[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list6[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list6[i].hostInfo!.isNotEmpty
                ? Text(
                    list6[i].hostInfo![0].length > 2
                        ? '${list6[i].hostInfo![0].substring(0, 2)}...'
                        : list6[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list6[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    } else if (index == 7) {
      return Row(
        children: [
          list7[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list7[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list7[i].hostInfo!.isNotEmpty
                ? Text(
                    list7[i].hostInfo![0].length > 2
                        ? '${list7[i].hostInfo![0].substring(0, 2)}...'
                        : list7[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list7[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          list8[i].hostInfo!.isNotEmpty
              ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                  ScreenUtil().setHeight(30), list8[i].hostInfo![1])
              : WidgetUtils.commonSizedBox(0, 0),
          SizedBox(
            width: ScreenUtil().setHeight(50),
            child: list8[i].hostInfo!.isNotEmpty
                ? Text(
                    list8[i].hostInfo![0].length > 2
                        ? '${list8[i].hostInfo![0].substring(0, 2)}...'
                        : list8[i].hostInfo![0],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        color: MyColors.mineGrey,
                        overflow: TextOverflow.ellipsis),
                  )
                : const Text(''),
          ),
          showHead(list8[i].memberList!),
          const Spacer(),

          /// 热度
          Row(
            children: [
              Text(
                '热度值:',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
              // WidgetUtils.commonSizedBox(0, 5),
              Text(
                hotDegree > 9999
                    ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
                    : hotDegree.toString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: MyColors.g6,
                    fontFamily: 'YOUSHEBIAOTIHEI'),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget showHead(List<MemberList> listm) {
    if (listm.length == 1) {
      return WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
          ScreenUtil().setHeight(30), listm[0].avatar!);
    } else if (listm.length == 2) {
      return Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
              ScreenUtil().setHeight(30), listm[0].avatar!),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[1].avatar!),
          ),
        ],
      );
    }
    if (listm.length == 3) {
      return Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
              ScreenUtil().setHeight(30), listm[0].avatar!),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[1].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[2].avatar!),
          ),
        ],
      );
    }
    if (listm.length == 4) {
      return Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
              ScreenUtil().setHeight(30), listm[0].avatar!),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[1].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[2].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-20, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[3].avatar!),
          ),
        ],
      );
    }
    if (listm.length == 5) {
      return Row(
        children: [
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
              ScreenUtil().setHeight(30), listm[0].avatar!),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[1].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-15, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[2].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-20, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[3].avatar!),
          ),
          Transform.translate(
            offset: const Offset(-25, 0),
            child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(30),
                ScreenUtil().setHeight(30), listm[4].avatar!),
          ),
        ],
      );
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: isUp,
      //是否允许上拉加载更多
      enablePullDown: isDown,
      // 是否允许下拉刷新
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  list.isNotEmpty
                      ? Container(
                          child: WidgetUtils.onlyText(
                              '热门排行',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600)),
                        )
                      : WidgetUtils.commonSizedBox(0, 0),
                  list.isNotEmpty
                      ? WidgetUtils.commonSizedBox(10, 0)
                      : WidgetUtils.commonSizedBox(0, 0),

                  ///顶部排行
                  _rmtj(),

                  WidgetUtils.commonSizedBox(5, 0),

                  // HappyWallBanner(),

                  WidgetUtils.commonSizedBox(5, 0),

                  /// 标题栏 、 导航栏
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 800.h,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      // 重新初始化
                                      _refreshController.resetNoData();
                                      setState(() {
                                        isOK = false;
                                        index = 2;
                                        page = 1;
                                        doPostTJRoomList2('2');
                                      });
                                    }
                                  }),
                                  child: WidgetUtils.myContainerPD(
                                      ScreenUtil().setHeight(40),
                                      ScreenUtil().setHeight(90),
                                      '女神',
                                      index == 2 ? 36.sp : 30.sp,
                                      index == 2
                                          ? MyColors.newHomeBlack
                                          : MyColors.g6,
                                      index == 2 ? true : false),
                                ),
                                WidgetUtils.commonSizedBox(0, 15.h),
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      // 重新初始化
                                      _refreshController.resetNoData();
                                      setState(() {
                                        isOK = false;
                                        index = 3;
                                        page = 1;
                                        doPostTJRoomList2('3');
                                      });
                                    }
                                  }),
                                  child: WidgetUtils.myContainerPD(
                                      ScreenUtil().setHeight(40),
                                      ScreenUtil().setHeight(90),
                                      '男神',
                                      index == 3 ? 36.sp : 30.sp,
                                      index == 3
                                          ? MyColors.newHomeBlack
                                          : MyColors.g6,
                                      index == 3 ? true : false),
                                ),
                                WidgetUtils.commonSizedBox(0, 15.h),
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      // 重新初始化
                                      _refreshController.resetNoData();
                                      setState(() {
                                        isOK = false;
                                        index = 6;
                                        page = 1;
                                        doPostTJRoomList2('6');
                                      });
                                    }
                                  }),
                                  child: WidgetUtils.myContainerPD(
                                      ScreenUtil().setHeight(40),
                                      ScreenUtil().setHeight(90),
                                      '交友',
                                      index == 6 ? 36.sp : 30.sp,
                                      index == 6
                                          ? MyColors.newHomeBlack
                                          : MyColors.g6,
                                      index == 6 ? true : false),
                                ),
                                WidgetUtils.commonSizedBox(0, 15.h),
                                listFL.isNotEmpty
                                    ? GestureDetector(
                                        onTap: (() {
                                          if (MyUtils.checkClick()) {
                                            // 重新初始化
                                            _refreshController.resetNoData();
                                            setState(() {
                                              isOK = false;
                                              index = listFL[0].type as int;
                                              page = 1;
                                              doPostTJRoomList2(
                                                  listFL[0].type.toString());
                                            });
                                          }
                                        }),
                                        child: WidgetUtils.myContainerPD(
                                            ScreenUtil().setHeight(40),
                                            ScreenUtil().setHeight(90),
                                            listFL[0].title!,
                                            ScreenUtil().setSp(28),
                                            index == listFL[0].type as int
                                                ? MyColors.newHomeBlack
                                                : MyColors.g6,
                                            index == listFL[0].type as int
                                                ? true
                                                : false),
                                      )
                                    : const Text(''),
                                listFL.isNotEmpty
                                    ? WidgetUtils.commonSizedBox(0, 15.h)
                                    : const Text(''),
                                listFL.length > 1
                                    ? GestureDetector(
                                        onTap: (() {
                                          if (MyUtils.checkClick()) {
                                            // 重新初始化
                                            _refreshController.resetNoData();
                                            setState(() {
                                              isOK = false;
                                              index = listFL[1].type as int;
                                              page = 1;
                                              doPostTJRoomList2(
                                                  listFL[1].type.toString());
                                            });
                                          }
                                        }),
                                        child: WidgetUtils.myContainerPD(
                                            ScreenUtil().setHeight(40),
                                            ScreenUtil().setHeight(90),
                                            listFL[1].title!,
                                            ScreenUtil().setSp(28),
                                            index == listFL[1].type as int
                                                ? MyColors.newHomeBlack
                                                : MyColors.g6,
                                            index == listFL[1].type as int
                                                ? true
                                                : false),
                                      )
                                    : const Text(''),
                                listFL.length > 1
                                    ? WidgetUtils.commonSizedBox(0, 15.h)
                                    : const Text(''),
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      // 重新初始化
                                      _refreshController.resetNoData();
                                      setState(() {
                                        isOK = false;
                                        index = 4;
                                        page = 1;
                                        doPostTJRoomList2('4');
                                      });
                                    }
                                  }),
                                  child: WidgetUtils.myContainerPD(
                                      ScreenUtil().setHeight(40),
                                      ScreenUtil().setHeight(90),
                                      '新厅',
                                      index == 4 ? 36.sp : 30.sp,
                                      index == 4
                                          ? MyColors.newHomeBlack
                                          : MyColors.g6,
                                      index == 4 ? true : false),
                                ),
                                // WidgetUtils.commonSizedBox(0, 15.h),
                                // GestureDetector(
                                //   onTap: (() {
                                //     if (MyUtils.checkClick()) {
                                //       // 重新初始化
                                //       _refreshController.resetNoData();
                                //       setState(() {
                                //         isOK = false;
                                //         index = 5;
                                //         page = 1;
                                //         doPostTJRoomList2('5');
                                //       });
                                //     }
                                //   }),
                                //   child: SizedBox(
                                //     height: ScreenUtil().setHeight(40),
                                //     width: ScreenUtil().setHeight(160),
                                //     child: Stack(
                                //       alignment: Alignment.center,
                                //       children: [
                                //         index == 5
                                //             ? WidgetUtils.showImagesFill(
                                //                 'assets/images/paidui_diantai_bg.png',
                                //                 ScreenUtil().setHeight(56),
                                //                 ScreenUtil().setHeight(160))
                                //             : const Text(''),
                                //         Container(
                                //           alignment: Alignment.centerLeft,
                                //           width: ScreenUtil().setHeight(160),
                                //           padding:
                                //               const EdgeInsets.only(left: 9),
                                //           child: WidgetUtils.showImages(
                                //               'assets/images/paidui_diantai1.png',
                                //               ScreenUtil().setHeight(24),
                                //               ScreenUtil().setHeight(116)),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Padding(
                        padding: EdgeInsets.all(5.h),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isList = !isList;
                              sp.setBool('paidui_list_type', isList);
                            });
                          },
                          child: SizedBox(
                            width: 30.h,
                            height: 30.h,
                            child: Image(
                              image: AssetImage(isList
                                  ? 'assets/images/paidui_list_table.png'
                                  : 'assets/images/paidui_list_collect.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  isOK
                      ? /*ListView.builder(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: _itemPaihang,
                          itemCount: index == 2
                              ? list2.length
                              : index == 3
                                  ? list3.length
                                  : index == 4
                                      ? list4.length
                                      : index == 5
                                          ? list5.length
                                          : index == 6
                                              ? list6.length
                                              : index == listFL[0].type as int
                                                  ? list7.length
                                                  : list8.length,
                        )*/
                      Builder(builder: (BuildContext context) {
                          final List<DataPH> list;
                          switch (index) {
                            case 2:
                              list = list2;
                              break;
                            case 3:
                              list = list3;
                              break;
                            case 4:
                              list = list4;
                              break;
                            case 5:
                              list = list5;
                              break;
                            case 6:
                              list = list6;
                              break;
                            default:
                              list = index == (listFL[0].type as int)
                                  ? list7
                                  : list8;
                          }

                          //2女厅 3男厅 4新厅 5游戏厅
                          if (index == 2) {
                            roomType = '女神';
                          } else if (index == 3) {
                            roomType = '男神';
                          } else if (index == 4) {
                            roomType = '新厅';
                          } else if (index == 5) {
                            roomType = '游戏厅';
                          } else if (index == 6) {
                            roomType = '交友';
                          } else if (index == listFL[0].type as int) {
                            roomType = listFL[0].title!;
                          } else if (index == listFL[1].type as int) {
                            roomType = listFL[1].title!;
                          }
                          return PaiduiListPage(
                            isList: isList,
                            index: index,
                            roomType: roomType,
                            list: list,
                            listFL: listFL,
                            action: (id) {
                              if (MyUtils.checkClick() &&
                                  sp.getBool('joinRoom') == false) {
                                setState(() {
                                  sp.setBool('joinRoom', true);
                                });
                                doPostBeforeJoin(id.toString());
                              }
                            },
                            listBanner: listBanner,
                          );
                        })
                      : const Text(''),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataFL> listFL = [];

  /// 获取分类
  Future<void> doPostRoomType() async {
    try {
      fenleiBean bean = await DataUtils.postRoomType();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listFL.clear();
            if (bean.data!.isNotEmpty) {
              for (int i = 0; i < bean.data!.length; i++) {
                listFL.add(bean.data![i]);
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

  /// 房间列表
  Future<void> doPostTJRoomList2(type) async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize,
      'type': type
    };
    try {
      Loading.show();
      tjRoomListBean bean = await DataUtils.postTJRoomList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isOK = true;
            isUp = true; //是否允许上拉
            isDown = true; //是否允许下拉
            if (page == 1 && type == "2") {
              list2.clear();
            } else if (page == 1 && type == "3") {
              list3.clear();
            } else if (page == 1 && type == "4") {
              list4.clear();
            } else if (page == 1 && type == "5") {
              list5.clear();
            } else if (page == 1 && type == "6") {
              list6.clear();
            } else if (page == 1 && type == listFL[0].type.toString()) {
              list7.clear();
            } else if (page == 1 && type == listFL[1].type.toString()) {
              list8.clear();
            }
            if (bean.data!.isNotEmpty) {
              if (type == "2") {
                for (int i = 0; i < bean.data!.length; i++) {
                  list2.add(bean.data![i]);
                }
              } else if (type == "3") {
                for (int i = 0; i < bean.data!.length; i++) {
                  list3.add(bean.data![i]);
                }
              } else if (type == "4") {
                for (int i = 0; i < bean.data!.length; i++) {
                  list4.add(bean.data![i]);
                }
              } else if (type == "5") {
                for (int i = 0; i < bean.data!.length; i++) {
                  list5.add(bean.data![i]);
                }
              } else if (type == "6") {
                for (int i = 0; i < bean.data!.length; i++) {
                  list6.add(bean.data![i]);
                }
              } else if (type == listFL[0].type.toString()) {
                for (int i = 0; i < bean.data!.length; i++) {
                  list7.add(bean.data![i]);
                }
              } else if (type == listFL[1].type.toString()) {
                for (int i = 0; i < bean.data!.length; i++) {
                  list8.add(bean.data![i]);
                }
              }
            } else {
              if (page > 1) {
                if (bean.data!.length < MyConfig.pageSize) {
                  _refreshController.loadNoData();
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(e.toString());
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.toString().isEmpty) {
      return;
    } else {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
        sp.setString('roomID', roomID);
        eventBus.fire(SubmitButtonBack(title: '加入其他房间'));
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(sp.getString('sqRoomID').toString() == roomID){
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentRFPage(
                context,
                RoomPage(
                  roomId: roomID,
                  beforeId: '',
                  roomToken: bean.data!.rtc!,
                ));
          }else{
            doPostRoomJoin(roomID, '', bean.data!.rtc!);
          }
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: roomToken,
              ));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  List<RoomList1> listRoom = [];
  List<RoomList2> listRoom2 = [];
  List<RoomList3> listRoom3 = [];
  List<BannerList> listBanner = [];

  /// 首页 推荐房间/海报轮播/推荐主播
  Future<void> doPostPushRoom() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
      // Loading.show(MyConfig.successTitle);
      homeTJBean bean = await DataUtils.postPushRoom();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listRoom.clear();
            listRoom2.clear();
            listRoom3.clear();
            if (bean.data!.roomList1!.isNotEmpty) {
              listRoom = bean.data!.roomList1!;
            }
            if (bean.data!.roomList2!.isNotEmpty) {
              listRoom2 = bean.data!.roomList2!;
            }
            if (bean.data!.roomList3!.isNotEmpty) {
              listRoom3 = bean.data!.roomList3!;
            }
            listBanner = bean.data?.bannerList ?? [];
            // _refreshController.loadNoData();
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
      // Loading.dismiss();
    } catch (e) {
      // Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  Widget _rmtj() {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        child: Row(
          children: [
            _rmSwiper(218, listRoom2),
            const SizedBox(width: 16),

            ///热门推荐第一个大的轮播图
            _rmSwiper(280, listRoom),
            const SizedBox(width: 16),
            _rmSwiper(218, listRoom3),
          ],
        ),
      ),
    );
  }

  Widget _rmSwiper(double size, dynamic list) {
    if (list.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
      );
    } else {
      return Container(
        width: size,
        height: size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            // 配置图片地址
            final String roomName = list[index].roomName;
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                FadeInImage.assetNetwork(
                  width: size,
                  height: size,
                  placeholder: 'assets/images/img_placeholder.png',
                  image: list[index].coverImg!,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    // 图片加载错误后展示的 widget
                    // print("---图片加载错误---");
                    // 此处不能 setState
                    return const Image(
                      image: AssetImage('assets/images/img_placeholder.png'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StyleUtils.getCommonTextStyle(
                        color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            );
          },
          // 配置图片数量
          itemCount: list.length,
          // 无限循环
          loop: true,
          // 自动轮播
          autoplay: true,
          autoplayDelay: 4000,
          duration: 2500,
          onIndexChanged: (index) {},
          onTap: (index) {
            if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
              setState(() {
                sp.setBool('joinRoom', true);
              });
              doPostBeforeJoin(list[index].id.toString());
            }
          },
        ),
      );
    }
  }
}
