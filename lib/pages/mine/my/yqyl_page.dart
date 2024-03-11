import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/my/yqyl_sq_page.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/getShareBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/my_toast_utils.dart';

/// 邀请有礼
class YQYLPage extends StatefulWidget {
  String kefuUid;
  String kefUavatar;

  YQYLPage({super.key, required this.kefuUid, required this.kefUavatar});

  @override
  State<YQYLPage> createState() => _YQYLPageState();
}

class _YQYLPageState extends State<YQYLPage> {
  bool isGet = false;
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('邀请有礼', true, context, false, 0);
    doPostYqApply();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          WidgetUtils.showImagesFill('assets/images/mine_yq_bg1.jpg',
              double.infinity, double.infinity),
          Column(
            children: [
              const Spacer(),
              Container(
                width: double.infinity.h,
                color: Colors.transparent,
                child: Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        Clipboard.setData(ClipboardData(
                          text: shareUrl,
                        ));
                        MyToastUtils.showToastBottom('已成功复制到剪切板');
                      }),
                      child: Container(
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/mine_yq_fx.png', 60.h, 220.h),
                      ),
                    ),
                    (isApply != 1 && isGet)
                        ? WidgetUtils.commonSizedBox(0, 30.h)
                        : const Text(''),
                    (isApply != 1 && isGet)
                        ? GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return YQYLSQPage(
                                    kefuUid: widget.kefuUid,
                                    kefUavatar: widget.kefUavatar,
                                  );
                                })).then((value) {
                                  doPostYqApply();
                                });
                              }
                            }),
                            child: Container(
                              color: Colors.transparent,
                              child: WidgetUtils.showImages(
                                  'assets/images/mine_yq_ks.png', 60.h, 220.h),
                            ),
                          )
                        : const Text(''),
                    const Spacer(),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(120.h, 0),
            ],
          )
        ],
      ),
    );
  }

  String shareUrl = '';
  int isApply = 0; //是否已申请 1是 0否
  /// 获取邀请链接
  Future<void> doPostYqApply() async {
    try {
      getShareBean bean = await DataUtils.postGetShareUrl();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isGet = true;
            isApply = bean.data!.isApply as int;
            shareUrl = bean.data!.url!;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
