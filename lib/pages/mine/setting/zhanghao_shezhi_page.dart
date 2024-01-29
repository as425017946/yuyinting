import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/mine/setting/password_page.dart';

import '../../../config/config_screen_util.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'bing_phone_page.dart';

/// 账号设置
class ZhanghaoShezhipage extends StatefulWidget {
  const ZhanghaoShezhipage({Key? key}) : super(key: key);

  @override
  State<ZhanghaoShezhipage> createState() => _ZhanghaoShezhipageState();
}

class _ZhanghaoShezhipageState extends State<ZhanghaoShezhipage> {
  var appBar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('账号设置', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
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
            WidgetUtils.commonSizedBox(10, 0),
            sp.getString('user_phone').toString().isEmpty
                ? const Text('')
                : Container(
                    height: ConfigScreenUtil.autoHeight90,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: ConfigScreenUtil.autoHeight20,
                        ),
                        Text(
                          '绑定手机号',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(29)),
                        ),
                        const Spacer(),
                        Text(
                          '已绑定',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g6,
                              fontSize: ScreenUtil().setSp(29)),
                        ),
                        // Container(
                        //   alignment: Alignment.centerRight,
                        //   child: WidgetUtils.showImages(
                        //       'assets/images/mine_more.png', 15, 20),
                        // ),
                        SizedBox(
                          width: ConfigScreenUtil.autoHeight20,
                        ),
                      ],
                    ),
                  ),
            // GestureDetector(
            //   onTap: (() {
            //     Navigator.pushNamed(context, 'ChangePhonePage');
            //   }),
            //   child: WidgetUtils.onlyTextLeftRightImg(
            //       '更换手机号',
            //       StyleUtils.getCommonTextStyle(
            //           color: Colors.black, fontSize: ScreenUtil().setSp(29)),
            //       'assets/images/mine_more.png'),
            // ),

            WidgetUtils.commonSizedBox(1, 0),
            GestureDetector(
              onTap: (() {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PasswordPage(title: '设置登录密码');
                }));
              }),
              child: WidgetUtils.onlyTextLeftRightImg(
                  '登录密码设置',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                  'assets/images/mine_more.png'),
            ),
            WidgetUtils.commonSizedBox(10, 0),
            GestureDetector(
              onTap: (() {
                Navigator.pushNamed(context, 'ZhuxiaoPage');
              }),
              child: WidgetUtils.onlyTextLeftRightImg(
                  '注销账号',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                  'assets/images/mine_more.png'),
            ),
          ],
        ),
      ),
    );
  }
}
