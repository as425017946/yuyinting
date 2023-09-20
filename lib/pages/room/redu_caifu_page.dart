import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../bean/rankListBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 热度-财富榜
class ReDuCaiFuPage extends StatefulWidget {
  String roomID;
  ReDuCaiFuPage({super.key, required this.roomID});

  @override
  State<ReDuCaiFuPage> createState() => _ReDuCaiFuPageState();
}

class _ReDuCaiFuPageState extends State<ReDuCaiFuPage>  with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  int page = 1;
  // 财富榜传wealth 魅力榜传charm : 日榜day 周榜week 月榜month
  String dateType = 'day';
  List<ListBD> _list = [];
  List<ListBD> _list2 = [];

  int showPage = 0;

  /// 在线用户推荐使用
  Widget _itemTuiJian(BuildContext context, int i) {
    return Column(
      children: [
        GestureDetector(
          onTap: (() {
            // MyToastUtils.showToastBottom('点击了');
          }),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: double.infinity,
            height: ScreenUtil().setHeight(130),
            child: Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
                    _list2[i].avatar!),
                WidgetUtils.commonSizedBox(0, 10),
                Expanded(
                  child: Column(
                    children: [
                      const Expanded(child: Text('')),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            WidgetUtils.onlyText(
                                _list2[i].nickname!,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.roomTCWZ2,
                                    fontSize: ScreenUtil().setSp(25))),
                          ],
                        ),
                      ),
                      const Expanded(child: Text(''))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRankList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          /// 日榜 周榜 月榜
          Row(
            children: [
              const Expanded(child: Text('')),
              Stack(
                children: [
                  Opacity(
                    opacity: 0.2,
                    child: Row(
                      children: [
                        Container(
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: Colors.grey,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: WidgetUtils.commonSizedBox(ScreenUtil().setHeight(50), ScreenUtil().setHeight(270)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setHeight(270),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 0 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 0;
                                    dateType = 'day';
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('日榜', StyleUtils.getCommonTextStyle(color: showPage == 0 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 1 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 1;
                                    dateType = 'week';
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('周榜', StyleUtils.getCommonTextStyle(color: showPage == 1 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: showPage == 2 ? 0.2 : 0,
                                child: Container(
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              GestureDetector(
                                onTap: ((){
                                  setState(() {
                                    showPage = 2;
                                    dateType = 'month';
                                  });
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: WidgetUtils.onlyTextCenter('月榜', StyleUtils.getCommonTextStyle(color: showPage == 2 ? MyColors.roomTCWZ2 : MyColors.roomTCWZ3, fontSize: ScreenUtil().setSp(25))),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Expanded(child: Text('')),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(323),
            width: double.infinity,
            child: Row(
              children: [
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    _list.length>1 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg'): const Text(''),
                    WidgetUtils.commonSizedBox(5, 0),
                    Stack(
                      children: [
                        WidgetUtils.showImagesFill(
                            'assets/images/room_two.png',
                            ScreenUtil().setHeight(104),
                            ScreenUtil().setHeight(155)),
                        Container(
                          width: ScreenUtil().setHeight(155),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              _list.length>1 ? _list[1].nickname! : '',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    _list.isNotEmpty ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(120), ScreenUtil().setHeight(120), 'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg') : const Text(''),
                    WidgetUtils.commonSizedBox(5, 0),
                    Stack(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/room_one.png',
                            ScreenUtil().setHeight(165),
                            ScreenUtil().setHeight(192)),
                        Container(
                          width: ScreenUtil().setHeight(192),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              _list.isNotEmpty ? _list[0].nickname! : '',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
                Column(
                  children: [
                    const Expanded(child: Text('')),
                    _list.length > 2 ? WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(100), ScreenUtil().setHeight(100), 'https://img-blog.csdnimg.cn/6d15082ac7234ec7a16065e74f689590.jpeg') : const Text(''),
                    WidgetUtils.commonSizedBox(5, 0),
                    Stack(
                      children: [
                        WidgetUtils.showImagesFill(
                            'assets/images/room_three.png',
                            ScreenUtil().setHeight(104),
                            ScreenUtil().setHeight(155)),
                        Container(
                          width: ScreenUtil().setHeight(155),
                          margin: const EdgeInsets.only(top: 5),
                          alignment: Alignment.topCenter,
                          child: WidgetUtils.onlyTextCenter(
                              _list.length > 2 ? _list[2].nickname! : '',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomPHWZBlack,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.w600)),
                        )
                      ],
                    )
                  ],
                ),
                const Expanded(child: Text('')),
              ],
            ),
          ),
          /// 展示在线用户
          ListView.builder(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: _itemTuiJian,
            itemCount: _list2.length,
          )
        ],
      ),
    );
  }


  /// 榜单
  Future<void> doPostRankList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'category': 'wealth',
      'date_type': dateType,
      'room_id': widget.roomID,
      'page': page,
      'pageSize': '30'
    };
    try {
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
    } catch (e) {
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
