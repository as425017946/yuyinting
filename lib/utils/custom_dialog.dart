import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';

class CustomDialog extends Dialog {
  final double? width; // 宽度
  final double? height; // 高度
  final String title; // 顶部标题
  final String content; // 内容
  final String cancelTxt; // 取消按钮的文本
  final String enterTxt; // 确认按钮的文本
  final Function callback; // 修改之后的回掉函数
  final int ziSize; // 文字大小

  CustomDialog(
      {this.width,
      this.height,
      required this.title,
      required this.content, // 根据content来，判断显示哪种类型
      this.cancelTxt: "取消",
      this.enterTxt: "确认",
      required this.callback,
      this.ziSize: 34});

  @override
  Widget build(BuildContext context) {
    String _inputVal = "";

    return GestureDetector(
        // 点击遮罩层隐藏弹框
        child: Material(
            type: MaterialType.transparency, // 配置透明度
            child: Center(
                child: GestureDetector(
                    // 点击遮罩层关闭弹框，并且点击非遮罩区域禁止关闭
                    onTap: () {
                      print('我是非遮罩区域～');
                    },
                    child: Container(
                        width: this.width ?? (270 * 2).w,
                        height: this.height ?? (120 * 2).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: <
                                Widget>[
                          Visibility(
                              visible: this.content != null ? true : false,
                              child: Positioned(
                                  top: 0,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          0, (19 * 2).w, 0, (19 * 2).w),
                                      child: Text("${this.title}",
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setSp(ziSize),
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600))))),
                          Container(
                              padding: EdgeInsets.fromLTRB(
                                  (15 * 2).w, 0, (15 * 2).w, 0),
                              alignment: Alignment.center,
                              child: Container(
                                  width: double.infinity,
                                  margin:
                                      EdgeInsets.fromLTRB(0, 0, 0, (42 * 2).w),
                                  alignment: Alignment.center,
                                  child: Text(content,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(34),
                                          fontWeight: FontWeight.w600)))),
                          Container(
                              height: (43 * 2).w,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Color(0xffEFEFF4)))),
                              child: Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                            height: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                            0xffEFEFF4)))),
                                            child: Text(cancelTxt,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize:
                                                        ScreenUtil().setSp(34),
                                                    fontWeight:
                                                        FontWeight.w400))),
                                        onTap: () {
                                          eventBus.fire(SubmitButtonBack(
                                              title: '编辑个人资料取消保存'));
                                          Navigator.pop(context);
                                        })),
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                            height: double.infinity, // 继承父级的高度
                                            alignment: Alignment.center,
                                            child: Text(enterTxt,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize:
                                                        ScreenUtil().setSp(34),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        onTap: () {
                                          if (content != null) {
                                            callback(_inputVal); // 通过回掉函数传给父级
                                          }
                                          Navigator.pop(context); // 关闭dialog
                                        }))
                              ]))
                        ]))))),
        onTap: () {
          Navigator.pop(context);
        });
  }
}
