import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/pages/gongping/web_page.dart';
import 'package:yuyinting/pages/home/search_page.dart';
import '../../bean/Common_bean.dart';
import '../../bean/homeTJBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/pushStreamerBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
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
  List<int> listI = [];
  int a = 0, b = 0, c = 0;

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
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostPushRoom();
    doPostPushStreamer();
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
    doPostPushRoom();
    doPostPushStreamer();
    _refreshController.loadComplete();
  }

  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogE('值 ==  ${sp.getInt('tjFirst')}');
    if (sp.getInt('tjFirst') == 0) {
      doPostPushRoom();
      doPostPushStreamer();
      setState(() {
        int zhi = int.parse(sp.getInt('tjFirst').toString()) + 1;
        sp.setInt('tjFirst', zhi);
      });
    }
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
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  // 推荐主播
  Widget tuijian(context, i) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 0),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: double.infinity,
          height: ScreenUtil().setWidth(80 * 1.25),
          child: Row(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.CircleHeadImage(
                        (70 * 1.3).w, (70 * 1.3).w, listAnchor[i].avatar!),
                    listAnchor[i].live == 1
                        ? WidgetUtils.showImages(
                            'assets/images/zhibozhong.webp',
                            (80 * 1.3).w,
                            (80 * 1.3).w)
                        : const Text(''),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(0, 10),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          WidgetUtils.onlyText(
                              listAnchor[i].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * 2.w)),
                          WidgetUtils.commonSizedBox(0, 5),
                          listAnchor[i].gender != 0
                              ? Stack(
                                  children: [
                                    WidgetUtils.showImages(
                                        listAnchor[i].gender == 1
                                            ? 'assets/images/avj.png'
                                            : 'assets/images/avk.png',
                                        15 * 2.w,
                                        45 * 2.w),
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: int.parse(listAnchor[i]
                                                      .age
                                                      .toString()) >
                                                  9
                                              ? 15 * 1.3.w
                                              : 20 * 1.3.w),
                                      width: 45 * 2.w,
                                      height: 15 * 2.w,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        listAnchor[i].age.toString(),
                                        style: StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 12 * 2.w),
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(''),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        listAnchor[i].description!,
                        textAlign: TextAlign.left,
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 23.sp),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
                    setState(() {
                      sp.setBool('joinRoom', true);
                    });
                    doPostBeforeJoin(listAnchor[i].roomId.toString(),
                        listAnchor[i].uid.toString());
                  }
                }),
                child: Container(
                  height: 80 * 1.3.w,
                  width: 120 * 1.3.w,
                  color: Colors.transparent,
                  child: const SVGASimpleImage(
                    assetsName: 'assets/svga/home_gensui.svga',
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
        ),
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
    return SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: isUp, //是否允许上拉加载更多
      enablePullDown: isDown, // 是否允许下拉刷新
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      //渐变位置
                      begin: Alignment.topCenter, //右上
                      end: Alignment.bottomCenter, //左下
                      stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: [MyColors.homeTopBG, Colors.white])),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentPageCom(
                            context, const SearchPage());
                      }
                    }),
                    child: Container(
                      height: ScreenUtil().setHeight(100),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: ScreenUtil().setHeight(50),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: MyColors.homeSoucuoBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setHeight(50))),
                          //设置四周边框
                          border: Border.all(
                              width: 1, color: MyColors.homeSoucuoBG),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.showImages(
                                'assets/images/sousuo_hui.png', 25.h, 25.h),
                            WidgetUtils.commonSizedBox(0, 10),
                            Expanded(
                                child: WidgetUtils.onlyText(
                                    '搜索ID昵称房间名',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.black_1,
                                        fontSize: 26.sp))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: double.infinity,
                    child: Column(
                      children: [
                        ///轮播图
                        Container(
                          height: ScreenUtil().setWidth(140 * 1.3),
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Swiper(
                            key: UniqueKey(),
                            itemBuilder: (BuildContext context, int index) {
                              // 配置图片地址
                              return CachedNetworkImage(
                                imageUrl: listBanner[index].img!,
                                fit: BoxFit.fill,
                                placeholder: (context, url) =>
                                    WidgetUtils.CircleImageAss(
                                  ScreenUtil().setWidth(140 * 1.3),
                                  double.infinity,
                                  ScreenUtil().setHeight(10),
                                  'assets/images/img_placeholder.png',
                                ),
                                errorWidget: (context, url, error) =>
                                    WidgetUtils.CircleImageAss(
                                  ScreenUtil().setWidth(140 * 1.3),
                                  double.infinity,
                                  ScreenUtil().setHeight(10),
                                  'assets/images/img_placeholder.png',
                                ),
                              );
                            },
                            // 配置图片数量
                            itemCount: listBanner.length,
                            // 无限循环
                            loop: true,
                            // 自动轮播
                            autoplay: true,
                            autoplayDelay: 5000,
                            duration: 2000,
                            onIndexChanged: (index) {
                              // LogE('用户拖动或者自动播放引起下标改变调用');
                            },
                            onTap: (index) {
                              if (MyUtils.checkClick()) {
                                MyUtils.goTransparentPageCom(context,
                                    WebPage(url: listBanner[index].url!));
                              }
                            },
                          ),
                        ),

                        ///热门推荐
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.onlyText(
                            '热门推荐',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600)),
                        WidgetUtils.commonSizedBox(10, 0),

                        ///热门推荐
                        _rmtj(),
                        /*SizedBox(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(350),
                          child: Row(
                            children: [
                              ///热门推荐第一个大的轮播图
                              SizedBox(
                                height: ScreenUtil().setHeight(350),
                                width: ScreenUtil().setWidth(450),
                                child: listRoom.isNotEmpty
                                    ? Swiper(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          // 配置图片地址
                                          return Stack(
                                            children: [
                                              Container(
                                                height:
                                                    ScreenUtil().setHeight(350),
                                                width:
                                                    ScreenUtil().setWidth(450),
                                                //超出部分，可裁剪
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/images/img_placeholder.png',
                                                  image:
                                                      listRoom[index].coverImg!,
                                                  fit: BoxFit.cover,
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    // TODO 图片加载错误后展示的 widget
                                                    // print("---图片加载错误---");
                                                    // 此处不能 setState
                                                    return WidgetUtils
                                                        .showImages(
                                                      'assets/images/img_placeholder.png',
                                                      double.infinity,
                                                      double.infinity,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 10.h,
                                                  left: 10.h,
                                                  child: WidgetUtils.onlyText(
                                                      listRoom[index]
                                                                  .roomName!
                                                                  .length >
                                                              10
                                                          ? '${listRoom[index].roomName!.substring(0, 10)}...'
                                                          : listRoom[index]
                                                              .roomName!,
                                                      StyleUtils
                                                          .getCommonTextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 22.sp)))
                                            ],
                                          );
                                        },
                                        // 配置图片数量
                                        itemCount: listRoom.isEmpty
                                            ? 0
                                            : listRoom.length,
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
                                            doPostBeforeJoin(
                                                listRoom[index].id.toString(),
                                                '');
                                          }
                                        },
                                      )
                                    : const Text(''),
                              ),
                              WidgetUtils.commonSizedBox(0, 10),
                              Expanded(
                                  child: Column(
                                children: [
                                  ///热门推荐 小的轮播图1
                                  Expanded(
                                      child: SizedBox(
                                    height: ScreenUtil().setHeight(170),
                                    width: double.infinity,
                                    child: listRoom2.isNotEmpty
                                        ? Swiper(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // 配置图片地址
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: ScreenUtil()
                                                        .setHeight(170),
                                                    width: double.infinity,
                                                    //超出部分，可裁剪
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'assets/images/img_placeholder.png',
                                                      image: listRoom2[index]
                                                          .coverImg!,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        // TODO 图片加载错误后展示的 widget
                                                        // print("---图片加载错误---");
                                                        // 此处不能 setState
                                                        return WidgetUtils
                                                            .showImages(
                                                          'assets/images/img_placeholder.png',
                                                          double.infinity,
                                                          double.infinity,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 10.h,
                                                      left: 10.h,
                                                      child: WidgetUtils.onlyText(
                                                          listRoom2[index]
                                                                      .roomName!
                                                                      .length >
                                                                  10
                                                              ? '${listRoom2[index].roomName!.substring(0, 10)}...'
                                                              : listRoom2[index]
                                                                  .roomName!,
                                                          StyleUtils
                                                              .getCommonTextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      22.sp)))
                                                ],
                                              );
                                            },
                                            // 配置图片数量
                                            itemCount: listRoom2.length,
                                            // 无限循环
                                            loop: true,
                                            // 自动轮播
                                            autoplay: true,
                                            autoplayDelay: 4000,
                                            duration: 2000,
                                            onTap: (index) {
                                              if (MyUtils.checkClick() &&
                                                  sp.getBool('joinRoom') ==
                                                      false) {
                                                setState(() {
                                                  sp.setBool('joinRoom', true);
                                                });
                                                doPostBeforeJoin(
                                                    listRoom2[index]
                                                        .id
                                                        .toString(),
                                                    '');
                                              }
                                            },
                                          )
                                        : const Text(''),
                                  )),
                                  WidgetUtils.commonSizedBox(10, 0),

                                  ///热门推荐 小的轮播图2
                                  Expanded(
                                      child: SizedBox(
                                    height: ScreenUtil().setHeight(170),
                                    child: listRoom3.isNotEmpty
                                        ? Swiper(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              // 配置图片地址
                                              return Stack(
                                                children: [
                                                  Container(
                                                    height: ScreenUtil()
                                                        .setHeight(170),
                                                    width: double.infinity,
                                                    //超出部分，可裁剪
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'assets/images/img_placeholder.png',
                                                      image: listRoom3[index]
                                                          .coverImg!,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        // TODO 图片加载错误后展示的 widget
                                                        // print("---图片加载错误---");
                                                        // 此处不能 setState
                                                        return WidgetUtils
                                                            .showImages(
                                                          'assets/images/img_placeholder.png',
                                                          double.infinity,
                                                          double.infinity,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Positioned(
                                                      bottom: 10.h,
                                                      left: 10.h,
                                                      child: WidgetUtils.onlyText(
                                                          listRoom3[index]
                                                                      .roomName!
                                                                      .length >
                                                                  10
                                                              ? '${listRoom3[index].roomName!.substring(0, 10)}...'
                                                              : listRoom3[index]
                                                                  .roomName!,
                                                          StyleUtils
                                                              .getCommonTextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      22.sp)))
                                                ],
                                              );
                                            },
                                            // 配置图片数量
                                            itemCount: listRoom3.length,
                                            // 无限循环
                                            loop: true,
                                            // 自动轮播
                                            autoplay: true,
                                            autoplayDelay: 4000,
                                            duration: 2000,
                                            onTap: (index) {
                                              if (MyUtils.checkClick() &&
                                                  sp.getBool('joinRoom') ==
                                                      false) {
                                                setState(() {
                                                  sp.setBool('joinRoom', true);
                                                });
                                                doPostBeforeJoin(
                                                    listRoom3[index]
                                                        .id
                                                        .toString(),
                                                    '');
                                              }
                                              // doPostBeforeJoin(listRoom3[index].id.toString());
                                            },
                                          )
                                        : const Text(''),
                                  )),
                                ],
                              ))
                            ],
                          ),
                        )*/
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
                        '推荐主播',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600)),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: tuijian,
                    itemCount: listAnchor.length,
                  ),
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
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        child: Row(
          children: [
            ///热门推荐第一个大的轮播图
            _rmSwiper(450, listRoom),
            const SizedBox(width: 16),
            Column(
              children: [
                _rmSwiper(218, listRoom2),
                const SizedBox(height: 14),
                _rmSwiper(218, listRoom3),
              ],
            ),
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
              doPostBeforeJoin(list[index].id.toString(), '');
            }
          },
        ),
      );
    }
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
  Future<void> doPostPushStreamer() async {
    LogE('token == ${sp.getString('user_token')}');
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
              if (bean.data!.anchorList!.isNotEmpty) {
                listAnchor = bean.data!.anchorList!;
              }
            } else {
              if (bean.data!.anchorList!.isNotEmpty) {
                for (int i = 0; i < bean.data!.anchorList!.length; i++) {
                  listAnchor.add(bean.data!.anchorList![i]);
                }
              } else {
                if (bean.data!.anchorList!.length < 6) {
                  _refreshController.loadNoData();
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
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID, String anchorUid) async {
    //判断房间id是否为空的
    if (sp.getString('roomID') == null || sp.getString('').toString().isEmpty) {
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
          doPostRoomJoin(roomID, '', anchorUid, bean.data!.rtc!);
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
}
