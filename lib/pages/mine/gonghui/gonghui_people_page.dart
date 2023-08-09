import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/config/my_config.dart';
import '../../../bean/ghPeopleBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 公会成员
class GonghuiPeoplePage extends StatefulWidget {
  const GonghuiPeoplePage({Key? key}) : super(key: key);

  @override
  State<GonghuiPeoplePage> createState() => _GonghuiPeoplePageState();
}

class _GonghuiPeoplePageState extends State<GonghuiPeoplePage> {
  var appBar;
  final TextEditingController _souSuoName = TextEditingController();
  var length = 1;

  List<ListP> list = [];

  /// 当前页码
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
      doPostSearchGuildStreamer('');
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
    doPostSearchGuildStreamer('');
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('公会成员', true, context, false, 0);
    doPostSearchGuildStreamer('');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// 公会成员
  Widget _itemPeople(BuildContext context, int i) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 10),
        width: double.infinity,
        height: ScreenUtil().setHeight(120),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setWidth(100), list[i].avatar!),
                list[i].liveStatus == 1 ? WidgetUtils.showImages('assets/images/zhibozhong.webp', ScreenUtil().setHeight(100), ScreenUtil().setWidth(100),) : const Text(''),
              ],
            ),
            WidgetUtils.commonSizedBox(0, 10),
            WidgetUtils.onlyText(list[i].nickname!, StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: 14)),
            WidgetUtils.commonSizedBox(0, 5),
            Container(
              height: ScreenUtil().setHeight(25),
              width: ScreenUtil().setWidth(40),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: list[i].gender == 0 ? MyColors.dtPink : MyColors.dtBlue,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius:
                const BorderRadius.all(Radius.circular(30.0)),
              ),
              child: WidgetUtils.showImages(
                  list[i].gender == 0
                      ? 'assets/images/nv.png'
                      : 'assets/images/nan.png',
                  10,
                  10),
            ),
            const Expanded(child: Text('')),
            sp.getString('my_identity').toString() == 'leader' ? GestureDetector(
              onTap: ((){
                isRemove(context, list[i].streamerUid.toString(),i);
              }),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(100), Colors.white, MyColors.homeTopBG, '移出', ScreenUtil().setSp(25), MyColors.homeTopBG),
            ) : const Text(''),
            WidgetUtils.commonSizedBox(0, 20),

          ],
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
                        onTap: ((){
                          if(MyUtils.checkClick()){
                            MyUtils.hideKeyboard(context);
                            doPostSearchGuildStreamer(_souSuoName.text.trim().toString());
                          }
                        }),
                        child:  WidgetUtils.showImages('assets/images/sousuo_hui.png',
                            ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      Expanded(child: WidgetUtils.commonTextField(_souSuoName, '请输入昵称或ID')),
                    ],
                  ),
                ),
              ),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
          Expanded(
            child:  length > 0 ? SmartRefresher(
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
                :
            Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
                  WidgetUtils.commonSizedBox(10, 0),
                  WidgetUtils.onlyTextCenter('暂无公会成员', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
                  const Expanded(child: Text('')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 我的公会
  Future<void> doPostSearchGuildStreamer(keyword) async {
    Loading.show('加载中...');
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_id': sp.getString('guild_id'),
        'keyword': keyword
      };
      ghPeopleBean bean = await DataUtils.postSearchGuildStreamer(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              list.clear();
            }
            if(bean.data!.list!.isNotEmpty){
              for(int i =0; i < bean.data!.list!.length; i++){
                list.add(bean.data!.list![i]);
              }
              if(bean.data!.list!.length < MyConfig.pageSize){
                _refreshController.loadNoData();
              }

              length = bean.data!.list!.length;
            }else{
              if (page == 1) {
                length = 0;
              }else{
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 是否移除
  Future<void> isRemove(BuildContext context,streamer_uid,index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '',
            callback: (res) {
              doPostKickOut(streamer_uid,index);
            },
            content: '是否确认移除该主播？',
          );
        });
  }

  /// 踢出公会
  Future<void> doPostKickOut(streamer_uid,index) async {
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
