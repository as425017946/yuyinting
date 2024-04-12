import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/myShopListBean.dart';
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
/// 气泡
class QiPaoBBPage extends StatefulWidget {
  const QiPaoBBPage({Key? key}) : super(key: key);

  @override
  State<QiPaoBBPage> createState() => _QiPaoBBPageState();
}

class _QiPaoBBPageState extends State<QiPaoBBPage>  with AutomaticKeepAliveClientMixin{
  /// 刷新一次后不在刷新
  @override
  bool get wantKeepAlive => true;

  var length = 1;
  List<bool> listB = [];
  List<DataMy> _list2 = [];
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;
  /// 是否有选中的
  bool isChoose = false;
  int price=0;
  String dressID = '';

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
    doPostMyShopList();
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
    doPostMyShopList();
    _refreshController.loadComplete();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostMyShopList();
  }

  Widget _itemLiwu(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          for (int a = 0; a < length; a++) {
            if (a == i) {
              listB[i] = true;
            } else {
              listB[a] = false;
            }
          }
          for (int a = 0; a < length; a++) {
            if (listB[a]) {
              isChoose = true;
              dressID = _list2[i].dressId.toString();
              // price = _list[a].price!;
              break;
            }
          }
        });
        if(isChoose){
          doPostSetDress(_list2[i].dressId.toString(), '1');
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
                ? "assets/images/zhuangban_bg3.png"
                : "assets/images/zhuangban_bg1.png"),
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
          enablePullUp: false,
          onLoading: _onLoading,
          onRefresh: _onRefresh,
          child: OptionGridView(
            padding: const EdgeInsets.all(20),
            itemCount: _list2.length,
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
        isChoose ? GestureDetector(
          onTap: ((){
              if(MyUtils.checkClick()){
                for (int a = 0; a < length; a++) {
                  setState(() {
                    listB[a] = false;
                    isChoose = false;
                  });
                }
                doPostSetDress(dressID, '0');
              }
          }),
          child: Container(
            height: ScreenUtil().setHeight(110),
            width: double.infinity,
            color: MyColors.zhuangbanBottomBG,
            alignment: Alignment.center,
            child: Container(
              height: 70.h,
              alignment: Alignment.center,
              width: 200.h,
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: MyColors.loginBtnP,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              child: Text(
                '卸下装扮',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ) : const Text('')
      ],
    );
  }

  /// 背包声波
  Future<void> doPostMyShopList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'class_id': '3',
      'page': page,
      'pageSize': MyConfig.pageSize2
    };
    try {
      myShopListBean bean = await DataUtils.postMyShopList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              listB.clear();
              _list2.clear();
            }
            if (bean.data!.isNotEmpty) {
              for(int i =0; i < bean.data!.length; i++){
                _list2.add(bean.data![i]);
                if(_list2[i].isWear == 1){
                  listB.add(true);
                }else{
                  listB.add(false);
                }
              }
              length = _list2.length;
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

  /// 设置装扮
  Future<void> doPostSetDress(String newID, String isWear) async {
    Map<String, dynamic> params = <String, dynamic>{
      'new_dress_id': newID,
      'is_wear': isWear,
    };
    try {
      CommonBean bean = await DataUtils.postSetDress(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
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

