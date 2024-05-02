import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:yuyinting/pages/trends/trends_more_page.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../bean/Common_bean.dart';
import '../../bean/DTTuiJianListBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 动态-推荐页面
class TrendsTuiJianPage extends StatefulWidget {
  const TrendsTuiJianPage({super.key});

  @override
  State<TrendsTuiJianPage> createState() => _TrendsTuiJianPageState();
}

class _TrendsTuiJianPageState extends State<TrendsTuiJianPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  String action = 'create';
  int index = 0;
  int length = 1;
  double x = 0, y = 0;

  List<ListTJ> _list = [];
  List<String> imgListUrl = [];
  List<BannerTJ> imgList = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var listen;
  int page = 1;

  void _onRefresh() async {
    _refreshController.resetNoData();
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    if (mounted) {
      setState(() {
        page = 1;
      });
    }
    doPostRecommendList("1");
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {
        page++;
      });
    }
    doPostRecommendList("0");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostRecommendList('1');
    listen = eventBus.on<HiBack>().listen((event) {
      LogE('打招呼回调 == ${event.isBack}');
      LogE('打招呼回调 == ${_list.length}');
      if (event.isBack) {
        //目的是为了有打过招呼的这个人的hi都变成私信按钮
        for (int i = 0; i < _list.length; i++) {
          setState(() {
            if (_list[i].uid.toString() == event.index) {
              _list[i].isHi = 1;
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    listen.cancel();
  }

  _initializeVideoController(List<String> listImg,int i) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: listImg[0],
      thumbnailPath: (await getTemporaryDirectory()).path,
      quality: 30,
    );
    setState(() {
      _list[i].imgUrl![1] = fileName!;
    });
    // LogE('视频图片 $fileName');
  }

  Widget waterCard(BuildContext context, int index){
    if (_list[index].type == 2){
      _initializeVideoController(_list[index].imgUrl!,index);
    }
    final item = _list[index];
    return GestureDetector(
      onTap: ((){
        if(MyUtils.checkClick()){
          MyUtils.goTransparentRFPage(context,
              TrendsMorePage(note_id: _list[index].id.toString(), index: index));
        }
      }),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: const BoxDecoration(
          //背景
          color: MyColors.f7,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          children: [
            if (item.type == 2)
              WidgetUtils.CircleImageNetTop(350.h, 350.w, 30.h, item.imgUrl![1])
            else if (item.imgUrl != null && item.imgUrl!.isNotEmpty)
              WidgetUtils.CircleImageNetTop(350.h, 350.w, 30.h, item.imgUrl![0])
            else
              Image.asset('assets/images/img_placeholder.png', width: 350.w, height: 350.w, fit: BoxFit.fill,),
            
            Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              alignment: Alignment.topLeft,
              child: Text(
                _list[index].text!,
                maxLines: 3,
                style: TextStyle(
                  color: MyColors.newHomeBlack,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(10.h, 0),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 10.w),
                WidgetUtils.CircleHeadImage(
                    25 * 2.w, 25 * 2.w, _list[index].avatar!),
                WidgetUtils.commonSizedBox(0, 10.w),
                WidgetUtils.onlyText(_list[index].nickname!, StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 24.sp,)),
                const Spacer(),
                _list[index].isLike == 0 ?  GestureDetector(
                    onTap:((){
                      doPostLike(_list[index].id.toString(), index);
                    }),
                    child: WidgetUtils.showImages('assets/images/dt_dianzan1.png', 56.h, 115.w))
                : Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      WidgetUtils.showImages('assets/images/trends_zan.png', 30.h, 30.h),
                      WidgetUtils.commonSizedBox(0, 5.w),
                      WidgetUtils.onlyText(_list[index].like.toString(), StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 22.sp,))
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 10.w),
              ],
            ),
            WidgetUtils.commonSizedBox(10.h, 0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: MyUtils.myHeader(),
      footer: MyUtils.myFotter(),
      controller: _refreshController,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          child: MasonryGridView.count(
            // 展示几列
            crossAxisCount: 2,
            // 元素总个数
            itemCount: _list.length,
            // 单个子元素
            itemBuilder: waterCard,
            // 纵向元素间距
            mainAxisSpacing: 15.h,
            // 横向元素间距
            crossAxisSpacing: 10,
            //本身不滚动，让外面的singlescrollview来滚动
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, //收缩，让元素宽度自适应
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  /// 推荐动态列表
  Future<void> doPostRecommendList(is_refresh) async {
    Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'pageSize': MyConfig.pageSize,
      'is_refresh': is_refresh
    };
    try {
      Loading.show(MyConfig.successTitle);
      DTTuiJianListBean bean = await DataUtils.postRecommendList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (page == 1) {
              _list.clear();
            }
            if (bean.data!.banner!.isNotEmpty) {
              imgList.clear();
              imgList = bean.data!.banner!;
            }
            if (bean.data!.list!.isNotEmpty) {
              for (int i = 0; i < bean.data!.list!.length; i++) {
                _list.add(bean.data!.list![i]);
              }
              for (int i = 0; i < _list.length; i++) {
                if (_list[i].type == 2) {
                  _list[i].imgUrl!.add('');
                }
              }
              LogE('推荐${_list.length}');
              length = bean.data!.list!.length;
            } else {
              if (page == 1) {
                length = 0;
              } else {
                if (bean.data!.list!.length < MyConfig.pageSize) {
                  _refreshController.loadNoData();
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 点赞
  Future<void> doPostLike(note_id, index) async {
    LogE('点赞数据$note_id');
    Map<String, dynamic> params = <String, dynamic>{
      'note_id': note_id,
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postLike(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          int a = _list[index].like as int;
          setState(() {
            if (action == 'delete') {
              _list[index].isLike = 0;
              _list[index].like = a - 1;
            } else {
              _list[index].isLike = 1;
              _list[index].like = a + 1;
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
}
