import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../../bean/myHomeBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 礼物墙
class WallPage extends StatefulWidget {
  const WallPage({Key? key}) : super(key: key);

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  var appBar;

  List<AllGiftArr> list_a = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('礼物墙', true, context, false, 0);
    doPostMyIfon();
  }

  ///收藏使用
  Widget _initlistdata(context, index) {
    return Column(
      children: [
        list_a[index].status == 0
            ? Container(
                width: 130.h,
                height: 130.h,
                //超出部分，可裁剪
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75.h),
                ),
                child: CachedNetworkImage(
                  imageUrl: list_a[index].img!,
                  fit: BoxFit.cover,
                  color: Colors.grey,
                  colorBlendMode: BlendMode.color,
                  placeholder: (context, url) => WidgetUtils.CircleImageAss(
                    130.h,
                    130.h,
                    130.h / 2,
                    'assets/images/img_placeholder.png',
                  ),
                  errorWidget: (context, url, error) {
                    // return const Icon(Icons.error);
                    return WidgetUtils.CircleImageAss(
                      130.h,
                      130.h,
                      130.h / 2,
                      'assets/images/img_error.png',
                    );
                  },
                ),
              )
            : WidgetUtils.CircleHeadImage(ScreenUtil().setHeight(130),
                ScreenUtil().setHeight(150), list_a[index].img!),
        WidgetUtils.onlyTextCenter(
            list_a[index].name!,
            StyleUtils.getCommonTextStyle(
                color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
        WidgetUtils.onlyTextCenter(
            'x${list_a[index].count.toString()}',
            StyleUtils.getCommonTextStyle(
                color: MyColors.g6, fontSize: ScreenUtil().setSp(25))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          itemCount: list_a.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10, //设置列间距
            mainAxisSpacing: 10, //设置行间距
            childAspectRatio: 3 / 5,
          ),
          itemBuilder: _initlistdata),
    );
  }

  Future<void> doPostMyIfon() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id')
    };
    try {
      myHomeBean bean = await DataUtils.postMyHome(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_a.clear();
          setState(() {
            if (bean.data!.giftList!.allGiftArr!.isNotEmpty) {
              list_a = bean.data!.giftList!.allGiftArr!;
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
