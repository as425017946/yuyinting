import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';
import '../../bean/Common_bean.dart';
import '../../bean/homeTJBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/gp_quanxian_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';
///推荐页面
class TuijianPage extends StatefulWidget {
  const TuijianPage({Key? key}) : super(key: key);

  @override
  State<TuijianPage> createState() => _TuijianPageState();
}

class _TuijianPageState extends State<TuijianPage> with AutomaticKeepAliveClientMixin{
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
  int a = 0, b =0, c = 0;

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
    doPostPushRoom();
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
    doPostPushRoom();
    _refreshController.loadComplete();
  }

  final TextEditingController _souSuoName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostPushRoom();
  }

  Widget tuijian(context, i){
    return Column(
      children: [
        WidgetUtils.commonSizedBox(20, 0),
        GestureDetector(
          onTap: ((){
            doPostBeforeJoin(listAnchor[i].roomId.toString());
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.CircleHeadImage(76.h, 76.h, listAnchor[i].avatar!),
                    listAnchor[i].live == 1 ? WidgetUtils.showImages( 'assets/images/zhibozhong.webp', 80.h, 80.h) : const Text(''),
                  ],
                ),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(listAnchor[i].nickname!, StyleUtils.getCommonTextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Stack(
                              children: [
                                WidgetUtils.showImages(listAnchor[i].gender == 1 ? 'assets/images/avj.png' : 'assets/images/avk.png', 15, 45),
                                Container(
                                  padding: const EdgeInsets.only(right: 8),
                                  width: 45,
                                  height: 15,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    listAnchor[i].age.toString(),
                                    style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          listAnchor[i].description!,
                          textAlign: TextAlign.left,
                          style: StyleUtils.getCommonTextStyle(color: Colors.grey,fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  width: 120.h,
                  child: const SVGASimpleImage(assetsName: 'assets/svga/home_gensui.svga',),
                ),
                WidgetUtils.commonSizedBox(0, 20),

              ],
            ),
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
      doPostBeforeJoin(roomId);
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
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(      //渐变位置
                    begin: Alignment.topCenter, //右上
                    end: Alignment.bottomCenter, //左下
                    stops: [0.0, 1.0],         //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [
                      MyColors.homeTopBG,
                      Colors.white
                    ]
                )
            ),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(80),
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
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    //设置四周边框
                    border: Border.all(width: 1, color: MyColors.homeSoucuoBG),
                  ),
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      WidgetUtils.showImages('assets/images/sousuo.png',
                          ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                      WidgetUtils.commonSizedBox(0, 10),
                      Expanded(child: WidgetUtils.commonTextField(_souSuoName, '搜索ID昵称房间名')),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      width: double.infinity,
                      child: Column(
                        children: [
                          ///轮播图
                          Container(
                            height:ScreenUtil().setHeight(140),
                            //超出部分，可裁剪
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Swiper(
                              key: UniqueKey(),
                              itemBuilder: (BuildContext context,int index){
                                // 配置图片地址
                                return CachedNetworkImage(
                                  imageUrl: listBanner[index].img!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => WidgetUtils.CircleImageAss(ScreenUtil().setHeight(140), double.infinity, ScreenUtil().setHeight(10) , 'assets/images/img_placeholder.png',),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                );
                              },
                              // 配置图片数量
                              itemCount: listBanner.length ,
                              // 无限循环
                              loop: true,
                              // 自动轮播
                              autoplay: true,
                              autoplayDelay: 5000,
                              duration: 2000,
                              onIndexChanged: (index){
                                // LogE('用户拖动或者自动播放引起下标改变调用');
                              },
                              onTap: (index){
                                // LogE('用户点击引起下标改变调用');
                              },
                            ),
                          ),
                          ///热门推荐
                          WidgetUtils.commonSizedBox(10, 0),
                          WidgetUtils.onlyText('热门推荐', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(10, 0),
                          SizedBox(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(350),
                            child: Row(
                              children: [
                                ///热门推荐第一个大的轮播图
                                Container(
                                  height:ScreenUtil().setHeight(350),
                                  width: ScreenUtil().setWidth(450),
                                  //超出部分，可裁剪
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Swiper(
                                    key: UniqueKey(),
                                    itemBuilder: (BuildContext context,int index){
                                      // 配置图片地址
                                      return FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/img_placeholder.png',
                                        image: listRoom[index].coverImg!,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                    // 配置图片数量
                                    itemCount: listRoom.isEmpty ? 0 : listRoom.length ,
                                    // 无限循环
                                    loop: true,
                                    // 自动轮播
                                    autoplay: true,
                                    autoplayDelay: 4000,
                                    duration: 2500,
                                    onIndexChanged: (index){
                                    },
                                    onTap: (index){
                                      quanxian(listRoom[index].id.toString());
                                    },
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(0, 10),
                                Expanded(child: Column(
                                  children: [
                                    ///热门推荐 小的轮播图1
                                    Expanded(child: Container(
                                      height: ScreenUtil().setHeight(170),
                                      //超出部分，可裁剪
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Swiper(
                                        key: UniqueKey(),
                                        itemBuilder: (BuildContext context,int index){
                                          // 配置图片地址
                                          return FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/img_placeholder.png',
                                            image: listRoom2[index].coverImg!,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                        // 配置图片数量
                                        itemCount: listRoom2.length ,
                                        // 无限循环
                                        loop: true,
                                        // 自动轮播
                                        autoplay: true,
                                        autoplayDelay: 4000,
                                        duration: 2000,
                                        onTap: (index){
                                          quanxian(listRoom2[index].id.toString());
                                        },
                                      ),
                                    )),
                                    WidgetUtils.commonSizedBox(10, 0),
                                    ///热门推荐 小的轮播图2
                                    Expanded(child: Container(
                                      height: ScreenUtil().setHeight(170),
                                      //超出部分，可裁剪
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Swiper(
                                        key: UniqueKey(),
                                        itemBuilder: (BuildContext context,int index){
                                          // 配置图片地址
                                          return FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/img_placeholder.png',
                                            image: listRoom3[index].coverImg!,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                        // 配置图片数量
                                        itemCount: listRoom3.length ,
                                        // 无限循环
                                        loop: true,
                                        // 自动轮播
                                        autoplay: true,
                                        autoplayDelay: 4000,
                                        duration: 2000,
                                        onTap: (index){
                                          quanxian(listRoom3[index].id.toString());
                                          // doPostBeforeJoin(listRoom3[index].id.toString());
                                        },
                                      ),
                                    )),
                                  ],
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    ///推荐主播
                    WidgetUtils.commonSizedBox(20, 0),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: WidgetUtils.onlyText('推荐主播', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(28),fontWeight: FontWeight.w600)),
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
      ),
    );
  }

  /// 首页 推荐房间/海报轮播/推荐主播
  Future<void> doPostPushRoom() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
      Loading.show(MyConfig.successTitle);
      homeTJBean bean = await DataUtils.postPushRoom();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listRoom.clear();
            listRoom2.clear();
            listRoom3.clear();
            if(bean.data!.bannerList!.isNotEmpty){
              listBanner = bean.data!.bannerList!;
            }
            if(bean.data!.roomList1!.isNotEmpty){
              listRoom = bean.data!.roomList1!;
            }
            if(bean.data!.roomList2!.isNotEmpty){
              listRoom2 = bean.data!.roomList2!;
            }
            if(bean.data!.roomList3!.isNotEmpty){
              listRoom3 = bean.data!.roomList3!;
            }
            if(bean.data!.anchorList!.isNotEmpty){
              listAnchor = bean.data!.anchorList!;
            }
            _refreshController.loadNoData();
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



  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '');
          break;
        case MyHttpConfig.errorRoomCode://需要密码
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(context, RoomTSMiMaPage(roomID: roomID,));
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


  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password) async {
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
          MyUtils.goTransparentRFPage(context, RoomPage(roomId: roomID,));
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
