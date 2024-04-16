import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';

import '../../bean/fenleiBean.dart';
import '../../bean/homeTJBean.dart';
import '../../bean/tjRoomListBean.dart';
import '../../colors/my_colors.dart';
import '../../utils/SVGASimpleImage3.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/web_page.dart';

class PaiduiListPage extends StatelessWidget {
  final bool isList;
  //2女厅 3男厅 4新厅 5游戏厅 6交友 7相亲 8点唱
  final int index;
  final String roomType;
  final List<DataPH> list;
  final List<DataFL> listFL;
  final void Function(int? id) action;
  final List<BannerList> listBanner;
  const PaiduiListPage({
    super.key,
    required this.isList,
    required this.index,
    required this.roomType,
    required this.list,
    required this.listFL,
    required this.action,
    required this.listBanner,
  });

  @override
  Widget build(BuildContext context) {
    int itemCount = list.length;
    if (isList && listBanner.isNotEmpty) {
      itemCount += 1;
    }
    if (itemCount == 0) {
      return const Text('');
    }
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
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    DataPH? model;
    if (isList && listBanner.isNotEmpty) {
      const num = 2;
      if (index > num) {
        model = list[index-1];
      } else if (index == min(num, list.length)) {
        return _banner();
      }  
    }
    final item = model ?? list[index];
    return GestureDetector(
      onTap: () => action(item.id),
      child: isList ? _tableItem(item, index) : _collectItem(item),
    );
  }

  Widget _tableItem(DataPH item, int i) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          //渐变位置
            begin: Alignment.centerRight, //右上
            end: Alignment.centerLeft, //左下
            stops: const [
              0.0,
              1.0
            ], //[渐变起始点, 渐变结束点]
            //渐变颜色[始点颜色, 结束颜色]
            colors: [
              i % 4 == 0
                  ? MyColors.newY1
                  : i % 4 == 1
                  ? MyColors.newY2
                  : i % 4 == 2
                  ? MyColors.newY3
                  : MyColors.newY4,
              i % 4 == 0
                  ? MyColors.newY11
                  : i % 4 == 1
                  ? MyColors.newY22
                  : i % 4 == 2
                  ? MyColors.newY33
                  : MyColors.newY44
            ]),
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
                Row(
                  children: [
                    Expanded(
                      child: WidgetUtils.onlyText(
                        item.roomName!,
                        StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 29.sp,
                        ),
                      ),
                    ),
                    // index == 4
                    //     ? WidgetUtils.showImages(
                    //         'assets/images/room_xinting_tj.png', 30.w, 100.w)
                    //     : const Text('')
                  ],
                ),
                const Expanded(child: Text('')),
                Row(
                  children: [
                    _tag(),
                    SizedBox(width: 18.w),
                    index == 5
                        ? WidgetUtils.onlyText(
                            item.notice!,
                            StyleUtils.getCommonTextStyle(
                              color: MyColors.paiduiPurple,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(18),
                            ),
                          )
                        : const Text('')
                  ],
                ),
                const Expanded(child: Text('')),
                _tableBottom(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectItem(DataPH item) {
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
            child: _tag(),
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: index == 4
          //       ? WidgetUtils.showImages(
          //           'assets/images/room_xinting_tj.png', 30.w, 100.w)
          //       : const Text(''),
          // ),
          Positioned(
            top: 5.w,
            right: 10.w,
            child: _hotDegree(item),
          ),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 5)
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
      children.add(
          const SVGASimpleImage3(assetsName: 'assets/svga/pk/room_pk_qj.svga'));
    }
    return SizedBox(
      height: size,
      width: size,
      child: Stack(children: children),
    );
  }

  Widget _tag() {
    String img;
    switch (index) {
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
      width: 111.w*0.7,
      height: 42.w*0.7,
    );
  }

  Widget _hotDegree(DataPH item) {
    final int hotDegree = item.hotDegree ?? 0;
    final String text = hotDegree > 9999
        ? '${(hotDegree / 10000).toStringAsFixed(0)}w'
        : hotDegree.toString();
    if (isList) {
      return Text(
        '热度值:$text',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(24),
            color: MyColors.g6,
            fontFamily: 'YOUSHEBIAOTIHEI'),
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
            style: TextStyle(
                fontSize: ScreenUtil().setSp(24),
                color: Colors.white,
                fontFamily: 'YOUSHEBIAOTIHEI'),
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
            // (e) => SizedBox(
            //   width: 28.w,
            //   child: UnconstrainedBox(
            //     alignment: Alignment.centerLeft,
            //     child: _head(e.avatar!),
            //   ),
            // ),
            (e) => Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 36.0 / 28.0,
              child: _head(e.avatar!, size: 28),
            ),
          )
          .toList(),
    );
  }

  Widget _tableBottom(DataPH item) {
    final List<Widget> children = [
      _headList(item.memberList!),
      const Spacer(),
      _hotDegree(item),
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

  Widget _banner() {
    final height = 140*1.25.w;
    return Container(
      height: height,
      //超出部分，可裁剪
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Swiper(
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
        onTap: (index) {
          if (MyUtils.checkClick()) {
            Get.to(() => WebPage(url: listBanner[index].url!));
          }
        },
      ),
    );
  }

}
