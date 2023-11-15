import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/Common_bean.dart';

import '../../../bean/qyListBean.dart';
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
/// 入驻审核
class ShenhePage extends StatefulWidget {
  const ShenhePage({Key? key}) : super(key: key);

  @override
  State<ShenhePage> createState() => _ShenhePageState();
}

class _ShenhePageState extends State<ShenhePage> {
  var appBar;
  var length = 1;
  List<Data> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('入驻审核', true, context, false, 0);
    doPostApplySignList();
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
          WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setWidth(100), list[i].avatar!),
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
          GestureDetector(
            onTap: ((){
              doPostSignExamine(list[i].streamerUid,'2',i);
            }),
            child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(90), Colors.white, MyColors.homeTopBG, '同意', ScreenUtil().setSp(25), MyColors.homeTopBG),
          ),
          WidgetUtils.commonSizedBox(0, 10),
          GestureDetector(
            onTap: ((){
              doPostSignExamine(list[i].streamerUid,'3',i);
            }),
            child: WidgetUtils.myContainer(ScreenUtil().setHeight(45), ScreenUtil().setHeight(90), Colors.white, MyColors.peopleRed, '拒绝', ScreenUtil().setSp(25), MyColors.peopleRed),
          ),
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
      body: length > 0 ? ListView.builder(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        itemBuilder: _itemPeople,
        itemCount: list.length,
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
            WidgetUtils.onlyTextCenter('暂无申请人员', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(26))),
            const Expanded(child: Text('')),
          ],
        ),
      ),
    );
  }


  /// 签约列表
  Future<void> doPostApplySignList() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'guild_id': sp.getString('guild_id'),
    };
    try {
      qyListBean bean = await DataUtils.postApplySignList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(bean.data!.isNotEmpty){
              list = bean.data!;
              length = list.length;
            }else{
              length = 0;
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


  /// 签约状态
  Future<void> doPostSignExamine(streamer_uid,status,index) async {
    Loading.show();
    Map<String, dynamic> params = <String, dynamic>{
      'guild_id': sp.getString('guild_id'),
      'streamer_uid': streamer_uid,
      'status': status //2通过 3拒绝
    };
    try {
      CommonBean bean = await DataUtils.postSignExamine(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('操作成功！');
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
