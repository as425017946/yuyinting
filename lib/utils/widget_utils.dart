import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import '../colors/my_colors.dart';
import '../config/config_screen_util.dart';
import '../config/my_config.dart';
import '../main.dart';
import '../widget/NetworkImageSSL.dart';
import 'event_utils.dart';
import 'line_painter2.dart';
import 'loading.dart';
import 'log_util.dart';
import 'my_utils.dart';
import 'regex_formatter.dart';
import 'style_utils.dart';

///组件工具类
class WidgetUtils {
  ///appbar 头部
  static Widget getAppBar(String title, bool isBack, BuildContext context,
      bool isCreate, int index) {
    return AppBar(
      //标题居中
      centerTitle: true,
      leading: isBack == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: (() {
                //如果loading正在显示，让其消失
                Loading.dismiss();
                Navigator.of(context).pop();
                MyUtils.hideKeyboard(context);
                if (index == 1) {
                  eventBus.fire(SubmitButtonBack(title: '编辑信息离开'));
                }
              }),
            )
          : IconButton(
              icon: WidgetUtils.showImages(
                  'assets/images/ic_mine_photo_def.png',
                  ConfigScreenUtil.autoHeight70,
                  ConfigScreenUtil.autoHeight70),
              onPressed: (() {
                //如果loading正在显示，让其消失
                if (MyUtils.checkClick()) {
                  // eventBus.fire(HomeBack(isBack: true, index: 1));
                }
              }),
            ),
      actions: [
        GestureDetector(
          onTap: (() {
            if (index == 0) {
              eventBus.fire(SubmitButtonBack(title: '发布'));
            } else if (index == 1) {
              eventBus.fire(SubmitButtonBack(title: '完成'));
            } else if (index == 2) {
              eventBus.fire(SubmitButtonBack(title: '账单明细'));
            } else if (index == 3) {
              eventBus.fire(SubmitButtonBack(title: '创建公会'));
            } else if (index == 4) {
              eventBus.fire(SubmitButtonBack(title: '公会手册'));
            } else if (index == 5) {
              eventBus.fire(SubmitButtonBack(title: '管理'));
            } else if (index == 6) {
              eventBus.fire(SubmitButtonBack(title: '装扮商城'));
            } else if (index == 7) {
              eventBus.fire(SubmitButtonBack(title: '忘记密码'));
            }
          }),
          child: isCreate == true
              ? index == 0
                  ? WidgetUtils.myContainer(
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(80),
                      MyColors.zhouBangBg,
                      MyColors.zhouBangBg,
                      '发布',
                      ScreenUtil().setSp(25),
                      Colors.white)
                  : index == 1
                      ? Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 15),
                          child: Text(
                            '完成',
                            style: StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : index == 2
                          ? Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 15),
                              child: Text(
                                '账单明细',
                                style: StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(25)),
                              ),
                            )
                          : index == 3
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    '创建公会',
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(25)),
                                  ),
                                )
                              : index == 4
                                  ? Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        '公会手册',
                                        style: StyleUtils.getCommonTextStyle(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(25)),
                                      ),
                                    )
                                  : index == 5
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(right: 15),
                                          child: Text(
                                            '管理',
                                            style:
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(25)),
                                          ),
                                        )
                                      : index == 6
                                          ? Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  right: 15),
                                              child: Text(
                                                '装扮商城',
                                                style: StyleUtils
                                                    .getCommonTextStyle(
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil()
                                                            .setSp(25)),
                                              ),
                                            )
                                          : index == 7
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  child: Text(
                                                    '忘记密码',
                                                    style: StyleUtils
                                                        .getCommonTextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(25)),
                                                  ),
                                                )
                                              : const Text('')
              : Text(''),
        )
      ],
      title: Text(
        title,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.black,
            fontSize: ScreenUtil().setSp(34),
            fontWeight: FontWeight.w600),
      ),
      elevation: 0,
      //去掉Appbar底部阴影
      //背景颜色
      backgroundColor: Colors.white,
    );
  }

  ///登录通用输入账号，密码
  static Widget commonLoginWidget(
    String url,
    TextEditingController content,
    bool obscureText,
    String hintText,
  ) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(20, 10, 40, 10),
      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
      height: ConfigScreenUtil.autoHeight80,
      width: double.infinity,
      child: Row(
        children: [
          WidgetUtils.showImages(url, ConfigScreenUtil.autoHeight50,
              ConfigScreenUtil.autoHeight50),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              //边框设置
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1, //宽度
                    color: MyColors.b8, //边框颜色
                  ),
                ),
              ),
              child: TextField(
                obscureText: obscureText,
                controller: content,
                inputFormatters: [
                  RegexFormatter(regex: MyUtils.regexFirstNotNull),
                ],
                style: StyleUtils.loginTextStyle,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  // labelText: "请输入用户名",
                  // icon: Icon(Icons.people), //前面的图标
                  hintText: hintText,
                  hintStyle: StyleUtils.loginHintTextStyle,
                  // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///通用 输入文本
  static Widget commonTextField(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
      ],
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('长度$value');
        eventBus.fire(InfoBack(info: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
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
    );
  }

  ///通用 输入文本可以自定义输入长度
  static Widget commonTextFieldZDY(
      TextEditingController controller, String hintText, int length) {
    return TextField(
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
        //设置只能输入6位
        LengthLimitingTextInputFormatter(length),
      ],
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('长度$value');
        eventBus.fire(InfoBack(info: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
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
    );
  }

  ///通用 输入文本是否显示密码
  static Widget commonTextFieldIsShow(
      TextEditingController controller, String hintText, bool obscureText) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
      ],
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        // eventBus.fire(InfoBack(infos: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.loginHintTextStyle,

        contentPadding: const EdgeInsets.only(bottom: 0),
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
    );
  }

  ///通用 显示可输入多少数字
  static Widget commonTextFieldDT(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      maxLength: 30,
      maxLines: 8,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
      ],
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('长度$value');
        // eventBus.fire(InfoBack(infos: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
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
    );
  }

  ///通用数字键盘，只能输入数字
  static Widget commonTextFieldNumber(
      {required TextEditingController controller,
      required String hintText,
      bool? enabled = true,
      bool? obscureText = false}) {
    return TextField(
      enabled: enabled,
      obscureText: obscureText!,
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      //设置键盘为数字
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('输入信息 $value');
        eventBus.fire(InfoBack(info: value));
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.loginHintTextStyle,
        // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
      ),
    );
  }

  ///通用数字键盘，只能输入数字
  static Widget commonTextFieldNumber2(
      {required TextEditingController controller,
      required String hintText,
      bool? enabled = true,
      bool? obscureText = false}) {
    return TextField(
      enabled: enabled,
      obscureText: obscureText!,
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
        FilteringTextInputFormatter.digitsOnly,
        //设置只能输入6位
        LengthLimitingTextInputFormatter(6),
      ],
      keyboardType: TextInputType.number,
      //设置键盘为数字
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('输入信息 $value');
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.loginHintTextStyle,
        // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
      ),
    );
  }

  ///通用登录大按钮
  static Widget commonSubmitButton(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: ConfigScreenUtil.autoHeight80,
      alignment: Alignment.center,
      width: double.infinity,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: MyColors.homeTopBG,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(
            Radius.circular(ConfigScreenUtil.autoHeight80 / 2)),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: ConfigScreenUtil.autoHeight90,
        splashColor: MyColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(ConfigScreenUtil.autoHeight90 / 2)),
        ),
        onPressed: (() {
          if (MyUtils.checkClick()) {
            eventBus.fire(SubmitButtonBack(title: title));
          }
        }),
        child: Text(
          title,
          style: StyleUtils.buttonTextStyle,
        ),
      ),
    );
  }

  ///通用登录大按钮
  static Widget commonSubmitButton2(String title, Color color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      height: ConfigScreenUtil.autoHeight80,
      alignment: Alignment.center,
      width: double.infinity,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: color,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(
            Radius.circular(ConfigScreenUtil.autoHeight80 / 2)),
      ),
      child: MaterialButton(
        minWidth: double.infinity,
        height: ConfigScreenUtil.autoHeight80,
        splashColor: MyColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(ConfigScreenUtil.autoHeight80 / 2)),
        ),
        onPressed: (() {
          if (MyUtils.checkClick()) {
            eventBus.fire(SubmitButtonBack(title: title));
          }
        }),
        child: Text(
          title,
          style: StyleUtils.whiteTextStyle,
        ),
      ),
    );
  }

  ///通用SizedBox
  static Widget commonSizedBox(double height, double width) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  ///通用横线
  static Widget myLine(
      {Color? color = MyColors.f5,
      double? thickness = 1,
      double? indent = 0,
      double? endIndent = 0}) {
    return Divider(
      color: color,
      indent: indent,
      endIndent: endIndent,
      // 线的厚度
      thickness: thickness,
    );
  }

  ///展示头像或修改头像
  static Widget headerImageShow(
      BuildContext context, String imageUrl, String imageUrl2) {
    return Container(
      height: ConfigScreenUtil.autoHeight180,
      width: double.infinity,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: (() {
          // Navigator.pop(context);
        }),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImageSSL(imageUrl) as ImageProvider
                    : AssetImage(imageUrl)),
            Image(
              image: AssetImage(imageUrl2),
              width: ConfigScreenUtil.autoHeight40,
              height: ConfigScreenUtil.autoHeight40,
            ),
          ],
        ),
      ),
    );
  }

  /// 圆形图片
  static Widget CircleHeadImage(double height, double width, String imgUrl) {
    // LogE('头像地址 == $imgUrl');
    return Container(
      height: height,
      width: width,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: imgUrl.isNotEmpty
          ? ClipOval(
              child: imgUrl.contains('com.leimu.yuyinting') ||
                      imgUrl.contains('storage')
                  ? Image.file(
                      File(imgUrl),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    )
                  : imgUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imgUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircleImageAss(
                            height,
                            width,
                            height / 2,
                            'assets/images/img_placeholder.png',
                          ),
                          errorWidget: (context, url, error) {
                            LogE('加载错误提示 $error');
                            // return const Icon(Icons.error);
                            return CircleImageAss(
                              height,
                              width,
                              height / 2,
                              'assets/images/img_placeholder.png',
                            );
                          },
                        )
                      : Image(
                          image: const AssetImage(
                              'assets/images/img_placeholder.png'),
                          width: width,
                          height: height,
                          gaplessPlayback: true,
                        ),
            )
          : Image(
              image: const AssetImage('assets/images/img_placeholder.png'),
              width: width,
              height: height,
              gaplessPlayback: true,
            ),
    );
  }

  /// 圆形图片
  static Widget CircleHeadImageIOS(double height, double width, String imgUrl) {
    // LogE('头像地址 == $imgUrl');
    return Container(
      height: height,
      width: width,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: imgUrl.isNotEmpty
          ? ClipOval(
              child: imgUrl.contains('http')
                  ? CachedNetworkImage(
                      imageUrl: imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => CircleImageAss(
                        height,
                        width,
                        height / 2,
                        'assets/images/img_placeholder.png',
                      ),
                      errorWidget: (context, url, error) {
                        LogE('加载错误提示 $error');
                        // return const Icon(Icons.error);
                        return CircleImageAss(
                          height,
                          width,
                          height / 2,
                          'assets/images/img_placeholder.png',
                        );
                      },
                    )
                  : imgUrl.isNotEmpty
                      ? Image.file(
                          File(imgUrl),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        )
                      : Image(
                          image: const AssetImage(
                              'assets/images/img_placeholder.png'),
                          width: width,
                          height: height,
                          gaplessPlayback: true,
                        ),
            )
          : Image(
              image: const AssetImage('assets/images/img_placeholder.png'),
              width: width,
              height: height,
              gaplessPlayback: true,
            ),
    );
  }

  ///圆角图片 网络
  static Widget CircleImageNet(
      double height, double width, double radius, String url) {
    return Container(
      height: height,
      width: width,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: url.contains('com.leimu.yuyinting') || url.contains('storage')
          ? Image.file(
              File(url),
              fit: BoxFit.cover,
              gaplessPlayback: true,
            )
          : url.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircleImageAss(
                    height,
                    width,
                    ScreenUtil().setHeight(10),
                    'assets/images/img_placeholder.png',
                  ),
                  errorWidget: (context, url, error) {
                    LogE('加载错误提示 $error');
                    // return const Icon(Icons.error);
                    return CircleImageAss(
                      height,
                      width,
                      ScreenUtil().setHeight(10),
                      'assets/images/img_placeholder.png',
                    );
                  },
                )
              : Image(
                  image: const AssetImage('assets/images/img_placeholder.png'),
                  width: width,
                  height: height,
                  gaplessPlayback: true,
                ),
    );
  }

  ///圆角图片 本地
  static Widget CircleImageAss(
      double height, double width, double radius, String url) {
    return Container(
      width: width,
      height: height,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: (url.contains('com.leimu.yuyinting') || url.contains('storage'))
          ? Image.file(
              File(url),
              fit: BoxFit.fill,
              gaplessPlayback: true,
            )
          : Image(
              image: AssetImage(url),
              width: width,
              height: height,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
    );
  }

  ///圆角图片 本地，加载失败展示网络图
  static Widget CircleImageAssNet(
      double height, double width, double radius, String url, String netUrl) {
    LogE('头像信息 == $url');
    LogE('头像信息 ==*9*** $netUrl');
    return Container(
      width: width,
      height: height,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: (url.contains('com.leimu.yuyinting') || url.contains('storage'))
          ? Image.file(
              File(url),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return CachedNetworkImage(
                  imageUrl: netUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircleImageAss(
                    height,
                    width,
                    ScreenUtil().setHeight(10),
                    'assets/images/img_placeholder.png',
                  ),
                  errorWidget: (context, url, error) {
                    LogE('加载错误提示 $error');
                    // return const Icon(Icons.error);
                    return CircleImageAss(
                      height,
                      width,
                      ScreenUtil().setHeight(10),
                      'assets/images/img_placeholder.png',
                    );
                  },
                );
              },
            )
          : Image(
              image: AssetImage(url),
              width: width,
              height: height,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                return CachedNetworkImage(
                  imageUrl: netUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircleImageAss(
                    height,
                    width,
                    ScreenUtil().setHeight(10),
                    'assets/images/img_placeholder.png',
                  ),
                  errorWidget: (context, url, error) {
                    LogE('加载错误提示 $error');
                    // return const Icon(Icons.error);
                    return CircleImageAss(
                      height,
                      width,
                      ScreenUtil().setHeight(10),
                      'assets/images/img_placeholder.png',
                    );
                  },
                );
              },
            ),
    );
  }

  ///圆形图片网络
  static Widget CricleImagess(double height, double width, String url) {
    return ClipOval(
      child: SizedBox(
        height: height,
        width: width,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircleImageAss(
            height,
            width,
            ScreenUtil().setHeight(10),
            'assets/images/img_placeholder.png',
          ),
          errorWidget: (context, url, error) {
            LogE('加载错误提示 $error');
            // return const Icon(Icons.error);
            return CircleImageAss(
              height,
              width,
              ScreenUtil().setHeight(10),
              'assets/images/img_placeholder.png',
            );
          },
        ),
      ),
    );
  }

  ///展示图片使用
  static Widget showImages(String url, double height, double width) {
    return url.contains('com.leimu.yuyinting') || url.contains('storage')
        ? Image.file(
            File(url),
            fit: BoxFit.fill,
            gaplessPlayback: true,
          )
        : Image(
            image: AssetImage(url),
            width: width,
            height: height,
            gaplessPlayback: true,
          );
  }

  ///展示图片使用
  static Widget showImagesNet(String url, double height, double width) {
    return SizedBox(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircleImageAss(
          height,
          width,
          ScreenUtil().setHeight(10),
          'assets/images/img_placeholder.png',
        ),
        errorWidget: (context, url, error) {
          LogE('加载错误提示 $error');
          // return const Icon(Icons.error);
          return CircleImageAss(
            height,
            width,
            ScreenUtil().setHeight(10),
            'assets/images/img_placeholder.png',
          );
        },
      ),
    );
  }

  ///展示图片使用厅内使用，主要是用于加载不出来直接给一个默认的厅图
  static Widget showImagesNetRoom(String url, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        //设置Container修饰
        image: DecorationImage(
          //背景图片修饰
          image: AssetImage("assets/images/img_placeholder_room.png"),
          fit: BoxFit.fill, //覆盖
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => CircleImageAss(
          height,
          width,
          ScreenUtil().setHeight(10),
          'assets/images/img_placeholder.png',
        ),
        errorWidget: (context, url, error) {
          LogE('加载错误提示 $error');
          // return const Icon(Icons.error);
          return CircleImageAss(
            height,
            width,
            ScreenUtil().setHeight(10),
            'assets/images/img_placeholder_room.png',
          );
        },
      ),
    );
  }

  ///展示图片使用
  static Widget showImagesFill(String url, double height, double width) {
    return Image(
        image: AssetImage(url),
        width: width,
        height: height,
        fit: BoxFit.fill,
        gaplessPlayback: true);
  }

  ///通用我的横条白底选择框
  static Widget whiteKuang(String imageUrl, String title, bool isVersion) {
    return GestureDetector(
      onTap: (() {
        switch (title) {
          case '我的装扮':
            eventBus.fire(SubmitButtonBack(title: '我的装扮'));
            break;
          case '公会中心':
            eventBus.fire(SubmitButtonBack(title: '公会中心'));
            break;
          case '全民代理':
            eventBus.fire(SubmitButtonBack(title: '全民代理'));
            break;
          case '等级成就':
            eventBus.fire(SubmitButtonBack(title: '等级成就'));
            break;
          case '联系客服':
            eventBus.fire(SubmitButtonBack(title: '联系客服'));
            break;
          case '会长后台':
            eventBus.fire(SubmitButtonBack(title: '会长后台'));
            break;
          case '邀请有礼':
            eventBus.fire(SubmitButtonBack(title: '邀请有礼'));
            break;
        }
      }),
      child: Container(
        height: ConfigScreenUtil.autoHeight90,
        width: double.infinity,
        decoration: StyleUtils.wihtieBgStyle,
        child: Row(
          children: [
            Image(
              image: AssetImage(imageUrl),
              width: ConfigScreenUtil.autoHeight40,
              height: ConfigScreenUtil.autoHeight40,
            ),
            SizedBox(
              width: ConfigScreenUtil.autoHeight10,
            ),
            Text(
              title,
              style: StyleUtils.getCommonTextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(29)),
            ),
            WidgetUtils.commonSizedBox(0, 10.w),
            (title == '公会中心' && isVersion)
                ? Transform.translate(
                    offset: Offset(0, -5.h),
                    child: CustomPaint(
                      painter: LinePainter2(colors: Colors.red),
                    ),
                  )
                : const Text(''),
            const Expanded(child: Text('')),
            // Text(
            //   isVersion ? sp.getString(MyConfig.appVersion).toString() : '',
            //   style: StyleUtils.textStyleG3,
            // ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            // Text(sp.getString('gengxin').toString(),
            //     style: StyleUtils.textStyleG9),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Image(
              image: const AssetImage('assets/images/mine_more.png'),
              width: ScreenUtil().setHeight(16),
              height: ScreenUtil().setHeight(27),
            ),
          ],
        ),
      ),
    );
  }

  ///背景色
  static Widget bgLine(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: MyColors.f5,
      ),
      child: const Text(''),
    );
  }

  ///带边框的发布按钮
  static Widget issueButton(String title, Color boxColors, Color borderColors,
      Color txtColors, bool isClick, int type) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        width: ScreenUtil().setWidth(180),
        height: ScreenUtil().setHeight(50),
        alignment: Alignment.center,
        //边框设置
        decoration: BoxDecoration(
          //背景
          color: boxColors,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          //设置四周边框
          border: Border.all(width: 1, color: borderColors),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: ScreenUtil().setSp(30), color: txtColors),
        ),
      ),
    );
  }

  ///底部出现选择框
  static Widget popWidget(BuildContext context, String title, String info,
      String name, List<String> listData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: ConfigScreenUtil.autoHeight100,
      width: double.infinity,
      //边框设置
      decoration: StyleUtils.getCommonBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: StyleUtils.textStyleG6,
            ),
          ),
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                _onClickItem(listData, info, context);
              }
            }),
            child: Row(
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(21),
                ),
                Text(
                  name.isEmpty ? title : name,
                  style: StyleUtils.textStyleb3,
                ),
                Image(
                  image: const AssetImage('assets/images/more.png'),
                  width: ScreenUtil().setWidth(48),
                  height: ScreenUtil().setHeight(48),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(15),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///配合上面使用的选择框
  static void _onClickItem(var data, var selectData, BuildContext context) {
    Pickers.showSinglePicker(
      context,
      data: data,
      selectData: selectData,
      pickerStyle: DefaultPickerStyle(),
      onConfirm: (p, position) {},
    );
  }

  ///直接显示信息的text(例：居民姓名：张三)，位置在最下面
  static Widget onlyTextBottom(
    String title,
    TextStyle style,
  ) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Text(
        title,
        style: style,
      ),
    );
  }

  ///直接显示信息的text(例：居民姓名：张三)
  static Widget onlyText(
    String title,
    TextStyle style,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        maxLines: 2,
        style: style,
      ),
    );
  }

  ///直接显示信息的text(例：居民姓名：张三)
  static Widget onlyTextCenter(
    String title,
    TextStyle style,
  ) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        style: style,
      ),
    );
  }

  ///直接显示信息的text(例：居民姓名：张三)
  static Widget onlyTextTitle({
    required String title,
    required TextStyle style,
    required double maxWidth,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: style,
      ),
    );
  }

  ///直接显示信息的text，左右两侧显示(例：居民姓名：好多空格    张三)
  static Widget onlyTextLeftRight(
      String title, String info, TextStyle leftStyle, TextStyle rightStyle) {
    return Container(
      height: ConfigScreenUtil.autoHeight50,
      width: double.infinity,
      //边框设置
      decoration: StyleUtils.getCommonBoxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: ConfigScreenUtil.autoHeight20,
          ),
          Text(
            title,
            style: leftStyle,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                info,
                style: rightStyle,
              ),
            ),
          ),
          SizedBox(
            width: ConfigScreenUtil.autoHeight20,
          ),
        ],
      ),
    );
  }

  ///直接显示信息的text，左右两侧显示(例：居民姓名：好多空格    >)
  static Widget onlyTextLeftRightImg(
      String title, TextStyle leftStyle, String url) {
    return Container(
      height: ConfigScreenUtil.autoHeight90,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: ConfigScreenUtil.autoHeight20,
          ),
          Text(
            title,
            style: leftStyle,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: WidgetUtils.showImages(url, 15, 20),
            ),
          ),
          SizedBox(
            width: ConfigScreenUtil.autoHeight20,
          ),
        ],
      ),
    );
  }

  ///自定义圆角背景框
  static Widget myContainer(double height, double width, Color boxColors,
      Color borderColors, String title, double size, Color txtColors) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: boxColors,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        border: Border.all(width: 1, color: borderColors),
      ),
      child: Text(
        title,
        style: StyleUtils.getCommonTextStyle(color: txtColors, fontSize: size),
      ),
    );
  }

  ///自定义圆角背景框，无内容
  static Widget containerNo(
      {double pad = 0,
      double? height,
      double? width,
      Color? color,
      double? ra,
      Widget? w}) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(pad),
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: color,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(Radius.circular(ra!)),
      ),
      child: w,
    );
  }

  ///自定义圆角背景框自适应长度
  static Widget myContainerZishiying(
      Color boxColors, String title, TextStyle style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
          alignment: Alignment.center,
          //边框设置
          decoration: BoxDecoration(
            //背景
            color: boxColors,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Text(
            title,
            style: style,
          ),
        )
      ],
    );
  }

  ///自定义圆角背景框自适应长度
  static Widget myContainerZishiying2(
      Color boxColors, Color borderColors, String title, TextStyle style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
          alignment: Alignment.center,
          //边框设置
          decoration: BoxDecoration(
            //背景
            color: boxColors,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            //设置四周边框
            border: Border.all(width: 1, color: borderColors),
          ),
          child: Text(
            title,
            style: style,
          ),
        )
      ],
    );
  }

  static Widget updatePassword(
      String title, TextEditingController controller, String info) {
    return Container(
      height: ScreenUtil().setHeight(80),
      margin: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(26), 0, 0),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenUtil().setWidth(21),
          ),
          Text(
            title,
            style: StyleUtils.textStyleb3,
          ),
          Expanded(
              child: TextField(
            obscureText: true,
            controller: controller,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: info,
              hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: MyColors.b8),
            ),
          )),
          SizedBox(
            width: ScreenUtil().setWidth(21),
          ),
        ],
      ),
    );
  }

  /// 个人主页使用
  static Widget PeopleButton(String imgUrl, String title, Color color) {
    return Container(
      width: ScreenUtil().setWidth(208),
      height: ScreenUtil().setHeight(65),
      alignment: Alignment.center,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: color,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          const Expanded(child: Text('')),
          title != '取消关注'
              ? WidgetUtils.showImages(
                  imgUrl, ScreenUtil().setHeight(38), ScreenUtil().setWidth(33))
              : const Text(''),
          WidgetUtils.commonSizedBox(0, 5),
          WidgetUtils.onlyText(
              title,
              StyleUtils.getCommonTextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(32))),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }

  ///派对使用
  static Widget paiduiBtn(
      Color color, String title, String imgUrl, double width) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: width,
              height: ScreenUtil().setHeight(25),
              margin: const EdgeInsets.only(left: 5),
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: color,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(30)),
                  Text(
                    title,
                    style: StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(18),
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            WidgetUtils.showImages(
                imgUrl, ScreenUtil().setHeight(30), ScreenUtil().setHeight(30))
          ],
        )
      ],
    );
  }

  ///实名制使用
  static Widget commonTextFieldRenzheng(
      TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
      ],
      style: StyleUtils.loginTextStyle,
      onChanged: (value) {
        LogE('长度$value');
        eventBus.fire(InfoBack(info: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.getCommonTextStyle(
            color: MyColors.g9, fontSize: ScreenUtil().setSp(32)),

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
    );
  }

  ///实名制提示
  static Widget renzhengText(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        maxLines: 20,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(21),
          color: Colors.black,
          height: 2.0,
        ),
      ),
    );
  }

  ///装扮商城使用
  static Widget myContainerZhuangban(
      Color boxColors, String title, TextStyle style) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 2, right: 15, bottom: 2),
      alignment: Alignment.center,
      //边框设置
      decoration: BoxDecoration(
        //背景
        color: boxColors,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  ///编辑个人
  static Widget bianjiTextField(
      TextEditingController controller, String hintText, int length) {
    return TextField(
      controller: controller,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
        LengthLimitingTextInputFormatter(length) //限制输入长度
      ],
      style: StyleUtils.getCommonTextStyle(
          color: MyColors.g3, fontSize: ScreenUtil().setSp(25)),
      onChanged: (value) {
        LogE('长度$value');
        // eventBus.fire(InfoBack(infos: value));
      },
      decoration: InputDecoration(
        // border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.getCommonTextStyle(
            color: MyColors.g9, fontSize: ScreenUtil().setSp(25)),

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
    );
  }

  /// 装扮购买使用
  static Widget myContainerZB(
      double height,
      double width,
      Color boxColors,
      Color borderColors,
      String title,
      double size,
      Color txtColors,
      String url) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        //边框设置
        decoration: BoxDecoration(
          //背景
          color: boxColors,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(width: 1, color: borderColors),
        ),
        child: Row(
          children: [
            const Spacer(),
            WidgetUtils.showImages(url, 25.h, 25.h),
            WidgetUtils.commonSizedBox(0, 5.h),
            Text(
              title,
              style: StyleUtils.getCommonTextStyle(
                  color: txtColors, fontSize: size),
            ),
            const Spacer(),
          ],
        ));
  }

  ///通用数字键盘，只能输入数字, 发红包使用
  static Widget commonTextFieldNumberHB(
      {required TextEditingController controller,
      required String hintText,
      bool? enabled = true,
      bool? obscureText = false}) {
    return TextField(
      enabled: enabled,
      obscureText: obscureText!,
      controller: controller,
      textAlign: TextAlign.end,
      inputFormatters: [
        RegexFormatter(regex: MyUtils.regexFirstNotNull),
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      //设置键盘为数字
      style: StyleUtils.getCommonTextStyle(
          color: Colors.black87, fontSize: 32.sp, fontWeight: FontWeight.w500),
      onChanged: (value) {
        eventBus.fire(InfoBack(info: value));
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        // labelText: "请输入用户名",
        // icon: Icon(Icons.people), //前面的图标
        hintText: hintText,
        hintStyle: StyleUtils.getCommonTextStyle(
            color: MyColors.g9, fontSize: 32.sp, fontWeight: FontWeight.w500),
        // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
      ),
    );
  }
}
