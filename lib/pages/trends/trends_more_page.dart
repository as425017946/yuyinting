import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/pages/trends/trends_hi_page.dart';
import 'package:yuyinting/utils/loading.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/DTMoreBean.dart';
import '../../bean/plBean.dart';
import '../../bean/userInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../config/smile_utils.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../widget/SwiperPage.dart';
import '../message/chat_page.dart';
import '../message/geren/people_info_page.dart';
import 'PagePreviewVideo.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' as foundation;

class TrendsMorePage extends StatefulWidget {
  String note_id;
  int index;
  TrendsMorePage({Key? key, required this.note_id, required this.index}) : super(key: key);

  @override
  State<TrendsMorePage> createState() => _TrendsMorePageState();
}

class _TrendsMorePageState extends State<TrendsMorePage>
    with SingleTickerProviderStateMixin {
  var appBar;
  TextEditingController controller = TextEditingController();
  String headImage = '',
      nickName = '',
      text = '',
      constellation = '',
      add_time = '',
      city = '',
      myUid = '';
  int gender = 0,
      like = 0,
      comment = 0,
      is_hi = 0,
      isLike = 0,
      age = 0,
      type = 1;
  //查看详情是不是自己
  bool isMe = false;
  List<String> imgList = [];
  List<CommentList> comList = [];
  String action = 'create';
  double x = 0, y = 0;
  var listen ;
  bool _isEmojiPickerVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('动态详情', true, context, false, 0);
    doPostDtDetail(widget.note_id);
    doPostMyIfon();

    /// 页面加载完成
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController = SVGAAnimationController(vsync: this);
      loadAnimation();
    });

    _focusNode = FocusNode();
    _focusNode!.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    animationController?.stop(); // 停止动画播放
    animationController?.dispose();
    // 移除监听器
    animationController?.removeListener(_animListener);
    animationController = null;
    _focusNode!.removeListener(_onFocusChange);
    _focusNode!.dispose();
    super.dispose();
  }

  SVGAAnimationController? animationController;

  //动画是否在播放
  bool isShow = false;

  void loadAnimation() async {
    final videoItem = await _loadSVGA(false, 'assets/svga/dianzan_2.svga');
    videoItem.autorelease = false;
    animationController?.videoItem = videoItem;
    animationController
        ?.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => animationController?.videoItem = null);

    // 监听动画
    animationController?.addListener(_animListener);
  }

  void _animListener() {
    //TODO
    if (animationController!.currentFrame >= animationController!.frames - 1) {
      // 动画播放到最后一帧时停止播放
      animationController?.stop();
      if (mounted) {
        setState(() {
          isShow = false;
        });
      }
    }
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

  FocusNode? _focusNode;

  void _onFocusChange() {
    if (_focusNode!.hasFocus) {
      // 获取焦点事件处理逻辑
      print('TextField获取焦点');
      setState(() {
        _isEmojiPickerVisible = false;
      });
    } else {
      // 失去焦点事件处理逻辑
      print('TextField失去焦点');
    }
  }

  // 评论区
  Widget _itemsTuijian(BuildContext context, int i) {
    LogE('==========${comList[i].id.toString()}');
    return Column(
      children: [
        WidgetUtils.commonSizedBox(10, 0),
        Container(
          height: ScreenUtil().setHeight(100),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  WidgetUtils.CircleHeadImage(35, 35, comList[i].avatar!),
                  comList[i].gender != 0 ? Container(
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setWidth(30),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: BoxDecoration(
                      //背景
                      color: comList[i].gender == 1
                          ? MyColors.dtBlue
                          : MyColors.dtPink,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: WidgetUtils.showImages(
                        comList[i].gender == 1
                            ? 'assets/images/nan.png'
                            : 'assets/images/nv.png',
                        10,
                        10),
                  ) : const Text(''),
                ],
              ),
              WidgetUtils.commonSizedBox(0, 10),
              Expanded(
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        comList[i].nickname!,
                        style: StyleUtils.getCommonTextStyle(
                            color: MyColors.g6,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(5, 10),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        comList[i].content!,
                        maxLines: 10,
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(25)),
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
              (isMe || comList[i].uid.toString() == sp.getString('user_id'))
                  ? GestureDetector(
                      onTap: (() {
                        doPostComment('delete', comList[i].id.toString(), i);
                      }),
                      child: WidgetUtils.onlyText(
                          '删除',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(25))),
                    )
                  : const Text('')
            ],
          ),
        ),
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 45),
            Expanded(
                child: Text(
              '${comList[i].addTime} · 来自：${comList[i].city!.isEmpty ? '未知' : comList[i].city!}',
              style: StyleUtils.getCommonTextStyle(
                  color: MyColors.g9, fontSize: ScreenUtil().setSp(26)),
            )),
          ],
        ),
      ],
    );
  }

  late VideoPlayerController _videoController;

  Widget showVideo(List<String> listImg) {
    String a = listImg[0];
    _videoController = VideoPlayerController.network(
      a,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
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
              SizedBox(
                width: ScreenUtil().setHeight(200),
                height: ScreenUtil().setHeight(200),
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              ),
              GestureDetector(
                onTap: () {
                  MyUtils.goTransparentRFPage(
                      context, PagePreviewVideo(url: a));
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
  Widget showImag(List<String> listImg) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: ((details) {
        final tapPosition = details.globalPosition;
        setState(() {
          x = tapPosition.dx;
          y = tapPosition.dy;
        });
      }),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetUtils.commonSizedBox(10, 0),
                        Container(
                          height: ScreenUtil().setHeight(100),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: ((){
                                    if(MyUtils.checkClick()) {
                                      MyUtils.goTransparentRFPage(context,
                                          PeopleInfoPage(otherId: myUid,));
                                    }
                                  }),
                                  child: WidgetUtils.CircleHeadImage(40, 40, headImage)),
                              WidgetUtils.commonSizedBox(0, 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(child: Text('')),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(300),
                                    child: Text(
                                      nickName,
                                      style: StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(36),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    alignment: Alignment.center,
                                    //边框设置
                                    decoration: BoxDecoration(
                                      //背景
                                      color: gender == 1
                                          ? MyColors.dtBlue
                                          : MyColors.dtPink,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        WidgetUtils.showImages(
                                            gender == 1
                                                ? 'assets/images/nan.png'
                                                : 'assets/images/nv.png',
                                            10,
                                            10),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            age == -1
                                                ? '0·$constellation'
                                                : '${age.toString()}·$constellation',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                              const Expanded(child: Text('')),
                              // myUid == sp.getString('user_id')
                              //     ? const Text('')
                              //     : is_hi == 0
                              //         ? GestureDetector(
                              //           onTap: ((){
                              //             MyUtils.goTransparentPageCom(context, TrendsHiPage(imgUrl: headImage, uid: myUid, index: widget.index));
                              //           }),
                              //           child: WidgetUtils.showImages(
                              //               'assets/images/trends_hi.png',
                              //               124,
                              //               59),
                              //         )
                              //         : GestureDetector(
                              //             onTap: (() {
                              //               MyUtils.goTransparentRFPage(
                              //                   context,
                              //                   ChatPage(
                              //                       nickName: nickName,
                              //                       otherUid: sp
                              //                           .getString('user_id')
                              //                           .toString(),
                              //                       otherImg: headImage));
                              //             }),
                              //             child: WidgetUtils.myContainer(
                              //                 ScreenUtil().setHeight(45),
                              //                 ScreenUtil().setHeight(100),
                              //                 Colors.white,
                              //                 MyColors.homeTopBG,
                              //                 '私信',
                              //                 ScreenUtil().setSp(25),
                              //                 MyColors.homeTopBG),
                              //           ),
                            ],
                          ),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        Text(
                          text,
                          maxLines: 10,
                          style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(32),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        type == 2 ? showVideo(imgList) : showImag(imgList),
                        WidgetUtils.commonSizedBox(10, 0),
                        Row(
                          children: [
                            WidgetUtils.onlyText(
                                '$add_time·来自：$city',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w600)),
                            const Expanded(child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  if (isLike == 1) {
                                    action = 'delete';
                                  } else {
                                    action = 'create';
                                    isShow = true;
                                  }
                                });
                                if (isLike == 0) {
                                  animationController?.reset();
                                  animationController?.forward();
                                }
                                doPostLike();
                              }),
                              child: WidgetUtils.showImages(
                                  isLike == 0
                                      ? 'assets/images/trends_zan1.png'
                                      : 'assets/images/trends_zan_2.png',
                                  18,
                                  18),
                            ),
                            WidgetUtils.commonSizedBox(0, 5),
                            SizedBox(
                              width: ScreenUtil().setHeight(80),
                              child: WidgetUtils.onlyText(
                                  like == 0 ? '抢首赞' : like.toString(),
                                  StyleUtils.getCommonTextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(21),
                                  )),
                            ),
                            WidgetUtils.showImages(
                                'assets/images/trends_message.png', 18, 18),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyText(
                                comList.isEmpty
                                    ? '评论'
                                    : comList.length.toString(),
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                  ),

                  ///内容信息
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.myLine(thickness: 10),
                  WidgetUtils.commonSizedBox(20, 0),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      WidgetUtils.onlyText(
                          '评论 ${comList.length}',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 110),
                    itemBuilder: _itemsTuijian,
                    itemCount: comList.length,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height:_isEmojiPickerVisible ? 560.h : 110.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 0.5, //宽度
                      color: MyColors.f2, //边框颜色
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 20),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(60),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.f2,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: TextField(
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.send,
                              // 设置为发送按钮
                              controller: controller,
                              inputFormatters: [
                                RegexFormatter(
                                    regex: MyUtils.regexFirstNotNull),
                                LengthLimitingTextInputFormatter(
                                    30) //限制输入长度
                              ],
                              style: StyleUtils.loginTextStyle,
                              onSubmitted: (value) {
                                if(controller.text.trim().isNotEmpty){
                                  doPostComment('create', '', 0);
                                  MyUtils.hideKeyboard(context);
                                }
                              },
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                // labelText: "请输入用户名",
                                // icon: Icon(Icons.people), //前面的图标
                                hintText: '对 TA 说点什么吧~',
                                hintStyle: StyleUtils.loginHintTextStyle,

                                contentPadding: const EdgeInsets.only(
                                    top: 0, bottom: 0),
                                border: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                              ),
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              MyUtils.hideKeyboard(context);
                              _isEmojiPickerVisible = !_isEmojiPickerVisible;
                            });
                          }),
                          child: WidgetUtils.showImages(
                              'assets/images/trends_biaoqing.png', 22, 22),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        GestureDetector(
                          onTap: (() {
                            if(controller.text.trim().isNotEmpty){
                              _isEmojiPickerVisible = false;
                              doPostComment('create', '', 0);
                              MyUtils.hideKeyboard(context);
                            }
                          }),
                          child: Container(
                            height: ScreenUtil().setHeight(60),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: MyColors.homeTopBG,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: WidgetUtils.onlyText(
                                '发送',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(28))),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 20),
                      ],
                    ),
                    const Spacer(),
                    _isEmojiPickerVisible ? Visibility(
                      visible: _isEmojiPickerVisible,
                      child: SizedBox(
                        height: 450.h,
                        child: EmojiPicker(
                          onEmojiSelected: (Category? category, Emoji emoji) {},
                          onBackspacePressed: () {
                            // Do something when the user taps the backspace button (optional)
                            // Set it to null to hide the Backspace-Button
                          },
                          textEditingController: controller,
                          // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 *
                                (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                    ? 1.30
                                    : 1.0),
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            backspaceColor: Colors.blue,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: false,
                            replaceEmojiOnLimitExceed: false,
                            recentTabBehavior: RecentTabBehavior.RECENT,
                            recentsLimit: 28,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            // Needs to be const Widget
                            loadingIndicator: const SizedBox.shrink(),
                            // Needs to be const Widget
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            emojiSet: defaultEmojiSets,
                            buttonMode: ButtonMode.MATERIAL,
                          ),
                        ),
                      ),
                    ) : WidgetUtils.commonSizedBox(0, 0),
                  ],
                ),
              ),
            ),

            ///点赞显示样式
            isShow
                ? Positioned(
                    left: x - ScreenUtil().setHeight(50),
                    top: y - ScreenUtil().setHeight(210),
                    height: ScreenUtil().setHeight(100),
                    width: ScreenUtil().setHeight(100),
                    child: SVGAImage(animationController!),
                  )
                : const Text(''),
          ],
        ),
      ),
    );
  }

  /// 动态详情
  Future<void> doPostDtDetail(note_id) async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': note_id,
    };
    try {
      DTMoreBean bean = await DataUtils.postDtDetail(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            headImage = bean.data!.noteInfo!.avatar!;
            nickName = bean.data!.noteInfo!.nickname!;
            is_hi = bean.data!.noteInfo!.isHi as int;
            text = bean.data!.noteInfo!.text!;
            city = bean.data!.noteInfo!.city!;
            add_time = bean.data!.noteInfo!.addTime!;
            like = bean.data!.noteInfo!.like as int;
            comment = bean.data!.noteInfo!.comment as int;
            isLike = bean.data!.noteInfo!.isLike as int;
            age = bean.data!.noteInfo!.age as int;
            gender = bean.data!.noteInfo!.gender as int;
            constellation = bean.data!.noteInfo!.constellation!;
            type = bean.data!.noteInfo!.type as int;
            imgList = bean.data!.noteInfo!.imgUrl!;
            myUid = bean.data!.noteInfo!.uid.toString();
            comList = bean.data!.noteInfo!.commentList!;
            if(bean.data!.noteInfo!.uid.toString() == sp.getString('user_id')){
              isMe = true;
            }else{
              isMe = false;
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
  Future<void> doPostLike() async {
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': widget.note_id,
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postLike(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (action == 'delete') {
              isLike = 0;
              like--;
            } else {
              isLike = 1;
              like++;
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 评论
  Future<void> doPostComment(actionPL, comment_id, index) async {
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': widget.note_id,
      'action': actionPL,
      'content': controller.text.trim(),
      'comment_id': comment_id
    };
    try {
      plBean bean = await DataUtils.postComment(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (actionPL == 'delete') {
              comList.removeAt(index);
            } else {
              CommentList c = CommentList();
              c.id = bean.data;
              c.uid = int.parse(sp.getString('user_id').toString());
              c.avatar = sp.getString('dt_img').toString();
              c.nickname = sp.getString('dt_nick').toString();
              c.gender = int.parse(sp.getString('dt_gender').toString());
              c.content = controller.text.trim();
              DateTime d = DateTime.now();
              c.addTime = d.toString().substring(0, 10);
              c.city = sp.getString('dt_city').toString();
              comList.insert(0, c);
              controller.text = '';
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 获取我的信息
  Future<void> doPostMyIfon() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id')
    };
    try {
      userInfoBean bean = await DataUtils.postUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString("dt_img", bean.data!.avatarUrl!);
            sp.setString("dt_gender", bean.data!.gender.toString());
            sp.setString("dt_nick", bean.data!.nickname!);
            sp.setString("dt_city", bean.data!.city!);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
