import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/myHomeBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../widget/SwiperPage.dart';
import '../liwu/wall_page.dart';

///资料

class MyZiliaoPage extends StatefulWidget {
  const MyZiliaoPage({Key? key}) : super(key: key);

  @override
  State<MyZiliaoPage> createState() => _MyZiliaoPageState();
}

class _MyZiliaoPageState extends State<MyZiliaoPage> {
  int gender = 0,
      is_pretty = 0,
      all_gift_type = 0,
      age = 0,
      receive_gift_type = 0;
  String headImg = '',
      nickName = '',
      userNumber = '',
      voice_card = '',
      description = '',
      city = '',
      constellation = '',
      xzUrl = '';

  List<String> list_p = [];
  List<ReceiveGift> list_a = [];
  TextEditingController controller = TextEditingController();
  // 查看图片使用
  List<String> imgList = [];


  Widget _itemTuiJian(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return SwiperPage(imgList: imgList);
            }));
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(160),
            ScreenUtil().setHeight(160), ScreenUtil().setHeight(20), list_p[i]),
      ),
    );
  }

  Widget liwu(int i) {
    if (i == 1) {
      return WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[0].img!);
    } else if (i == 2) {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[0].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[1].img!)
        ],
      );
    } else if (i == 3) {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[0].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[1].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[2].img!)
        ],
      );
    } else {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[0].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[1].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[2].img!),
          WidgetUtils.commonSizedBox(0, 10.h),
          WidgetUtils.CircleImageNet(110.h, 110.h, 55.h, list_a[3].img!)
        ],
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostMyIfon();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WidgetUtils.commonSizedBox(20, 0),
          Container(
            height: ScreenUtil().setHeight(260),
            padding: const EdgeInsets.only(left: 10, right: 10),
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: MyColors.peopleLiwu,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentPageCom(context,
                            WallPage(uid: sp.getString('user_id').toString()));
                      }
                    }
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(44),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/people_liwu.png',
                            ScreenUtil().setHeight(35),
                            ScreenUtil().setHeight(35)),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText(
                            '礼物墙',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText(
                            '共收到$receive_gift_type/$all_gift_type款',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.g9,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(26))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText(
                            '查看',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(26))),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.showImages(
                            'assets/images/people_right.png',
                            ScreenUtil().setHeight(25),
                            ScreenUtil().setHeight(15)),
                        WidgetUtils.commonSizedBox(0, 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: list_a.isNotEmpty
                      ? Row(
                          children: [
                            liwu(list_a.length),
                          ],
                        )
                      : Column(
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.showImages(
                                'assets/images/no_have.png', 60, 60),
                            WidgetUtils.onlyTextCenter(
                                '暂无收到礼物',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.g6,
                                    fontSize: ScreenUtil().setSp(18))),
                            const Expanded(child: Text('')),
                          ],
                        ),
                )
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(20, 0),
          WidgetUtils.onlyText(
              '关于我',
              StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(28))),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_xingzuo.png',
                    ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                constellation.isEmpty
                    ? WidgetUtils.onlyText(
                        '未知',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.g3,
                            fontSize: ScreenUtil().setSp(25)))
                    : WidgetUtils.showImages(xzUrl, 45.h, 160.w),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_age.png',
                    ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyText(
                    age.toString(),
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_dingwei.png',
                    ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyText(
                    city.isEmpty ? '未知' : city,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g3, fontSize: ScreenUtil().setSp(25))),
              ],
            ),
          ),
          WidgetUtils.myLine(thickness: 5),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyText(
              '签名',
              StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(28))),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyText(
              description,
              StyleUtils.getCommonTextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(25))),
          WidgetUtils.commonSizedBox(20, 0),
          list_p.isNotEmpty
              ? SizedBox(
                  height: ScreenUtil().setHeight(160),
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: _itemTuiJian,
                    itemCount: list_p.length > 3 ? 3 : list_p.length,
                  ),
                )
              : const Text(''),
          WidgetUtils.commonSizedBox(20, 0),
        ],
      ),
    );
  }

  /// 个人主页
  Future<void> doPostMyIfon() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id')
    };
    try {
      myHomeBean bean = await DataUtils.postMyHome(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          list_a.clear();
          setState(() {
            sp.setString("user_headimg", bean.data!.userInfo!.avatarUrl!);
            headImg = bean.data!.userInfo!.avatarUrl!;
            gender = bean.data!.userInfo!.gender as int;
            nickName = bean.data!.userInfo!.nickname!;
            userNumber = bean.data!.userInfo!.number.toString();
            voice_card = bean.data!.userInfo!.voiceCardUrl!;
            is_pretty = bean.data!.userInfo!.isPretty as int;
            age = bean.data!.userInfo!.age as int;
            constellation = bean.data!.userInfo!.constellation!;
            if (bean.data!.userInfo!.constellation! == '白羊座') {
              xzUrl = 'assets/images/xz/baiyang.png';
            } else if (bean.data!.userInfo!.constellation! == '处女座') {
              xzUrl = 'assets/images/xz/chunv.png';
            } else if (bean.data!.userInfo!.constellation! == '金牛座') {
              xzUrl = 'assets/images/xz/jinniu.png';
            } else if (bean.data!.userInfo!.constellation! == '巨蟹座') {
              xzUrl = 'assets/images/xz/juxie.png';
            } else if (bean.data!.userInfo!.constellation! == '摩羯座') {
              xzUrl = 'assets/images/xz/mojie.png';
            } else if (bean.data!.userInfo!.constellation! == '射手座') {
              xzUrl = 'assets/images/xz/sheshou.png';
            } else if (bean.data!.userInfo!.constellation! == '狮子座') {
              xzUrl = 'assets/images/xz/shizi.png';
            } else if (bean.data!.userInfo!.constellation! == '双鱼座') {
              xzUrl = 'assets/images/xz/shuangyu.png';
            } else if (bean.data!.userInfo!.constellation! == '双子座') {
              xzUrl = 'assets/images/xz/shuangzi.png';
            } else if (bean.data!.userInfo!.constellation! == '水瓶座') {
              xzUrl = 'assets/images/xz/shuiping.png';
            } else if (bean.data!.userInfo!.constellation! == '天秤座') {
              xzUrl = 'assets/images/xz/tiancheng.png';
            } else if (bean.data!.userInfo!.constellation! == '天蝎座') {
              xzUrl = 'assets/images/xz/tianxie.png';
            }
            city = bean.data!.userInfo!.city!;
            description = bean.data!.userInfo!.description!;
            if (bean.data!.userInfo!.photoId!.isNotEmpty) {
              list_p = bean.data!.userInfo!.photoUrl!;
            }
            for(int i = 0; i < bean.data!.userInfo!.photoUrl!.length; i++) {
              imgList.add(bean.data!.userInfo!.photoUrl![i].toString());
            }
            if (bean.data!.giftList!.receiveGift!.isNotEmpty) {
              list_a = bean.data!.giftList!.receiveGift!;
            }
            all_gift_type = bean.data!.giftList!.allGiftType!;
            receive_gift_type = bean.data!.giftList!.receiveGiftType!;
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
      LogE('错误信息2 ${e.toString()}');
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
