import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bean/Common_bean.dart';
import '../../bean/onlineRoomUserBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/SVGASimpleImage.dart';
///房间内清除魅力
class RoomCleanMeiLiPage extends StatefulWidget {
  String roomID;
  RoomCleanMeiLiPage({super.key, required this.roomID});

  @override
  State<RoomCleanMeiLiPage> createState() => _RoomCleanMeiLiPageState();
}

class _RoomCleanMeiLiPageState extends State<RoomCleanMeiLiPage> {
  // 是否全麦
  bool isAll = false;
  // 麦上有几个人是否点击了选中
  List<bool> listChoose = [];
  // 送人的id集合
  List<String> listUID = [];
  // 是否选了要送的对象(从点击个人信息送的礼物不需要判断此项)
  bool isChoosePeople = false;

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if (listChoose[i]) {
            listChoose[i] = false;
            listUID.remove(listMaiXu[i].uid.toString());
          } else {
            listChoose[i] = true;
            listUID.add(listMaiXu[i].uid.toString());
          }

          int a = 0;
          for(int i  = 0; i < listChoose.length; i++){
            if(listChoose[i] == false){
              isAll = false;
            }else{
              a ++;
            }
          }
          // 是否有选中的人
          if(a > 0){
            isChoosePeople = true;
          }else{
            isChoosePeople = false;
          }
          if(a == listChoose.length){
            isAll = true;
          }
        });
      }),
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 10.h, 0),
        height: ScreenUtil().setHeight(60),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(50),
                    ScreenUtil().setHeight(50), listMaiXu[i].avatar!),
                listChoose[i]
                    ? SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: const SVGASimpleImage(
                    assetsName: 'assets/svga/r_people_choose.svga',
                  ),
                )
                    : WidgetUtils.commonSizedBox(60.h, 60.h),
              ],
            ),
            (i == 0 && listMaiXu[i].serialNumber == 9) ? WidgetUtils.showImages('assets/images/room_zhuchi.png',
                ScreenUtil().setHeight(20), ScreenUtil().setHeight(20))
                :
            Container(
              width: ScreenUtil().setHeight(20),
              height: ScreenUtil().setHeight(20),
              alignment: Alignment.center,
              //边框设置
              decoration: BoxDecoration(
                //背景
                color: MyColors.roomCirle,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 0.5, color: MyColors.roomTCWZ2),
              ),
              child: Text(
                listMaiXu[i].serialNumber.toString(),
                style: StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ScreenUtil().setSp(14)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostOnlineRoomUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: 260.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/room_tc2.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20, 0),
                // 全麦
                Container(
                  height: ScreenUtil().setHeight(60),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: _itemPeople,
                            itemCount: listMaiXu.length,
                          )),
                      listMaiXu.isNotEmpty ? GestureDetector(
                        onTap: (() {
                          setState(() {
                            for(int i = 0; i < listMaiXu.length; i++){
                              if(isAll){
                                listChoose[i] = false;
                                listUID.clear();
                              }else{
                                listChoose[i] = true;
                                listUID.clear();
                                for(int i =0; i < listMaiXu.length; i++){
                                  listUID.add(listMaiXu[i].uid.toString());
                                }
                              }
                            }
                            isAll = !isAll;
                          });
                        }),
                        child: SizedBox(
                          height: ScreenUtil().setHeight(60),
                          width: ScreenUtil().setHeight(80),
                          child: WidgetUtils.onlyTextCenter(
                              isAll ? '取消' : '全麦',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomTCWZ2,
                                  fontSize: ScreenUtil().setSp(28))),
                        ),
                      ) : const Text('')
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: (() {
                    eventBus.fire(SubmitButtonBack(title: '清除魅力'));
                    if (MyUtils.checkClick()) {
                      if(isAll){
                        doPostCleanCharm();
                      }else{
                        doPostCleanCharmSingle();
                      }
                    }
                    // doPostTeamReport();
                  }),
                  child: WidgetUtils.myContainer(
                      ScreenUtil().setHeight(50),
                      ScreenUtil().setHeight(200),
                      MyColors.homeTopBG,
                      MyColors.homeTopBG,
                      '清除魅力',
                      ScreenUtil().setSp(25),
                      Colors.white),
                ),
                WidgetUtils.commonSizedBox(40, 0),
              ],
            ),
          )
        ],
      ),
    );
  }


  List<DataMX> listMaiXu= [];
  /// 房间麦序在线用户
  Future<void> doPostOnlineRoomUser() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      onlineRoomUserBean bean = await DataUtils.postOnlineRoomUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listMaiXu.clear();
            listChoose.clear();
            for(int i = 0; i < bean.data!.length; i++){
              if(bean.data![i].serialNumber == 9){
                listMaiXu.add(bean.data![i]);
                break;
              }
            }
            for(int i = 0; i < bean.data!.length; i++){
              listChoose.add(false);
              if(bean.data![i].serialNumber != 9){
                listMaiXu.add(bean.data![i]);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }



  /// 厅内清除单个魅力
  Future<void> doPostCleanCharmSingle() async {
    String toUids = '';
    setState(() {
      listUID = listUID.toSet().toList();
    });
    for(int i = 0; i < listUID.length; i++){
      if(toUids.isEmpty){
        toUids = listUID[i];
      }else{
        toUids = '$toUids,${listUID[i]}';
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
      'uid':toUids,
    };
    try {
      CommonBean bean = await DataUtils.postCleanCharmSingle(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('魅力值已清除');
          Navigator.pop(context);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 清除魅力值-全麦
  Future<void> doPostCleanCharm() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomID,
    };
    try {
      CommonBean bean = await DataUtils.postCleanCharm(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('魅力值已清除');
          Navigator.pop(context);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
