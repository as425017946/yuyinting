import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';

import '../../../utils/my_toast_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 切换账号
class QiehuanAccountPage extends StatefulWidget {
  const QiehuanAccountPage({Key? key}) : super(key: key);

  @override
  State<QiehuanAccountPage> createState() => _QiehuanAccountPageState();
}

class _QiehuanAccountPageState extends State<QiehuanAccountPage> {
  var appBar;
  bool show = false;
  bool isClick = false;
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('切换账号', true, context, true, 5);
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '管理'){
        setState(() {
          isClick = true;
          appBar = WidgetUtils.getAppBar('切换账号', true, context, true, 1);
        });
      }else if(event.title == '完成'){
        setState(() {
          isClick = false;
          appBar = WidgetUtils.getAppBar('切换账号', true, context, true, 5);
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, 10),
            GestureDetector(
              onTap: ((){
                MyToastUtils.showToastBottom('点击了');
              }),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(140),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(80),
                        ScreenUtil().setHeight(80),
                        'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：123456', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    show == true ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    isClick == true ? Container(
                      width: ScreenUtil().setHeight(80),
                      height: ScreenUtil().setHeight(40),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.red,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Text(
                        '删除',
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                      ),
                    ) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10, 10),
            GestureDetector(
              onTap: ((){
                MyToastUtils.showToastBottom('点击了');
              }),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(140),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(80),
                        ScreenUtil().setHeight(80),
                        'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：123456', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    show == true ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    isClick == true ? Container(
                      width: ScreenUtil().setHeight(80),
                      height: ScreenUtil().setHeight(40),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.red,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Text(
                        '删除',
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                      ),
                    ) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10, 10),
            GestureDetector(
              onTap: ((){
                MyToastUtils.showToastBottom('点击了');
              }),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(140),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(80),
                        ScreenUtil().setHeight(80),
                        'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText('昵称', StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：123456', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    show == true ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    isClick == true ? Container(
                      width: ScreenUtil().setHeight(80),
                      height: ScreenUtil().setHeight(40),
                      alignment: Alignment.center,
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.red,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Text(
                        '删除',
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                      ),
                    ) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10, 10),
            GestureDetector(
              onTap: ((){
                MyToastUtils.showToastBottom('点击了');
              }),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(140),
                //边框设置
                decoration: const BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.CircleHeadImage2(
                        ScreenUtil().setHeight(80),
                        ScreenUtil().setHeight(80),
                        'assets/images/trends_jiahao.png'),
                    WidgetUtils.commonSizedBox(5, 20),
                    WidgetUtils.onlyText('添加账号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(30))),
                    WidgetUtils.commonSizedBox(0, 20),
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10, 10),
            WidgetUtils.onlyText('最多可以保存3个账号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(24))),
          ],
        ),
      ),
    );
  }
}
