import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/log_util.dart';
import '../../bean/DTListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/SwiperPage.dart';

/// 动态-关注页面
class TrendsGuanZhuPage extends StatefulWidget {
  const TrendsGuanZhuPage({super.key});

  @override
  State<TrendsGuanZhuPage> createState() => _TrendsGuanZhuPageState();
}

class _TrendsGuanZhuPageState extends State<TrendsGuanZhuPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int index = 0;
  double x = 0, y = 0;

  List<ListDT> _list = [];
  List<String> imgList = [];
  var length = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
  }

  Widget _itemsTuijian(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {}),
      child: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 0),
          Container(
            height: ScreenUtil().setHeight(100),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(40, 40, _list[i].avatar!),
                WidgetUtils.commonSizedBox(0, 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(child: Text('')),
                    Container(
                      width: ScreenUtil().setWidth(300),
                      padding: EdgeInsets.only(left: ScreenUtil().setHeight(8)),
                      child: Text(
                        _list[i].nickname!,
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(30),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(25),
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
                              color: _list[i].gender == 1
                                  ? MyColors.dtBlue
                                  : MyColors.dtPink,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetUtils.showImages(
                                    _list[i].gender == 1
                                        ? 'assets/images/nan.png'
                                        : 'assets/images/nv.png',
                                    10,
                                    10),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    _list[i].age == -1 ? '0·${_list[i].constellation!}' : '${_list[i].age.toString()}·${_list[i].constellation!}',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
                const Expanded(child: Text('')),
                _list[i].gender == 0
                    ? WidgetUtils.showImages(
                        'assets/images/trends_hi.png', 124, 59)
                    : GestureDetector(
                        onTap: (() {}),
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
          WidgetUtils.onlyText(
              _list[i].text!,
              StyleUtils.getCommonTextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
              )),
          WidgetUtils.commonSizedBox(10, 0),
          showImag(_list[i].imgUrl!, i),
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
              WidgetUtils.showImages('assets/images/trends_zan1.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText(
                  _list[i].like == 0 ? '抢首赞' : _list[i].like.toString(),
                  StyleUtils.getCommonTextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(21),
                  )),
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.showImages(
                  'assets/images/trends_message.png', 18, 18),
              WidgetUtils.commonSizedBox(0, 5),
              WidgetUtils.onlyText(
                  _list[i].comment == 0 ? '评论' : _list[i].comment.toString(),
                  StyleUtils.getCommonTextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(21),
                  )),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.myLine()
        ],
      ),
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
          alignment: Alignment.centerLeft,
          child: WidgetUtils.CircleImageNet(
              ScreenUtil().setHeight(300),
              ScreenUtil().setHeight(280),
              ScreenUtil().setHeight(10),
              listImg[0]),
        ),
      );
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetUtils.commonSizedBox(50, 0),
                      WidgetUtils.showImages(
                          'assets/images/trends_no.jpg',
                          ScreenUtil().setHeight(242),
                          ScreenUtil().setWidth(221)),
                      WidgetUtils.onlyTextBottom(
                          '您还没有关注的人',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.homeNoHave,
                              fontSize: ScreenUtil().setSp(32))),
                      WidgetUtils.commonSizedBox(10, 0),
                      WidgetUtils.myLine(),
                      GestureDetector(
                        onTap: (() {
                          Navigator.pushNamed(context, 'TrendsMorePage');
                        }),
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(10, 0),
                            Container(
                              height: ScreenUtil().setHeight(100),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  WidgetUtils.CircleHeadImage(40, 40,
                                      'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                  WidgetUtils.commonSizedBox(0, 8),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      Container(
                                        width: ScreenUtil().setWidth(130),
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setHeight(8)),
                                        child: Text(
                                          '张三',
                                          style: StyleUtils.getCommonTextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(30),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(25),
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        margin: const EdgeInsets.only(top: 2),
                                        alignment: Alignment.center,
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: MyColors.dtPink,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            WidgetUtils.showImages(
                                                'assets/images/nv.png', 10, 10),
                                            WidgetUtils.commonSizedBox(0, 5),
                                            Column(
                                              children: [
                                                WidgetUtils.onlyText(
                                                    '21·天秤',
                                                    StyleUtils
                                                        .getCommonTextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: Text('')),
                                    ],
                                  ),
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages(
                                      'assets/images/trends_hi.png', 124, 59),
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            WidgetUtils.onlyText(
                                '哈哈哈哈哈哈',
                                StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(28),
                                )),
                            WidgetUtils.commonSizedBox(10, 0),
                            Row(
                              children: [
                                WidgetUtils.CircleImageNet(150, 150, 10,
                                    'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                                const Expanded(child: Text('')),
                                WidgetUtils.CircleImageNet(150, 150, 10,
                                    'https://img2.baidu.com/it/u=3119889017,2293875546&fm=253&fmt=auto&app=120&f=JPEG?w=608&h=342'),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(20, 0),
                            Row(
                              children: [
                                WidgetUtils.onlyText(
                                    '刚刚·来自：唐山',
                                    StyleUtils.getCommonTextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(21),
                                    )),
                                const Expanded(child: Text('')),
                                WidgetUtils.showImages(
                                    'assets/images/trends_zan1.png', 18, 18),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    '抢首赞',
                                    StyleUtils.getCommonTextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(21),
                                    )),
                                WidgetUtils.commonSizedBox(0, 20),
                                WidgetUtils.showImages(
                                    'assets/images/trends_message.png', 18, 18),
                                WidgetUtils.commonSizedBox(0, 5),
                                WidgetUtils.onlyText(
                                    '评论',
                                    StyleUtils.getCommonTextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(21),
                                    )),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(10, 0),
                            WidgetUtils.myLine()
                          ],
                        ),
                      )
                    ],
                  )
                : SmartRefresher(
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
                  ),

            ///点赞显示样式
            // Positioned(
            //   left: x-ScreenUtil().setHeight(100),
            //   top: y-ScreenUtil().setHeight(100),
            //   height: ScreenUtil().setHeight(200),
            //   width: ScreenUtil().setHeight(200),
            //   child: const SVGASimpleImage(
            //       assetsName: 'assets/svga/dianzan_2.svga'),
            // )
          ],
        ),
      ),
    );
  }

  /// 关注列表
  Future<void> doPostGZFollowList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show("加载中...");
      DTListBean bean = await DataUtils.postGZFollowList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for(int i =0; i < bean.data!.list!.length; i++){
                _list.add(bean.data!.list![i]);
              }

              length = bean.data!.list!.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.list!.length < MyConfig.pageSize){
              _refreshController.loadNoData();
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
