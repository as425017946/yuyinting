import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/Marquee.dart';
/// 蓝色魔方
class MofangLanPage extends StatefulWidget {
  const MofangLanPage({super.key});

  @override
  State<MofangLanPage> createState() => _MofangLanPageState();
}

class _MofangLanPageState extends State<MofangLanPage> with AutomaticKeepAliveClientMixin,TickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  int isCheck = 1;

  //爆照动画是否在播放
  bool isShow = false;
  // 是否跳过动画
  bool isTiaoguo = false;
  // 是否点击更多
  bool isMore = false;
  SVGAAnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    loadAnimation();
  }
  void loadAnimation() async {
    final videoItem = await _loadSVGA(false, 'assets/svga/mofang_lan_baozha.svga');
    videoItem.autorelease = false;
    animationController?.videoItem = videoItem;
    animationController
        ?.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => animationController?.videoItem = null);

    // 监听动画
    animationController?.addListener(() {
      if (animationController!.currentFrame >= animationController!.frames - 1) {
        LogE('播放完成');
        // 动画播放到最后一帧时停止播放
        animationController?.stop();
        setState(() {
          isShow = false;
        });
      }
    });
  }


  Future _loadSVGA(isUrl, svgaUrl) {
    Future Function(String) decoder;
    if (isUrl) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(svgaUrl);
  }

  @override
  void dispose() {
    animationController?.dispose();
    animationController = null;
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            Container(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              child: WidgetUtils.showImagesFill(
                  "assets/images/mofang_lan_bg.png",
                  ScreenUtil().setHeight(900),
                  double.infinity),
            ),
            Container(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Stack(
                children: [
                  Column(
                    children: [
                      WidgetUtils.commonSizedBox(ScreenUtil().setHeight(80), 0),
                      Row(
                        children: [
                          // 关闭
                          GestureDetector(
                            onTap: (() {
                              Navigator.pop(context);
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/mofang_lan_close.png',
                                ScreenUtil().setHeight(45),
                                ScreenUtil().setHeight(45)),
                          ),
                          const Spacer(),
                          // 更多
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isMore = !isMore;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/mofang_lan_dian.png',
                                ScreenUtil().setHeight(21),
                                ScreenUtil().setHeight(47)),
                          ),
                        ],
                      ),
                      // 中奖信息滚动
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0.14,
                            child: Container(
                              width: ScreenUtil().setHeight(310),
                              height: ScreenUtil().setHeight(42),
                              decoration: const BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                BorderRadius.all(Radius.circular(21)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setHeight(310),
                            height: ScreenUtil().setHeight(42),
                            child: Marquee(
                              speed: 10,
                              child: Text(
                                '恭喜某某用户单抽喜中价值500元的小柴一个',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(21)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // 切换魔方svga图
                      Opacity(opacity: isShow == false ? 1 : 0 ,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(500),
                              width: ScreenUtil().setHeight(500),
                              child: SVGASimpleImage(
                                  assetsName: 'assets/svga/mofang_lan_show.svga'),
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                width: ScreenUtil().setHeight(120),
                                height: ScreenUtil().setHeight(50),
                                decoration: const BoxDecoration(
                                  //背景
                                  color: Colors.black54,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(21)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: ((){
                                setState(() {
                                  isShow = true;
                                });
                                animationController?.reset();
                                animationController?.forward();
                              }),
                              child: SizedBox(
                                width: ScreenUtil().setHeight(120),
                                height: ScreenUtil().setHeight(50),
                                child: WidgetUtils.onlyTextCenter(
                                    '点击转动',
                                    TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(26),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 蓝色魔方和金色魔方按钮切换
                      GestureDetector(
                        onTap: ((){
                          eventBus.fire(MofangBack(info: 1));
                        }),
                        child: WidgetUtils.showImages('assets/images/mofang_lan.png', ScreenUtil().setHeight(75), ScreenUtil().setHeight(316)),
                      ),

                      const Spacer(),
                      // 抽奖次数
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isCheck = 1;
                              });
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setHeight(170),
                              decoration: BoxDecoration(
                                //设置Container修饰
                                image: DecorationImage(
                                  //背景图片修饰
                                  image: AssetImage(isCheck == 1
                                      ? "assets/images/mofang_lan_btn.png"
                                      :'assets/images/mofang_btn.png'),
                                  fit: BoxFit.fill, //覆盖
                                ),
                              ),
                              child: Row(
                                children: [
                                  WidgetUtils.commonSizedBox(
                                      0, ScreenUtil().setHeight(55)),
                                  Column(
                                    children: [
                                      WidgetUtils.commonSizedBox(7, 0),
                                      Text(
                                        '转  1  次',
                                        style: StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(28)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isCheck = 2;
                              });
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setHeight(170),
                              decoration: BoxDecoration(
                                //设置Container修饰
                                image: DecorationImage(
                                  //背景图片修饰
                                  image: AssetImage(isCheck == 2
                                      ? "assets/images/mofang_lan_btn.png"
                                      : 'assets/images/mofang_btn.png'),
                                  fit: BoxFit.fill, //覆盖
                                ),
                              ),
                              child: Row(
                                children: [
                                  WidgetUtils.commonSizedBox(
                                      0, ScreenUtil().setHeight(55)),
                                  Column(
                                    children: [
                                      WidgetUtils.commonSizedBox(7, 0),
                                      Text(
                                        '转 10 次',
                                        style: StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(28)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isCheck = 3;
                              });
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(60),
                              width: ScreenUtil().setHeight(170),
                              decoration: BoxDecoration(
                                //设置Container修饰
                                image: DecorationImage(
                                  //背景图片修饰
                                  image: AssetImage(isCheck == 3
                                      ? "assets/images/mofang_lan_btn.png"
                                      : 'assets/images/mofang_btn.png'),
                                  fit: BoxFit.fill, //覆盖
                                ),
                              ),
                              child: Row(
                                children: [
                                  WidgetUtils.commonSizedBox(
                                      0, ScreenUtil().setHeight(55)),
                                  Column(
                                    children: [
                                      WidgetUtils.commonSizedBox(7, 0),
                                      Text(
                                        '转100次',
                                        style: StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(28)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(30, 0),
                    ],
                  ),
                  //奖池
                  Positioned(
                      right: ScreenUtil().setHeight(10),
                      top: ScreenUtil().setHeight(150),
                      child: Stack(
                        children: [
                          WidgetUtils.showImages(
                              'assets/images/mofang_jin_jiangchi.png',
                              ScreenUtil().setHeight(90),
                              ScreenUtil().setHeight(109)),
                          Container(
                            height: ScreenUtil().setHeight(90),
                            width: ScreenUtil().setHeight(109),
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(58)),
                            child: WidgetUtils.onlyTextCenter(
                                '魔方奖池',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(22))),
                          )
                        ],
                      )),
                  // 跳过动画
                  Positioned(
                    left: ScreenUtil().setHeight(15),
                    top: ScreenUtil().setHeight(180),
                    child: GestureDetector(
                      onTap: ((){
                        setState(() {
                          isTiaoguo = !isTiaoguo;
                        });
                      }),
                      child: Row(
                        children: [
                          WidgetUtils.showImages(isTiaoguo ? 'assets/images/mofang_check_no.png' : 'assets/images/mofang_check_yes.png', ScreenUtil().setHeight(24), ScreenUtil().setHeight(24)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText('跳过动画', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(20)))
                        ],
                      ),
                    ),
                  ),
                  // 右上角功能
                  isMore ? Positioned(
                    top: ScreenUtil().setHeight(120),
                    right: 0,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Container(
                            height: ScreenUtil().setHeight(156),
                            width: ScreenUtil().setHeight(137),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.black,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                              BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(156),
                          width: ScreenUtil().setHeight(137),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                  child: WidgetUtils.onlyTextCenter(
                                      '玩法规则',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ2,
                                          fontSize: ScreenUtil().setSp(21)))),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: WidgetUtils.onlyTextCenter(
                                      '我的记录',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ2,
                                          fontSize: ScreenUtil().setSp(21)))),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: WidgetUtils.onlyTextCenter(
                                      '我的背包',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.roomTCWZ2,
                                          fontSize: ScreenUtil().setSp(21)))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ) : const Text(''),

                  // 魔方爆炸效果
                  isShow == true ? Container(
                    height: ScreenUtil().setHeight(580),
                    width: ScreenUtil().setHeight(580),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(140)),
                    alignment: Alignment.center,
                    child: SVGAImage(animationController!),
                  ) : WidgetUtils.commonSizedBox(0, 0)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
