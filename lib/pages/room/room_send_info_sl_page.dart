import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import '../../colors/my_colors.dart';
import '../../config/smile_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'package:flutter/foundation.dart' as foundation;

class RoomSendInfoSLPage extends StatefulWidget {
  int type;
  RoomSendInfoSLPage({super.key, required this.type});

  @override
  State<RoomSendInfoSLPage> createState() => _RoomSendInfoSLPageState();
}

class _RoomSendInfoSLPageState extends State<RoomSendInfoSLPage> {
  TextEditingController controller = TextEditingController();


  bool _isEmojiPickerVisible = false;

  FocusNode? _focusNode;

  bool isF = false;

  void _onFocusChange() {
    if (_focusNode!.hasFocus) {
      // 获取焦点事件处理逻辑
      print('TextField获取焦点');
      setState(() {
        _isEmojiPickerVisible = false;
      });
    } else {
      // 失去焦点事件处理逻辑
      print('TextField失去焦点');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.type == 1){
      _isEmojiPickerVisible = true;
    }else{
      isF = true;
    }
    _focusNode = FocusNode();
    _focusNode!.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode!.removeListener(_onFocusChange);
    _focusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                Navigator.pop(context);
              }
            }),
            child: Container(
              color: Colors.transparent,
            ),
          )),
          Container(
            height: 80.h,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.h),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(60),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.f2,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      autofocus: isF,
                      textInputAction: TextInputAction.send,
                      // 设置为发送按钮
                      controller: controller,
                      inputFormatters: [
                        // RegexFormatter(regex: MyUtils.regexFirstNotNull),
                        LengthLimitingTextInputFormatter(50) //限制输入长度
                      ],
                      style: StyleUtils.loginTextStyle,
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          MyToastUtils.showToastBottom('请输入要发送的信息');
                          return;
                        }
                        if (MyUtils.checkClick()) {
                          eventBus.fire(siliaoBack(info: value, title: '私聊消息'));
                        }
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      decoration: InputDecoration(
                        // border: InputBorder.none,
                        // labelText: "请输入用户名",
                        // icon: Icon(Icons.people), //前面的图标
                        hintText: '请输入文字信息',
                        hintStyle: StyleUtils.loginHintTextStyle,

                        contentPadding:
                            const EdgeInsets.only(top: 0, bottom: 0),
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
                ),
                WidgetUtils.commonSizedBox(0, 10),
                GestureDetector(
                  onTap: (() {
                    setState(() {
                      MyUtils.hideKeyboard(context);
                      _isEmojiPickerVisible = !_isEmojiPickerVisible;
                    });
                  }),
                  child: WidgetUtils.showImages(
                      'assets/images/trends_biaoqing.png',
                      ScreenUtil().setHeight(45),
                      ScreenUtil().setHeight(45)),
                ),
                WidgetUtils.commonSizedBox(0, 10),
                _isEmojiPickerVisible
                    ? GestureDetector(
                  onTap: (() {
                    //判断表情发送
                    if (controller.text.isEmpty) {
                      MyToastUtils.showToastBottom('请输入要发送的信息');
                      return;
                    }
                    if (MyUtils.checkClick()) {
                      eventBus.fire(siliaoBack(info: controller.text, title: '私聊消息'));
                    }
                    setState(() {
                      Navigator.pop(context);
                    });
                  }),
                  child: Container(
                    width: 90.h,
                    height: 50.h,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.riBangBg,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(
                          Radius.circular(20.0)),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        '发送',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: 28.sp)),
                  ),
                )
                    : const Text(''),
                WidgetUtils.commonSizedBox(0, 20.h),
              ],
            ),
          ),
          Visibility(
            visible: _isEmojiPickerVisible,
            child: SizedBox(
              height: 450.h,
              child: EmojiPicker(
                onEmojiSelected: (Category? category, Emoji emoji) {},
                onBackspacePressed: () {
                  // Do something when the user taps the backspace button (optional)
                  // Set it to null to hide the Backspace-Button
                },
                textEditingController: controller,
                // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform ==
                          TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: const Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: false,
                  replaceEmojiOnLimitExceed: false,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  // Needs to be const Widget
                  loadingIndicator: const SizedBox.shrink(),
                  // Needs to be const Widget
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  emojiSet: defaultEmojiSets,
                  buttonMode: ButtonMode.MATERIAL,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
