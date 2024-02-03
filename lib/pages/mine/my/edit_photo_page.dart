import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;



class EditPhotoPage extends StatefulWidget {
  int length;
  EditPhotoPage({super.key, required this.length});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  List<File> imgArray = [];
  var imagesUrl, imagesType;
  String origin_path = '', origin_url = '';
  List<AssetEntity> selectAss = [];
  onTapPickFromGallery() async {
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            maxAssets: widget.length, requestType: RequestType.image,
        selectedAssets: selectAss),);

    selectAss = entitys!;

    if (entitys == null) return;

    doPostPostFileUpload2(entitys);
    // final ImagePicker _picker = ImagePicker();
    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // print('选择照片路径:${image?.path}');

  }

  onTapPickFromCamera() async {
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    print('照片路径:${imgFile.path}');

    selectAss.add(entity);

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
                  Container(
                    height: ScreenUtil().setHeight(540),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    child: WidgetUtils.showImages(
                        'assets/images/mine_head_shili.png',
                        ScreenUtil().setHeight(520),
                        double.infinity),
                  ),
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
    var dir = await path_provider.getTemporaryDirectory();
    String targetPath = '';
    var result;
    if (path.toString().contains('.gif') || path.toString().contains('.GIF')) {
      targetPath = path;
    } else if (path.toString().contains('.jpg') ||
        path.toString().contains('.GPG')) {
      targetPath =
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.jpeg') ||
        path.toString().contains('.GPEG')) {
      targetPath =
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (path.toString().contains('.svga') ||
        path.toString().contains('.SVGA')) {
      MyToastUtils.showToastBottom('不支持svga格式图片上传');
      return;
    } else if (path.toString().contains('.webp') ||
        path.toString().contains('.WEBP')) {
      targetPath =
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.webp";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else {
      targetPath =
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.png";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    }
    Loading.show("上传中...");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap(
      {
        'type': 'image',
        "file": await MultipartFile.fromFile(path.contains('.gif') || path.toString().contains('.GIF') ? targetPath : result!.path ,
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
      if (jsonResponse['code'] == 200) {
        eventBus.fire(PhotoBack(selectAss: selectAss, id: jsonResponse['data'].toString()));
        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }else if(jsonResponse['code'] == 401){
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      }else{
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }

  }

  /// 获取文件url
  Future<void> doPostPostFileUpload2(List<AssetEntity> lists) async {
    Loading.show("上传中...");
    String id = '';
    for (int i = 0; i < lists.length; i++) {
      File? imgFile = await lists[i].file;
      var dir = await path_provider.getTemporaryDirectory();
      String targetPath = '';
      var result;
      if (imgFile!.path.toString().contains('.gif') || imgFile!.path.toString().contains('.GIF')) {
        targetPath = imgFile!.path;
      } else if (imgFile!.path.toString().contains('.jpg') ||
          imgFile!.path.toString().contains('.GPG')) {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      } else if (imgFile!.path.toString().contains('.jpeg') ||
          imgFile!.path.toString().contains('.GPEG')) {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      } else if (imgFile!.path.toString().contains('.svga') ||
          imgFile!.path.toString().contains('.SVGA')) {
        MyToastUtils.showToastBottom('不支持svga格式图片上传');
        return;
      } else if (imgFile!.path.toString().contains('.webp') ||
          imgFile!.path.toString().contains('.WEBP')) {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.webp";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      } else {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.png";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      }
      var name = imgFile!.path.substring(imgFile!.path.lastIndexOf("/") + 1, imgFile!.path.length);
      FormData formdata = FormData.fromMap(
        {
          'type': 'image',
          "file": await MultipartFile.fromFile(result!.path,
            filename: name,)
        },
      );
      BaseOptions option = BaseOptions(
          contentType: 'multipart/form-data', responseType: ResponseType.plain);
      option.headers["Authorization"] = sp.getString('user_token') ?? '';
      Dio dio = Dio(option);
      //application/json
      try {
        var respone = await dio.post(
            MyHttpConfig.fileUpload,
            data: formdata);
        Map jsonResponse = json.decode(respone.data.toString());

        LogE('上传id$id');
        if (jsonResponse['code'] == 200) {
          if(id.isEmpty){
            id = jsonResponse['data'].toString();
          }else{
            id = '$id,${jsonResponse['data'].toString()}';
          }
          if(i == lists.length - 1){
            eventBus.fire(PhotoBack(
                selectAss: lists, id: id));
            MyToastUtils.showToastBottom('上传成功');
            Loading.dismiss();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        } else if (jsonResponse['code'] == 401) {
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
        } else {
          MyToastUtils.showToastBottom(jsonResponse['msg']);
        }
      } catch (e) {
        Loading.dismiss();
        // MyToastUtils.showToastBottom(MyConfig.errorTitle);
      }
    }

  }

}