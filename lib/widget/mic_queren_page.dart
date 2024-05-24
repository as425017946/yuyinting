import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../bean/roomInfoBean.dart';
import '../colors/my_colors.dart';
import '../main.dart';
import '../utils/event_utils.dart';
import '../utils/style_utils.dart';
/// 开麦确认
class MicPage extends StatefulWidget {
  String title;
  String roomID;
  List<MikeList> listM;
  MicPage({super.key,required this.title, required this.roomID, required this.listM});

  @override
  State<MicPage> createState() => _MicPageState();
}

class _MicPageState extends State<MicPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sp.setString('mic_quren', '1');
  }
  // 默认选中今日不在弹出
  bool  isCheck = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          sp.setString('mic_quren', '0');
          return true;
        },
        child: Center(
          child: Container(
            width: double.infinity,
            height: 300.h,
            margin: EdgeInsets.only(left: 50.h, right: 50.h),
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(
                  Radius.circular(10)),
            ),
            child: Column(
              children: [
                const Spacer(),
                WidgetUtils.onlyTextCenter(widget.title == '邀请上麦' ? '主播正在邀请您上麦，是否允许' : '主播申请打开您的麦克风，是否允许', StyleUtils.getCommonTextStyle(
                    color: MyColors.g2, fontSize: 32.sp, fontWeight: FontWeight.w600)),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                        sp.setString('mic_quren', '0');
                      }),
                      child: Container(
                        width: 200.h,
                        height: 80.h,
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.d8,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                        ),
                        child: WidgetUtils.onlyTextCenter('拒绝', StyleUtils.getCommonTextStyle(color: MyColors.g2, fontSize: 32.sp)),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20.h),
                    GestureDetector(
                      onTap: ((){
                        if(MyUtils.checkClick()){
                          Navigator.pop(context);
                          sp.setString('mic_quren', '0');
                          if(widget.title == '邀请上麦'){
                            eventBus
                                .fire(RoomBack(title: '抱麦', index: sp.getString('user_id').toString()));
                          }else{
                            for (int i = 0; i < widget.listM.length; i++) {
                              if (sp.getString('user_id').toString() ==
                                  widget.listM[i].uid.toString()) {
                                LogE('邀请开麦== ${widget.listM[i].serialNumber!}');
                                eventBus
                                    .fire(RoomBack(title: '开麦1', index: (widget.listM[i].serialNumber! - 1 ).toString()));
                                break;
                              }
                            }

                          }
                        }
                      }),
                      child: Container(
                        width: 200.h,
                        height: 80.h,
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.roomMessageYellow2,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)),
                        ),
                        child: WidgetUtils.onlyTextCenter(widget.title == '邀请上麦' ? '上麦' : '开麦', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 32.sp)),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                WidgetUtils.commonSizedBox(20.h, 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
