import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/pages/mine/zhuangban/show_liwu_page.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/balanceBean.dart';
import '../../../bean/shopListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/OptionGridView.dart';
import '../qianbao/dou_pay_page.dart';
/// 进厅横幅
class HengfuPage extends StatefulWidget {
  const HengfuPage({Key? key}) : super(key: key);

  @override
  State<HengfuPage> createState() => _HengfuPageState();
}

class _HengfuPageState extends State<HengfuPage> with AutomaticKeepAliveClientMixin {
  /// 刷新一次后不在刷新
  @override
  bool get wantKeepAlive => true;

  var length = 1;
  List<bool> listB = [];

  final List<DataSC> _list = [];
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;
  /// 是否有选中的
  bool isChoose = false;
  int price=0;
  // 装扮id
  String dressID = '';
  String useDayLW = '0', priceLW = '0';


  void _onRefresh() async {
    // 重新初始化
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
    doPostMyIfon();
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
    doPostMyIfon();
    _refreshController.loadComplete();
  }


  @override
  void initState() {
    super.initState();
    doPostMyIfon();
    doPostBalance();
  }

  Widget _itemLiwu(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        //如果不是空的则展示多个购买信息
        if(_list[i].stepPriceDay!.isNotEmpty){
          if(MyUtils.checkClick()){
            MyUtils.goTransparentPage(context, ShowLiWuPage(imgUrl: _list[i].img!, imgSVGAUrl: _list[i].gifImg!, dressID: _list[i].gid.toString(), list: _list[i].stepPriceDay!,yue: jinbi2, fit: BoxFit.contain,));
          }
        }else{
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
                dressID = _list[i].gid.toString();
                useDayLW = _list[a].useDay.toString();
                priceLW = _list[a].price!.toString();
                break;
              } else {
                isChoose = false;
                dressID = '';
                useDayLW = '';
                priceLW = '';
              }
            }
          });
        }

      }),
      child: Container(
        width: ScreenUtil().setHeight(211),
        height: ScreenUtil().setHeight(325),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage(listB[i] == true
                ? "assets/images/zhuangban_bg2.png"
                : "assets/images/zhuangban_bg1.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 20),
            WidgetUtils.showImagesNet(
                _list[i].img!,
                ScreenUtil().setHeight(200),
                ScreenUtil().setHeight(300),
                fit: BoxFit.contain,
            ),
            WidgetUtils.commonSizedBox(10, 20),
            WidgetUtils.onlyTextCenter(
                _list[i].name!,
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(25))),
            // WidgetUtils.onlyTextCenter(
            //     _list[i].status == 1 ? '有效时长：永久' : '有效时长：${_list[i].useDay}天',
            //     StyleUtils.getCommonTextStyle(
            //         color: Colors.white,
            //         fontSize: ScreenUtil().setSp(25))),
            WidgetUtils.commonSizedBox(10, 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(child: length > 0
            ? SmartRefresher(
          header: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: MyUtils.myHeader(),
          ),
          footer: MyUtils.myFotter(),
          controller: _refreshController,
          enablePullUp: false,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: OptionGridView(
            padding: const EdgeInsets.all(20),
            itemCount:  _list.length,
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
                              '豆',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      GestureDetector(
                        onTap: ((){
                          if(MyUtils.checkClick()) {
                            MyUtils.goTransparentPageCom(context, DouPayPage(
                              shuliang: jinbi,));
                          }
                        }),
                        child: WidgetUtils.onlyText(
                            '$jinbi 金豆 | 充值 >',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.zhuangbanWZ,
                                fontSize: ScreenUtil().setSp(25))),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                    ],
                  )),
              GestureDetector(
                onTap: (() {
                  if(MyUtils.checkClick()){
                    doPostBuyDress(dressID);
                  }
                }),
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
      'class_id': '6',
      'page': page,
      'pageSize': MyConfig.pageSize2
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
              length = _list.length;
            }else{
              if (page == 1) {
                length = 0;
              }
            }
            if(bean.data!.length < MyConfig.pageSize){
              if(page > 1) {
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


  // 金币 钻石
  String jinbi = '', jinbi2 = '', zuanshi = '', zuanshi2 = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(double.parse(bean.data!.goldBean!) > 10000){
              jinbi = '${(double.parse(bean.data!.goldBean!)/10000)}w';
              List<String> a = jinbi.split('.');
              jinbi2 = '${a[0]}.${a[1].substring(0,2)}w';
            }else{
              jinbi = bean.data!.goldBean!;
              jinbi2 = bean.data!.goldBean!;
            }
            if(double.parse(bean.data!.diamond!) > 10000){
              zuanshi = '${(double.parse(bean.data!.diamond!)/10000)}w';
              List<String> a = zuanshi.split('.');
              zuanshi2 = '${a[0]}.${a[1].substring(0,2)}w';
            }else{
              zuanshi = bean.data!.diamond!;
              zuanshi2 = bean.data!.diamond!;
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
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 购买装扮
  Future<void> doPostBuyDress(String dressID) async {
    Map<String, dynamic> params = <String, dynamic>{
      'dress_id': dressID, //装扮id
      'use_day': useDayLW,
      'price': priceLW
    };
    try {
      CommonBean bean = await DataUtils.postBuyDress(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            for (int a = 0; a < length; a++) {
              listB[a] = false;
            }
            isChoose = false;
            dressID = '';
          });
          MyToastUtils.showToastBottom(MyConfig.buySuccess);
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