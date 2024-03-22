import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:yuyinting/pages/message/report_img_page.dart';

import '../../bean/Common_bean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 举报用户
class ReportPage extends StatefulWidget {
  String otherUID;
  ReportPage({super.key, required this.otherUID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  TextEditingController controllerInfo = TextEditingController();
  var appBar;
  List<AssetEntity> lista = [];
  List<String> listaID = [];
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('举报该用户', true, context, false, 0);
    listen = eventBus.on<PhotoBack>().listen((event) {
      setState(() {
        if (lista.isEmpty) {
          lista = event.selectAss!;
        } else {
          for (int i = 0; i < event.selectAss!.length; i++) {
            lista.add(event.selectAss![i]);
          }
        }
        if (listaID.isEmpty) {
          listaID = event.id.split(',');
        } else {
          List<String> listID = event.id.split(',');
          for (int i = 0; i < listID.length; i++) {
            listaID.add(listID[i]);
          }
        }
      });
    });
  }


  void _removeImage2(int index) {
    setState(() {
      lista.removeAt(index);
      listaID.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      appBar: appBar,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(20, double.infinity),
            Container(
              margin: EdgeInsets.only(left: 20.h,right: 20.h),
              padding: EdgeInsets.all(20.h),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                //设置四周边框
                border: Border.all(width: 1, color: MyColors.d8),
              ),
              child: TextField(
                controller: controllerInfo,
                maxLength: 150,
                maxLines: 10,
                inputFormatters: [
                  // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                ],
                style: StyleUtils.loginTextStyle,
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  // labelText: "请输入用户名",
                  // icon: Icon(Icons.people), //前面的图标
                  hintText: '请填写举报信息',
                  hintStyle: StyleUtils.loginHintTextStyle,

                  contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h, left: 20.h),
              child: WidgetUtils.onlyText('截图凭证', StyleUtils.getCommonTextStyle(color: MyColors.g3,fontSize: ScreenUtil().setSp(33))),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.h,right: 20.h, top: 10.h),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 10.h,
                children: [
                  for (int i = 0; i < lista.length; i++)
                    Stack(
                      children: [
                        Container(
                          height: 150.h,
                          width: 190.w,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setHeight(20)),
                          ),
                          child: AssetEntityImage(
                            lista[i],
                            width: ScreenUtil().setHeight(120),
                            height: ScreenUtil().setHeight(120),
                            fit: BoxFit.cover,
                            isOriginal: false,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              if (MyUtils.checkClick()) {
                                setState(() {
                                  _removeImage2(i);
                                });
                              }
                            },
                            child: ClipOval(
                              child: Container(
                                color: Colors.white.withOpacity(0.7),
                                width: 20,
                                height: 20,
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  lista.length < 3
                      ? GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        Future.delayed(
                            const Duration(seconds: 0), () {
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (context,
                                      animation,
                                      secondaryAnimation) {
                                    return ReportIMGPage(
                                      length: 3 -
                                          lista.length,
                                    );
                                  }));
                        });
                      }
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/images_add.png',
                        150.h,
                        190.w),
                  )
                      : const Text(''),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(100, 0),
            GestureDetector(
              onTap: (() {
                if(MyUtils.checkClick()){
                  doPostMyIfon();
                }
              }),
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: WidgetUtils.myContainer(
                    ScreenUtil().setHeight(80),
                    double.infinity,
                    MyColors.homeTopBG,
                    MyColors.homeTopBG,
                    '确定',
                    ScreenUtil().setSp(33),
                    Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 用户举报
  Future<void> doPostMyIfon() async {
    String photo_id = '';
    for (int i = 0; i < listaID.length; i++) {
      if (photo_id.isNotEmpty && listaID[i].isNotEmpty) {
        photo_id = '$photo_id${listaID[i]},';
      } else if (photo_id.isEmpty) {
        photo_id = '${listaID[i]},';
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.otherUID,
      'content': controllerInfo.text.trim().toString(),
      'img_id': photo_id,
    };
    try {
      CommonBean bean = await DataUtils.postUserReport(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('已收到您的举报信息，请耐心等待官方审核');
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
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
      LogE('错误信息 ${e.toString()}');
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
