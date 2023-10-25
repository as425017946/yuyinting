import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../bean/roomBGBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';
import '../../widget/SVGASimpleImage.dart';

/// 我的背景
class RoomBG2Page extends StatefulWidget {
  const RoomBG2Page({super.key});

  @override
  State<RoomBG2Page> createState() => _RoomBG2PageState();
}

class _RoomBG2PageState extends State<RoomBG2Page> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doPostBgList();
  }

  onTapPickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择照片路径:${image?.path}');

    doPostPostFileUpload(image!.path);
  }


  ///收藏使用
  Widget _initlistdata(context, index) {
    LogE('返回下标$index');
    return index == list.length
        ? GestureDetector(
            onTap: (() {
              onTapPickFromGallery();
            }),
            child: Column(
              children: [
                WidgetUtils.showImagesFill('assets/images/room_my_jia.png',
                    ScreenUtil().setHeight(320), ScreenUtil().setHeight(180)),
                WidgetUtils.commonSizedBox(5, 0),
                WidgetUtils.onlyTextCenter(
                    '添加',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.roomTCWZ2,
                        fontSize: ScreenUtil().setSp(28))),
                WidgetUtils.commonSizedBox(15, 0),
              ],
            ),
          )
        : GestureDetector(
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
              '自定义${index + 1}',
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
          itemCount: list.length+1,
          rowCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: _initlistdata,
        ),
      ),
    );
  }


  List<CustomBglist> list = [];

  /// 房间默认背景
  Future<void> doPostBgList() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID').toString(),
    };
    try {
      roomBGBean bean = await DataUtils.postBgList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list.clear();
          setState(() {
            list = bean.data!.customBglist!;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 获取文件url
  Future<void> doPostPostFileUpload(path) async {
    var dir = await path_provider.getTemporaryDirectory();
    String targetPath = '';
    if(path.toString().contains('.gif') || path.toString().contains('.GIF')){
      targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.gif";
    }else{
      targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      path, targetPath,
      quality: 50,
      rotate: 180,
    );
    Loading.show("上传中...");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
      {
        'room_id': sp.getString('roomID').toString(),
        'bg_type': '1',
        "file": await MultipartFile.fromFile(result!.path,
          filename: name,)
      },
    );
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token')??'';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(
          MyHttpConfig.uploadBg,
          data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      if (respone.statusCode == 200) {
        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
      }else if(respone.statusCode == 401){
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      }else{
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }

  }

}
