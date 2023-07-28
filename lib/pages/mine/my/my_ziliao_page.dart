import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/myHomeBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';

///资料

class MyZiliaoPage extends StatefulWidget {
  const MyZiliaoPage({Key? key}) : super(key: key);

  @override
  State<MyZiliaoPage> createState() => _MyZiliaoPageState();
}

class _MyZiliaoPageState extends State<MyZiliaoPage> {
  int  gender = 0, is_pretty = 0, all_gift_type = 0, age = 0, receive_gift_type = 0;
  String headImg = '',
      nickName = '',
      userNumber = '',
      voice_card = '',
      description = '',
      city = '',
      constellation = '';

  List<String> list_p = [];
  List<ReceiveGift> list_a = [];
  TextEditingController controller = TextEditingController();

  Widget _itemTuiJian(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: WidgetUtils.CircleImageNet(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), ScreenUtil().setHeight(20), list_p[i]),
    );
  }


  Widget _itemLiwu(BuildContext context, int i) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(110), ScreenUtil().setHeight(110), list_a[i].img!),
    );
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
                  onTap: ((){
                    Navigator.pushNamed(context, 'WallPage');
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(44),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        WidgetUtils.showImages('assets/images/people_liwu.png', ScreenUtil().setHeight(35), ScreenUtil().setHeight(35)),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText('礼物墙', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(32))),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText('共收到$receive_gift_type/$all_gift_type款', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(26))),
                        const Expanded(child: Text('')),
                        WidgetUtils.onlyText('查看', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(26))),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.showImages('assets/images/people_right.png', ScreenUtil().setHeight(25), ScreenUtil().setHeight(15)),
                        WidgetUtils.commonSizedBox(0, 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: list_a.isNotEmpty ?  SizedBox(
                    height: ScreenUtil().setHeight(110),
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: _itemLiwu,
                      itemCount: list_a.length > 4 ? 4 : list_a.length,
                    ),
                  ): const Text(''),
                )
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(20, 0),
          WidgetUtils.onlyText('关于我', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(28))),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_xingzuo.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyText( constellation.isEmpty ? '未知' : constellation, StyleUtils.getCommonTextStyle(color: MyColors.g3 ,  fontSize: ScreenUtil().setSp(25))),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_age.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyText(age.toString(), StyleUtils.getCommonTextStyle(color: MyColors.g3 ,  fontSize: ScreenUtil().setSp(25))),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(70),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                WidgetUtils.showImages('assets/images/people_dingwei.png', ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyText(city.isEmpty ? '未知' : city, StyleUtils.getCommonTextStyle(color: MyColors.g3 , fontSize: ScreenUtil().setSp(25))),
              ],
            ),
          ),
          WidgetUtils.myLine(thickness: 5),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyText('签名', StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(28))),
          WidgetUtils.commonSizedBox(10, 0),
          WidgetUtils.onlyText(description, StyleUtils.getCommonTextStyle(color: Colors.black , fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(25))),
          WidgetUtils.commonSizedBox(20, 0),
          list_p.isNotEmpty ? SizedBox(
            height: ScreenUtil().setHeight(110),
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: _itemTuiJian,
              itemCount: list_p.length > 4 ? 4 : list_p.length,
            ),
          ): const Text(''),
          WidgetUtils.commonSizedBox(20, 0),
        ],
      ),
    );
  }


  /// 个人主页
  Future<void> doPostMyIfon() async {
    Loading.show('加载中...');
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
            city = bean.data!.userInfo!.city!;
            description = bean.data!.userInfo!.description!;
            if(bean.data!.userInfo!.photoId!.isNotEmpty){
              list_p = bean.data!.userInfo!.photoUrl!;
            }
            if(bean.data!.giftList!.receiveGift!.isNotEmpty){
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
      Loading.dismiss();
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

}
