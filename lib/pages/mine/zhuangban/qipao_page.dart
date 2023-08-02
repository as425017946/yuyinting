import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/myShopListBean.dart';
import '../../../bean/shopListBean.dart';
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
import '../../../widget/OptionGridView.dart';
/// 公平气泡
class QipaoPage extends StatefulWidget {
  const QipaoPage({Key? key}) : super(key: key);

  @override
  State<QipaoPage> createState() => _QipaoPageState();
}

class _QipaoPageState extends State<QipaoPage>  with AutomaticKeepAliveClientMixin{
  /// 刷新一次后不在刷新
  @override
  bool get wantKeepAlive => true;

  var length = 1;
  List<bool> listB = [];

  List<Data> _list = [];
  List<DataMy> _list2 = [];
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;
  /// 是否有选中的
  bool isChoose = false;
  int price=0;



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
    if(sp.getString('isShop').toString() == '1') {
      doPostMyIfon();
    }else {
      doPostMyShopList();
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
    if(sp.getString('isShop').toString() == '1') {
      doPostMyIfon();
    }else {
      doPostMyShopList();
    }
    _refreshController.loadComplete();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(sp.getString('isShop').toString() == '1') {
      doPostMyIfon();
    }else {
      doPostMyShopList();
    }
  }

  Widget _itemLiwu(BuildContext context, int i) {
    return sp.getString('isShop').toString() == '1'
        ? GestureDetector(
      onTap: (() {
        setState(() {
          for (int a = 0; a < length; a++) {
            if (a == i) {
              listB[a] = !listB[a];
            } else {
              listB[a] = false;
            }
          }
          for (int a = 0; a < length; a++) {
            if (listB[a]) {
              isChoose = true;
              price = _list[a].price!;
              break;
            } else {
              isChoose = false;
            }
          }
        });
      }),
      child: Container(
        width: ScreenUtil().setHeight(211),
        height: ScreenUtil().setHeight(325),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/zhuangban_bg1.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 20),
            WidgetUtils.showImagesNet(
                _list[i].img!,
                ScreenUtil().setHeight(200),
                ScreenUtil().setHeight(200)),
            WidgetUtils.commonSizedBox(10, 20),
            WidgetUtils.onlyTextCenter(
                _list[i].name!,
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.onlyTextCenter(
                _list[i].status == 1 ? '有效时长：永久' : '有效时长：${_list[i].useDay}天',
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 20),
          ],
        ),
      ),
    )
        : Container(
      width: ScreenUtil().setHeight(211),
      height: ScreenUtil().setHeight(325),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        //设置Container修饰
        image: DecorationImage(
          //背景图片修饰
          image: AssetImage("assets/images/zhuangban_bg1.png"),
          fit: BoxFit.fill, //覆盖
        ),
      ),
      child: Column(
        children: [
          WidgetUtils.commonSizedBox(20, 20),
          WidgetUtils.showImagesNet(
              _list2[i].img!,
              ScreenUtil().setHeight(200),
              ScreenUtil().setHeight(200)),
          WidgetUtils.commonSizedBox(10, 20),
          WidgetUtils.onlyTextCenter(
              _list2[i].name!,
              StyleUtils.getCommonTextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(25))),
          WidgetUtils.onlyTextCenter(
              _list2[i].isLong == 1 ? '有效时长：永久' : '到期：${_list2[i].expireTime}',
              StyleUtils.getCommonTextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(25))),
          WidgetUtils.commonSizedBox(10, 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: length > 0
            ? SmartRefresher(
          header: MyUtils.myHeader(),
          footer: MyUtils.myFotter(),
          controller: _refreshController,
          enablePullUp: true,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: OptionGridView(
            padding: const EdgeInsets.all(20),
            itemCount: sp.getString('isShop').toString() == '1' ?  _list.length : _list2.length,
            rowCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemBuilder: _itemLiwu,
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
                  '这里空空如野',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
              const Expanded(child: Text('')),
            ],
          ),
        ),),
        isChoose ? Container(
          height: ScreenUtil().setHeight(110),
          width: double.infinity,
          color: MyColors.zhuangbanBottomBG,
          child: Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Row(
                        children: [
                          WidgetUtils.onlyText(
                              price.toString(),
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(50))),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.onlyText(
                              '钻/豆',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'DouPayPage');
                        }),
                        child: WidgetUtils.onlyText(
                            '0 钻 | 充值 >',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zhuangbanWZ,
                                fontSize: ScreenUtil().setSp(25))),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                    ],
                  )),
              GestureDetector(
                onTap: (() {}),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(70),
                    ScreenUtil().setHeight(200),
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '立即购买',
                    ScreenUtil().setSp(33),
                    Colors.white),
              ),
              WidgetUtils.commonSizedBox(0, 20),
            ],
          ),
        ) : const Text('')
      ],
    );
  }
  /// 头像框
  Future<void> doPostMyIfon() async {
    Map<String, dynamic> params = <String, dynamic>{
      'class_id': '3',
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      shopListBean bean = await DataUtils.postShopList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
              listB.clear();
            }
            if (bean.data!.isNotEmpty) {
              for(int i =0; i < bean.data!.length; i++){
                _list.add(bean.data![i]);
                listB.add(false);
              }
              length = bean.data!.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.length < MyConfig.pageSize){
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


  /// 背包座驾
  Future<void> doPostMyShopList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'class_id': '3',
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      myShopListBean bean = await DataUtils.postMyShopList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list2.clear();
            }
            if (bean.data!.isNotEmpty) {
              for(int i =0; i < bean.data!.length; i++){
                _list2.add(bean.data![i]);
              }
              length = _list2.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.length < MyConfig.pageSize){
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
