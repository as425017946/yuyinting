// import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/loading.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../main.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../bigclient/bigclient_model.dart';

class BigClientPage extends StatefulWidget {
  const BigClientPage({Key? key}) : super(key: key);

  @override
  State<BigClientPage> createState() => _BigClientPageState();
}

class _BigClientPageState extends State<BigClientPage> {
  @override
  void initState() {
    Get.put(BigClientController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BigClientController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "财富等级",
            style: TextStyle(
                color: const Color(0xFFF9E7C9),
                fontSize: ScreenUtil().setSp(33)),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            color: Colors.black,
            onPressed: (() {
              //如果loading正在显示，让其消失
              Loading.dismiss();
              Get.back();
              MyUtils.hideKeyboard(context);
            }),
          )),
      body: WillPopScope(
        onWillPop: () async => !Loading.isShow,
        child: const _BigClientPageBody(),
      ),
    );
  }
}

class _BigClientPageBody extends StatelessWidget {
  const _BigClientPageBody({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return Container(
      color: const Color(0xFF10101B),
      child: Column(
        children: [
          const _BigClientPageTop(),
          const _BigClientPageTab(),
          Expanded(
            child: PageView(
              controller: c.controller,
              onPageChanged: c.onPageChanged,
              children: const [
                _BigClientPageList0(),
                _BigClientPageList1(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigClientPageTop extends StatelessWidget {
  const _BigClientPageTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return FittedBox(
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
      child: SizedBox(
        width: 750,
        height: 554,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            _line(),
            // _swiperPoint(c),
            _swiper(c),
            _light(c),
          ],
        ),
      ),
    );
  }

  Widget _head(double size, String avatarFrameGifImg, String avatarFrameImg,
      String level, String ryz) {
    final boxSize = size * 14 / 9.0;
    return Positioned(
      left: 10,
      bottom: 191,
      child: Row(
        children: [
          GestureDetector(
            onTap: (() {
              // if (MyUtils.checkClick()) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const MyInfoPage(),
              //     ),
              //   ).then((value) {
              //     doPostMyIfon();
              //   });
              // }
            }),
            child: SizedBox(
              height: boxSize,
              width: boxSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  WidgetUtils.CircleHeadImage(size, size, sp.getString('user_headimg').toString()),
                  // 头像框静态图
                  (avatarFrameGifImg.isEmpty && avatarFrameImg.isNotEmpty)
                      ? WidgetUtils.CircleHeadImage(
                          boxSize, boxSize, avatarFrameImg)
                      : const Text(''),
                  // 头像框动态图
                  avatarFrameGifImg.isNotEmpty
                      ? SizedBox(
                          height: boxSize,
                          width: boxSize,
                          child: SVGASimpleImage(
                            resUrl: avatarFrameGifImg,
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 240),
                    child: Text(
                      sp.getString('nickname').toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF9E7C9),
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFFCFFBFB),
                          Color(0xFFFFFBF5),
                          Color(0xFFFFE18F),
                          Color(0xFF97F1F5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'YouSheBiaoTiHei',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '财富值:$ryz',
                style: const TextStyle(
                  color: Color(0xFFF9E7C9),
                  fontSize: 19,
                  fontFamily: 'YouSheBiaoTiHei',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line() {
    return const Positioned(
      left: 63,
      top: 495,
      width: 625,
      height: 4,
      child: Image(
        image: AssetImage('assets/images/bigclient_line.png'),
      ),
    );
  }

  Widget _light(BigClientController c) {
    return IgnorePointer(
      child: Obx(() {
        return Stack(
          alignment: Alignment.topCenter,
          children: List.generate(8, (index) => AnimatedOpacity(
            opacity: index == c.current.value ? 1.0 : 0.0, 
            duration: const Duration(seconds: 1),
            alwaysIncludeSemantics: true,
            child: Image.asset('assets/images/bigclient_light_${index + 1}.png', fit: BoxFit.fitWidth),
          )),
        );
      }
      ),
    );
    // return IgnorePointer(
    //   child: Obx(
    //     () => Image(
    //       image: AssetImage(
    //           'assets/images/bigclient_light_${c.current.value + 1}.png'),
    //       fit: BoxFit.fitWidth,
    //     ),
    //   ),
    // );
  }

  Widget _swiper(BigClientController c) {
    return Positioned(
      left: 0,
      bottom: 0,
      width: 750,
      height: 415,
      child: Swiper(
        itemBuilder: _itemBuilder,
        itemCount: 8,
        loop: false,
        viewportFraction: 624.0 / 750.0,
        scale: 0.9,
        onIndexChanged: c.onIndexChanged,
        onTap: (index) {},
        controller: c.swiperController,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    BigClientController c = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 113),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: AssetImage('assets/images/bigclient_board_${index + 1}.png'),
            fit: BoxFit.fitWidth,
          ),
          _head(70, c.avatarFrameGifImg, c.avatarFrameImg, 'LV.${c.grLevel}', c.data.gr_value),
          _point(c.texts[index]),
          if (index == c.data.title - 1)
            Positioned(
              left: 39,
              bottom: 20,
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: Color(0xFFF9E7C9),
                    fontSize: 19,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    const TextSpan(text: '获得下一级财富徽章还需 '),
                    TextSpan(
                      text: c.data.next_title_value,
                      style: const TextStyle(
                        color: Color(0xFFFFDD61),
                      ),
                    ),
                    const TextSpan(text: ' 财富值\n当前等级可领取 '),
                    TextSpan(
                      text: '${c.data.day_salary}',
                      style: const TextStyle(
                        color: Color(0xFFFFDD61),
                      ),
                    ),
                    const TextSpan(text: ' 金豆日俸禄'),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 196,
            bottom: 94,
            width: 74,
            height: 29,
            child: Image(
              image: AssetImage('assets/images/bigclient_tag_${c.getTag(index)}.png'),
              fit: BoxFit.contain,
            ),
          ),
          
          // Positioned(
          //   left: 201,
          //   bottom: 130,
          //   child: Obx(
          //     () => Text(
          //       c.ryz.obs,
          //       style: const TextStyle(
          //         color: Color(0xFFF9E7C9),
          //         fontSize: 19,
          //         fontFamily: 'YouSheBiaoTiHei',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _point(String text) {
    return Positioned(
      left: 0,
      bottom: 0,
      width: 624,
      height: 70,
      child: Transform.translate(
        offset: const Offset(0, 113),
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SizedBox(
                width: 29,
                height: 29,
                child: Image(
                  image: AssetImage('assets/images/bigclient_point.png'),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 3),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFCFFBFB),
                      Color(0xFFFFFBF5),
                      Color(0xFFFFE18F),
                      Color(0xFF97F1F5),
                    ],
                    stops: [0, 0.1, 0.5, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    // height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swiperPoint(BigClientController c) {
    final List<String> texts = ['曜星', '苍穹', '皓月', '辉耀', '星华', '天域', '银河', '至尊'];
    return Positioned(
      left: 0,
      bottom: 0,
      width: 750,
      height: 57,
      child: IgnorePointer(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.topCenter,
              child: UnconstrainedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 29,
                      height: 29,
                      child: Image(
                        image: AssetImage('assets/images/bigclient_point.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 3),
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [
                            Color(0xFFCFFBFB),
                            Color(0xFFFFFBF5),
                            Color(0xFFFFE18F),
                            Color(0xFF97F1F5),
                          ],
                          stops: [0, 0.1, 0.5, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        texts[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: texts.length,
          loop: false,
          controller: c.swiperController,
        ),
      ),
    );
  }
}

class _BigClientPageTab extends StatelessWidget {
  const _BigClientPageTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return SizedBox(
      height: 147.w,
      child: Padding(
        padding: EdgeInsets.only(bottom: 13.w),
        child: Row(
          children: [
            Expanded(child: Center(child: _leftBtn(c))),
            Expanded(child: Center(child: _rightBtn(c))),
          ],
        ),
      ),
    );
  }

  Widget _leftBtn(BigClientController c) {
    return GestureDetector(
      onTap: c.onLeft,
      child: Container(
        width: 226.w,
        height: 95.w,
        color: const Color(0xFF10101B),
        child: Obx(() {
          if (c.select.value == 0) {
            return const Image(
              image: AssetImage('assets/images/bigclient_btn_0_select.png'),
              fit: BoxFit.contain,
            );
          } else {
            return Center(
                child: Transform.translate(
              offset: Offset(0, 20.w),
              child: SizedBox(
                width: 184.w,
                height: 25.w,
                child: const Image(
                  image: AssetImage('assets/images/bigclient_btn_0.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ));
          }
        }),
      ),
    );
  }

  Widget _rightBtn(BigClientController c) {
    return GestureDetector(
      onTap: c.onRight,
      child: Container(
        width: 190.w,
        height: 95.w,
        color: const Color(0xFF10101B),
        child: Obx(() {
          if (c.select.value == 1) {
            return const Image(
              image: AssetImage('assets/images/bigclient_btn_1_select.png'),
              fit: BoxFit.contain,
            );
          } else {
            return Center(
                child: Transform.translate(
              offset: Offset(0, 20.w),
              child: SizedBox(
                width: 123.w,
                height: 25.w,
                child: const Image(
                  image: AssetImage('assets/images/bigclient_btn_1.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ));
          }
        }),
      ),
    );
  }
}

class _BigClientPageList0 extends StatelessWidget {
  const _BigClientPageList0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BigClientController c = Get.find();
    return Column(
      children: [
        SingleChildScrollView(
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width: 750,
              child: Column(
                children: [
                  _item("日俸禄", c.dayBean, c.data.next_lv_value, c.onDay),
                  // _item("周薪水", c.weekBean, c.weekExp),
                  // _item("月薪水", c.weekBean, c.weekExp),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: Get.bottomBarHeight + 30.w),
          child: WidgetUtils.onlyTextCenter('注:金豆俸禄将在您达到等级要求后，每日18点发放至本页', StyleUtils.getCommonTextStyle(color: MyColors.mineYellow, fontSize: 24.sp)),
        ),
      ],
    );
  }

  Widget _item(String title, Rx<int> bean, String exp, void Function() action) {
    const textColor = Color(0xFFF9E7C9);
    const detailColor = Color(0xFF91856F);
    textStyle(FontWeight fw) =>
        TextStyle(color: textColor, fontSize: 33, fontWeight: fw);
    const detailStyle = TextStyle(
        color: detailColor, fontSize: 21, fontWeight: FontWeight.normal);
    final String expText;
    if (exp.isEmpty || int.parse(exp) == 0) {
      expText = '已达成';
    } else {
      expText = '还差 $exp 财富值可领取下一等级$title';
    }
    return SizedBox(
      width: 750,
      height: 167 + 30,
      child: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/bigclient_box.png'),
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Positioned(
            left: 90,
            bottom: 36.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: textStyle(FontWeight.w500),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 4),
                        child: SizedBox(
                          width: 137,
                          child: FittedBox(
                            child: Container(
                              alignment: Alignment.bottomRight,
                              constraints: const BoxConstraints(minWidth: 137),
                              child: Obx(() => Text(
                                bean.value.toString(),
                                style: textStyle(FontWeight.w900),
                              )),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '金豆',
                        style: textStyle(FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                Text(expText, style: detailStyle),
              ],
            ),
          ),
          Positioned(
            right: 84,
            bottom: 56 + 15,
            width: 164,
            height: 55,
            child: GestureDetector(
              onTap: action,
              child: const Image(
                image: AssetImage('assets/images/bigclient_btn.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BigClientPageList1 extends StatelessWidget {
  const _BigClientPageList1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FittedBox(
        alignment: Alignment.topCenter,
        fit: BoxFit.fitWidth,
        child: SizedBox(
          width: 750,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _text(),
                // _excel(), 
                Image.asset('assets/images/bigclient_excel.png', fit: BoxFit.fitWidth),
                const SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(bottom: Get.bottomBarHeight + 30.w),
                  child: WidgetUtils.onlyTextCenter('*此活动的有效日期及最终解释权归小柴派对本司所有', StyleUtils.getCommonTextStyle(color: MyColors.mineYellow, fontSize: 42.sp)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text() {
    const qStyle = TextStyle(color: Color(0xFFFDC15D), fontSize: 24);
    const aStyle = TextStyle(color: Colors.white, fontSize: 20, height: 1.7);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('财富等级是什么？', style: qStyle),
        SizedBox(height: 12),
        Text(
          '财富等级是您在平台成长的体现，等级越高象征着您的身份越高，除了独特的财富等级标识外，达到相应等级可在每日18点领取每日金豆俸禄，等级越高，账号价值越高！（注：未领取的日俸禄最多累积保留3日）',
          style: aStyle,
        ),
        SizedBox(height: 26),
        Text('如何提升等级？', style: qStyle),
        SizedBox(height: 12),
        Text(
          '根据用户赠送价值1金豆的礼物（注：所有礼物类型均可），均可获得1财富值，达到对应财富总值将提升财富等级。',
          style: aStyle,
        ),
        SizedBox(height: 42),
      ],
    );
  }

  Widget _excel() {
    const color = Color(0xFFF9E7C9);
    const titleStyle =
        TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w500);
    const listStyle =
        TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w400);
    BigClientController c = Get.find();
    return Container(
      decoration: BoxDecoration(
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        //设置四周边框
        border: Border.all(width: 2, color: color),
      ),
      child: Obx(() {
        List<Widget> list = [
          _item(titleStyle, 127, [
            '荣耀\n等级',
            '荣耀值',
            '日薪水/\n领取要求\n(当日荣耀值)',
            '周薪水/\n领取要求\n(当周荣耀值)',
            '月薪水/\n领取要求\n(当月荣耀值)'
          ])
        ];
        for (var item in c.success.value) {
          list.add(Container(width: 622, height: 2, color: color));
          list.add(_item(
              listStyle, 50, [item, '100', '0 / XX', '0 / XX', '0 / XX']));
        }
        return Column(children: list);
      }),
    );
  }

  Widget _item(TextStyle style, double height, List<String> texts) {
    final List<double> widths = [79, 90, 147, 147, 147];
    List<Widget> list = [];
    for (var i = 0; i < widths.length; i++) {
      if (i > 0) {
        list.add(Container(width: 2, height: height, color: style.color));
      }
      final width = widths[i];
      list.add(
        SizedBox(
          width: width,
          height: height,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              constraints: BoxConstraints(minWidth: width, minHeight: height),
              alignment: Alignment.center,
              child: Text(
                texts[i],
                textAlign: TextAlign.center,
                style: style,
              ),
            ),
          ),
        ),
      );
    }
    return Row(children: list);
  }
}
