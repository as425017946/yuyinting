import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:yuyinting/pages/trends/trends_hi_page.dart';
import 'package:yuyinting/pages/trends/trends_more_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import '../../bean/Common_bean.dart';
import '../../bean/DTListBean.dart';
import '../../bean/DTTuiJianListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/SwiperPage.dart';
import '../message/chat_page.dart';
import '../message/geren/people_info_page.dart';
import '../mine/my/my_info_page.dart';
import 'PagePreviewVideo.dart';

/// 动态-关注页面
class TrendsGuanZhuPage extends StatefulWidget {
  const TrendsGuanZhuPage({super.key});

  @override
  State<TrendsGuanZhuPage> createState() => _TrendsGuanZhuPageState();
}

class _TrendsGuanZhuPageState extends State<TrendsGuanZhuPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  String action = 'create';
  int index = 0;
  double x = 0, y = 0;
  var listen;
  List<ListDT> _list = [];
  List<String> imgList = [];

  List<ListTJ> _list_tj = [];
  List<String> imgListUrl = [];
  List<BannerTJ> imgList_tj = [];

  var length = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int page = 1;

  void _onRefresh() async {
    _refreshController.resetNoData();
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostGZFollowList();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostGZFollowList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostGZFollowList();
    doPostRecommendList("1");


    listen = eventBus.on<HiBack>().listen((event) {
      if (event.isBack) {
        //目的是为了有打过招呼的这个人的hi都变成私信按钮
        for (int i = 0; i < _list.length; i++) {
          setState(() {
            if (_list[i].uid.toString() == event.index) {
              _list[i].isHi = 1;
            }
          });
        }
        for (int i = 0; i < _list_tj.length; i++) {
          setState(() {
            if (_list_tj[i].uid.toString() == event.index) {
              _list_tj[i].isHi = 1;
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    listen.cancel();
  }


  Future _loadSVGA(isUrl, svgaUrl) {
    Future Function(String) decoder;
    if (isUrl) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(svgaUrl);
  }

  Widget _itemsTuijian(BuildContext context, int i) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        Container(
          height: ScreenUtil().setWidth(100 * 1.3),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    // 如果点击的是自己，进入自己的主页
                    if (sp.getString('user_id').toString() ==
                        _list[i].uid.toString()) {
                      MyUtils.goTransparentRFPage(context, const MyInfoPage());
                    } else {
                      sp.setString('other_id', _list[i].uid.toString());
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: _list[i].uid.toString(),
                            title: '其他',
                          ));
                    }
                  }
                }),
                child: WidgetUtils.CircleHeadImage(
                    40 * 2.w, 40 * 2.w, _list[i].avatar!),
              ),
              WidgetUtils.commonSizedBox(0, 8 * 2.w),
              Column(
                children: [
                  const Expanded(child: Text('')),
                  Container(
                    width: ScreenUtil().setWidth(300),
                    padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(8 * 1.3)),
                    child: Text(
                      _list[i].nickname!,
                      style: StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(30 * 1.3),
                    width: ScreenUtil().setWidth(300),
                    child: Row(
                      children: [
                        Container(
                          height: ScreenUtil().setWidth(25 * 1.3),
                          padding:
                              EdgeInsets.only(left: 5 * 2.w, right: 5 * 2.w),
                          margin: EdgeInsets.only(top: 2 * 2.w),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: _list[i].gender == 1
                                ? MyColors.dtBlue
                                : MyColors.dtPink,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(
                                ScreenUtil().setWidth(25 * 1.3) / 2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  _list[i].gender == 1
                                      ? 'assets/images/nan.png'
                                      : 'assets/images/nv.png',
                                  10 * 2.w,
                                  10 * 2.w),
                              WidgetUtils.commonSizedBox(0, 5 * 2.w),
                              WidgetUtils.onlyText(
                                  _list[i].age == -1
                                      ? '0·${_list[i].constellation!}'
                                      : '${_list[i].age.toString()}·${_list[i].constellation!}',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: 10 * 2.sp)),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const Expanded(child: Text('')),
                ],
              ),
              const Expanded(child: Text('')),
              _list[i].uid.toString() == sp.getString('user_id')
                  ? const Text('')
                  : _list[i].isHi == 0
                      ? GestureDetector(
                          onTap: (() {
                            MyUtils.goTransparentPageCom(
                                context,
                                TrendsHiPage(
                                    imgUrl: _list[i].avatar!,
                                    uid: _list[i].uid.toString(),
                                    index: i));
                          }),
                          child: WidgetUtils.showImages(
                              'assets/images/trends_hi.png',
                              124 * 2.w,
                              59 * 2.w),
                        )
                      : GestureDetector(
                          onTap: (() {
                            MyUtils.goTransparentRFPage(
                                context,
                                ChatPage(
                                    nickName: _list[i].nickname!,
                                    otherUid: _list[i].uid.toString(),
                                    otherImg: _list[i].avatar!));
                          }),
                          child: WidgetUtils.myContainer(
                              ScreenUtil().setWidth(45 * 1.3),
                              ScreenUtil().setWidth(100 * 1.3),
                              Colors.white,
                              MyColors.homeTopBG,
                              '私信',
                              ScreenUtil().setSp(25),
                              MyColors.homeTopBG),
                        ),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(5 * 2.w, 0),
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentRFPage(context,
                TrendsMorePage(note_id: _list[i].id.toString(), index: i));
          }),
          child: Container(
            color: Colors.transparent,
            child: WidgetUtils.onlyText(
                _list[i].text!,
                StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                )),
          ),
        ),
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        _list[i].type == 2
            ? showVideo(_list[i].imgUrl!, i)
            : showImag(_list[i].imgUrl!, i),
        WidgetUtils.commonSizedBox(20 * 2.w, 0),
        Row(
          children: [
            WidgetUtils.onlyText(
                '${_list[i].addTime}·来自：${_list[i].city}',
                StyleUtils.getCommonTextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(21),
                )),
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (_list[i].isLike == 1) {
                    action = 'delete';
                  } else {
                    action = 'create';
                    // isShow = false;
                  }
                });
                if (_list[i].isLike == 0) {
                  // animationController?.reset();
                  // animationController?.forward();
                }
                doPostLike(_list[i].id.toString(), i);
              }),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    WidgetUtils.showImages(
                        _list[i].isLike == 0
                            ? 'assets/images/trends_zan1.png'
                            : 'assets/images/trends_zan_2.png',
                        18 * 2.w,
                        18 * 2.w),
                    WidgetUtils.commonSizedBox(0, 5 * 2.w),
                    SizedBox(
                      width: ScreenUtil().setWidth(60 * 1.3),
                      child: WidgetUtils.onlyText(
                          _list[i].like == 0 ? '抢首赞' : _list[i].like.toString(),
                          StyleUtils.getCommonTextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(21),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                MyUtils.goTransparentRFPage(context,
                    TrendsMorePage(note_id: _list[i].id.toString(), index: i));
              }),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/trends_message.png', 18 * 2.w, 18 * 2.w),
                    WidgetUtils.commonSizedBox(0, 5 * 2.w),
                    WidgetUtils.onlyText(
                        _list[i].comment == 0
                            ? '评论'
                            : _list[i].comment.toString(),
                        StyleUtils.getCommonTextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(21),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        WidgetUtils.myLine()
      ],
    );
  }

  _initializeVideoController(List<String> listImg, int i) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: listImg[0],
      thumbnailPath: (await getTemporaryDirectory()).path,
      quality: 30,
    );
    setState(() {
      _list[i].imgUrl![1] = fileName!;
    });
    LogE('视频图片 $fileName');
  }

  Widget showVideo(List<String> listImg, int i) {
    if (listImg[1].isEmpty) {
      _initializeVideoController(listImg, i);
    }
    return Row(
      children: [
        Container(
          width: ScreenUtil().setHeight(200),
          height: ScreenUtil().setHeight(200),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: ScreenUtil().setHeight(200),
                height: ScreenUtil().setHeight(200),
                //超出部分，可裁剪
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: _list[i].imgUrl![1].isNotEmpty
                    ? Image.file(
                        File(_list[i].imgUrl![1]),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )
                    : const Text(''),
              ),
              GestureDetector(
                onTap: () {
                  MyUtils.goTransparentRFPage(
                      context, PagePreviewVideo(url: listImg[0]));
                },
                child: const Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _itemsTuijian2(BuildContext context, int i) {
    return Column(
      children: [
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        Container(
          height: ScreenUtil().setWidth(100 * 1.3),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    // 如果点击的是自己，进入自己的主页
                    if (sp.getString('user_id').toString() ==
                        _list_tj[i].uid.toString()) {
                      MyUtils.goTransparentRFPage(context, const MyInfoPage());
                    } else {
                      sp.setString('other_id', _list_tj[i].uid.toString());
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: _list_tj[i].uid.toString(),
                            title: '其他',
                          ));
                    }
                  }
                }),
                child: WidgetUtils.CircleHeadImage(
                    40 * 2.w, 40 * 2.w, _list_tj[i].avatar!),
              ),
              WidgetUtils.commonSizedBox(0, 8 * 2.w),
              Column(
                children: [
                  const Expanded(child: Text('')),
                  Container(
                    width: ScreenUtil().setWidth(300),
                    padding:
                        EdgeInsets.only(left: ScreenUtil().setWidth(8 * 1.3)),
                    child: Text(
                      _list_tj[i].nickname!,
                      style: StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(30 * 1.3),
                    width: ScreenUtil().setWidth(300),
                    child: Row(
                      children: [
                        Container(
                          height: ScreenUtil().setWidth(25 * 1.3),
                          padding:
                              EdgeInsets.only(left: 5 * 2.w, right: 5 * 2.w),
                          margin: EdgeInsets.only(top: 2 * 2.w),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: _list_tj[i].gender == 1
                                ? MyColors.dtBlue
                                : MyColors.dtPink,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(
                                ScreenUtil().setWidth(25 * 1.3) / 2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  _list_tj[i].gender == 1
                                      ? 'assets/images/nan.png'
                                      : 'assets/images/nv.png',
                                  10 * 2.w,
                                  10 * 2.w),
                              WidgetUtils.commonSizedBox(0, 5 * 2.w),
                              WidgetUtils.onlyText(
                                  _list_tj[i].age == -1
                                      ? '0·${_list_tj[i].constellation!}'
                                      : '${_list_tj[i].age.toString()}·${_list_tj[i].constellation!}',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: 10 * 2.sp)),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const Expanded(child: Text('')),
                ],
              ),
              const Expanded(child: Text('')),
              _list_tj[i].uid.toString() == sp.getString('user_id')
                  ? const Text('')
                  : _list_tj[i].isHi == 0
                      ? GestureDetector(
                          onTap: (() {
                            MyUtils.goTransparentPageCom(
                                context,
                                TrendsHiPage(
                                    imgUrl: _list_tj[i].avatar!,
                                    uid: _list_tj[i].uid.toString(),
                                    index: i));
                          }),
                          child: WidgetUtils.showImages(
                              'assets/images/trends_hi.png',
                              124 * 2.w,
                              59 * 2.w),
                        )
                      : GestureDetector(
                          onTap: (() {
                            MyUtils.goTransparentRFPage(
                                context,
                                ChatPage(
                                    nickName: _list_tj[i].nickname!,
                                    otherUid: _list_tj[i].uid.toString(),
                                    otherImg: _list_tj[i].avatar!));
                          }),
                          child: WidgetUtils.myContainer(
                              ScreenUtil().setWidth(45 * 1.3),
                              ScreenUtil().setWidth(100 * 1.3),
                              Colors.white,
                              MyColors.homeTopBG,
                              '私信',
                              ScreenUtil().setSp(25),
                              MyColors.homeTopBG),
                        ),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(5 * 2.w, 0),
        GestureDetector(
          onTap: (() {
            MyUtils.goTransparentRFPage(context,
                TrendsMorePage(note_id: _list_tj[i].id.toString(), index: i));
          }),
          child: Container(
            color: Colors.transparent,
            child: WidgetUtils.onlyText(
                _list_tj[i].text!,
                StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                )),
          ),
        ),
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        _list_tj[i].type == 2
            ? showVideo2(_list_tj[i].imgUrl!, i)
            : showImag(_list_tj[i].imgUrl!, i),
        WidgetUtils.commonSizedBox(20 * 2.w, 0),
        Row(
          children: [
            WidgetUtils.onlyText(
                '${_list_tj[i].addTime}·来自：${_list_tj[i].city}',
                StyleUtils.getCommonTextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(21),
                )),
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (_list_tj[i].isLike == 1) {
                    action = 'delete';
                  } else {
                    action = 'create';
                    // isShow = false;
                  }
                });
                if (_list_tj[i].isLike == 0) {
                  // animationController?.reset();
                  // animationController?.forward();
                }
                doPostLike(_list_tj[i].id.toString(), i);
              }),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    WidgetUtils.showImages(
                        _list_tj[i].isLike == 0
                            ? 'assets/images/trends_zan1.png'
                            : 'assets/images/trends_zan_2.png',
                        18 * 2.w,
                        18 * 2.w),
                    WidgetUtils.commonSizedBox(0, 5 * 2.w),
                    SizedBox(
                      width: ScreenUtil().setWidth(60 * 1.3),
                      child: WidgetUtils.onlyText(
                          _list_tj[i].like == 0
                              ? '抢首赞'
                              : _list_tj[i].like.toString(),
                          StyleUtils.getCommonTextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(21),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                MyUtils.goTransparentRFPage(
                    context,
                    TrendsMorePage(
                        note_id: _list_tj[i].id.toString(), index: i));
              }),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 20.w),
                child: Row(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/trends_message.png', 18 * 2.w, 18 * 2.w),
                    WidgetUtils.commonSizedBox(0, 5 * 2.w),
                    WidgetUtils.onlyText(
                        _list_tj[i].comment == 0
                            ? '评论'
                            : _list_tj[i].comment.toString(),
                        StyleUtils.getCommonTextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(21),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        WidgetUtils.commonSizedBox(10 * 2.w, 0),
        WidgetUtils.myLine()
      ],
    );
  }

  _initializeVideoController2(List<String> listImg, int i) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: listImg[0],
      thumbnailPath: (await getTemporaryDirectory()).path,
      quality: 30,
    );
    setState(() {
      _list_tj[i].imgUrl![1] = fileName!;
    });
    LogE('视频图片 $fileName');
  }

  Widget showVideo2(List<String> listImg, int i) {
    if (listImg[1].isEmpty) {
      _initializeVideoController2(listImg, i);
    }
    return Row(
      children: [
        Container(
          width: ScreenUtil().setHeight(200),
          height: ScreenUtil().setHeight(200),
          decoration: const BoxDecoration(
            //背景
            color: Colors.black87,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: ScreenUtil().setHeight(200),
                height: ScreenUtil().setHeight(200),
                //超出部分，可裁剪
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: _list_tj[i].imgUrl![1].isNotEmpty
                    ? Image.file(
                        File(_list_tj[i].imgUrl![1]),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )
                    : const Text(''),
              ),
              GestureDetector(
                onTap: () {
                  MyUtils.goTransparentRFPage(
                      context, PagePreviewVideo(url: listImg[0]));
                },
                child: const Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  ///显示图片
  Widget showImag(List<String> listImg, int i) {
    if (listImg.length == 1) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: Container(
          height: ScreenUtil().setHeight(300),
          alignment: Alignment.centerLeft,
          child: WidgetUtils.CircleImageNet(
              ScreenUtil().setHeight(300),
              ScreenUtil().setHeight(280),
              ScreenUtil().setHeight(10),
              listImg[0]),
        ),
      );
    } else if (listImg.length == 2) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(240),
          child: Row(
            children: [
              Expanded(
                  child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(240),
                      double.infinity, ScreenUtil().setHeight(10), listImg[0])),
              WidgetUtils.commonSizedBox(0, 10),
              Expanded(
                  child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(240),
                      double.infinity, ScreenUtil().setHeight(10), listImg[1])),
            ],
          ),
        ),
      );
    } else if (listImg.length == 3) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(350),
          child: Row(
            children: [
              WidgetUtils.CircleImageNet(
                  ScreenUtil().setHeight(350),
                  ScreenUtil().setHeight(350),
                  ScreenUtil().setHeight(10),
                  listImg[0]),
              WidgetUtils.commonSizedBox(0, 10),
              Expanded(
                  child: Column(
                children: [
                  WidgetUtils.CircleImageNet(ScreenUtil().setHeight(170),
                      double.infinity, ScreenUtil().setHeight(10), listImg[1]),
                  const Spacer(),
                  WidgetUtils.CircleImageNet(ScreenUtil().setHeight(170),
                      double.infinity, ScreenUtil().setHeight(10), listImg[2]),
                ],
              )),
            ],
          ),
        ),
      );
    } else if (listImg.length == 4) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(490),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(240),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[0])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(240),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[1])),
                ],
              ),
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(240),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[2])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(240),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[3])),
                ],
              )
            ],
          ),
        ),
      );
    } else if (listImg.length == 5) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(370),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[0])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[1])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[2])),
                ],
              ),
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[3])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[4])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: Opacity(
                    opacity: 0,
                    child: WidgetUtils.CircleImageNet(
                        ScreenUtil().setHeight(180),
                        double.infinity,
                        ScreenUtil().setHeight(10),
                        listImg[0]),
                  )),
                ],
              )
            ],
          ),
        ),
      );
    } else if (listImg.length == 6) {
      return GestureDetector(
        onTap: (() {
          imgList = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgList);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(370),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[0])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[1])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[2])),
                ],
              ),
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[3])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[4])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(
                          ScreenUtil().setHeight(180),
                          double.infinity,
                          ScreenUtil().setHeight(10),
                          listImg[5])),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Text('');
    }
  }


  Widget waterCard(BuildContext context, int index){
    final item = _list[index];
    return GestureDetector(
      onTap: ((){
        if(MyUtils.checkClick()){
          MyUtils.goTransparentRFPage(context,
              TrendsMorePage(note_id: _list[index].id.toString(), index: index));
        }
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: const BoxDecoration(
          //背景
          color: MyColors.f7,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            if (item.imgUrl != null && item.imgUrl!.isNotEmpty)
              WidgetUtils.CircleImageNetTop(350.h, 350.w, 30.h, item.imgUrl![0])
            else
              Image.asset('assets/images/img_placeholder.png', width: 350.w, height: 350.w, fit: BoxFit.fill,),

            Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              alignment: Alignment.topLeft,
              child: Text(
                _list[index].text!,
                maxLines: 3,
                style: TextStyle(
                  color: MyColors.newHomeBlack,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10.h, 0),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10.w),
                WidgetUtils.CircleHeadImage(
                    25 * 2.w, 25 * 2.w, _list[index].avatar!),
                WidgetUtils.commonSizedBox(0, 10.w),
                WidgetUtils.onlyText(_list[index].nickname!, StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 24.sp,)),
                const Spacer(),
                _list[index].isLike == 0 ?  GestureDetector(
                    onTap:((){
                      doPostLike(_list[index].id.toString(), index);
                    }),
                    child: WidgetUtils.showImages('assets/images/dt_dianzan1.png', 56.h, 115.w))
                    : Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      WidgetUtils.showImages('assets/images/trends_zan.png', 30.h, 30.h),
                      WidgetUtils.commonSizedBox(0, 5.w),
                      WidgetUtils.onlyText(_list[index].like.toString(), StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 22.sp,))
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10.w),
              ],
            ),
            WidgetUtils.commonSizedBox(10.h, 0),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (isOk == true && length == 0)
            ? SmartRefresher(
                header: MyUtils.myHeader(),
                footer: MyUtils.myFotter(),
                controller: _refreshController,
                enablePullUp: true,
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/trends_no.jpg',
                          ScreenUtil().setHeight(242),
                          ScreenUtil().setWidth(221)),
                      WidgetUtils.onlyTextBottom(
                          '您还没有关注的人',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.homeNoHave,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(50, 0),
                      Row(
                        children: [
                          Expanded(child: WidgetUtils.myLine()),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.onlyTextBottom(
                              '为您推荐一些有趣的内容',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.homeNoHave,
                                  fontSize: ScreenUtil().setSp(25))),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(child: WidgetUtils.myLine()),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        itemBuilder: _itemsTuijian2,
                        itemCount: _list_tj.length,
                      )
                    ],
                  ),
                ),
              )
            : SmartRefresher(
                header: MyUtils.myHeader(),
                footer: MyUtils.myFotter(),
                controller: _refreshController,
                enablePullUp: true,
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    child: MasonryGridView.count(
                      // 展示几列
                      crossAxisCount: 2,
                      // 元素总个数
                      itemCount: _list.length,
                      // 单个子元素
                      itemBuilder: waterCard,
                      // 纵向元素间距
                      mainAxisSpacing: 15.h,
                      // 横向元素间距
                      crossAxisSpacing: 10,
                      //本身不滚动，让外面的singlescrollview来滚动
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true, //收缩，让元素宽度自适应
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
      ],
    );
  }


  bool isOk = false;
  /// 关注列表
  Future<void> doPostGZFollowList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show(MyConfig.successTitle);
      DTListBean bean = await DataUtils.postGZFollowList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isOk = true;
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list.add(bean.data!.list![i]);
                if (bean.data!.list![i].type == 2) {
                  _list[i].imgUrl!.add('');
                }
              }
              length = _list.length;
            } else {
              if(page == 1){
                // 没有关注的人，需要请求推荐的接口
                doPostRecommendList("1");
              }else{
                // 没有关注的人，需要请求推荐的接口
                doPostRecommendList("0");
              }

              if (page > 1) {
                if (bean.data!.list!.length < MyConfig.pageSize) {
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

  /// 推荐动态列表
  Future<void> doPostRecommendList(is_refresh) async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize,
      'is_refresh': is_refresh
    };
    try {
      Loading.show(MyConfig.successTitle);
      DTTuiJianListBean bean = await DataUtils.postRecommendList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list_tj.clear();
            }
            if (bean.data!.banner!.isNotEmpty) {
              imgList_tj = bean.data!.banner!;
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list_tj.add(bean.data!.list![i]);
                if (bean.data!.list![i].type == 2) {
                  _list_tj[i].imgUrl!.add('');
                }
              }
              LogE('推荐${_list_tj.length}');
            } else {
              if (page > 1) {
                if (bean.data!.list!.length < MyConfig.pageSize) {
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 点赞
  Future<void> doPostLike(note_id, index) async {
    LogE('点赞数据$note_id');
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': note_id,
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postLike(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (length > 0) {
            int a = _list[index].like as int;
            setState(() {
              if (action == 'delete') {
                _list[index].isLike = 0;
                _list[index].like = a - 1;
              } else {
                _list[index].isLike = 1;
                _list[index].like = a + 1;
              }
            });
          } else {
            int a = _list_tj[index].like as int;
            setState(() {
              if (action == 'delete') {
                _list_tj[index].isLike = 0;
                _list_tj[index].like = a - 1;
              } else {
                _list_tj[index].isLike = 1;
                _list_tj[index].like = a + 1;
              }
            });
          }
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
