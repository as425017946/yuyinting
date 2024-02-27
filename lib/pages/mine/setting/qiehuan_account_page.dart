import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/event_utils.dart';
import '../../../bean/qiehuanBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../login/login_page.dart';
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

    LogE('*****${sp.getString(MyConfig.userTwoToken).toString().isNotEmpty}');
    LogE('*****///${sp.getString(MyConfig.userTwoUID).toString()}');
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
            sp.getString(MyConfig.userOneToken).toString() != 'null' && sp.getString(MyConfig.userOneToken).toString().isNotEmpty ? GestureDetector(
              onTap: ((){
                if(sp.getString('user_token') != sp.getString(MyConfig.userOneToken)){
                  if(isClick){
                    MyToastUtils.showToastBottom('删除成功');
                    setState(() {
                      sp.setString('user_token', '');
                      sp.setString(MyConfig.userOneUID, '');
                      sp.setString(MyConfig.userOneHeaderImg, '');
                      sp.setString(MyConfig.userOneName, '');
                      sp.setString(MyConfig.userOneToken, '');
                      sp.setString(MyConfig.userOneID, '');
                    });
                  }else{
                    setState(() {
                      MyConfig.clickIndex = 1;
                      doPostCheckToken(1);
                    });
                  }

                }else{
                  MyToastUtils.showToastBottom('当前登录账号不能删除');
                }
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
                        sp.getString(MyConfig.userOneHeaderImg).toString()),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText(sp.getString(MyConfig.userOneName).toString(), StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：${sp.getString(MyConfig.userOneID).toString()}', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    sp.getString('user_token') == sp.getString(MyConfig.userOneToken) ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 10),
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
            ): const Text(''),
            WidgetUtils.commonSizedBox(10, 10),
            sp.getString(MyConfig.userTwoToken).toString() != 'null' && sp.getString(MyConfig.userTwoToken).toString().isNotEmpty ?  GestureDetector(
              onTap: ((){
                if(sp.getString('user_token') != sp.getString(MyConfig.userTwoToken)){
                  if(isClick){
                    MyToastUtils.showToastBottom('删除成功');
                    setState(() {
                      sp.setString('user_token', '');
                      sp.setString(MyConfig.userTwoUID, '');
                      sp.setString(MyConfig.userTwoHeaderImg, '');
                      sp.setString(MyConfig.userTwoName, '');
                      sp.setString(MyConfig.userTwoToken, '');
                      sp.setString(MyConfig.userTwoID, '');
                    });
                  }else{
                    setState(() {
                      MyConfig.clickIndex = 2;
                      doPostCheckToken(2);
                    });
                  }

                }else{
                  MyToastUtils.showToastBottom('当前登录账号不能删除');
                }
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
                        sp.getString(MyConfig.userTwoHeaderImg).toString()),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText(sp.getString(MyConfig.userTwoName).toString(), StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：${sp.getString(MyConfig.userTwoID).toString()}', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    sp.getString('user_token') == sp.getString(MyConfig.userTwoToken)  ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 10),
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
            ) : WidgetUtils.commonSizedBox(0, 0),
            sp.getString(MyConfig.userTwoToken).toString() != 'null' && sp.getString(MyConfig.userTwoToken).toString().isNotEmpty ? WidgetUtils.commonSizedBox(10, 10) : WidgetUtils.commonSizedBox(0, 0),
            sp.getString(MyConfig.userThreeToken).toString() != 'null' && sp.getString(MyConfig.userThreeToken).toString().isNotEmpty ? GestureDetector(
              onTap: ((){

                if(sp.getString('user_token') != sp.getString(MyConfig.userThreeToken)){
                  if(isClick){
                    MyToastUtils.showToastBottom('删除成功');
                    setState(() {
                      sp.setString('user_token', '');
                      sp.setString(MyConfig.userThreeUID, '');
                      sp.setString(MyConfig.userThreeHeaderImg, '');
                      sp.setString(MyConfig.userThreeName, '');
                      sp.setString(MyConfig.userThreeToken, '');
                      sp.setString(MyConfig.userThreeID, '');
                    });
                  }else{
                    setState(() {
                      MyConfig.clickIndex = 3;
                      doPostCheckToken(3);
                    });
                  }

                }else{
                  MyToastUtils.showToastBottom('当前登录账号不能删除');
                }
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
                        sp.getString(MyConfig.userThreeHeaderImg).toString()),
                    WidgetUtils.commonSizedBox(5, 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          WidgetUtils.onlyText(sp.getString(MyConfig.userThreeName).toString(), StyleUtils.getCommonTextStyle(color: MyColors.g2,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(30))),
                          WidgetUtils.commonSizedBox(5, 20),
                          WidgetUtils.onlyText('ID：${sp.getString(MyConfig.userThreeID).toString()}', StyleUtils.getCommonTextStyle(color: MyColors.g9,fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    sp.getString('user_token') == sp.getString(MyConfig.userThreeToken)  ? WidgetUtils.onlyText('当前登录', StyleUtils.getCommonTextStyle(color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(20))) : const Text(''),
                    WidgetUtils.commonSizedBox(0, 10),
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
            ) : WidgetUtils.commonSizedBox(0, 0),
            sp.getString(MyConfig.userThreeToken).toString() != 'null' && sp.getString(MyConfig.userThreeToken).toString().isNotEmpty ? WidgetUtils.commonSizedBox(10, 10) : WidgetUtils.commonSizedBox(0, 0),
            sp.getString(MyConfig.userOneToken).toString() != 'null' && sp.getString(MyConfig.userTwoToken).toString() != 'null' && sp.getString(MyConfig.userThreeToken).toString() != 'null' && sp.getString(MyConfig.userOneToken).toString().isNotEmpty && sp.getString(MyConfig.userTwoToken).toString().isNotEmpty && sp.getString(MyConfig.userThreeToken).toString().isNotEmpty ? const Text('') : GestureDetector(
              onTap: ((){
                setState(() {
                  MyConfig.issAdd = true;
                });
                eventBus.fire(SubmitButtonBack(title: '添加新账号'));
                Navigator.pushNamed(context, 'LoginPage');
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
                    WidgetUtils.CircleImageAss(80.h, 80.h, 40.h, 'assets/images/moren.png'),
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

  /// 切换用户
  Future<void> doPostCheckToken(v1) async {
    try {
      Loading.show("切换中...");
      String token = '';
      setState(() {
        if(v1 == 1){
          token = sp.getString(MyConfig.userOneToken).toString();
        }else if(v1 == 2){
          token = sp.getString(MyConfig.userTwoToken).toString();
        }else{
          token = sp.getString(MyConfig.userThreeToken).toString();
        }
      });
      Map<String, dynamic> params = <String, dynamic>{
        'token': token,
      };
      qiehuanBean commonBean = await DataUtils.postCheckToken(params);
      switch (commonBean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('成功切换');
          MyUtils.signOut();
          Future.delayed(const Duration(milliseconds: 1000),((){
            setState(() {
              sp.setString('user_token', '');
              sp.setString("user_account", '');
              sp.setString("user_id", '');
              sp.setString("em_pwd", '');
              sp.setString("em_token", '');
              sp.setString("user_password", '');
              sp.setString('user_phone', '');
              sp.setString('nickname', '');
              sp.setString("user_headimg", '');
              sp.setString("user_headimg_id", '');
              // 保存身份
              sp.setString("user_identity", '');
            });
            eventBus.fire(SubmitButtonBack(title: '成功切换账号'));
            sp.setString("em_pwd", commonBean.data!.emPwd!);
            sp.setString('user_identity', commonBean.data!.identity!);
            eventBus.fire(SubmitButtonBack(title: '更换了身份'));
            if(v1 == 1){
              setState(() {
                sp.setString('user_token', sp.getString(MyConfig.userOneToken).toString());
                sp.setString(MyConfig.userOneUID, commonBean.data!.uid.toString());
                sp.setString('user_id', commonBean.data!.uid.toString());
                MyUtils.initSDK();
                MyUtils.addChatListener();
                //先退出然后在登录
                MyUtils.signIn();
              });
            }else if(v1 == 2){
              setState(() {
                sp.setString('user_token', sp.getString(MyConfig.userTwoToken).toString());
                sp.setString(MyConfig.userTwoUID, commonBean.data!.uid.toString());
                sp.setString('user_id', commonBean.data!.uid.toString());
                MyUtils.initSDK();
                MyUtils.addChatListener();
                //先退出然后在登录
                MyUtils.signIn();
              });
            }else{
              setState(() {
                sp.setString('user_token', sp.getString(MyConfig.userThreeToken).toString());
                sp.setString(MyConfig.userThreeUID, commonBean.data!.uid.toString());
                sp.setString('user_id', commonBean.data!.uid.toString());
                MyUtils.initSDK();
                MyUtils.addChatListener();
                //先退出然后在登录
                MyUtils.signIn();
              });
            }
          }));
          break;
        case MyHttpConfig.errorloginCode:
          eventBus.fire(SubmitButtonBack(title: '成功切换账号'));
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(commonBean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

}
