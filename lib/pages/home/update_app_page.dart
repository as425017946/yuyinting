import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 在线更新app 使用
class UpdateAppPage extends StatefulWidget {
  String version;
  String url;
  String info;
  String forceUpdate;
  String title;

  UpdateAppPage(
      {super.key,
      required this.version,
      required this.url,
      required this.info,
      required this.forceUpdate,
      required this.title});

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  bool isClick = false;
  String info = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(widget.info.contains(';')){
        List<String> listInfo = widget.info.split(';');
        for(int i = 0; i < listInfo.length; i++){
          if(info.isEmpty){
            info = listInfo[i];
          }else{
            info = '$info\n${listInfo[i]}';
          }
        }
      }else{
        info = widget.info;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          // 返回键按下时的操作
          return false; // 如果希望按下返回键时关闭弹窗，返回true；如果希望阻止关闭弹窗，返回false
        },
        child: Center(
          child: Container(
            height: 580.h,
            width: 560.w,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/update_app.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(50.h, 0),
                Row(
                  children: [
                    const Spacer(),
                    (isClick == false && widget.forceUpdate == '0') ? GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 60.h,
                        width: 60.h,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: WidgetUtils.showImages(
                            'assets/images/update_app_close.png', 30.h, 30.h),
                      ),
                    ) : const Text('')
                  ],
                ),
                WidgetUtils.commonSizedBox(120.h, 0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 40.h),
                  child: WidgetUtils.onlyText(
                      '更新内容',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500)),
                ),
                WidgetUtils.commonSizedBox(10.h, 0),
                Container(
                  height: 150.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 40.h, right: 40.h),
                  child: SingleChildScrollView(
                    child: Text(
                        info,
                        maxLines: 100,
                        style:  TextStyle(
                          color: MyColors.g6,
                          fontSize: 26.sp,
                          height: 1.5
                        ),),
                  ),
                ),
                const Spacer(),
                isClick == true ? Stack(
                  children: [
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 40.h, right: 40.h),
                      // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                      child: ClipRRect(
                        // 边界半径（`borderRadius`）属性，圆角的边界半径。
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        child: LinearProgressIndicator(
                          value: jindu/100,
                          backgroundColor: MyColors.d8,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5b46b9)),
                        ),
                      ),
                    ),
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 50.h, right: 40.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '已更新$jindu%',
                        style: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 8.0,
                        ),
                      ),
                    ),
                  ],
                ) : WidgetUtils.commonSizedBox(0, 0),
                const Spacer(),
                isClick == false ? GestureDetector(
                  onTap: ((){
                    if(widget.title == 'ios'){
                      doUpdateIOS(widget.url);
                    }else{
                      if(MyUtils.checkClick()) {
                        setState(() {
                          isClick = true;
                        });
                        // 在这里放置确认操作的代码
                        doUpdate(context, widget.version, widget.url);
                      }
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                    height: ScreenUtil().setHeight(80),
                    alignment: Alignment.center,
                    width: double.infinity,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.loginBtnP,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: Text(
                      '立即更新',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ) : WidgetUtils.commonSizedBox(0, 0),
                WidgetUtils.commonSizedBox(50.h, 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //3.执行更新操作
  doUpdate(BuildContext context, String version, String url) async {
    // //关闭更新内容提示框
    // Navigator.pop(context);
    // downloadAndroid(url);
    _updateVersion(url);
  }
  //定义apk的名称，与下载进度dialog
  String apkName = 'flutterApp.apk';
  String progress = "";
  double jindu = 0;
  // late ProgressDialog pr;
  /// android app更新
  void _updateVersion(String url) async {
    // pr = ProgressDialog(
    //   context,
    //   showLogs: true,
    //   type: ProgressDialogType.download, //下载类型带下载进度
    //   isDismissible: false, //点击外层不消失
    // );
    // if (!pr.isShowing()) {
    //   pr.show();
    // }
    try {
      // 获取APP安装路径
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      // destinationFilename 是对下载的apk进行重命名
      OtaUpdate().execute(url, destinationFilename: 'lmkj.apk').listen(
            (OtaEvent event) {
          print('status:${event.status},value:${event.value} }');
          switch (event.status) {
            case OtaStatus.DOWNLOADING: // 下载中
              setState(() {
                progress = event.value!;
                double d = double.parse(progress);
                jindu = d;
                LogE('进度 ==  $d');
                // pr.update(
                //   progress: d,
                //   message: "下载中，请稍后…",
                // );
              });
              break;
            case OtaStatus.INSTALLING: //安装中
              // if (pr.isShowing()) {
              //   OpenFile.open("${appDocPath}/lmkj.apk");
              // }
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
              print('更新失败，请稍后再试');
              // if (pr.isShowing()) {
              //   pr.hide();
              // }
              break;
            default: // 其他问题
              break;
          }
        },
      );
    } catch (e) {
      print('更新失败，请稍后再试');
    }
  }


  //更新ios 直接跳转外部链接
  void doUpdateIOS(String url) async{
    await launch(url, forceSafariVC: false);
  }
}
