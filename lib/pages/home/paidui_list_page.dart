import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bean/fenleiBean.dart';
import '../../bean/tjRoomListBean.dart';
import '../../colors/my_colors.dart';
import '../../utils/SVGASimpleImage3.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

class PaiduiListPage extends StatelessWidget {
  final bool isList;
  //2女厅 3男厅 4新厅 5游戏厅 6交友 7相亲 8点唱
  final int index;
  final String roomType;
  final List<DataPH> list;
  final List<DataFL> listFL;
  final void Function(int? id) action;
  const PaiduiListPage({
    super.key,
    required this.isList,
    required this.index,
    required this.roomType,
    required this.list,
    required this.listFL,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
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
      itemCount: list.length,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final item = list[index];
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
        color: i % 4 == 0 ? MyColors.newY1 : i % 4 == 1 ? MyColors.newY2 : i % 4 == 2 ? MyColors.newY3 : MyColors.newY4,
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
    Color color;
    String img;
    switch (index) {
      case 2:
        color = MyColors.paiduiRed;
        img = 'assets/images/paidui_nvshen.png';
        break;
      case 3:
        color = MyColors.paiduiBlue;
        img = 'assets/images/paidui_nanshen.png';
        break;
      case 4:
        color = MyColors.paiduiOrange;
        img = 'assets/images/paidui_xinting.png';
        break;
      case 5:
        color = MyColors.paiduiPurple;
        img = 'assets/images/paidui_youxi.png';
        break;
      case 6:
        color = MyColors.paiduiXQ;
        img = 'assets/images/paidui_jiaoyou.png';
        break;
      case 7:
        color = MyColors.paiduiXQ;
        img = 'assets/images/paidui_xiangqin.png';
        break;
      case 8:
        color = MyColors.paiduiXQ;
        img = 'assets/images/paidui_dianchang.png';
        break;
      default:
        img = 'assets/images/paidui_dianchang.png';
    }
    double width = index == 5 ? 105.w : 94.w;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Container(
        //   width: width,
        //   height: 30.w,
        //   alignment: Alignment.center,
        //   margin: EdgeInsets.only(left: 8.w),
        //   padding: EdgeInsets.only(left: 14.w),
        //   decoration: BoxDecoration(
        //     color: color,
        //     borderRadius: BorderRadius.all(Radius.circular(15.w)),
        //   ),
        //   child: Text(
        //     roomType,
        //     style: StyleUtils.getCommonTextStyle(
        //         color: Colors.white,
        //         fontSize: ScreenUtil().setSp(18),
        //         fontWeight: FontWeight.w600),
        //   ),
        // ),
        SizedBox(
          width: 72.w,
          height: 30.h,
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage(img),
            width: 72.w,
            height: 30.h
          ),
        ),
      ],
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

  Widget _head(String img) {
    return WidgetUtils.CircleHeadImage(36.w, 36.w, img);
  }

  Widget _headList(List<MemberList> list) {
    return Row(
      children: list
          .map(
            (e) => SizedBox(
              width: 28.w,
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: _head(e.avatar!),
              ),
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
}
