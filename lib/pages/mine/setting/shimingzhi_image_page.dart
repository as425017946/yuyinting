import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
/// 实名制上传图片使用
class ShimingzhiImagePage extends StatefulWidget {
  const ShimingzhiImagePage({super.key});

  @override
  State<ShimingzhiImagePage> createState() => _ShimingzhiImagePageState();
}

class _ShimingzhiImagePageState extends State<ShimingzhiImagePage> { List<File> imgArray = [];
var imagesUrl, imagesType;
String origin_path = '', origin_url = '';

onTapPickFromGallery() async {
  Navigator.pop(context);
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  print('选择照片路径:${image?.path}');

  doPostPostFileUpload(image!.path);
}

onTapPickFromCamera() async {
  Navigator.pop(context);

  final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
  if (entity == null) return;
  File? imgFile = await entity.file;
  if (imgFile == null) return;
  print('照片路径:${imgFile.path}');



  doPostPostFileUpload(imgFile.path);
}


@override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const Expanded(child: Text('')),
          Container(
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            child: Column(
              children: [
                WidgetUtils.myLine(thickness: 10),
                GestureDetector(
                  onTap: (() {
                    onTapPickFromCamera();
                  }),
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(70),
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        '拍照',
                        style: StyleUtils.getCommonTextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(38)),
                      ),
                    ),
                  ),
                ),
                WidgetUtils.myLine(thickness: 1),
                GestureDetector(
                  onTap: (() {
                    // selectAssets();
                    onTapPickFromGallery();
                  }),
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(70),
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        '从相册选择',
                        style: StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(38),
                        ),
                      ),
                    ),
                  ),
                ),
                WidgetUtils.myLine(thickness: 10),
                GestureDetector(
                  onTap: (() {
                    // selectAssets();
                    Navigator.pop(context);
                  }),
                  child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(70),
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        '取消',
                        style: StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(38),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ));
}

/// 获取文件url
Future<void> doPostPostFileUpload(path) async {
  Loading.show("上传中...");
  var name = path.substring(path.lastIndexOf("/") + 1, path.length);
  FormData formdata = FormData.fromMap(
    {
      'type': 'image',
      "file": await MultipartFile.fromFile(path,
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
        MyHttpConfig.fileUpload,
        data: formdata);
    Map jsonResponse = json.decode(respone.data.toString());
    if (respone.statusCode == 200) {
      eventBus.fire(FileBack(info: path, id: jsonResponse['data'].toString()));
      MyToastUtils.showToastBottom('上传成功');
      Loading.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
