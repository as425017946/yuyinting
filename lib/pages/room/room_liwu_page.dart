import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/bean/liwuBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/room/room_show_liwu_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';
import '../../bean/Common_bean.dart';
import '../../bean/balanceBean.dart';
import '../../bean/onlineRoomUserBean.dart';
import '../../bean/roomInfoBean.dart';
import '../../bean/walletListBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../widget/OptionGridView.dart';

/// 厅内礼物
class RoomLiWuPage extends StatefulWidget {
  List<MikeList> listM;
  String uid;
  RoomLiWuPage({super.key, required this.listM, required this.uid});

  @override
  State<RoomLiWuPage> createState() => _RoomLiWuPageState();
}

class _RoomLiWuPageState extends State<RoomLiWuPage>
    with SingleTickerProviderStateMixin {
  // 类型
  int leixing = 0;
  // 点击的礼物id
  String giftId = '';
  // 显不显示全麦按钮
  int changdu = 0;
  // 经典
  List<DataL> listC = [];
  List<bool> listCBool = [];

  // 特权
  List<DataL> listPV = [];
  List<bool> listPVBool = [];

  // 背包
  List<DataL> listPl = [];
  List<bool> listPlBool = [];

  // 麦上有几个人是否点击了选中
  List<bool> listChoose = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int shuliang = 1;
  bool isTS = false;
  // 赠送礼物需要的图片
  String imgUrl = '';
  // 选择需要赠送的哪个人
  List<bool> listPeople = [];
  // 是否选了要送的对象(从点击个人信息送的礼物不需要判断此项)
  bool isChoosePeople = false;
  // 赠送数量
  String numbers = '';
  // 是不是点击麦上人进来的
  bool isMaiPeople = false;
  // 是否全麦
  bool isAll = false;
  // 要送的礼物地址
  String url = '', svga = '';

  Widget _itemPeople(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if (listChoose[i]) {
            isChoosePeople = false;
            listChoose[i] = false;
            listPeople[listMaiXu[i].serialNumber! - 1] = false;
          } else {
            isChoosePeople = true;
            listChoose[i] = true;
            listPeople[listMaiXu[i].serialNumber! - 1] = true;
          }

          int a = 0;
          for(int i  = 0; i < listChoose.length; i++){
            if(listChoose[i] == false){
              isAll = false;
            }else{
              a ++;
            }
          }
          if(a == listChoose.length){
            isAll = true;
          }
        });
        eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
      }),
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                        height: 50.h,
                        width: 50.h,
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/r_people_choose.svga',
                        ),
                      )
                    : const Text(''),
              ],
            ),
            i == 0 ? WidgetUtils.showImages('assets/images/room_tingzhu.png',
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
                i.toString(),
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

  /// 礼物
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          if(leixing == 0){
            for (int i = 0; i < listC.length; i++) {
              listCBool[i] = false;
            }
            listCBool[index] = true;

            url = listC[index].img.toString();
            svga = listC[index].imgRendering.toString();
          }else if(leixing == 1){
            for (int i = 0; i < listPV.length; i++) {
              listPVBool[i] = false;
            }
            listPVBool[index] = true;

            url = listPV[index].img.toString();
            svga = listPV[index].imgRendering.toString();
          }else{
            for (int i = 0; i < listPl.length; i++) {
              listPlBool[i] = false;
            }
            listPlBool[index] = true;

            url = listPl[index].img.toString();
            svga = listPl[index].imgRendering.toString();
          }
        });

        _animationController.reset();
        _animationController.forward();
      }),
      child: Container(
        height: ScreenUtil().setHeight(190),
        width: 130.h,
        alignment: Alignment.center,
        child: leixing == 0 ? Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(190),
              width: ScreenUtil().setHeight(130),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10.h, 0),
                  listCBool[index]
                      ? AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _animation.value,
                              child: WidgetUtils.showImagesNet(
                                  listC[index].img!,
                                  ScreenUtil().setHeight(110),
                                  ScreenUtil().setHeight(100)),
                            );
                          },
                        )
                      :
                  WidgetUtils.showImagesNet(
                      listC[index].img!,
                      ScreenUtil().setHeight(110),
                      ScreenUtil().setHeight(100)),
                  WidgetUtils.onlyTextCenter(
                      listC[index].name!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '${listC[index].price}钻',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ3,
                          fontSize: ScreenUtil().setSp(21))),
                ],
              ),
            ),
            listCBool[index]
                ? WidgetUtils.showImagesFill('assets/images/room_liwu_bg.png',
                    ScreenUtil().setHeight(190), ScreenUtil().setHeight(130))
                : const Text(''),
          ],
        ) : leixing == 1 ? Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(190),
              width: ScreenUtil().setHeight(130),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10.h, 0),
                  listPVBool[index]
                      ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: WidgetUtils.showImagesNet(
                            listPV[index].img!,
                            ScreenUtil().setHeight(110),
                            ScreenUtil().setHeight(100)),
                      );
                    },
                  )
                      :
                  WidgetUtils.showImagesNet(
                      listPV[index].img!,
                      ScreenUtil().setHeight(110),
                      ScreenUtil().setHeight(100)),
                  WidgetUtils.onlyTextCenter(
                      listPV[index].name!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '${listPV[index].price}钻',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ3,
                          fontSize: ScreenUtil().setSp(21))),
                ],
              ),
            ),
            listPVBool[index]
                ? WidgetUtils.showImagesFill('assets/images/room_liwu_bg.png',
                ScreenUtil().setHeight(190), ScreenUtil().setHeight(130))
                : const Text(''),
          ],
        ) : Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(190),
              width: ScreenUtil().setHeight(130),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(10.h, 0),
                  listPlBool[index]
                      ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        child: WidgetUtils.showImagesNet(
                            listPl[index].img!,
                            ScreenUtil().setHeight(110),
                            ScreenUtil().setHeight(100)),
                      );
                    },
                  )
                      :
                  WidgetUtils.showImagesNet(
                      listPl[index].img!,
                      ScreenUtil().setHeight(110),
                      ScreenUtil().setHeight(100)),
                  WidgetUtils.onlyTextCenter(
                      listPl[index].name!,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ2,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.onlyTextCenter(
                      '${listPl[index].price}钻',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.roomTCWZ3,
                          fontSize: ScreenUtil().setSp(21))),
                ],
              ),
            ),
            listPlBool[index]
                ? WidgetUtils.showImagesFill('assets/images/room_liwu_bg.png',
                ScreenUtil().setHeight(190), ScreenUtil().setHeight(130))
                : const Text(''),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i < 10; i++){
      listPeople.add(false);
    }
    setState(() {
      for (int i = 0; i < widget.listM.length; i++) {
        listChoose.add(false);
      }
    });
    doPostOnlineRoomUser();
    doPostGiftList();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    /// 缩小至 0.2倍大小，放大至3倍大小 非线性动画
    _animation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    if(widget.uid.isEmpty){
      setState(() {
        isMaiPeople = true;
      });
    }else{
      for(int i = 0; i < widget.listM.length; i++){
        if(widget.uid == widget.listM[i].uid.toString()){
          if(i == 8){
            listChoose[0] = true;
          }else{
            listChoose[i+1] = true;
          }
          setState(() {
            isMaiPeople = true;
            listPeople[i] = true;
          });
          eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.fire(ResidentBack(isBack: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    for(int i = 0; i < listPeople.length; i++){
                      listPeople[i] = false;
                    }
                    eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
                    eventBus.fire(ResidentBack(isBack: true));
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
                height: isMaiPeople ? 640.h : 600.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage("assets/images/room_tc1.png"),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(10, 0),
                        // 全麦
                        isMaiPeople ? Container(
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
                              changdu > 0 ? GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    for(int i = 0; i < listMaiXu.length; i++){
                                      if(isAll){
                                        listChoose[i] = false;
                                        listPeople[listMaiXu[i].serialNumber! - 1] = false;
                                        isChoosePeople = false;
                                      }else{
                                        listChoose[i] = true;
                                        listPeople[listMaiXu[i].serialNumber! - 1] = true;
                                        isChoosePeople = true;
                                      }
                                    }
                                    eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
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
                        ) : WidgetUtils.commonSizedBox(0, 0),
                        isMaiPeople ? WidgetUtils.myLine(
                            color: MyColors.roomTCWZ3,
                            endIndent: 20,
                            indent: 20,
                            thickness: 0.5) : WidgetUtils.commonSizedBox(0, 0),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  url = '';
                                  svga = '';
                                  leixing = 0;
                                });
                              }),
                              child: WidgetUtils.onlyTextCenter(
                                  '经典',
                                  StyleUtils.getCommonTextStyle(
                                      color: leixing == 0
                                          ? MyColors.roomTCWZ2
                                          : MyColors.roomTCWZ3,
                                      fontSize: leixing == 0
                                          ? ScreenUtil().setSp(28)
                                          : ScreenUtil().setSp(25))),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            Container(
                              height: ScreenUtil().setHeight(10),
                              width: ScreenUtil().setWidth(1),
                              color: MyColors.roomTCWZ3,
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  url = '';
                                  svga = '';
                                  leixing = 1;
                                });
                                if(listPV.isEmpty){
                                  doPostGiftList();
                                }
                              }),
                              child: WidgetUtils.onlyTextCenter(
                                  '特权',
                                  StyleUtils.getCommonTextStyle(
                                      color: leixing == 1
                                          ? MyColors.roomTCWZ2
                                          : MyColors.roomTCWZ3,
                                      fontSize: leixing == 1
                                          ? ScreenUtil().setSp(28)
                                          : ScreenUtil().setSp(25))),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            Container(
                              height: ScreenUtil().setHeight(10),
                              width: ScreenUtil().setWidth(1),
                              color: MyColors.roomTCWZ3,
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  url = '';
                                  svga = '';
                                  leixing = 2;
                                });
                                if(listPl.isEmpty){
                                  doPostGiftList();
                                }
                              }),
                              child: WidgetUtils.onlyTextCenter(
                                  '背包',
                                  StyleUtils.getCommonTextStyle(
                                      color: leixing == 2
                                          ? MyColors.roomTCWZ2
                                          : MyColors.roomTCWZ3,
                                      fontSize: leixing == 2
                                          ? ScreenUtil().setSp(28)
                                          : ScreenUtil().setSp(25))),
                            ),
                            const Expanded(child: Text('')),
                            leixing == 2
                                ? GestureDetector(
                              onTap: (() {
                                setState(() {});
                              }),
                              child: WidgetUtils.onlyTextCenter(
                                  '赠送全部',
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.roomMessageYellow,
                                      fontSize: ScreenUtil().setSp(28))),
                            )
                                : const Text(''),
                            WidgetUtils.commonSizedBox(0, 20),
                          ],
                        ),

                        /// 展示礼物-经典
                        leixing == 0 ? Expanded(child: SingleChildScrollView(
                          child: OptionGridView(
                            padding: EdgeInsets.fromLTRB(20.h, 20.h, 0, 0),
                            itemCount: listC.length,
                            rowCount: 4,
                            mainAxisSpacing: 10.h,
                            // 上下间距
                            crossAxisSpacing: 0.h,
                            //左右间距
                            itemBuilder: _initlistdata,
                          ),
                        )) : leixing == 1 ?
                        /// 展示礼物-特权
                        Expanded(child: SingleChildScrollView(
                          child: OptionGridView(
                            padding: EdgeInsets.fromLTRB(20.h, 20.h, 0, 0),
                            itemCount: listPV.length,
                            rowCount: 4,
                            mainAxisSpacing: 10.h,
                            // 上下间距
                            crossAxisSpacing: 0.h,
                            //左右间距
                            itemBuilder: _initlistdata,
                          ),
                        )) :
                        /// 展示礼物-背包
                        Expanded(child: SingleChildScrollView(
                          child: OptionGridView(
                            padding: EdgeInsets.fromLTRB(20.h, 20.h, 0, 0),
                            itemCount: listPl.length,
                            rowCount: 4,
                            mainAxisSpacing: 10.h,
                            // 上下间距
                            crossAxisSpacing: 0.h,
                            //左右间距
                            itemBuilder: _initlistdata,
                          ),
                        )),
                        /// 底部送礼
                        Container(
                          height: ScreenUtil().setHeight(100),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 20),
                              Expanded(
                                child: Row(
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_dd.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(24)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyTextCenter(
                                        '10000',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(25))),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_zz.png',
                                        ScreenUtil().setHeight(26),
                                        ScreenUtil().setHeight(24)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyTextCenter(
                                        '100',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(25))),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    Image(
                                      image: const AssetImage(
                                          'assets/images/mine_more.png'),
                                      width: ScreenUtil().setHeight(8),
                                      height: ScreenUtil().setHeight(15),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: ScreenUtil().setHeight(58),
                                width: ScreenUtil().setHeight(250),
                                decoration: const BoxDecoration(
                                  //设置Container修饰
                                  image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/room_liwu_songli.png"),
                                    fit: BoxFit.fill, //覆盖
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: (() {
                                            setState(() {
                                              isTS = !isTS;
                                            });
                                          }),
                                          child: Row(
                                            children: [
                                              const Expanded(child: Text('')),
                                              WidgetUtils.onlyTextCenter(
                                                  shuliang.toString(),
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                      ScreenUtil().setSp(25))),
                                              WidgetUtils.commonSizedBox(0, 10),
                                              WidgetUtils.showImages(
                                                  'assets/images/room_liwu_shang.png',
                                                  ScreenUtil().setHeight(16),
                                                  ScreenUtil().setHeight(9)),
                                              const Expanded(child: Text('')),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: (() {
                                            // eventBus.fire(LiWuShowBack(url: imgUrl, listPeople: listPeople, numbers: numbers));
                                            if(isMaiPeople == false){
                                              setState(() {
                                                listPeople[9] = true;
                                              });
                                              eventBus.fire(ResidentBack(isBack: true));
                                              Navigator.pop(context);
                                              MyUtils.goTransparentPageCom(context, RoomShowLiWuPage(listPeople: listPeople,url: url , svga:svga));
                                            }else{
                                              if(isChoosePeople == false){
                                                MyToastUtils.showToastBottom('请选择要送的对象');
                                                return;
                                              }else{
                                                doPostSendGift();
                                              }
                                            }
                                          }),
                                          child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            color: Colors.transparent,
                                            child: WidgetUtils.onlyTextCenter(
                                                '送礼',
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil().setSp(31))),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              WidgetUtils.commonSizedBox(0, 20),
                            ],
                          ),
                        )
                      ],
                    ),
                    isTS
                        ? Container(
                      height: 450.h,
                      width: 250.h,
                      margin: EdgeInsets.only(right: 30.h, bottom: 90.h),
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 1314;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '1314',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '一生一世',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 666;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '666',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '大吉大利',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 520;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '520',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '我爱你',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 188;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '188',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '要抱抱',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 99;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '99',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '长长久久',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 66;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '66',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '六六大顺',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 10;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '10',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '十全十美',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 5;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '5',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '五福临门',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                shuliang = 1;
                                isTS = false;
                              });
                            }),
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 120.h,
                                    child: WidgetUtils.onlyTextCenter(
                                        '1',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  WidgetUtils.onlyText(
                                      '一心一意',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600)),
                                  WidgetUtils.commonSizedBox(0, 20.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : const Text('')
                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  /// 获取礼物列表
  Future<void> doPostGiftList() async {
    LogE('token ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'type': leixing,
    };
    try {
      liwuBean bean = await DataUtils.postGiftList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(leixing == 0){
              listC.clear();
              listCBool.clear();
              listC = bean.data!;
              for (int i = 0; i < listC.length; i++) {
                listCBool.add(false);
              }
            }else if(leixing == 1){
              listPV.clear();
              listPVBool.clear();
              listPV = bean.data!;
              for (int i = 0; i < listPV.length; i++) {
                listPVBool.add(false);
              }
            }else if(leixing == 2){
              listPl.clear();
              listPlBool.clear();
              listPl = bean.data!;
              for (int i = 0; i < listPl.length; i++) {
                listPlBool.add(false);
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

  List<DataMX> listMaiXu= [];
  /// 房间麦序在线用户
  Future<void> doPostOnlineRoomUser() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID').toString(),
    };
    try {
    onlineRoomUserBean bean = await DataUtils.postOnlineRoomUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listMaiXu.clear();
            for(int i = 0; i < bean.data!.length; i++){
              if(bean.data![i].serialNumber == 9){
                listMaiXu.add(bean.data![i]);
                break;
              }
            }
            for(int i = 0; i < bean.data!.length - 1; i++){
              listMaiXu.add(bean.data![i]);
            }
            changdu = listMaiXu.length;
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

  /// 送礼物
  Future<void> doPostSendGift() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID').toString(),
      'receive_id': sp.getString('roomID').toString(),
      'gift_id': giftId,
      'number': shuliang,
      'gift_type': (leixing+1).toString(),
    };
    try {
      CommonBean bean = await DataUtils.postSendGift(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          eventBus.fire(ResidentBack(isBack: true));
          setState(() {
            for(int i = 0; i < listPeople.length; i++){
              listPeople[i] = false;
            }
            eventBus.fire(ChoosePeopleBack(listPeople: listPeople));
          });
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(context, RoomShowLiWuPage(listPeople: listPeople,url: url, svga:svga));
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

  /// 钱包明细
  Future<void> doPostWalletList() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
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
