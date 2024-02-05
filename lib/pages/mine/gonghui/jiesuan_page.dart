import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/ghJieSuanListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'jiesuan_more_page.dart';
/// 结算账单
class JiesuanPage extends StatefulWidget {
  const JiesuanPage({Key? key}) : super(key: key);

  @override
  State<JiesuanPage> createState() => _JiesuanPageState();
}

class _JiesuanPageState extends State<JiesuanPage> {
  var appBar;
  List<Settle> list = [];
  // 直刷流水返点、背包流水返点、钻石游戏流水返点、公会名称
  String zjMoney = '', bbMoney = '', zsMoney = '', name = '';
  int page = 1;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

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
    doPostSettleList();
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
    doPostSettleList();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('结算账单', true, context, false, 0);
    doPostSettleList();
  }

  /// 账单
  Widget _itemZhangdan(BuildContext context, int i) {
    return GestureDetector(
      onTap: ((){
        MyUtils.goTransparentPageCom(context, JiesuanMorePage(id: list[i].id.toString(), starTime: list[i].beginTime!, endTime: list[i].endTime!));
      }),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: 260.h
        ),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: const EdgeInsets.only(bottom: 10),
        color: MyColors.dailiBaobiao,
        child: Column(
          children: [
            Row(
              children: [
                WidgetUtils.onlyText(list[i].beginTime!, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText('至', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(28))),
                WidgetUtils.commonSizedBox(0, 5),
                WidgetUtils.onlyText(list[i].endTime!, StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                const Expanded(child: Text('')),
                // WidgetUtils.onlyText('已结算', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
            WidgetUtils.commonSizedBox(15, 10),
            Row(
              children: [
                WidgetUtils.onlyText('当周总流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(list[i].weekSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                // WidgetUtils.onlyText('无效流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                // WidgetUtils.onlyText(list[i].unvalidSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText('V币直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(list[i].gbDirectSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('背包流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(list[i].packSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            Row(
              children: [
                WidgetUtils.onlyText('钻石直刷流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(list[i].dDirectSp!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText('钻石游戏流水：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
                WidgetUtils.onlyText(list[i].dGame!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 10),
            // Row(
            //   children: [
            //     WidgetUtils.onlyText('扣款V币：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            //     WidgetUtils.onlyText(list[i].deductibleGc!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
            //     const Expanded(child: Text('')),
            //     WidgetUtils.onlyText('扣款钻石：', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            //     WidgetUtils.onlyText(list[i].deductibleD!, StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: ScreenUtil().setSp(25), fontWeight: FontWeight.w600)),
            //   ],
            // ),
            WidgetUtils.onlyTextCenter('查明细>', StyleUtils.getCommonTextStyle(color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 10),
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
      body:  Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              WidgetUtils.showImagesFill('assets/images/gonghui_more_bg.jpg', ScreenUtil().setHeight(300), double.infinity),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Stack(
                  children: [
                    WidgetUtils.showImages('assets/images/gonghui_jiesuan.png', ScreenUtil().setHeight(250), double.infinity),
                    SizedBox(
                      height: ScreenUtil().setHeight(250),
                      child:  Column(
                        children: [
                          const Expanded(child: Text('')),
                          Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 140),
                              SizedBox(
                                width: ScreenUtil().setHeight(200),
                                child: Text(name,style: TextStyle(
                                    fontSize: ScreenUtil().setSp(55),
                                    color: Colors.white,
                                    fontFamily: 'YOUSHEBIAOTIHEI'),),
                              ),
                              // WidgetUtils.onlyText('27%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                            ],
                          ),
                          // WidgetUtils.commonSizedBox(8, 5),
                          // Row(
                          //   children: [
                          //     WidgetUtils.commonSizedBox(0, 140),
                          //     SizedBox(
                          //       width: ScreenUtil().setHeight(200),
                          //       child: WidgetUtils.onlyText('背包流水返点', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
                          //     ),
                          //     WidgetUtils.onlyText('27%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                          //   ],
                          // ),
                          // WidgetUtils.commonSizedBox(8, 5),
                          // Row(
                          //   children: [
                          //     WidgetUtils.commonSizedBox(0, 140),
                          //     SizedBox(
                          //       width: ScreenUtil().setHeight(200),
                          //       child: WidgetUtils.onlyText('钻石游戏流水返点', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
                          //     ),
                          //     WidgetUtils.onlyText('10%', StyleUtils.getCommonTextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33)))
                          //   ],
                          // ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
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
                itemCount: list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 结算账单列表
  Future<void> doPostSettleList() async {
    Loading.show(MyConfig.successTitle);
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_id': sp.getString('guild_id'),
        'page': page,
        'pageSize': MyConfig.pageSize,
      };
      ghJieSuanListBean bean = await DataUtils.postSettleList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            name = bean.data!.guildName!;
            if (bean.data!.settle!.isNotEmpty) {
              list = bean.data!.settle!;
            }else{
              if(page > 1){
                if(bean.data!.settle!.length < MyConfig.pageSize){
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

