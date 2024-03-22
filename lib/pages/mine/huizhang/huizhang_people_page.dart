import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/config/my_config.dart';
import '../../../bean/hzZhuBoBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/geren/people_info_page.dart';
import '../my/my_info_page.dart';

/// 公会成员
class HuiZhangPeoplePage extends StatefulWidget {
  String hzhtID;

  HuiZhangPeoplePage({Key? key, required this.hzhtID}) : super(key: key);

  @override
  State<HuiZhangPeoplePage> createState() => _HuiZhangPeoplePageState();
}

class _HuiZhangPeoplePageState extends State<HuiZhangPeoplePage> {
  var appBar;
  final TextEditingController _souSuoName = TextEditingController();
  var length = 1;

  List<Lists> list = [];

  /// 当前页码
  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
      doPostSearchConsortiaStreamer('');
    }
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
    doPostSearchConsortiaStreamer('');
    _refreshController.loadComplete();
  }

  var listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会主播', true, context, false, 0);
    doPostSearchConsortiaStreamer('');
    //设置完比例后返回显示
    listen = eventBus.on<BiLiBack>().listen((event) {
      setState(() {
        list[event.index].ratio = '${event.number}%';
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  /// 公会成员
  Widget _itemPeople(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              // 如果点击的是自己，进入自己的主页
              if (sp.getString('user_id').toString() ==
                  list[i].streamerUid.toString()) {
                MyUtils.goTransparentRFPage(context, const MyInfoPage());
              } else {
                sp.setString('other_id', list[i].streamerUid.toString());
                MyUtils.goTransparentRFPage(
                    context,
                    PeopleInfoPage(
                      otherId: list[i].streamerUid.toString(),
                      title: '其他',
                    ));
              }
            }
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(120),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.CircleImageNet(
                        76.h, 76.h, 38.h, list[i].avatar!),
                    list[i].liveStatus == 1
                        ? WidgetUtils.showImages(
                            'assets/images/zhibozhong.webp',
                            ScreenUtil().setHeight(100),
                            ScreenUtil().setWidth(100),
                          )
                        : const Text(''),
                  ],
                ),
                WidgetUtils.commonSizedBox(0, 10),
                SizedBox(
                  height: 76.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          WidgetUtils.onlyText(
                              list[i].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black, fontSize: 14)),
                          WidgetUtils.commonSizedBox(0, 5),
                          list[i].gender != 0
                              ? Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setWidth(40),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: BoxDecoration(
                                    //背景
                                    color: list[i].gender == 1
                                        ? MyColors.dtBlue
                                        : MyColors.dtPink,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0)),
                                  ),
                                  child: WidgetUtils.showImages(
                                      list[i].gender == 1
                                          ? 'assets/images/nan.png'
                                          : 'assets/images/nv.png',
                                      10,
                                      10),
                                )
                              : const Text(''),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetUtils.onlyText(
                              'ID:${list[i].id.toString()}',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black, fontSize: 14)),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10.h),
                const Spacer(),
                SizedBox(
                  height: 76.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      WidgetUtils.onlyText(
                          '分润',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black, fontSize: 14)),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText(
                          list[i].ratio!,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black, fontSize: 14)),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 76.h,
                  width: 200.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      WidgetUtils.onlyText(
                          '所属厅',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black, fontSize: 14)),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText(
                          list[i].title!.length > 5
                              ? '${list[i].title!.substring(0, 5)}...'
                              : list[i].title!,
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black, fontSize: 14)),
                      const Spacer(),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 20),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine(indent: 20, endIndent: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 20),
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                child: Container(
                  height: ScreenUtil().setHeight(70),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: MyColors.f4,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    //设置四周边框
                    border: Border.all(width: 1, color: MyColors.f4),
                  ),
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            MyUtils.hideKeyboard(context);
                            doPostSearchConsortiaStreamer(
                                _souSuoName.text.trim().toString());
                          }
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/sousuo_hui.png',
                            ScreenUtil().setHeight(30),
                            ScreenUtil().setHeight(30)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      Expanded(
                          child: TextField(
                        controller: _souSuoName,
                        inputFormatters: [
                          // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        ],
                        style: StyleUtils.loginTextStyle,
                        onSubmitted: (value) {
                          MyUtils.hideKeyboard(context);
                          doPostSearchConsortiaStreamer(value);
                        },
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          // labelText: "请输入用户名",
                          // icon: Icon(Icons.people), //前面的图标
                          hintText: '请输入昵称或ID',
                          hintStyle: StyleUtils.loginHintTextStyle,

                          contentPadding:
                              const EdgeInsets.only(top: 0, bottom: 0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
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
                      )),
                    ],
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
          Expanded(
            child: length > 0
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
                      itemCount: list.length,
                    ),
                  )
                : Container(
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const Expanded(child: Text('')),
                        WidgetUtils.showImages(
                            'assets/images/no_have.png', 100, 100),
                        WidgetUtils.commonSizedBox(10, 0),
                        WidgetUtils.onlyTextCenter(
                            '暂无公会成员',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g6,
                                fontSize: ScreenUtil().setSp(26))),
                        const Expanded(child: Text('')),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  /// listUrl
  Future<void> doPostSearchConsortiaStreamer(keyword) async {
    Loading.show(MyConfig.successTitle);
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'cid': widget.hzhtID,
        'keyword': keyword,
        'page': page,
        'pageSize': MyConfig.pageSize
      };
      hzZhuBoBean bean = await DataUtils.postSearchConsortiaStreamer(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            if (bean.data!.lists!.isNotEmpty) {
              for (int i = 0; i < bean.data!.lists!.length; i++) {
                list.add(bean.data!.lists![i]);
              }
              if (bean.data!.lists!.length < MyConfig.pageSize) {
                _refreshController.loadNoData();
              }

              length = bean.data!.lists!.length;
            } else {
              if (page == 1) {
                length = 0;
              } else {
                _refreshController.loadNoData();
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

  /// 是否移除
  Future<void> isRemove(BuildContext context, streamer_uid, index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '',
            callback: (res) {
              doPostKickOut(streamer_uid, index);
            },
            content: '是否确认移除该主播？',
          );
        });
  }

  /// 踢出公会
  Future<void> doPostKickOut(streamer_uid, index) async {
    Loading.show();
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_id': sp.getString('guild_id'),
        'streamer_uid': streamer_uid
      };
      CommonBean bean = await DataUtils.postKickOut(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.removeAt(index);
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
}
