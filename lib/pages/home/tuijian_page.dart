import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import '../../bean/Common_bean.dart';
import '../../bean/homeTJBean.dart';
import '../../bean/hotRoomBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/pushStreamerBean.dart';
import '../../bean/soundBean.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/gp_quanxian_page.dart';
import '../gongping/gp_room_page.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

///推荐页面
class TuijianPage extends StatefulWidget {
  const TuijianPage({Key? key}) : super(key: key);

  @override
  State<TuijianPage> createState() => _TuijianPageState();
}

class _TuijianPageState extends State<TuijianPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  List<BannerList> listBanner = [];
  List<RoomList1> listRoom = [];
  List<RoomList2> listRoom2 = [];
  List<RoomList3> listRoom3 = [];
  List<AnchorList> listAnchor = [];
  List<bool> listB = [];
  List<int> listI = [];
  int a = 0, b = 0, c = 0;
  bool isFirstUp = false; //是否首次打开进入
  bool isUp = true; //是否允许上拉
  bool isDown = true; //是否允许下拉
  void _onRefresh() async {
    // 重新初始化
    _refreshController.resetNoData();
    setState(() {
      sp.setBool('joinRoom', false);
      isUp = false;
    });
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostHotRoom();
    doPostPushRoom();
    await doPostPushStreamer();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {
      sp.setBool('joinRoom', false);
      isDown = false;
    });
    // monitor network fetch
    // await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostHotRoom();
    doPostPushRoom();
    if (!await doPostPushStreamer()) _refreshController.loadComplete();
  }

  // 显示推荐房间弹窗次数是否刷新
  int tjRoom = 0;
  var listen, listen2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostHotRoom();
    doPostPushRoom();
    doPostPushStreamer();
    _initialize();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '退出房间' ||
          event.title == '收起房间' ||
          event.title == '回到首页') {
        if (mounted) {
          setState(() {
            page = 1;
          });
        }
        doPostPushStreamer();
      } else if (event.title == '首页其他页面') {
        if (_mPlayer.isPlaying) {
          _mPlayer.stopPlayer();
        }
      }
    });
    listen2 = eventBus.on<FirstInfoBack>().listen((event) {
      if (event.isOk) {
        // 推荐房间
        MyUtils.goTransparentPageCom(
            context,
            GPRoomPage(
              roomID: list[0].id.toString(),
              roomUrl: list[0].coverImg!,
              roomName: list[0].roomName!,
            ));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listen2.cancel();
    if (_mPlayer.isPlaying) {
      stopPlayer();
    }
  }

  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool playRecord = false; //音频文件播放状态
  //播放录音
  void play(String voiceCard) async {
    LogE('录音地址**$voiceCard');
    await _mPlayer.startPlayer(
      fromURI: voiceCard,
      whenFinished: () {
        for (int i = 0; i < listB.length; i++) {
          if (listB[i]) {
            setState(() {
              listB[i] = false;
            });
          }
        }
        playRecord = false;
      },
    );
    playRecord = true;

    // _mPlayer
    //     .startPlayer(
    //         fromURI: voiceCard,
    //         whenFinished: () {
    //           setState(() {
    //             for (int i = 0; i < listB.length; i++) {
    //               listB[i] = false;
    //             }
    //             playRecord = false;
    //           });
    //         })
    //     .then((value) {
    //   setState(() {
    //     playRecord = true;
    //   });
    // });
  }

//停止播放录音
  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
    for (int i = 0; i < listB.length; i++) {
      if (listB[i]) {
        setState(() {
          listB[i] = false;
        });
      }
    }
    playRecord = false;

    // _mPlayer!.stopPlayer().then((value) {
    //   setState(() {
    //     for (int i = 0; i < listB.length; i++) {
    //       listB[i] = false;
    //     }
    //     playRecord = false;
    //   });
    // });
  }

  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
  }

  // 推荐主播
  Widget tuijian(context, i) {
    List<String> biaoqian = [];
    if (listAnchor[i].label!.contains(',')) {
      biaoqian = listAnchor[i].label!.split(',');
    }
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              // 如果点击的是自己，进入自己的主页
              if (sp.getString('user_id').toString() ==
                  listAnchor[i].uid.toString()) {
                MyUtils.goTransparentRFPage(context, const MyInfoPage());
              } else {
                sp.setString('other_id', listAnchor[i].uid.toString());
                MyUtils.goTransparentRFPage(
                    context,
                    PeopleInfoPage(
                      otherId: listAnchor[i].uid.toString(),
                      title: '其他',
                    ));
              }
            }
          }),
          child: Container(
            width: double.infinity,
            height: ScreenUtil().setWidth(220 * 1.25),
            margin: EdgeInsets.only(left: 20.h, right: 20.h),
            padding: EdgeInsets.only(
                left: 30.w, right: 30.w, top: 15.h, bottom: 15.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  //渐变位置
                  begin: Alignment.centerRight, //右上
                  end: Alignment.centerLeft, //左下
                  stops: const [
                    0.0,
                    1.0
                  ], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [
                    i % 4 == 0
                        ? MyColors.newY1
                        : i % 4 == 1
                            ? MyColors.newY2
                            : i % 4 == 2
                                ? MyColors.newY3
                                : MyColors.newY4,
                    i % 4 == 0
                        ? MyColors.newY11
                        : i % 4 == 1
                            ? MyColors.newY22
                            : i % 4 == 2
                                ? MyColors.newY33
                                : MyColors.newY44
                  ]),
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(10.h, 0),
                Row(
                  children: [
                    Stack(
                      children: [
                        WidgetUtils.CircleHeadImage((110 * 1.3).w,
                            (110 * 1.3).w, listAnchor[i].avatar!),
                        SizedBox(
                            height: (110 * 1.3).w,
                            width: (110 * 1.3).w,
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/party_avatar_wave.svga',
                            ))
                      ],
                    ),
                    Expanded(
                      child: Container(
                        height: (110 * 1.3).w,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                WidgetUtils.commonSizedBox(0, 30.w),
                                WidgetUtils.onlyText(
                                    listAnchor[i].nickname!,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.newHomeBlack,
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.commonSizedBox(0, 10.w),
                                listAnchor[i].voiceCardUrl!.isNotEmpty
                                    ? GestureDetector(
                                        onTap: (() async {
                                          if (MyUtils.checkClick()) {
                                            if (_mPlayer.isPlaying) {
                                              if (listB[i]) {
                                                setState(() {
                                                  listB[i] = false;
                                                });
                                                stopPlayer();
                                                return;
                                              }
                                              await stopPlayer();
                                            }
                                            setState(() {
                                              listB[i] = true;
                                            });
                                            play(listAnchor[i].voiceCardUrl!);
                                          }
                                        }),
                                        child: Stack(
                                          children: [
                                            WidgetUtils.showImages(
                                                'assets/images/tuijian_audio.png',
                                                42.h,
                                                100.w),
                                            SizedBox(
                                              height: 42.h,
                                              width: 100.w,
                                              child: Row(
                                                children: [
                                                  const Spacer(),
                                                  listB[i]
                                                      ? SizedBox(
                                                          height: 30.h,
                                                          width: 50.w,
                                                          child:
                                                              const SVGASimpleImage(
                                                            assetsName:
                                                                'assets/svga/tj_audio.svga',
                                                          ))
                                                      : WidgetUtils.showImages(
                                                          'assets/images/tj_audio.png',
                                                          30.h,
                                                          50.w),
                                                  WidgetUtils.commonSizedBox(
                                                      0, 10.w),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const Text(''),
                                const Spacer(),
                                WidgetUtils.showImages(
                                    'assets/images/tj_zaixian.png', 30.h, 70.w),
                                WidgetUtils.commonSizedBox(0, 20.w),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                WidgetUtils.commonSizedBox(0, 30.w),
                                WidgetUtils.onlyText(
                                    listAnchor[i].gender == 0
                                        ? '未知'
                                        : listAnchor[i].gender == 1
                                            ? "男"
                                            : '女',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.g9, fontSize: 24.sp)),
                                WidgetUtils.commonSizedBox(0, 10.w),
                                WidgetUtils.onlyText(
                                    '${listAnchor[i].age}岁',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.g9, fontSize: 24.sp)),
                                WidgetUtils.commonSizedBox(0, 10.w),
                                WidgetUtils.onlyText(
                                    listAnchor[i].constellation!,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.g9, fontSize: 24.sp)),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                WidgetUtils.commonSizedBox(0, 30.w),
                                biaoqian.isNotEmpty
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 10.w,
                                            right: 10.w,
                                            top: 8.h,
                                            bottom: 8.h),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: Colors.white,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            biaoqian[0],
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.newHomeBlack,
                                                fontSize: 19.sp)),
                                      )
                                    : const Text(''),
                                biaoqian.isNotEmpty
                                    ? WidgetUtils.commonSizedBox(0, 10.w)
                                    : const Text(''),
                                biaoqian.length > 1
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 10.w,
                                            right: 10.w,
                                            top: 8.h,
                                            bottom: 8.h),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: Colors.white,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            biaoqian[1],
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.newHomeBlack,
                                                fontSize: 19.sp)),
                                      )
                                    : const Text(''),
                                biaoqian.length > 1
                                    ? WidgetUtils.commonSizedBox(0, 10.w)
                                    : const Text(''),
                                biaoqian.length > 2
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 10.w,
                                            right: 10.w,
                                            top: 8.h,
                                            bottom: 8.h),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: Colors.white,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        child: WidgetUtils.onlyTextCenter(
                                            biaoqian[2],
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.newHomeBlack,
                                                fontSize: 19.sp)),
                                      )
                                    : const Text(''),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  height: 60.h,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: 30.w, right: 10.w, top: 8.h, bottom: 8.h),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: listAnchor[i].description!.isEmpty
                        ? Colors.transparent
                        : Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    children: [
                      WidgetUtils.onlyText(
                          listAnchor[i].description!.length > 15
                              ? listAnchor[i].description!.substring(0, 15)
                              : listAnchor[i].description!,
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.newHomeBlack, fontSize: 24.sp)),
                      const Spacer(),
                      WidgetUtils.showImages(
                          'assets/images/tj_zhaota.png', 55.h, 140.w),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(10.h, 0),
      ],
    );
  }

  Future<void> quanxian(String roomId) async {
    // PermissionStatus status = await Permission.storage.request();
    // LogE('权限状态$status');
    // 请求多个权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();
    // 检查权限状态
    if (statuses[Permission.microphone] == PermissionStatus.granted) {
      LogE('权限状态$statuses');
      // 所有权限都已授予，执行你的操作
      doPostBeforeJoin(roomId, '');
    } else {
      // 用户拒绝了某些权限，后弹提示语
      // ignore: use_build_context_synchronously
      MyUtils.goTransparentPageRoom(context, const GPQuanXianPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    child: Column(
                      children: [
                        ///轮播图
                        // Container(
                        //   height: ScreenUtil().setWidth(140 * 1.3),
                        //   //超出部分，可裁剪
                        //   clipBehavior: Clip.hardEdge,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //   ),
                        //   child: Swiper(
                        //     key: UniqueKey(),
                        //     itemBuilder: (BuildContext context, int index) {
                        //       // 配置图片地址
                        //       return CachedNetworkImage(
                        //         imageUrl: listBanner[index].img!,
                        //         fit: BoxFit.fill,
                        //         placeholder: (context, url) =>
                        //             WidgetUtils.CircleImageAss(
                        //           ScreenUtil().setWidth(140 * 1.3),
                        //           double.infinity,
                        //           ScreenUtil().setHeight(10),
                        //           'assets/images/img_placeholder.png',
                        //         ),
                        //         errorWidget: (context, url, error) =>
                        //             WidgetUtils.CircleImageAss(
                        //           ScreenUtil().setWidth(140 * 1.3),
                        //           double.infinity,
                        //           ScreenUtil().setHeight(10),
                        //           'assets/images/img_placeholder.png',
                        //         ),
                        //       );
                        //     },
                        //     // 配置图片数量
                        //     itemCount: listBanner.length,
                        //     // 无限循环
                        //     loop: true,
                        //     // 自动轮播
                        //     autoplay: true,
                        //     autoplayDelay: 5000,
                        //     duration: 2000,
                        //     onIndexChanged: (index) {
                        //       // LogE('用户拖动或者自动播放引起下标改变调用');
                        //     },
                        //     onTap: (index) {
                        //       if (MyUtils.checkClick()) {
                        //         MyUtils.goTransparentPageCom(context,
                        //             WebPage(url: listBanner[index].url!));
                        //       }
                        //     },
                        //   ),
                        // ),

                        ///热门推荐
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.onlyText(
                            '热门推荐',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(33),
                                fontWeight: FontWeight.w600)),
                        WidgetUtils.commonSizedBox(10, 0),

                        ///热门推荐
                        _rmtj(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ///推荐主播
                  WidgetUtils.commonSizedBox(20, 0),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: WidgetUtils.onlyText(
                        '发现新伙伴',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                  ),
                  listAnchor.isNotEmpty
                      ? ListView.builder(
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: tuijian,
                          itemCount: listAnchor.length,
                        )
                      : const Text(''),
                  WidgetUtils.commonSizedBox(20, 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///热门推荐
  Widget _rmtj() {
    return Column(
      children: [
        ///顶部排行
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            child: Container(
              width: ScreenUtil().setHeight(280 + 137.5 + 137.5 + 10),
              height: 320.h,
              color: Colors.transparent,
              child: Row(
                children: [
                  list.isNotEmpty
                      ? Container(
                          height: 320.h,
                          width: 300.h,
                          color: Colors.transparent,
                          child: Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  WidgetUtils.CircleImageNet(
                                      320.h, 300.h, 10, list[index].coverImg!),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      list[index].roomName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: StyleUtils.getCommonTextStyle(
                                          color: Colors.white, fontSize: 21.sp),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0.h,
                                    child: SizedBox(
                                        height: 200.h,
                                        width: 100.w,
                                        child: const SVGASimpleImage(
                                          assetsName:
                                              'assets/svga/home_xinxing.svga',
                                        )),
                                  )
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
                              if (MyUtils.checkClick() &&
                                  sp.getBool('joinRoom') == false) {
                                setState(() {
                                  sp.setBool('joinRoom', true);
                                });
                                doPostBeforeJoin(list[index].id.toString(), '');
                              }
                            },
                          ),
                        )
                      : SizedBox(
                          height: 320.h,//280.h,
                          width: 300.h,//280.h,
                        ),
                  WidgetUtils.commonSizedBox(10.h, 15.w),
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(
                        children: [
                          WidgetUtils.commonSizedBox(5.h, 0),
                          Expanded(
                              child: GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick() &&
                                        sp.getBool('joinRoom') == false) {
                                      setState(() {
                                        sp.setBool('joinRoom', true);
                                      });
                                      doPostPushSound(0);
                                    }
                                  }),
                                  child: WidgetUtils.showImagesFill(
                                      sp.getInt('user_gender') == 2 ? 'assets/images/home_nansheng.png' : 'assets/images/home_nvsheng.png',
                                      double.infinity,
                                      double.infinity))),
                          WidgetUtils.commonSizedBox(20.h, 0),
                          Expanded(
                              child: GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick() &&
                                        sp.getBool('joinRoom') == false) {
                                      setState(() {
                                        sp.setBool('joinRoom', true);
                                      });
                                      doPostPushSound(1);
                                    }
                                  }),
                                  child: WidgetUtils.showImagesFill(
                                      'assets/images/home_yule.png',
                                      double.infinity,
                                      double.infinity))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
    // return SizedBox(
    //   width: double.infinity,
    //   child: FittedBox(
    //     child: Row(
    //       children: [
    //         ///热门推荐第一个大的轮播图
    //         _rmSwiper(450, listRoom),
    //         const SizedBox(width: 16),
    //         Column(
    //           children: [
    //             _rmSwiper(218, listRoom2),
    //             const SizedBox(height: 14),
    //             _rmSwiper(218, listRoom3),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  /// 首页 推荐房间/海报轮播/推荐主播
  Future<void> doPostPushRoom() async {
    LogE('token == ${sp.getString('user_token')}');
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
            if (bean.data!.bannerList!.isNotEmpty) {
              listBanner = bean.data!.bannerList!;
            }
            if (bean.data!.roomList1!.isNotEmpty) {
              listRoom = bean.data!.roomList1!;
            }
            if (bean.data!.roomList2!.isNotEmpty) {
              listRoom2 = bean.data!.roomList2!;
            }
            if (bean.data!.roomList3!.isNotEmpty) {
              listRoom3 = bean.data!.roomList3!;
            }
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

  /// 推荐主播
  Future<bool> doPostPushStreamer() async {
    LogE('token == ${sp.getString('user_token')}');
    bool isNoData = false;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'page': page,
        'pageSize': page == 1 ? 4 : 6,
      };
      // Loading.show(MyConfig.successTitle);
      pushStreamerBean bean = await DataUtils.postPushStreamer(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              listAnchor.clear();
              listB.clear();
              if (bean.data!.anchorList!.isNotEmpty) {
                listAnchor = bean.data!.anchorList!;
                for (int i = 0; i < bean.data!.anchorList!.length; i++) {
                  listB.add(false);
                }
              }
            } else {
              if (bean.data!.anchorList!.isNotEmpty) {
                for (int i = 0; i < bean.data!.anchorList!.length; i++) {
                  listAnchor.add(bean.data!.anchorList![i]);
                  listB.add(false);
                }
              } else {
                if (bean.data!.anchorList!.length < 6) {
                  _refreshController.loadNoData();
                  isNoData = true;
                }
              }
            }
            isUp = true;
            isDown = true;
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
    return isNoData;
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID, String anchorUid) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.isEmpty) {
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
      Loading.show2();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (sp.getString('sqRoomID').toString() == roomID) {
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentRFPage(
                context,
                RoomPage(
                  roomId: roomID,
                  beforeId: '',
                  roomToken: bean.data!.rtc!,
                ));
          } else {
            doPostRoomJoin(roomID, '', anchorUid, bean.data!.rtc!);
          }
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID,
                  roomToken: bean.data!.rtc!,
                  anchorUid: anchorUid));
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
  Future<void> doPostRoomJoin(
      roomID, password, String anchorUid, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password,
      'anchor_uid': anchorUid
    };
    try {
      Loading.show2();
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

  List<DataHot> list = [];

  /// 派对前5名排行
  Future<void> doPostHotRoom() async {
    try {
      // Loading.show();
      hotRoomBean bean = await DataUtils.postHotRoom();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            if (bean.data!.isNotEmpty) {
              list = bean.data!;
              if (tjRoom == 0) {
                tjRoom++;
              }
              if (sp.getBool('isFirst') == false && isFirstUp == false) {
                isFirstUp = true;
                // 推荐房间
                MyUtils.goTransparentPageCom(
                    context,
                    GPRoomPage(
                      roomID: bean.data![0].id.toString(),
                      roomUrl: bean.data![0].coverImg!,
                      roomName: bean.data![0].roomName!,
                    ));
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
      // Loading.dismiss();
    } catch (e) {
      // Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 推荐声音
  Future<void> doPostPushSound(int type) async {
    try {
      Loading.show2();
      soundBean bean = await DataUtils.postPushSound();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setBool('joinRoom', false);
            if (type == 0) {
              final roomId = bean.data!.findSound;
              if (roomId == 0) {
                MyToastUtils.showToastBottom('暂无合适的房间');
              } else {
                doPostBeforeJoin(bean.data!.findSound.toString(), '');
              }
            } else {
              doPostBeforeJoin(bean.data!.amuse.toString(), '');
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
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
