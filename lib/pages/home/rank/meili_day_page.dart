import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bean/rankListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/geren/people_info_page.dart';
///魅力日榜
class MeiLiDayPage extends StatefulWidget {
  String category;
  MeiLiDayPage({super.key, required this.category});

  @override
  State<MeiLiDayPage> createState() => _MeiLiDayPageState();
}

class _MeiLiDayPageState extends State<MeiLiDayPage> {
  int page = 1;
  List<ListBD> _list = [];
  List<ListBD> _list2 = [];
  // 日榜day 周榜week 月榜month
  String date_type = 'day';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRankList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(_list.length==1)
          SizedBox(
            height: ScreenUtil().setHeight(320),
            child:  Row(
              children: [
                const Expanded(child: Text('')),
                Opacity(
                  opacity: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setWidth(20),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(10))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: ((){
                    if(MyUtils.checkClick()) {
                      MyUtils.goTransparentRFPage(context,
                          PeopleInfoPage(otherId: _list[0].uid.toString(),));
                    }
                  }),
                  child: Transform.translate(offset: Offset(0,-20),
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: ScreenUtil().setHeight(260),
                      width: ScreenUtil().setWidth(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.CricleImagess(90, 90,
                              _list[0].avatar!),
                          SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/py_one.png',
                                    ScreenUtil().setHeight(231),
                                    ScreenUtil().setWidth(228)),
                                _list[0].liveStatus == 1 ?Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(28)),
                                  width: ScreenUtil().setHeight(60),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: const BoxDecoration(
                                    //设置Container修饰
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage("assets/images/py_tishi.png"),
                                      fit: BoxFit.cover, //覆盖
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(15),
                                          ScreenUtil().setWidth(15)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15))),
                                    ],
                                  ) /* add child content here */,
                                ) : const Text('')
                              ],
                            ),
                          ),
                          WidgetUtils.onlyTextBottom(
                              _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.pyWenZiBlue,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                Opacity(opacity: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_three.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setWidth(20),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(10))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        if(_list.length==2)
          SizedBox(
            height: ScreenUtil().setHeight(320),
            child:  Row(
              children: [
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[1].uid.toString(),));
                  }),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            _list[1].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            _list[1].nickname!,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        _list[1].liveStatus == 1 ?Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(60),
                          height: ScreenUtil().setWidth(30),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(15))),
                            ],
                          ) /* add child content here */,
                        ) : const Text('')
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[0].uid.toString(),));
                  }),
                  child: Transform.translate(offset: Offset(0,-20),
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: ScreenUtil().setHeight(260),
                      width: ScreenUtil().setWidth(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.CricleImagess(90, 90,
                              _list[0].avatar!),
                          SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/py_one.png',
                                    ScreenUtil().setHeight(231),
                                    ScreenUtil().setWidth(228)),
                                _list[0].liveStatus == 1 ?Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(28)),
                                  width: ScreenUtil().setHeight(60),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: const BoxDecoration(
                                    //设置Container修饰
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage("assets/images/py_tishi.png"),
                                      fit: BoxFit.cover, //覆盖
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(15),
                                          ScreenUtil().setWidth(15)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15))),
                                    ],
                                  ) /* add child content here */,
                                ) : const Text('')
                              ],
                            ),
                          ),
                          WidgetUtils.onlyTextBottom(
                              _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.pyWenZiBlue,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                Opacity(opacity: 0,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                        WidgetUtils.showImages(
                            'assets/images/py_three.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            '我爱车模',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(50),
                          height: ScreenUtil().setWidth(20),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(10))),
                            ],
                          ) /* add child content here */,
                        )
                      ],
                    ),
                  ),),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        if(_list.length>=3)
          SizedBox(
            height: ScreenUtil().setHeight(320),
            child:  Row(
              children: [
                const Expanded(child: Text('')),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[1].uid.toString(),));
                  }),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            _list[1].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_two.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            _list[1].nickname!,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        _list[1].liveStatus == 1 ?Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(60),
                          height: ScreenUtil().setWidth(30),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(15))),
                            ],
                          ) /* add child content here */,
                        ) : const Text('')
                      ],
                    ),
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[0].uid.toString(),));
                  }),
                  child: Transform.translate(offset: Offset(0,-20),
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: ScreenUtil().setHeight(260),
                      width: ScreenUtil().setWidth(230),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.CricleImagess(90, 90,
                              _list[0].avatar!),
                          SizedBox(
                            height: ScreenUtil().setHeight(231),
                            width: ScreenUtil().setWidth(228),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/py_one.png',
                                    ScreenUtil().setHeight(231),
                                    ScreenUtil().setWidth(228)),
                                _list[0].liveStatus == 1 ?Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(28)),
                                  width: ScreenUtil().setHeight(60),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: const BoxDecoration(
                                    //设置Container修饰
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage("assets/images/py_tishi.png"),
                                      fit: BoxFit.cover, //覆盖
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(15),
                                          ScreenUtil().setWidth(15)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(15))),
                                    ],
                                  ) /* add child content here */,
                                ) : const Text('')
                              ],
                            ),
                          ),
                          WidgetUtils.onlyTextBottom(
                              _list[0].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.pyWenZiBlue,
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),),
                ),
                WidgetUtils.commonSizedBox(0, 4),
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list[2].uid.toString(),));
                  }),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 70),
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(180),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WidgetUtils.CricleImagess(55, 55,
                            _list[2].avatar!),
                        WidgetUtils.showImages(
                            'assets/images/py_three.png',
                            ScreenUtil().setHeight(154),
                            ScreenUtil().setWidth(146)),
                        WidgetUtils.onlyTextBottom(
                            _list[2].nickname!,
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.pyWenZiBlue,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600)),
                        _list[2].liveStatus == 1 ?Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setHeight(98)),
                          width: ScreenUtil().setHeight(60),
                          height: ScreenUtil().setWidth(30),
                          decoration: const BoxDecoration(
                            //设置Container修饰
                            image: DecorationImage(
                              //背景图片修饰
                              image: AssetImage("assets/images/py_tishi.png"),
                              fit: BoxFit.cover, //覆盖
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/zhibo2.webp',
                                  ScreenUtil().setWidth(15),
                                  ScreenUtil().setWidth(15)),
                              WidgetUtils.onlyText(
                                  '在房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(15))),
                            ],
                          ) /* add child content here */,
                        ) : const Text('')
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
        WidgetUtils.commonSizedBox(ScreenUtil().setHeight(120), 0),
        SingleChildScrollView(
          child: Wrap(
            children: [
              for(int i = 0; i < _list2.length; i++)
                GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentRFPage(context, PeopleInfoPage(otherId: _list2[i].uid.toString(),));
                  }),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(60),
                        right: ScreenUtil().setWidth(20)),
                    child:  Container(
                      height: ScreenUtil().setHeight(90),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          WidgetUtils.onlyText(
                              (i+4).toString(),
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.pyWenZiGrey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(40))),
                          WidgetUtils.commonSizedBox(0, 15),
                          Container(
                            height: ScreenUtil().setHeight(90),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.CricleImagess(50, 50,
                                    _list2[i].avatar!),
                                _list2[i].liveStatus == 1 ? Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20)),
                                  width: ScreenUtil().setHeight(70),
                                  height: ScreenUtil().setWidth(31),
                                  decoration: const BoxDecoration(
                                    //设置Container修饰
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage(
                                          "assets/images/py_tishi.png"),
                                      fit: BoxFit.cover, //覆盖
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibo2.webp',
                                          ScreenUtil().setWidth(20),
                                          ScreenUtil().setWidth(25)),
                                      WidgetUtils.onlyText(
                                          '在房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(14))),
                                    ],
                                  ) /* add child content here */,
                                ) : const Text(''),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                          WidgetUtils.onlyText(
                              _list2[i].nickname!,
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(28))),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  /// 榜单
  Future<void> doPostRankList() async {
    //财富榜传wealth 魅力榜传charm
    Map<String, dynamic> params = <String, dynamic>{
      'category': widget.category,
      'date_type': date_type,
      'page': page,
      'pageSize': MyConfig.pageSize
    };
    try {
      Loading.show(MyConfig.successTitle);
      rankListBean bean = await DataUtils.postRankList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list.add(bean.data!.list![i]);
              }
              if(bean.data!.list!.length>3){
                for (int i = 3; i < bean.data!.list!.length; i++) {
                  _list2.add(bean.data!.list![i]);
                }
              }
            }
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
