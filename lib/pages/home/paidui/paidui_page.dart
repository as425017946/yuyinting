import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../bean/fenleiBean.dart';
import '../../../colors/my_colors.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import 'paidui_list_page.dart';
import 'paidui_model.dart';

class PaiduiPage extends StatefulWidget {
  const PaiduiPage({Key? key}) : super(key: key);
  @override
  State<PaiduiPage> createState() => _PaiduiPageState();
}

class _PaiduiPageState extends State<PaiduiPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => PaiduiController());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _Content();
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PaiduiController c = Get.find();
    final child = _content(c);
    return Obx(() => SmartRefresher(
          header: MyUtils.myHeader(),
          footer: MyUtils.myFotter(),
          controller: c.refreshController,
          enablePullUp: c.canRefresh,
          enablePullDown: c.canRefresh,
          onLoading: c.onLoading,
          onRefresh: c.onRefresh,
          child: child,
        ));
  }

  final _rmtj = _Rmtj();
  Widget _content(PaiduiController c) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _rmtj,
            c.happyWall,
            SizedBox(height: 20.w),
            _tabs(c),
            _roomList,
          ],
        ),
      ),
    );
  }

  final _roomList = PaiduiListPage();

  Widget _tabs(PaiduiController c) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(
              () => Row(
                children: c.listFL.map((element) => _tabItem(element, c)).toList(),
              ),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        _tabListType(c),
      ],
    );
  }

  Widget _tabItem(DataFL item, PaiduiController c) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GestureDetector(
        onTap: () => c.onTab(item),
        child: Obx(() {
          final isSelect = item.type == c.tabSelect?.type;
          return Container(
            width: 105.w,
            height: 50.w,
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isSelect)
                  const Image(
                    width: double.infinity,
                    height: double.infinity,
                    image: AssetImage('assets/images/paidui_title_bg.png'),
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                Text(
                  item.title ?? '',
                  style: StyleUtils.getCommonTextStyle(
                    color: isSelect ? MyColors.newHomeBlack : MyColors.g6,
                    fontSize: isSelect ? 36.sp : 30.sp,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _tabListType(PaiduiController c) {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: GestureDetector(
        onTap: c.onIsList,
        child: Obx(
          () => SizedBox(
            width: 40.w,
            height: 40.w,
            child: Image(
              image: AssetImage(c.listType),
            ),
          ),
        ),
      ),
    );
  }
}

class _Rmtj extends StatelessWidget {
  final PaiduiController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        child: Row(
          children: [
            Obx(() => _rmSwiper(218, c.listRoom2)),
            const SizedBox(width: 16),

            ///热门推荐第一个大的轮播图
            Obx(() => _rmSwiper(280, c.listRoom)),
            const SizedBox(width: 16),
            Obx(() => _rmSwiper(218, c.listRoom3)),
          ],
        ),
      ),
    );
  }

  Widget _rmSwiper(double size, List<dynamic> list) {
    if (list.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
      );
    } else {
      return Container(
        width: size,
        height: size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
        ),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            // 配置图片地址
            final String roomName = list[index].roomName;
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                FadeInImage.assetNetwork(
                  width: size,
                  height: size,
                  placeholder: 'assets/images/img_placeholder.png',
                  image: list[index].coverImg!,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    // 图片加载错误后展示的 widget
                    // print("---图片加载错误---");
                    // 此处不能 setState
                    return const Image(
                      image: AssetImage('assets/images/img_placeholder.png'),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            );
          },
          // 配置图片数量
          itemCount: list.length,
          // 无限循环
          loop: true,
          // 自动轮播
          autoplay: true,
          autoplayDelay: 4000,
          duration: 2500,
          onIndexChanged: (index) {},
          onTap: (index) => c.toRoom(int.parse(list[index].id)),
        ),
      );
    }
  }
}
