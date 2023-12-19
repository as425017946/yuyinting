import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/pages/trends/trends_hi_page.dart';
import 'package:yuyinting/pages/trends/trends_more_page.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../bean/Common_bean.dart';
import '../../bean/DTTuiJianListBean.dart';
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
import '../../widget/SwiperPage.dart';
import 'package:video_player/video_player.dart';

import '../message/chat_page.dart';
import '../message/geren/people_info_page.dart';
import 'PagePreviewVideo.dart';
/// 动态-推荐页面
class TrendsTuiJianPage extends StatefulWidget {
  const TrendsTuiJianPage({super.key});

  @override
  State<TrendsTuiJianPage> createState() => _TrendsTuiJianPageState();
}

class _TrendsTuiJianPageState extends State<TrendsTuiJianPage> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin{
  @override
  bool get wantKeepAlive => true;

  String action = 'create';
  int index = 0;
  int length = 1;
  double x = 0 , y = 0;

  List<ListTJ> _list = [];
  List<String> imgListUrl = [];
  List<BannerTJ> imgList = [];
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  var listen;
  int page = 1;


  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostRecommendList("1");
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
    doPostRecommendList("0");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRecommendList('1');

    animationController = SVGAAnimationController(vsync: this);
    loadAnimation();

    listen = eventBus.on<HiBack>().listen((event) {
      if(event.isBack){
        setState(() {
          _list[event.index].isHi = 1;
        });
      }
    });
  }


  @override
  void dispose() {
    animationController?.stop(); // 停止动画播放
    animationController?.dispose();
    // 移除监听器
    animationController?.removeListener(() {
      // 在这里处理动画的更新逻辑
    });
    animationController = null;
    super.dispose();
    listen.cancel();
    _videoController.dispose();
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
    animationController?.addListener(() {
      if (animationController!.currentFrame >= animationController!.frames - 1) {
        // 动画播放到最后一帧时停止播放
        animationController?.stop();
        if(mounted) {
          setState(() {
            isShow = false;
          });
        }
      }
    });
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

  Widget _itemsTuijian(BuildContext context, int i){
    return
      Column(
        children: [
          WidgetUtils.commonSizedBox(10, 0),
          Container(
            height: ScreenUtil().setHeight(100),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    sp.setString('other_id', _list[i].uid.toString());
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[i].uid.toString(),));
                  }),
                  child: WidgetUtils.CircleHeadImage(40, 40, _list[i].avatar!),
                ),
                WidgetUtils.commonSizedBox(0, 8),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    Container(
                      width: ScreenUtil().setWidth(300),
                      padding: EdgeInsets.only(left: ScreenUtil().setHeight(8)),
                      child: Text(
                        _list[i].nickname!,
                        style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                      width: ScreenUtil().setWidth(300),
                      child: Row(
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(25),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            margin: const EdgeInsets.only(top: 2),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: BoxDecoration(
                              //背景
                              color:  _list[i].gender == 1
                                  ? MyColors.dtBlue
                                  : MyColors.dtPink,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetUtils.showImages(_list[i].gender == 1 ? 'assets/images/nan.png' : 'assets/images/nv.png', 10, 10),
                                WidgetUtils.commonSizedBox(0, 5),
                                Column(
                                  children: [
                                    WidgetUtils.onlyText(_list[i].age == -1 ? '0·${_list[i].constellation!}' : '${_list[i].age.toString()}·${_list[i].constellation!}', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 10)),
                                  ],
                                )
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
                _list[i].uid.toString() == sp.getString('user_id') ? const Text('') :
                _list[i].isHi == 0
                    ? GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPageCom(context, TrendsHiPage(imgUrl: _list[i].avatar!, uid: _list[i].uid.toString(), index: i));
                  }),
                  child:  WidgetUtils.showImages(
                      'assets/images/trends_hi.png', 124, 59),
                )
                    : GestureDetector(
                  onTap: (() {
                    MyUtils.goTransparentRFPage(context, ChatPage(nickName: _list[i].nickname!, otherUid: _list[i].uid.toString(), otherImg: _list[i].avatar!));
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(45),
                      ScreenUtil().setHeight(100),
                      Colors.white,
                      MyColors.homeTopBG,
                      '私信',
                      ScreenUtil().setSp(25),
                      MyColors.homeTopBG),
                ),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(5, 0),
          GestureDetector(
            onTap: ((){
              MyUtils.goTransparentRFPage(context, TrendsMorePage( note_id: _list[i].id.toString(),));
            }),
            child: WidgetUtils.onlyText(
                _list[i].text!,
                StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                )),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          _list[i].type == 2 ? showVideo(_list[i].imgUrl!) : showImag(_list[i].imgUrl!, i),
          WidgetUtils.commonSizedBox(20, 0),
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
                onTap: ((){
                  setState(() {
                    if(_list[i].isLike == 1){
                      action = 'delete';
                    }else{
                      action = 'create';
                      isShow = true;
                    }
                  });
                  if(_list[i].isLike == 0){
                    animationController?.reset();
                    animationController?.forward();
                  }
                  doPostLike(_list[i].id.toString(),i);
                }),
                child: WidgetUtils.showImages(_list[i].isLike == 0 ? 'assets/images/trends_zan1.png' : 'assets/images/trends_zan_2.png', 18, 18),
              ),
              WidgetUtils.commonSizedBox(0, 5),
              SizedBox(
                width: ScreenUtil().setHeight(80),
                child: WidgetUtils.onlyText(
                    _list[i].like == 0 ? '抢首赞' : _list[i].like.toString(),
                    StyleUtils.getCommonTextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(21),
                    )),
              ),
              GestureDetector(
                onTap: ((){
                  MyUtils.goTransparentRFPage(context, TrendsMorePage( note_id: _list[i].id.toString(),));
                }),
                child: WidgetUtils.showImages(
                    'assets/images/trends_message.png', 18, 18),
              ),
              WidgetUtils.commonSizedBox(0, 5),
              GestureDetector(
                onTap: ((){
                  MyUtils.goTransparentRFPage(context, TrendsMorePage( note_id: _list[i].id.toString(),));
                }),
                child: WidgetUtils.onlyText(
                    _list[i].comment == 0 ? '评论' : _list[i].comment.toString(),
                    StyleUtils.getCommonTextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(21),
                    )),
              ),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.myLine()
        ],
      );
  }

  late VideoPlayerController _videoController;
  Widget showVideo(List<String> listImg) {
    String a = listImg[0];
    _videoController = VideoPlayerController.network(a,
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
                  MyUtils.goTransparentRFPage(context, PagePreviewVideo(url: a));
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
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
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
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
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
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(350),
          child: Row(
            children: [
              WidgetUtils.CircleImageNet(ScreenUtil().setHeight(350),
                  ScreenUtil().setHeight(350), ScreenUtil().setHeight(10), listImg[0]),
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
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(490),
          child: Column(
            children: [
              Row(
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
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(240),
                          double.infinity, ScreenUtil().setHeight(10), listImg[2])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(240),
                          double.infinity, ScreenUtil().setHeight(10), listImg[3])),
                ],
              )
            ],
          ),
        ),
      );
    } else if (listImg.length == 5) {
      return GestureDetector(
        onTap: (() {
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(370),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[0])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[1])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[2])),
                ],
              ),
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[3])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[4])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: Opacity(
                        opacity: 0,
                        child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                            double.infinity, ScreenUtil().setHeight(10), listImg[0]),
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
          imgListUrl = listImg;
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SwiperPage(imgList: imgListUrl);
              }));
        }),
        child: SizedBox(
          height: ScreenUtil().setHeight(370),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[0])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[1])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[2])),
                ],
              ),
              WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10), 10),
              Row(
                children: [
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[3])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[4])),
                  WidgetUtils.commonSizedBox(0, 10),
                  Expanded(
                      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(180),
                          double.infinity, ScreenUtil().setHeight(10), listImg[5])),
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
      onTapDown: ((details){
        final tapPosition = details.globalPosition;
        setState(() {
          x = tapPosition.dx;
          y = tapPosition.dy;
        });
      }),
      child: Stack(
        children: [
          Column(
            children: [
              WidgetUtils.commonSizedBox(20, 0),
              ///轮播图
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                height:ScreenUtil().setHeight(140),
                //超出部分，可裁剪
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Swiper(
                  itemBuilder: (BuildContext context,int index){
                    // 配置图片地址
                    return CachedNetworkImage(
                      imageUrl: imgList[index].img!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => WidgetUtils.CircleImageAss(ScreenUtil().setHeight(140), double.infinity, ScreenUtil().setHeight(10) , 'assets/images/img_placeholder.png',),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    );
                  },
                  // 配置图片数量
                  itemCount: imgList.length ,
                  // 无限循环
                  loop: true,
                  // 自动轮播
                  autoplay: true,
                  autoplayDelay: 5000,
                  duration: 2000,
                  onTap: (index){
                    // LogE('用户点击引起下标改变调用');

                  },
                ),
              ),
              Expanded(child: SmartRefresher(
                header: MyUtils.myHeader(),
                footer: MyUtils.myFotter(),
                controller: _refreshController,
                enablePullUp: true,
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: _itemsTuijian,
                  itemCount: _list.length,
                ),
              ),)
            ],
          ),
          ///点赞显示样式
          isShow ? Positioned(
            left: x-ScreenUtil().setHeight(50),
            top: y-ScreenUtil().setHeight(175),
            height: ScreenUtil().setHeight(100),
            width: ScreenUtil().setHeight(100),
            child: SVGAImage(animationController!),
          ) : const Text('')
        ],
      ),
    );
  }


  /// 关注列表
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
              _list.clear();
            }
            if(bean.data!.banner!.isNotEmpty){
              imgList = bean.data!.banner!;
            }
            if (bean.data!.list!.isNotEmpty) {
              for(int i =0; i < bean.data!.list!.length; i++){
                _list.add(bean.data!.list![i]);
              }
              LogE('推荐${_list.length}');
              length = bean.data!.list!.length;
            }else{
              if (page == 1) {
                length = 0;
              }else{
                if(bean.data!.list!.length < MyConfig.pageSize){
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
  Future<void> doPostLike(note_id,index) async {
    LogE('点赞数据$note_id');
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': note_id,
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postLike(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          int a = _list[index].like as int;
          setState(() {
            if(action == 'delete'){
              _list[index].isLike = 0;
              _list[index].like = a - 1;
            }else{
              _list[index].isLike = 1;
              _list[index].like = a + 1;
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

}
