import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../bean/Common_bean.dart';
import '../../bean/hotRoomBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/tjRoomListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
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

  //2女厅 3男厅 4新厅 5游戏厅 6交友
  int index = 2;
  String roomType = '女神';
  List<DataHot> list = [];
  List<DataPH> list2 = [];
  List<DataPH> list3 = [];
  List<DataPH> list4 = [];
  List<DataPH> list5 = [];
  List<DataPH> list6 = [];
  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isUp = true; //是否允许上拉
  bool isDown = true; //是否允许下拉
  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      sp.setBool('joinRoom',false);
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
    doPostHotRoom();
    doPostTJRoomList2('$index');
  }

  void _onLoading() async {
    setState(() {
      sp.setBool('joinRoom',false);
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
    doPostHotRoom();
    doPostTJRoomList2('$index');
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostHotRoom();
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
                    : list6[i].hotDegree as int;

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
    }
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
              setState(() {
                sp.setBool('joinRoom',false);
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
                                    : list6[i].coverImg!),
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
                                                  : list6[i].roomName!,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14))),
                          index == 4
                              ? WidgetUtils.showImages(
                                  'assets/images/room_xinting_tj.png',
                                  30.h,
                                  100.h)
                              : const Text('')
                        ],
                      ),
                      const Expanded(child: Text('')),
                      Row(
                        children: [
                          WidgetUtils.paiduiBtn(
                              index == 2
                                  ? MyColors.paiduiRed
                                  : index == 3
                                      ? MyColors.paiduiBlue
                                      : index == 4
                                          ? MyColors.paiduiOrange
                                          : index == 5
                                              ? MyColors.paiduiPurple
                                              : MyColors.btn_d,
                              roomType,
                              index == 2
                                  ? 'assets/images/paidui_nvshen.png'
                                  : index == 3
                                      ? 'assets/images/paidui_nanshen.png'
                                      : index == 4
                                          ? 'assets/images/paidui_xinting.png'
                                          : index == 5
                                              ? 'assets/images/paidui_youxi.png'
                                              : 'assets/images/paidui_jiaoyou.png',
                              index == 5
                                  ? ScreenUtil().setHeight(85)
                                  : ScreenUtil().setHeight(75)),
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
    } else {
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
      enablePullUp: isUp, //是否允许上拉加载更多
      enablePullDown: isDown, // 是否允许下拉刷新
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  list.isNotEmpty ? Container(
                    child: WidgetUtils.onlyText(
                        '热门排行',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600)),
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  list.isNotEmpty ? WidgetUtils.commonSizedBox(10, 0) : WidgetUtils.commonSizedBox(0, 0),

                  ///顶部排行
                  list.isNotEmpty ? SizedBox(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(280),
                    child: Row(
                      children: [
                        list.isNotEmpty ? GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                              setState(() {
                                sp.setBool('joinRoom',true);
                              });
                              doPostBeforeJoin(list[0].id.toString());
                            }
                          }),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              WidgetUtils.CircleImageNet(
                                  ScreenUtil().setHeight(280),
                                  ScreenUtil().setHeight(280),
                                  10,
                                  list[0].coverImg!),
                              Transform.translate(
                                offset: const Offset(-5, -5),
                                child: WidgetUtils.showImages(
                                    'assets/images/paidui_one.png',
                                    ScreenUtil().setHeight(84),
                                    ScreenUtil().setWidth(79)),
                              ),
                              Positioned(
                                  bottom: 10.h,
                                  left: 10.h,
                                  child: SizedBox(
                                    width: 270.h,
                                    child: Text(
                                      list[0].roomName!,
                                      style:
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: 30.sp),
                                    ),
                                  ))
                            ],
                          ),
                        ) : SizedBox(height: 280.h, width: 280.h,),
                        const Expanded(child: Text('')),
                        Column(
                          children: [
                            list.length > 1 ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                                  setState(() {
                                    sp.setBool('joinRoom',true);
                                  });
                                  doPostBeforeJoin(list[1].id.toString());
                                }
                              }),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  WidgetUtils.CircleImageNet(
                                      ScreenUtil().setHeight(137.5),
                                      ScreenUtil().setHeight(137.5),
                                      10,
                                      list[1].coverImg!),
                                  Transform.translate(
                                    offset: const Offset(-5, -4),
                                    child: WidgetUtils.showImages(
                                        'assets/images/paidui_two.png',
                                        ScreenUtil().setHeight(60),
                                        ScreenUtil().setWidth(55)),
                                  ),
                                  Positioned(
                                      bottom: 5.h,
                                      left: 5.h,
                                      child: SizedBox(
                                        width: 132.5.h,
                                        child: Text(
                                          list[1].roomName!,
                                          maxLines: 1,
                                          style: StyleUtils
                                              .getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 21.sp),
                                        ),
                                      ))
                                ],
                              ),
                            ) : SizedBox(height: 137.5.h, width: 137.5.h,),
                            const Expanded(child: Text('')),
                            list.length > 3 ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                                  setState(() {
                                    sp.setBool('joinRoom',true);
                                  });
                                  doPostBeforeJoin(list[3].id.toString());
                                }
                              }),
                              child: Stack(
                                children: [
                                  WidgetUtils.CircleImageNet(
                                      ScreenUtil().setHeight(137.5),
                                      ScreenUtil().setHeight(137.5),
                                      10,
                                      list[3].coverImg!),
                                  Positioned(
                                      bottom: 5.h,
                                      left: 5.h,
                                      child: SizedBox(
                                        width: 132.5.h,
                                        child: Text(
                                          list[3].roomName!,
                                          maxLines: 1,
                                          style: StyleUtils
                                              .getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 21.sp),
                                        ),
                                      ))
                                ],
                              ),
                            )  : SizedBox(height: 137.5.h, width: 137.5.h,),
                          ],
                        ),
                        const Expanded(child: Text('')),
                        Column(
                          children: [
                            list.length > 2 ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                                  setState(() {
                                    sp.setBool('joinRoom',true);
                                  });
                                  doPostBeforeJoin(list[2].id.toString());
                                }
                              }),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  WidgetUtils.CircleImageNet(
                                      ScreenUtil().setHeight(137.5),
                                      ScreenUtil().setHeight(137.5),
                                      10,
                                      list[2].coverImg!),
                                  Transform.translate(
                                    offset: const Offset(-5, -3),
                                    child: WidgetUtils.showImages(
                                        'assets/images/paidui_three.png',
                                        ScreenUtil().setHeight(60),
                                        ScreenUtil().setWidth(42)),
                                  ),
                                  Positioned(
                                      bottom: 5.h,
                                      left: 5.h,
                                      child: SizedBox(
                                        width: 132.5.h,
                                        child: Text(
                                          list[2].roomName!,
                                          maxLines: 1,
                                          style: StyleUtils
                                              .getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 21.sp),
                                        ),
                                      ))
                                ],
                              ),
                            ) : SizedBox(height: 137.5.h, width: 137.5.h,),
                            const Expanded(child: Text('')),
                            list.length > 4 ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                                  setState(() {
                                    sp.setBool('joinRoom',true);
                                  });
                                  doPostBeforeJoin(list[4].id.toString());
                                }
                              }),
                              child: Stack(
                                children: [
                                  WidgetUtils.CircleImageNet(
                                      ScreenUtil().setHeight(137.5),
                                      ScreenUtil().setHeight(137.5),
                                      10,
                                      list[4].coverImg!),
                                  Positioned(
                                      bottom: 5.h,
                                      left: 5.h,
                                      child: SizedBox(
                                        width: 132.5.h,
                                        child: Text(
                                          list[4].roomName!,
                                          maxLines: 1,
                                          style: StyleUtils
                                              .getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 21.sp),
                                        ),
                                      ))
                                ],
                              ),
                            ) : SizedBox(height: 137.5.h, width: 137.5.h,),
                          ],
                        ),
                      ],
                    ),
                  ): WidgetUtils.commonSizedBox(0, 0),
                  list.isNotEmpty ? WidgetUtils.commonSizedBox(10, 0): WidgetUtils.commonSizedBox(0, 0),

                  /// 标题栏 、 导航栏
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 重新初始化
                            _refreshController.resetNoData();
                            setState(() {
                              index = 2;
                              page = 1;
                              doPostTJRoomList2('2');
                            });
                          }
                        }),
                        child: WidgetUtils.myContainer(
                            ScreenUtil().setHeight(40),
                            ScreenUtil().setHeight(90),
                            index == 2
                                ? MyColors.paiduiRed
                                : MyColors.homeBG,
                            index == 2
                                ? MyColors.paiduiRed
                                : MyColors.homeBG,
                            '女神',
                            ScreenUtil().setSp(28),
                            index == 2 ? Colors.white : MyColors.g6),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 重新初始化
                            _refreshController.resetNoData();
                            setState(() {
                              index = 3;
                              page = 1;
                              doPostTJRoomList2('3');
                            });
                          }
                        }),
                        child: WidgetUtils.myContainer(
                            ScreenUtil().setHeight(40),
                            ScreenUtil().setHeight(90),
                            index == 3
                                ? MyColors.paiduiBlue
                                : MyColors.homeBG,
                            index == 3
                                ? MyColors.paiduiBlue
                                : MyColors.homeBG,
                            '男神',
                            ScreenUtil().setSp(28),
                            index == 3 ? Colors.white : MyColors.g6),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 重新初始化
                            _refreshController.resetNoData();
                            setState(() {
                              index = 6;
                              page = 1;
                              doPostTJRoomList2('6');
                            });
                          }
                        }),
                        child: WidgetUtils.myContainer(
                            ScreenUtil().setHeight(40),
                            ScreenUtil().setHeight(90),
                            index == 6 ? MyColors.btn_d : MyColors.homeBG,
                            index == 6 ? MyColors.btn_d : MyColors.homeBG,
                            '交友',
                            ScreenUtil().setSp(28),
                            index == 6 ? Colors.white : MyColors.g6),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 重新初始化
                            _refreshController.resetNoData();
                            setState(() {
                              index = 4;
                              page = 1;
                              doPostTJRoomList2('4');
                            });
                          }
                        }),
                        child: WidgetUtils.myContainer(
                            ScreenUtil().setHeight(40),
                            ScreenUtil().setHeight(90),
                            index == 4
                                ? MyColors.origin
                                : MyColors.homeBG,
                            index == 4
                                ? MyColors.origin
                                : MyColors.homeBG,
                            '新厅',
                            ScreenUtil().setSp(28),
                            index == 4 ? Colors.white : MyColors.g6),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 重新初始化
                            _refreshController.resetNoData();
                            setState(() {
                              index = 5;
                              page = 1;
                              doPostTJRoomList2('5');
                            });
                          }
                        }),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(40),
                          width: ScreenUtil().setHeight(160),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              index == 5
                                  ? WidgetUtils.showImagesFill(
                                  'assets/images/paidui_diantai_bg.png',
                                  ScreenUtil().setHeight(56),
                                  ScreenUtil().setHeight(160))
                                  : const Text(''),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: ScreenUtil().setHeight(160),
                                padding: const EdgeInsets.only(left: 9),
                                child: WidgetUtils.showImages(
                                    'assets/images/paidui_diantai1.png',
                                    ScreenUtil().setHeight(24),
                                    ScreenUtil().setHeight(116)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
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
                        : list6.length,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 派对前5名排行
  Future<void> doPostHotRoom() async {
    try {
      Loading.show();
      hotRoomBean bean = await DataUtils.postHotRoom();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            if (bean.data!.isNotEmpty) {
              list = bean.data!;
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
            }
            if (bean.data!.isNotEmpty) {
              if (type == "2") {
                for(int i = 0; i < bean.data!.length; i++){
                  list2.add(bean.data![i]);
                }
              } else if (type == "3") {
                for(int i = 0; i < bean.data!.length; i++){
                  list3.add(bean.data![i]);
                }
              } else if (type == "4") {
                for(int i = 0; i < bean.data!.length; i++){
                  list4.add(bean.data![i]);
                }
              } else if (type == "5") {
                for(int i = 0; i < bean.data!.length; i++){
                  list5.add(bean.data![i]);
                }
              } else if (type == "6") {
                for(int i = 0; i < bean.data!.length; i++){
                  list6.add(bean.data![i]);
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (sp.getString('roomID') == null || sp.getString('').toString().isEmpty) {
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
          doPostRoomJoin(roomID, '', bean.data!.rtc!);
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
            sp.setBool('joinRoom',false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom',false);
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
            sp.setBool('joinRoom',false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom',false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
