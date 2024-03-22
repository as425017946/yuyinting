import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/Common_bean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/regex_formatter.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 主播分瑞比例
class FenRunPage extends StatefulWidget {
  String name;
  String id;
  String ghID;
  int index;
  String bili;

  FenRunPage(
      {super.key,
      required this.name,
      required this.id,
      required this.ghID,
      required this.index,
      required this.bili});

  @override
  State<FenRunPage> createState() => _FenRunPageState();
}

class _FenRunPageState extends State<FenRunPage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller.text = widget.bili.split('%')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ))),
          Container(
            height: 300.h,
            width: 450.h,
            alignment: Alignment.center,
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                WidgetUtils.onlyTextCenter(
                    widget.name,
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: 28.sp)),
                const Spacer(),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0.h, 20.h),
                    WidgetUtils.onlyTextCenter(
                        '设置比例：',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.black, fontSize: 24.sp)),
                    Expanded(
                        child: Container(
                      height: 50.h,
                      padding: EdgeInsets.only( left: 10.h),
                      margin: EdgeInsets.only(right: 60.h),
                      alignment: Alignment.centerLeft,
                      //边框设置
                      decoration: BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        //设置四周边框
                        border: Border.all(width: 1, color: MyColors.homeTopBG),
                      ),
                      child: Transform.translate(
                        offset: Offset(0,10.h),
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          inputFormatters: [
                            // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          //设置键盘为数字
                          style: StyleUtils.loginTextStyle,
                          onChanged: (value) {
                            LogE('返回值==  $value');
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // labelText: "请输入用户名",
                            // icon: Icon(Icons.people), //前面的图标
                            hintText: '请填写50及以上的数字',
                            hintStyle: StyleUtils.loginHintTextStyle,
                            // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 60.h,
                        width: 140.h,
                        margin: EdgeInsets.only(bottom: 50.h),
                        alignment: Alignment.center,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.g9,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Text(
                          '取消',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 24.sp),
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 50.h),
                    GestureDetector(
                      onTap: (() {
                        Navigator.pop(context);
                        if (MyUtils.checkClick()) {
                          doPostSetRatio();
                        }
                      }),
                      child: Container(
                        height: 60.h,
                        width: 140.h,
                        margin: EdgeInsets.only(bottom: 50.h),
                        alignment: Alignment.center,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.homeTopBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Text(
                          '确认',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white, fontSize: 24.sp),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                  ))),
        ],
      ),
    );
  }

  /// listUrl
  Future<void> doPostSetRatio() async {
    Loading.show('修改中...');
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'guild_id': widget.ghID,
        'streamer_uid': widget.id,
        'ratio': controller.text.trim(),
      };
      CommonBean bean = await DataUtils.postSetRatio(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(
              BiLiBack(index: widget.index, number: controller.text.trim()));
          MyToastUtils.showToastBottom('设置成功');
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
