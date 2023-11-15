import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../../bean/whoLockMe.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
/// 谁看过我
class WhoLockMePage extends StatefulWidget {
  const WhoLockMePage({Key? key}) : super(key: key);

  @override
  State<WhoLockMePage> createState() => _WhoLockMePageState();
}

class _WhoLockMePageState extends State<WhoLockMePage> {

  var length = 1, number = 0;

  List<Data> _list = [];

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
    doPostHistoryList();
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
    doPostHistoryList();
    _refreshController.loadComplete();
  }

  Widget _itemPeople(BuildContext context, int i){
    return Container(
      height: ScreenUtil().setHeight(130),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: ((){
              Navigator.pushNamed(context, 'PeopleInfoPage');
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(90), ScreenUtil().setHeight(90), _list[i].avatar!),
                // WidgetUtils.showImages('assets/images/zhibozhong.webp', ScreenUtil().setHeight(110), ScreenUtil().setWidth(110),),
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
                        child: WidgetUtils.showImages(
                            _list[i].gender == 1 ? 'assets/images/nan.png' : 'assets/images/nv.png',
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
          Column(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyTextCenter(_list[i].addTime!.substring(5,10), StyleUtils.getCommonTextStyle(color: MyColors.homeNoHave, fontSize: ScreenUtil().setSp(21))),
              WidgetUtils.onlyTextCenter(_list[i].addTime!.substring(11,16), StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
              const Expanded(child: Text('')),
            ],
          ),
        ],
      ),
    );
  }

  // var appbar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // appbar = WidgetUtils.getAppBar('谁看过我', true, context, false, 0);
    doPostHistoryList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: length > 0
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
                '暂无人员查看您',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g6,
                    fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }


  /// 谁看过我
  Future<void> doPostHistoryList() async {
    try {
      Loading.show(MyConfig.successTitle);
      Map<String, dynamic> params = <String, dynamic>{
        'page': page,
        'pageSize': MyConfig.pageSize
      };
      whoLockMe bean = await DataUtils.postHistoryList(params);
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
              if(bean.data!.length < MyConfig.pageSize){
                _refreshController.loadNoData();
              }
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
