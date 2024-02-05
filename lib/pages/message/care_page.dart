import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../bean/Common_bean.dart';
import '../../bean/careListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import 'geren/people_info_page.dart';
///关注的人
class CarePage extends StatefulWidget {
  const CarePage({Key? key}) : super(key: key);

  @override
  State<CarePage> createState() => _CarePageState();
}

class _CarePageState extends State<CarePage> {

  List<Data> _list = [];
  var length = 1;
  var listen,infos = '';

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
    doPostFollowList();
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
    doPostFollowList();
    _refreshController.loadComplete();
  }

  Widget _itemPeople(BuildContext context, int i) {
    return SizedBox(
      height: ScreenUtil().setHeight(130),
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: ((){
              if(MyUtils.checkClick()){
                MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[i].uid.toString(),));
              }
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(80), ScreenUtil().setHeight(80), _list[i].avatar!),
                _list[i].live == 1 ? WidgetUtils.showImages('assets/images/zhibozhong.webp', ScreenUtil().setHeight(90), ScreenUtil().setHeight(90),) : WidgetUtils.commonSizedBox(0, 0),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          Expanded(
            child: Column(
              children: [
                const Expanded(child: Text('')),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        _list[i].nickname!,
                        style: StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(32)),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(40),
                        margin: const EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: _list[i].gender == 1 ? MyColors.dtBlue : MyColors.dtPink ,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child:  _list[i].gender == 1 ? WidgetUtils.showImages(
                            'assets/images/nan.png',
                            10,
                            10) : WidgetUtils.showImages(
                            'assets/images/nv.png',
                            10,
                            10),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: Text(
                    _list[i].description!,
                    style: StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          GestureDetector(
            onTap: ((){
              doPostFollow(_list[i].uid, i);
            }),
            child: Container(
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setWidth(150),
              alignment: Alignment.center,
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: MyColors.f6 ,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius:
                BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetUtils.showImages('assets/images/care_guanzhu.png', 8, 12),
                  WidgetUtils.commonSizedBox(0, 5),
                  WidgetUtils.onlyText(_list[i].follow == '0' ? '已关注' : '相互关注', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(22)))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen = eventBus.on<CareBack>().listen((event) {
        setState(() {
          infos = event.info;
          doPostFollowList();
        });
    });
    doPostFollowList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          WidgetUtils.onlyText('关注数（${_list.length}）', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
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
                      '暂无关注人员',
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


  /// 关注列表
  Future<void> doPostFollowList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'keywords': infos,
      'is_follow': '1',
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show(MyConfig.successTitle);
      careListBean bean = await DataUtils.postFollowList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if(bean.data!.isNotEmpty){
              for(int i =0; i < bean.data!.length; i++){
                _list.add(bean.data![i]);
              }
              // if(bean.data!.list!.length < MyConfig.pageSize){
              //   _refreshController.loadNoData();
              // }

              length = bean.data!.length;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 取消关注
  Future<void> doPostFollow(follow_id, index) async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status':'0',
      'follow_id': follow_id,
    };
    try {
      Loading.show("提交中...");
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("取关成功！");
          setState(() {
            _list.removeAt(index);
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
