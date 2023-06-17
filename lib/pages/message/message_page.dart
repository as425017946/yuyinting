import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

///消息
class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
  }

  Widget message(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {}),
      child: Container(
        height: ScreenUtil().setHeight(130),
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(110),
                    ScreenUtil().setWidth(110),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.showImages(
                  'assets/images/zhibozhong.webp',
                  ScreenUtil().setHeight(110),
                  ScreenUtil().setWidth(110),
                ),
              ],
            ),
            WidgetUtils.commonSizedBox(0, 10),
            Expanded(
              child: Column(
                children: [
                  const Expanded(child: Text('')),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          '昵称$i',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(38)),
                        ),
                        const Expanded(child: Text('')),
                        Text(
                          '10:59',
                          style: StyleUtils.getCommonTextStyle(
                              color: MyColors.g9,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: i % 2 == 0
                        ? Text(
                            'aaaaaa',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontSize: ScreenUtil().setSp(30)),
                          )
                        : Text(
                            '[图片] [语音]',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.homeTopBG,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                  ),
                  const Expanded(child: Text('')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            WidgetUtils.commonSizedBox(35, 0),
            ///头部信息
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: ScreenUtil().setHeight(60),
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  WidgetUtils.onlyTextBottom(
                      '消息',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(46),
                          fontWeight: FontWeight.bold)),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, 'CareHomePage');
                    }),
                    child: Container(
                      height: ScreenUtil().setHeight(81),
                      width: ScreenUtil().setWidth(38),
                      alignment: Alignment.center,
                      child: WidgetUtils.showImages(
                          'assets/images/messages_ren.png',
                          ScreenUtil().setHeight(41),
                          ScreenUtil().setWidth(38)),
                    ),
                  )
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(35, 0),

            /// 系统消息
            GestureDetector(
              onTap: ((){
                Navigator.pushNamed(context, 'XitongMorePage');
              }),
              child: Container(
                height: ScreenUtil().setHeight(130),
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    WidgetUtils.CircleHeadImage(
                        ScreenUtil().setHeight(110),
                        ScreenUtil().setWidth(110),
                        'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    WidgetUtils.commonSizedBox(0, 10),
                    Expanded(
                      child: Column(
                        children: [
                          const Expanded(child: Text('')),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  '系统消息',
                                  style: StyleUtils.getCommonTextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(38)),
                                ),
                                const Expanded(child: Text('')),
                                Text(
                                  '10:59',
                                  style: StyleUtils.getCommonTextStyle(
                                      color: MyColors.g9,
                                      fontSize: ScreenUtil().setSp(30)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            child: Text(
                              'aaaaaa',
                              style: StyleUtils.getCommonTextStyle(
                                  color: MyColors.g9,
                                  fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                itemBuilder: message,
                itemCount: 15,
              ),
            )
          ],
        ));
  }
}
