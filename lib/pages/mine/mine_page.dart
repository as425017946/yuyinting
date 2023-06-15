import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../colors/my_colors.dart';
import '../../utils/widget_utils.dart';

///我的
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  var guizuType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '我的装扮'){
      }else if(event.title == '公会中心'){
        // Navigator.pushNamed(context, 'GonghuiHomePage');
        if(mounted){
          Navigator.pushNamed(context, 'MyGonghuiPage');
        }
      }else if(event.title == '全民代理'){
        if(mounted) {
          Navigator.pushNamed(context, 'DailiHomePage');
        }
      }else if(event.title == '联系客服'){
        if(mounted) {
          Navigator.pushNamed(context, 'KefuPage');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/mine_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(30, 0),
            GestureDetector(
              onTap: ((){
                Navigator.pushNamed(context, 'SettingPage');
              }),
              child: Row(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/mine_icon_setting.png',
                      ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                ],
              ),
            ),

            ///头像等信息
            Row(
              children: [
                GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'MyInfoPage');
                  }),
                  child: WidgetUtils.CircleHeadImage(
                      ScreenUtil().setHeight(153),
                      ScreenUtil().setHeight(153),
                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                ),
                WidgetUtils.commonSizedBox(0, 15),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            Text(
                              '昵称',
                              style: StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(42)),
                            ),
                            WidgetUtils.commonSizedBox(0, 5),
                            Container(
                              height: ScreenUtil().setHeight(25),
                              width: ScreenUtil().setWidth(50),
                              margin: const EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.dtPink,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: WidgetUtils.showImages(
                                  'assets/images/nv.png', 12, 12),
                            ),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Row(
                        children: [
                          Text(
                            'ID:12345678',
                            style: StyleUtils.getCommonTextStyle(
                                color: MyColors.mineGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(21)),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.showImages(
                              'assets/images/mine_fuzhi.png',
                              ScreenUtil().setHeight(25),
                              ScreenUtil().setHeight(25))
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: ((){
                    Navigator.pushNamed(context, 'MyInfoPage');
                  }),
                  child: Row(
                    children: [
                      WidgetUtils.onlyText(
                          '主页',
                          StyleUtils.getCommonTextStyle(
                              color: MyColors.mineGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(21))),
                      WidgetUtils.commonSizedBox(0, 5),
                      WidgetUtils.showImages('assets/images/mine_more.png',
                          ScreenUtil().setHeight(22), ScreenUtil().setHeight(10))
                    ],
                  ),
                )
              ],
            ),
            WidgetUtils.commonSizedBox(18, 0),

            /// 升级贵族
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(270),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: const BoxDecoration(
                //设置Container修饰
                image: DecorationImage(
                  //背景图片修饰
                  image: AssetImage("assets/images/mine_guizu_bg.png"),
                  fit: BoxFit.fill, //覆盖
                ),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(right: 50, top: 20),
                    child: guizuType == 0
                        ? WidgetUtils.myContainer(
                            ScreenUtil().setHeight(39),
                            ScreenUtil().setHeight(116),
                            Colors.transparent,
                            MyColors.mineOrange,
                            '已开通',
                            ScreenUtil().setSp(21),
                            MyColors.mineOrange)
                        : SizedBox(
                            width: ScreenUtil().setHeight(116),
                            height: ScreenUtil().setHeight(39),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/mine_kaitong_bg.png',
                                    ScreenUtil().setHeight(39),
                                    ScreenUtil().setHeight(116)),
                                WidgetUtils.onlyTextCenter(
                                    '开通',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(21))),
                              ],
                            ),
                          ),
                  ),
                  WidgetUtils.commonSizedBox(50, 0),

                  /// 关注
                  Row(
                    children: [
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'CareHomePage');
                        }),
                        child: Column(
                          children: [
                            Container(
                              width: ScreenUtil().setHeight(80),
                              alignment: Alignment.topRight,
                              child: Text(
                                  '+1',
                                  style : StyleUtils.getCommonTextStyle(
                                      color: MyColors.mineRed,
                                      fontSize: ScreenUtil().setSp(25))),
                            ),
                            WidgetUtils.onlyText(
                                '8',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold)),
                            WidgetUtils.onlyText(
                                '关注',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mineGrey,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(flex: 2, child: Text('')),
                      GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'CareHomePage');
                        }),
                        child: Column(
                          children: [
                            Container(
                              width: ScreenUtil().setHeight(80),
                              alignment: Alignment.topRight,
                              child: Text(
                                  '+1',
                                  style : StyleUtils.getCommonTextStyle(
                                      color: MyColors.mineRed,
                                      fontSize: ScreenUtil().setSp(25))),
                            ),
                            WidgetUtils.onlyText(
                                '8',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold)),
                            WidgetUtils.onlyText(
                                '被关注',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mineGrey,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(flex: 2, child: Text('')),
                      GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'WhoLockMePage');
                        }),
                        child: Column(
                          children: [
                            Container(
                              width: ScreenUtil().setHeight(80),
                              alignment: Alignment.topRight,
                              child: Text(
                                  '+1',
                                  style : StyleUtils.getCommonTextStyle(
                                      color: MyColors.mineRed,
                                      fontSize: ScreenUtil().setSp(25))),
                            ),
                            WidgetUtils.onlyText(
                                '8',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(42),
                                    fontWeight: FontWeight.bold)),
                            WidgetUtils.onlyText(
                                '看过我',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.mineGrey,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  )
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(18, 0),
            /// 展示信息
            WidgetUtils.containerNo(pad: 20,height: ScreenUtil().setHeight(600), width: double.infinity, color: Colors.white, ra: 20, w: Column(
              children: [
                /// 钱包 礼物记录
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'WalletPage');
                        }),
                        child: WidgetUtils.containerNo(height: ScreenUtil().setHeight(133), width: double.infinity, color: MyColors.mineYellow, ra: 10, w: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 10),
                            Expanded(
                              child: Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.onlyText('我的钱包', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold)),
                                  WidgetUtils.onlyText('充值、兑换', StyleUtils.getCommonTextStyle(color: MyColors.mineGrey, fontSize: ScreenUtil().setSp(25))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                            WidgetUtils.showImages('assets/images/mine_qianbao.png', ScreenUtil().setHeight(67), ScreenUtil().setHeight(67)),
                            WidgetUtils.commonSizedBox(0, 10),
                          ],
                        )),
                      )
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: ((){
                          Navigator.pushNamed(context, 'LiwuPage');
                        }),
                        child: WidgetUtils.containerNo(height: ScreenUtil().setHeight(133), width: double.infinity, color: MyColors.minePink, ra: 10, w: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 10),
                            Expanded(
                              child: Column(
                                children: [
                                  const Expanded(child: Text('')),
                                  WidgetUtils.onlyText('礼物记录', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(36), fontWeight: FontWeight.bold)),
                                  WidgetUtils.onlyText('收送礼物明细', StyleUtils.getCommonTextStyle(color: MyColors.mineGrey, fontSize: ScreenUtil().setSp(25))),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                            WidgetUtils.showImages('assets/images/mine_liwu.png', ScreenUtil().setHeight(67), ScreenUtil().setHeight(67)),
                            WidgetUtils.commonSizedBox(0, 10),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(20, 0),
                WidgetUtils.whiteKuang('assets/images/mine_zhuangban.png', '我的装扮', false),
                WidgetUtils.whiteKuang('assets/images/mine_gonghui.png', '公会中心', false),
                WidgetUtils.whiteKuang('assets/images/mine_daili.png', '全民代理', false),
                WidgetUtils.whiteKuang('assets/images/mine_kefu.png', '联系客服', false),
              ],
            ))
          ],
        ) /* add child content here */,
      ),
    );
  }
}
