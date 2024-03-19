import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/room/room_messages_more_page.dart';
import '../../bean/searchAllBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 厅内消息列表
class RoomSearchPage extends StatefulWidget {
  const RoomSearchPage({super.key});

  @override
  State<RoomSearchPage> createState() => _RoomSearchPageState();
}

class _RoomSearchPageState extends State<RoomSearchPage> {
  final TextEditingController _souSuoName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// 消息列表
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return RoomMessagesMorePage(
                        otherUid: listUser[i].uid.toString(),
                        nickName: listUser[i].nickname!,
                        otherImg: listUser[i].avatar!,
                      );
                    }));
              });
            }
          }),
          child: Container(
            height: 110.h,
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.w),
                WidgetUtils.CircleImageNet(90.h, 90.h, 45.h, listUser[i].avatar!),
                WidgetUtils.commonSizedBox(0, 15.w),
                Expanded(
                    child: Column(
                      children: [
                        const Spacer(),
                        WidgetUtils.onlyText(
                            listUser[i].nickname!,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ2,
                                fontSize: ScreenUtil().setSp(28))),
                        WidgetUtils.commonSizedBox(10.h, 0),
                        const Spacer(),
                      ],
                    ))
              ],
            ),
          ),
        ),
        WidgetUtils.commonSizedBox(20, 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          eventBus.fire(SendMessageBack(type: 5, msgID: '0'));
          Navigator.of(context).pop();
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    eventBus.fire(SendMessageBack(type: 5, msgID: '0'));
                    Navigator.pop(context);
                  }
                }),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(856),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/room_tc1.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(15, 0),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            padding: EdgeInsets.only(left: 20.w),
                            height: 70.h,
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            //边框设置
                            decoration: BoxDecoration(
                              //背景
                              color: MyColors.home_hx,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                              const BorderRadius.all(Radius.circular(25.0)),
                              //设置四周边框
                              border: Border.all(width: 1, color: MyColors.home_hx),
                            ),
                            child: TextField(
                              controller: _souSuoName,
                              inputFormatters: [
                                RegexFormatter(regex: MyUtils.regexFirstNotNull),
                              ],
                              style: StyleUtils.loginTextStyle,
                              onChanged: (value) {
                              },
                              decoration: InputDecoration(
                                // border: InputBorder.none,
                                // labelText: "请输入用户名",
                                // icon: Icon(Icons.people), //前面的图标
                                hintText: '请输入用户昵称或ID',
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
                          ),),
                      GestureDetector(
                        onTap: ((){
                            if(MyUtils.checkClick()){
                              if(_souSuoName.text.trim().isEmpty){
                                MyToastUtils.showToastBottom('请输入要搜索的信息~');
                                return;
                              }
                              doPostSearchAll();
                            }
                        }),
                        child: Container(
                          height: 50.h,
                          width: 100.w,
                          padding: EdgeInsets.only(left: 10.h),
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: Text('搜索', style: TextStyle(
                            color: MyColors.roomTCWZ2,
                            fontSize: 28.sp
                          ),),
                        ),
                      ),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(15, 0),

                  /// 展示在线用户
                  Expanded(
                    child: listUser.isNotEmpty
                        ? ListView.builder(
                            padding:
                                EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                            itemBuilder: _itemTuiJian,
                            itemCount: listUser.length,
                          )
                        : const Text(''),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<UserList> listUser = [];
  /// 推荐页搜索房间和用户
  Future<void> doPostSearchAll() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'keywords': _souSuoName.text.trim().toString()
    };
    try {
      searchAllBean bean = await DataUtils.postSearchAll(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listUser.clear();
            listUser = bean.data!.userList!;
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
