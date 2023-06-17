import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 填写个人信息
class EditInfoPage extends StatefulWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  TextEditingController controller = TextEditingController();
  var sex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.black45,
      body: WillPopScope(
        //此处代码是出来选择学校弹窗后，不能点击返回消失页面
        onWillPop: () async {
          return Future.value(false);
        },
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(260, 0),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage("assets/images/login_ziliao_bg.png"),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(15, 0),
                    // GestureDetector(
                    //   onTap: ((){
                    //     Navigator.pop(context);
                    //   }),
                    //   child: Row(
                    //     children: [
                    //       const Expanded(child: Text('')),
                    //       Container(
                    //         height: ScreenUtil().setHeight(40),
                    //         width: ScreenUtil().setHeight(80),
                    //         alignment: Alignment.center,
                    //         //边框设置
                    //         decoration: const BoxDecoration(
                    //           //背景
                    //           color: MyColors.f2,
                    //           //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    //           borderRadius:
                    //           BorderRadius.all(Radius.circular(20.0)),
                    //         ),
                    //         child: Text(
                    //           '跳过',
                    //           style: StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14),
                    //         ),
                    //       ),
                    //       WidgetUtils.commonSizedBox(0, 15),
                    //     ],
                    //   ),
                    // ),
                    WidgetUtils.onlyTextCenter('填写个人信息', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(46), fontWeight: FontWeight.bold)),
                    WidgetUtils.onlyTextCenter('更容易遇到合拍的小伙伴哦', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(29))),
                    WidgetUtils.commonSizedBox(50, 0),
                    SizedBox(
                      height: ScreenUtil().setHeight(200),
                      width: ScreenUtil().setHeight(200),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(200),
                              ScreenUtil().setHeight(200),
                              'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                          WidgetUtils.showImages('assets/images/login_paizhao.png', ScreenUtil().setHeight(63), ScreenUtil().setHeight(63)),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(40, 0),
                    Container(
                      height: ScreenUtil().setHeight(110),
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 40, right: 40),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.f2,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius:
                        BorderRadius.all(Radius.circular(17.0)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          Expanded(child: WidgetUtils.commonTextField(controller, '请输入昵称')),
                          GestureDetector(
                            onTap: ((){
                              setState(() {
                                controller.text = '';
                              });
                            }),
                            child: WidgetUtils.showImages('assets/images/login_colse.png', ScreenUtil().setHeight(24), ScreenUtil().setHeight(24)),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(20, 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: ((){
                              setState(() {
                                sex = 1;
                              });
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(110),
                              width: double.infinity,
                              margin: const EdgeInsets.only(left: 40),
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: sex == 1 ? MyColors.loginBlue : MyColors.loginBlue2,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                const BorderRadius.all(Radius.circular(17.0)),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages('assets/images/nan.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(26)),
                                  WidgetUtils.commonSizedBox(0, 10),
                                  WidgetUtils.onlyTextCenter('男生', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(33))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: ((){
                              setState(() {
                                sex = 2;
                              });
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(110),
                              width: double.infinity,
                              margin: const EdgeInsets.only(right: 40),
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: sex == 2 ? MyColors.loginPink : MyColors.loginPink2,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                const BorderRadius.all(Radius.circular(17.0)),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.showImages('assets/images/nv.png', ScreenUtil().setHeight(26), ScreenUtil().setHeight(26)),
                                  WidgetUtils.commonSizedBox(0, 10),
                                  WidgetUtils.onlyTextCenter('女生', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(33))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    WidgetUtils.commonSizedBox(10, 10),
                    WidgetUtils.onlyTextCenter('性别后续不可修改', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(29))),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        width: double.infinity,
                        alignment: Alignment.center,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.loginPurple,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius:
                          BorderRadius.all(Radius.circular(30.0)),
                        ),
                        margin: const EdgeInsets.only(left: 40, right: 40),
                        child: Text('去听好声音', style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(33)),),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(20, 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
