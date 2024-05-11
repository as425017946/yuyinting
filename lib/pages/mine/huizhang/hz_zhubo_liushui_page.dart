import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/zhuboLiuShuiBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/date_picker.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 主播流水
class HZZhuBoLiuShuiPage extends StatefulWidget {
  String ghID;
  HZZhuBoLiuShuiPage({super.key, required this.ghID});

  @override
  State<HZZhuBoLiuShuiPage> createState() => _HZZhuBoLiuShuiPageState();
}

class _HZZhuBoLiuShuiPageState extends State<HZZhuBoLiuShuiPage> {
  TextEditingController controller = TextEditingController();
  var appBar;
  int page = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  String starTime = '', endTime = '', keyword = '';
  var listen;

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
    doPostStreamerSpendingList();
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
    doPostStreamerSpendingList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('主播流水', true, context, false, 0);
    DateTime now = DateTime.now();
    setState(() {
      starTime = now.toString().substring(0, 10);
      endTime = now.toString().substring(0, 10);
      doPostStreamerSpendingList();
    });
    listen = eventBus.on<InfoBack>().listen((event) {
      setState(() {
        keyword = event.info;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }


  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 200.h),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: const EdgeInsets.only(bottom: 10),
        color: MyColors.dailiBaobiao,
        child: Column(
          children: [
            Row(
              children: [
                WidgetUtils.onlyText(
                    '主播名称：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].nickname!,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: ScreenUtil().setSp(25))),
                const Spacer(),
                WidgetUtils.onlyText(
                    '主播ID：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].streamerUid.toString(),
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2, fontSize: ScreenUtil().setSp(25))),
                // WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
            WidgetUtils.commonSizedBox(15, 10),
            Row(
              children: [
                WidgetUtils.onlyText(
                    '总流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].beanSum!,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                // WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                // WidgetUtils.onlyText(list[i].unvalidSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText(
                    '金币直刷流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].gbDirectSpend!,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    '背包流水：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].packSpend!,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText(
                    '私信人数：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].msgPeople.toString(),
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    '私信条数：',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(
                    listInfo[i].msgNum.toString(),
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g2,
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            // WidgetUtils.onlyTextCenter('查明细>', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            // WidgetUtils.commonSizedBox(10, 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20.h, 20.h),
          Row(
            children: [
              const Expanded(child: Text('')),
              Column(
                children: [
                  Row(
                    children: [
                      WidgetUtils.onlyText(
                          '账号：',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(28))),
                      Container(
                        color: MyColors.dailiTime,
                        height: ScreenUtil().setHeight(40),
                        width: ScreenUtil().setHeight(300),
                        padding: const EdgeInsets.all(2),
                        child:
                        WidgetUtils.commonTextField(controller, '输入主播ID或昵称'),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(20, 10),
                  Row(
                    children: [
                      WidgetUtils.onlyText(
                          '时间：',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(28))),
                      GestureDetector(
                        onTap: (() {
                          if(MyUtils.checkClick()) {
                            DateTime now = DateTime.now();
                            int year = now.year;
                            int month = now.month;
                            int day = now.day;

                            DatePicker.show(
                              context,
                              startDate: DateTime(1970, 1, 1),
                              selectedDate: DateTime(year, month, day),
                              endDate: DateTime(2024, 12, 31),
                              onSelected: (date) {
                                setState(() {
                                  starTime = date.toString().substring(0, 10);
                                });
                              },
                            );
                          }
                        }),
                        child: Container(
                          color: MyColors.dailiTime,
                          padding: const EdgeInsets.all(2),
                          child: WidgetUtils.onlyText(
                              starTime,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.g6,
                                  fontSize: ScreenUtil().setSp(28))),
                        ),
                      ),
                      Opacity(
                          opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
                      Opacity(
                          opacity: 1,
                          child: WidgetUtils.onlyText(
                              '至',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.g6,
                                  fontSize: ScreenUtil().setSp(28)))),
                      Opacity(
                          opacity: 1, child: WidgetUtils.commonSizedBox(0, 10)),
                      GestureDetector(
                        onTap: (() {
                          DateTime now = DateTime.now();
                          int year = now.year;
                          int month = now.month;
                          int day = now.day;

                          DatePicker.show(
                            context,
                            startDate: DateTime(1970, 1, 1),
                            selectedDate: DateTime(year, month, day),
                            endDate: DateTime(2024, 12, 31),
                            onSelected: (date) {
                              setState(() {
                                endTime = date.toString().substring(0, 10);
                              });
                            },
                          );
                        }),
                        child: Container(
                          color: MyColors.dailiTime,
                          padding: const EdgeInsets.all(2),
                          child: WidgetUtils.onlyText(
                              endTime,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.g6,
                                  fontSize: ScreenUtil().setSp(28))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              WidgetUtils.commonSizedBox(0, 10),
              GestureDetector(
                onTap: (() {
                  MyUtils.hideKeyboard(context);
                  doPostStreamerSpendingList();
                }),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(50),
                    ScreenUtil().setHeight(120),
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '查询',
                    ScreenUtil().setSp(25),
                    Colors.white),
              ),
              const Expanded(child: Text('')),
            ],
          ),
          Expanded(
            child: SmartRefresher(
              header: MyUtils.myHeader(),
              footer: MyUtils.myFotter(),
              controller: _refreshController,
              enablePullUp: true,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                itemBuilder: _itemZhangdan,
                itemCount: listInfo.length,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// 房间流水
  List<Lists> listInfo = [];
  Future<void> doPostStreamerSpendingList() async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'start_time': starTime,
      'end_time': endTime,
      'keyword': controller.text.trim(),
      'guild_id': widget.ghID,
      'page': page,
      'pageSize': MyConfig.pageSize,
    };
    try {
      zhuboLiuShuiBean bean = await DataUtils.postCstreamerSpendingList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              listInfo.clear();
            }
            if (bean.data!.lists!.isNotEmpty) {
              for (int i = 0; i < bean.data!.lists!.length; i++) {
                listInfo.add(bean.data!.lists![i]);
              }
            } else {
              if (page > 1) {
                if (bean.data!.lists!.length < MyConfig.pageSize) {
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
}
