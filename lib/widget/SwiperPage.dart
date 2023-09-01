import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yuyinting/utils/log_util.dart';

///查看大图使用
class SwiperPage extends StatefulWidget {
  List<String> imgList;

  SwiperPage({Key? key, required this.imgList}) : super(key: key);

  @override
  State<SwiperPage> createState() => _SwiperPageState();
}

class _SwiperPageState extends State<SwiperPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogE('接受数据${widget.imgList[0]}');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (() {
          //点击任意地方都能关闭页面，并且不影响你的滑动查看
          Navigator.pop(context);
        }),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
                width: double.infinity,
                child: widget.imgList[index].contains('com.leimu.yuyinting')
                    ? Image.file(
                        File(widget.imgList[index].toString()),
                        fit: BoxFit.fill,
                        gaplessPlayback: true,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/img_placeholder.png',
                        image: widget.imgList[index],
                        fit: BoxFit.contain,
                      ));
          },
          itemCount: widget.imgList.length,
          pagination: const SwiperPagination(), //下面的分页小点
//        control: new SwiperControl(),  //左右的那个箭头,在某模拟器中会出现蓝线
        ),
      ),
    );
  }
}
