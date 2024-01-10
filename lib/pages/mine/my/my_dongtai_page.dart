import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:video_player/video_player.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/userDTListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../widget/SwiperPage.dart';
import '../../trends/PagePreviewVideo.dart';
import '../../trends/trends_more_page.dart';

///动态

class MyDongtaiPage extends StatefulWidget {
  const MyDongtaiPage({Key? key}) : super(key: key);

  @override
  State<MyDongtaiPage> createState() => _MyDongtaiPageState();
}

class _MyDongtaiPageState extends State<MyDongtaiPage> {
  List<ListDT> _list = [];
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
    doPostUserList();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostUserList();
    _refreshController.loadComplete();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          MyUtils.goTransparentRFPage(
              context,
              TrendsMorePage(
                note_id: _list[i].id.toString(),
              ));
        }
      }),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Text(
              _list[i].text!,
              maxLines: 20,
              style: StyleUtils.getCommonTextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
            WidgetUtils.commonSizedBox(10, 0),
            _list[i].type == 2
                ? showVideo(_list[i].imgUrl!)
                : showImag(_list[i].imgUrl!, i),
            WidgetUtils.commonSizedBox(10, 0),
            Row(
              children: [
                WidgetUtils.showImages(
                    _list[i].isLike == 0
                        ? 'assets/images/trends_zan1.png'
                        : 'assets/images/trends_zan_2.png',
                    18,
                    18),
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
      ),
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
                  if (MyUtils.checkClick()) {
                    MyUtils.goTransparentRFPage(
                        context, PagePreviewVideo(url: a));
                  }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
          if (MyUtils.checkClick()) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SwiperPage(imgList: listImg);
                }));
          }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostUserList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_videoController != null) {
      _videoController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return length > 0
        ? SmartRefresher(
            header: MyUtils.myHeader(),
            footer: MyUtils.myFotter(),
            controller: _refreshController,
            enablePullUp: true,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              itemBuilder: _itemPeople,
              itemCount: _list.length,
            ),
          )
        : Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
                WidgetUtils.commonSizedBox(10, 0),
                WidgetUtils.onlyTextCenter(
                    '暂无动态信息',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
                const Expanded(child: Text('')),
              ],
            ),
          );
  }

  /// 用户动态
  Future<void> doPostUserList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id'),
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show(MyConfig.successTitle);
      userDTListBean bean = await DataUtils.postUserList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list.add(bean.data!.list![i]);
              }

              length = bean.data!.list!.length;
            } else {
              if (page == 1) {
                length = 0;
              }
            }
            if (bean.data!.list!.length < MyConfig.pageSize) {
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
