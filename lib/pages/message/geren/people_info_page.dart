import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/geren/ziliao_page.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/userInfoBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../chat_page.dart';
import 'dongtai_page.dart';

/// 个人主页
class PeopleInfoPage extends StatefulWidget {
  String otherId;
  PeopleInfoPage({Key? key,required this.otherId}) : super(key: key);

  @override
  State<PeopleInfoPage> createState() => _PeopleInfoPageState();
}

class _PeopleInfoPageState extends State<PeopleInfoPage> {
  int _currentIndex = 0, gender = 0, is_pretty = 0, all_gift_type = 0, live = 0;
  late final PageController _controller;//
  // 0-未知 1-男 2-女
  int sex = 0;
  String headImg = '',
      headImgID = '',
      nickName = '',
      userNumber = '',
      voice_card = '',
      voice_cardID = '',
      description = '',
      city = '',
      photo_id = '',
      constellation = '',
      birthday = '';

  List<String> list_p = [];
  List<String> list_pID = [];
  List<String> list_label = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    doPostUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/people_bg.jpg"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),
                ///头部信息
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(50),
                        padding: const EdgeInsets.only(left: 15),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                        ),
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(10, 0),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 0),
                  height: ScreenUtil().setHeight(150),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(130), ScreenUtil().setHeight(130), headImg),
                      WidgetUtils.commonSizedBox(0, 10),
                      ///昵称等信息
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(child: Text('')),
                            WidgetUtils.onlyText(nickName, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(38), fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(5, 0),
                            Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(25),
                                  width: ScreenUtil().setWidth(50),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: BoxDecoration(
                                    //背景
                                    color: gender == 1 ?  MyColors.dtBlue : MyColors.dtPink,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: WidgetUtils.showImages(
                                      gender == 1 ? 'assets/images/nan.png' : 'assets/images/nv.png', 12, 12),
                                ),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(5, 0),
                            GestureDetector(
                              onTap: ((){
                                Clipboard.setData(ClipboardData(
                                  text: userNumber,
                                ));
                                MyToastUtils.showToastBottom('已成功复制到剪切板');
                              }),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: ScreenUtil().setHeight(150),
                                  minHeight: ScreenUtil().setHeight(38),
                                ),
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.peopleBlue,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetUtils.onlyText(
                                        'ID:$userNumber',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(26))),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.showImages(
                                        'assets/images/people_fuzhi.png',
                                        ScreenUtil().setHeight(22),
                                        ScreenUtil().setWidth(22)),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(child: Text('')),
                          ],
                        ),
                      ),
                      live == 1 ? GestureDetector(
                        onTap: ((){

                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setWidth(151),
                          padding: const EdgeInsets.only(left: 8),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: Colors.white ,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              WidgetUtils.showImages('assets/images/zhibozhong2.webp', ScreenUtil().setHeight(22), ScreenUtil().setWidth(22)),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.onlyText('踩房间', StyleUtils.getCommonTextStyle(color: MyColors.careBlue, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(28))),
                            ],
                          ),
                        ),
                      ) : const Text(''),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(10, 0),
                /// 音频
                Row(
                  children: [
                    Container(
                        height: ScreenUtil().setHeight(45),
                        width: ScreenUtil().setWidth(220),
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.only(left: 8),
                        alignment: Alignment.center,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.peopleYellow ,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: WidgetUtils.showImages('assets/images/people_bofang.png', ScreenUtil().setHeight(35), ScreenUtil().setWidth(35))
                      // Row(
                      //   children: [
                      //     // WidgetUtils.showImages('assets/images/people_bofang.png', ScreenUtil().setHeight(35), ScreenUtil().setWidth(35)),
                      //     // WidgetUtils.commonSizedBox(0, 20),
                      //     // WidgetUtils.onlyText('晴天少女', StyleUtils.getCommonTextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(22))),
                      //   ],
                      // ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
                WidgetUtils.commonSizedBox(15, 0),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                alignment: Alignment.bottomLeft,
                                height: ScreenUtil().setHeight(80),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 0;
                                          _controller.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                        });
                                      }),
                                      child: Text(
                                        '资料',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: _currentIndex == 0
                                                ? Colors.black
                                                : MyColors.g6,
                                            fontSize: ScreenUtil().setSp(36),
                                            fontWeight: _currentIndex == 0
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      ),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 20),
                                    GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 1;
                                          _controller.animateToPage(1,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                        });
                                      }),
                                      child: Text(
                                        '动态',
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: _currentIndex == 1
                                                ? Colors.black
                                                : MyColors.g6,
                                            fontSize: ScreenUtil().setSp(36),
                                            fontWeight: _currentIndex == 1
                                                ? FontWeight.w600
                                                : FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            _currentIndex == 0
                                ? SizedBox(
                              width: ScreenUtil().setHeight(55),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(
                                ScreenUtil().setHeight(10),
                                ScreenUtil().setHeight(55)),
                            WidgetUtils.commonSizedBox(0, 20),
                            _currentIndex == 1
                                ? SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                                : WidgetUtils.commonSizedBox(
                                ScreenUtil().setHeight(10),
                                ScreenUtil().setHeight(68)),
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            reverse: false,
                            controller: _controller,
                            onPageChanged: (index) {
                              setState(() {
                                // 更新当前的索引值
                                _currentIndex = index;
                              });
                            },
                            children: const [
                              ZiliaoPage(),
                              DongtaiPage(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: ScreenUtil().setHeight(120),
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(      //渐变位置
                      begin: Alignment.topCenter, //右上
                      end: Alignment.bottomCenter, //左下
                      stops: [0.0, 1.0],         //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: [Color.fromRGBO(255, 255, 255, 0), Color.fromRGBO(255, 255, 255, 1)]
                  )
              ),
              child: Row(
                children: [
                  WidgetUtils.PeopleButton('assets/images/people_hongbao.png', '发红包', MyColors.peopleRed),
                  const Expanded(child: Text('')),
                  WidgetUtils.PeopleButton('assets/images/people_jia.png', '加关注', MyColors.peopleYellow),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: ((){
                      MyUtils.goTransparentRFPage(context, ChatPage(nickName: nickName, otherUid: widget.otherId, otherImg: headImg));
                    }),
                    child: WidgetUtils.PeopleButton('assets/images/people_sixin.png', '私信', MyColors.peopleBlue2),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  /// 查看用户
  Future<void> doPostUserInfo() async {
    Loading.show('加载中...');
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.otherId
    };
    try {
      userInfoBean bean = await DataUtils.postUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          setState(() {
            sp.setString("user_headimg", bean.data!.avatarUrl!);
            sp.setString("label_id", bean.data!.labelId!);
            headImg = bean.data!.avatarUrl!;
            headImgID = bean.data!.avatar.toString();
            sex = bean.data!.gender as int;
            nickName = bean.data!.nickname!;
            userNumber = bean.data!.number.toString();
            voice_card = bean.data!.voiceLabelName!;
            voice_cardID = bean.data!.voiceCard.toString();
            birthday = bean.data!.birthday!;
            description = bean.data!.description!;
            city = bean.data!.city!;
            live = bean.data!.live as int;
            if(bean.data!.label!.isNotEmpty){
              list_label = bean.data!.label!.split(',');
            }
            if(bean.data!.photoId!.isNotEmpty){
              list_pID = bean.data!.photoId!.split(',');
              if(bean.data!.photoUrl!.length > 4){
                list_p.add(bean.data!.photoUrl![0]);
                list_p.add(bean.data!.photoUrl![1]);
                list_p.add(bean.data!.photoUrl![2]);
                list_p.add(bean.data!.photoUrl![3]);
              }else{
                list_p = bean.data!.photoUrl!;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
