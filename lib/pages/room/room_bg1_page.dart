import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import '../../config/my_config.dart';
import '../../widget/SVGASimpleImage.dart';

import '../../bean/roomBGBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';

/// 默认背景
class RoomBG1Page extends StatefulWidget {
  const RoomBG1Page({super.key});

  @override
  State<RoomBG1Page> createState() => _RoomBG1PageState();
}

class _RoomBG1PageState extends State<RoomBG1Page> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostBgList();
  }

  ///默认背景图
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          list[index].type = 1;
          for(int i = 0; i < list.length; i++){
            if(index != i) {
              list[i].type = 0;
            }
          }
          eventBus.fire(RoomBGBack(bgID: list[index].bgId.toString(), bgType: list[index].bgType.toString(), bgImagUrl: list[index].img.toString()));
        });
      }),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              list[index].bgType == 1
                  ? WidgetUtils.CircleImageNet(ScreenUtil().setHeight(320),
                      ScreenUtil().setHeight(180), 20.0, list[index].img!)
                  : Container(
                      height: 320.h,
                      width: 180.h,
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      //边框设置
                      decoration: const BoxDecoration(
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: SVGASimpleImage(
                        resUrl: list[index].img!,

                      ),
                    ),
              list[index].type == 1
                  ? WidgetUtils.showImagesFill('assets/images/room_bg_xzk.png',
                      ScreenUtil().setHeight(320), ScreenUtil().setHeight(180))
                  : const Text(''),
            ],
          ),
          WidgetUtils.commonSizedBox(5, 0),
          WidgetUtils.onlyTextCenter(
              '默认${index + 1}',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(28))),
          WidgetUtils.commonSizedBox(15, 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: OptionGridView(
          itemCount: list.length,
          rowCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: _initlistdata,
        ),
      ),
    );
  }

  List<DefaultBgList> list = [];

  /// 房间默认背景
  Future<void> doPostBgList() async {
    LogE('用户token${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID').toString(),
    };
    try {
      roomBGBean bean = await DataUtils.postBgList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list.clear();
          setState(() {
            list = bean.data!.defaultBgList!;
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
}
