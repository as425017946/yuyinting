import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';

import '../../../bean/homeTJBean.dart';
import '../../../bean/tjRoomListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../utils/SVGASimpleImage3.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../gongping/web_page.dart';
import 'paidui_model.dart';

class PaiduiListPage extends StatelessWidget {
  PaiduiListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaiduiController c = Get.find();
    return Obx(() {
      final page = c.roomListData;
      if (page == null) return const SizedBox.shrink();
      final data = page.data;
      int itemCount = data.length;
      if (itemCount < 0)  return const SizedBox.shrink();
      final listBanner = c.listBanner;
      final isList = c.isList;
      if (isList && listBanner.isNotEmpty) {
        itemCount += 1;
      }
      if (itemCount == 0) return const SizedBox.shrink();
      return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28.w - 10, vertical: 20.w),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isList ? 1 : 2,
          mainAxisSpacing: 24.w,
          crossAxisSpacing: 24.w,
          childAspectRatio: isList ? (694.0 / 160.0) : 1,
        ),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) => _itemBuilder(page.index, data, listBanner, isList, index, c.toRoom),
      );
    });
  }

  Widget _itemBuilder(int type, List<DataPH> data, List<BannerList> listBanner, bool isList, int index, void Function(int? id) action) {
    DataPH? model;
    if (isList && listBanner.isNotEmpty) {
      const num = 2;
      if (index > num) {
        model = data[index - 1];
      } else if (index == min(num, data.length)) {
        return _banner;
      }
    }
    final item = model ?? data[index];
    return GestureDetector(
      onTap: () => action(item.id),
      child: isList ? _tableItem(item, index, type) : _collectItem(item, type),
    );
  }

  Widget _tableItem(DataPH item, int i, int type) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: _getLinearGradient(i),
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // 阴影偏移量
          ),
        ],
      ),
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          _coverImg(item, 130.w),
          SizedBox(width: 26.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetUtils.onlyText(
                  item.roomName!,
                  StyleUtils.getCommonTextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 29.sp,
                  ),
                ),
                const Expanded(child: Text('')),
                Row(
                  children: [
                    _tag(type),
                    SizedBox(width: 18.w),
                    if (type == 5)
                      WidgetUtils.onlyText(
                        item.notice!,
                        StyleUtils.getCommonTextStyle(
                          color: MyColors.paiduiPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(18),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                _tableBottom(item, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getLinearGradient(int i) {
    final List<Color> colors;
    switch (i % 4) {
      case 1:
        colors = [MyColors.newY2, MyColors.newY22];
        break;
      case 2:
        colors = [MyColors.newY3, MyColors.newY33];
        break;
      case 3:
        colors = [MyColors.newY4, MyColors.newY44];
        break;
      default:
        colors = [MyColors.newY1, MyColors.newY11];
    }
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      stops: const [0.0, 1.0],
      colors: colors,
    );
  }

  Widget _collectItem(DataPH item, int type) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
      ),
      child: Stack(
        children: [
          _coverImg(item, double.infinity),
          Positioned(
            top: 5.w,
            left: 5.w,
            child: _tag(type),
          ),
          Positioned(
            top: 5.w,
            right: 10.w,
            child: _hotDegree(item, false),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == 5)
                  WidgetUtils.onlyText(
                    item.notice!,
                    StyleUtils.getCommonTextStyle(
                      color: MyColors.paiduiPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  ),
                Text(
                  item.roomName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 29.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverImg(DataPH item, double size) {
    List<Widget> children = [
      WidgetUtils.CircleImageNet(
        size,
        size,
        15.w,
        item.coverImg!,
      ),
    ];
    if (item.pkStatus == 1) {
      children.add(const SVGASimpleImage3(assetsName: 'assets/svga/pk/room_pk_qj.svga'));
    }
    return SizedBox(
      height: size,
      width: size,
      child: Stack(children: children),
    );
  }

  Widget _tag(int type) {
    String img;
    switch (type) {
      case 2:
        img = 'assets/images/paidui_nvshen.png';
        break;
      case 3:
        img = 'assets/images/paidui_nanshen.png';
        break;
      case 4:
        img = 'assets/images/paidui_xinting.png';
        break;
      case 5:
        img = 'assets/images/paidui_youxi.png';
        break;
      case 6:
        img = 'assets/images/paidui_jiaoyou.png';
        break;
      case 7:
        img = 'assets/images/paidui_xiangqin.png';
        break;
      case 8:
        img = 'assets/images/paidui_dianchang.png';
        break;
      default:
        img = 'assets/images/paidui_dianchang.png';
    }

    return Image(
      image: AssetImage(img),
      width: 111.w * 0.7,
      height: 42.w * 0.7,
    );
  }

  Widget _hotDegree(DataPH item, bool isList) {
    final int hotDegree = item.hotDegree ?? 0;
    final String text = hotDegree > 9999 ? '${(hotDegree / 10000).toStringAsFixed(0)}w' : hotDegree.toString();
    if (isList) {
      return Text(
        '热度值:$text',
        style: TextStyle(fontSize: ScreenUtil().setSp(24), color: MyColors.g6, fontFamily: 'YOUSHEBIAOTIHEI'),
      );
    } else {
      return Row(
        children: [
          Image(
            width: 20.w,
            height: 20.w,
            image: const AssetImage('assets/images/paidui_list_fire.png'),
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(fontSize: ScreenUtil().setSp(24), color: Colors.white, fontFamily: 'YOUSHEBIAOTIHEI'),
          ),
        ],
      );
    }
  }

  Widget _head(String img, {double size = 36}) {
    return WidgetUtils.CircleHeadImage(size.w, size.w, img);
  }

  Widget _headList(List<MemberList> list) {
    return Row(
      children: list
          .map(
            (e) => Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 36.0 / 28.0,
              child: _head(e.avatar!, size: 28),
            ),
          )
          .toList(),
    );
  }

  Widget _tableBottom(DataPH item, bool isList) {
    final List<Widget> children = [
      _headList(item.memberList!),
      const Spacer(),
      _hotDegree(item, isList),
    ];
    if (item.hostInfo!.isNotEmpty) {
      final img = item.hostInfo![1];
      var name = item.hostInfo![0];
      if (name.length > 2) {
        name = '${name.substring(0, 2)}...';
      }
      children.insert(
        0,
        Row(
          children: [
            _head(img),
            Container(
              width: 85.w,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: MyColors.mineGrey,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Row(children: children);
  }

  final _banner = _getListBanner();
}

Widget _getListBanner() {
    final PaiduiController c = Get.find();
    final height = 175.w;
    return Container(
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Obx(() {
        final listBanner = c.listBanner;
        return Swiper(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // 配置图片地址
            return CachedNetworkImage(
              imageUrl: listBanner[index].img!,
              fit: BoxFit.fill,
              placeholder: (context, url) => WidgetUtils.CircleImageAss(
                height,
                double.infinity,
                0,
                'assets/images/img_placeholder.png',
              ),
              errorWidget: (context, url, error) => WidgetUtils.CircleImageAss(
                height,
                double.infinity,
                0,
                'assets/images/img_placeholder.png',
              ),
            );
          },
          // 配置图片数量
          itemCount: listBanner.length,
          // 无限循环
          loop: true,
          // 自动轮播
          autoplay: true,
          autoplayDelay: 5000,
          duration: 2000,
          onIndexChanged: (index) {
            // LogE('用户拖动或者自动播放引起下标改变调用');
          },
          onTap: (index) => c.action(() {
            Get.to(() => WebPage(url: listBanner[index].url!));
          }),
        );
      }),
    );
  }