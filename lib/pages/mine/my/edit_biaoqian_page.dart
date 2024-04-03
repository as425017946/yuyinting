import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import '../../../bean/labelListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';

/// 编辑标签页面
class EditBiaoqianPage extends StatefulWidget {
  const EditBiaoqianPage({Key? key}) : super(key: key);

  @override
  State<EditBiaoqianPage> createState() => _EditBiaoqianPageState();
}

class _EditBiaoqianPageState extends State<EditBiaoqianPage> {
  List<Data> list = [];
  List<bool> list_b = [];
  int length = 0;
  var listen;
  String label = '';
  String labelName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostLabelList();
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '选好了') {
        sp.setString('label_id', '');
        for (int i = 0; i < list_b.length; i++) {
          if (list_b[i]) {
            label = '$label${list[i].id},';
            labelName = '$labelName${list[i].name},';
          }
        }
        sp.setString('label_id', label);
        sp.setString('label_name', labelName);
        eventBus.fire(SubmitButtonBack(title: '标签选完'));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        body: Column(
          children: [
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.pop(context);
                }
              }),
              child: WidgetUtils.showImagesFill(
                  'assets/images/mine_biaoqian.png',
                  ScreenUtil().setHeight(200),
                  double.infinity),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10, 0),
                  Row(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/mine_biaoqian_ren.png',
                          ScreenUtil().setHeight(42),
                          ScreenUtil().setHeight(42)),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.onlyText(
                          '你是？',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(35))),
                      WidgetUtils.commonSizedBox(0, 10),
                      WidgetUtils.onlyText(
                          '$length/3',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(35))),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Wrap(
                    spacing: ScreenUtil().setHeight(15),
                    runSpacing: ScreenUtil().setHeight(15),
                    children: List.generate(
                        list.length,
                        (index) => GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  if (length < 3) {
                                    setState(() {
                                      list_b[index] = !list_b[index];
                                      if (list_b[index]) {
                                        length++;
                                      } else {
                                        length--;
                                      }
                                    });
                                  } else {
                                    if (list_b[index]) {
                                      setState(() {
                                        list_b[index] = !list_b[index];
                                        length--;
                                      });
                                    }
                                  }
                                }
                              }),
                              child: WidgetUtils.myContainerZishiying2(
                                  list_b[index]
                                      ? MyColors.homeTopBG
                                      : Colors.white,
                                  list_b[index]
                                      ? MyColors.homeTopBG
                                      : MyColors.f2,
                                  list[index].name!,
                                  StyleUtils.getCommonTextStyle(
                                      color: list_b[index] == false
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: ScreenUtil().setSp(28))),
                            )),
                  ),
                  WidgetUtils.commonSizedBox(60, 0),
                  WidgetUtils.commonSubmitButton('选好了'),
                  WidgetUtils.commonSizedBox(20, 0),
                ],
              ),
            )
          ],
        ));
  }

  /// 获取标签
  Future<void> doPostLabelList() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{'type': '1'};
    try {
      labelListBean bean = await DataUtils.postLabelList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list.clear();
          setState(() {
            list = bean.data!;
            for (int i = 0; i < list.length; i++) {
              list_b.add(false);
            }

            for (int i = 0; i < list.length; i++) {
              if (sp
                  .getString('label_id')
                  .toString()
                  .contains(list[i].id.toString())) {
                list_b.insert(i, true);
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
}
