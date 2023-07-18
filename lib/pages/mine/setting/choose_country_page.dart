import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/quhao_bean.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../../bean/quhao_searche_bean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 选择国家区号
class ChooseCountryPage extends StatefulWidget {
  const ChooseCountryPage({Key? key}) : super(key: key);

  @override
  State<ChooseCountryPage> createState() => _ChooseCountryPageState();
}

class _ChooseCountryPageState extends State<ChooseCountryPage> {
  TextEditingController controllerName = TextEditingController();
  var appBar;
  // 搜索信息是否有值
  bool isHave = false;

  List<Popular> list_p = [];
  List<Normal> list_n = [] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('选择国家地区', true, context, false, 0);

    doQuhao();
  }

  // 常用
  Widget _itemCY(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: ((){
            eventBus.fire(AddressBack(info: list_p[i].code!));
            Navigator.pop(context);
          }),
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                WidgetUtils.onlyText(list_p[i].city!, StyleUtils.getCommonTextStyle(color: MyColors.g3,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(list_p[i].code!, StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(31))),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine()
      ],
    );
  }

  // 通用
  Widget _itemTY(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: ((){
            eventBus.fire(AddressBack(info: list_n[i].code!));
            Navigator.pop(context);
          }),
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                WidgetUtils.onlyText(list_n[i].city!, StyleUtils.getCommonTextStyle(color: MyColors.g3,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(list_n[i].code!, StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(31))),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine()
      ],
    );
  }

  // 搜索
  Widget _itemSS(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: ((){
            eventBus.fire(AddressBack(info: list_s[i].code!));
            Navigator.pop(context);
          }),
          child: SizedBox(
            width: double.infinity,
            height: ScreenUtil().setHeight(80),
            child: Row(
              children: [
                WidgetUtils.onlyText(list_s[i].city!, StyleUtils.getCommonTextStyle(color: MyColors.g3,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(list_s[i].code!, StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(31))),
              ],
            ),
          ),
        ),
        WidgetUtils.myLine()
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child:  Column(
            children: [
              Row(
                children: [
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
                              if(controllerName.text.isNotEmpty){
                                isHave = true;
                                doSearchQuhao();
                              }else{
                                MyUtils.hideKeyboard(context);
                                isHave = false;
                                doQuhao();
                              }
                            }),
                            child: WidgetUtils.showImages('assets/images/sousuo_hui.png',
                                ScreenUtil().setHeight(30), ScreenUtil().setHeight(30)),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          Expanded(child: WidgetUtils.commonTextField(controllerName, '请输入名称')),
                        ],
                      ),
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                ],
              ),
              WidgetUtils.commonSizedBox(20, 0),
              isHave == false ? Column(
                children: [
                  WidgetUtils.onlyText('常用', StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(42), fontWeight: FontWeight.w600)),
                  WidgetUtils.commonSizedBox(20, 0),
                  ListView.builder(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: _itemCY,
                    itemCount: list_p.length,
                  ),
                  WidgetUtils.commonSizedBox(20, 0),
                  WidgetUtils.onlyText('#', StyleUtils.getCommonTextStyle(
                      color: MyColors.g3, fontSize: ScreenUtil().setSp(42), fontWeight: FontWeight.w600)),
                  WidgetUtils.commonSizedBox(20, 0),
                  ListView.builder(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: _itemTY,
                    itemCount: list_n.length,
                  )
                ],
              )
                  :
              list_s.isNotEmpty ? ListView.builder(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: _itemSS,
                itemCount: list_s.length,
              ) : Container(
                height: ScreenUtil().setHeight(600),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/no_have.png', 100, 100),
                    WidgetUtils.commonSizedBox(10, 0),
                    WidgetUtils.onlyTextCenter('暂无搜索的国家区号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
                    const Expanded(child: Text('')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  ///区号
  Future<void> doQuhao() async {
    try {
      Loading.show("加载中...");
      QuhaoBean quhaoBean = await DataUtils.quhao();
      switch (quhaoBean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          list_n.clear();
          setState(() {
            list_p = quhaoBean.data!.popular!;
            list_n = quhaoBean.data!.normal!;
          });
          break;
        default:
          MyToastUtils.showToastBottom(quhaoBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom("111数据请求超时，请检查网络状况!");
    }
  }

  /// 按条件搜素
  List<DataSearch> list_s = [];
  Future<void> doSearchQuhao() async {
    var a = MediaQuery.of(context).viewInsets.bottom;
    if(a > 0){
      MyUtils.hideKeyboard(context);
    }
    String userName = controllerName.text.trim();
    Map<String, dynamic> params = <String, dynamic>{
      'keyword': userName,
    };
    try {
      Loading.show("加载中...");
      QuhaoSearcheBean quhaoSearcheBean = await DataUtils.codeSearch(params);
      switch (quhaoSearcheBean.code) {
        case MyHttpConfig.successCode:
          list_s.clear();
          if(quhaoSearcheBean.data!.isNotEmpty){
            setState(() {

              list_s = quhaoSearcheBean.data!;
            });
          }
          break;
        default:
          MyToastUtils.showToastBottom(quhaoSearcheBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
