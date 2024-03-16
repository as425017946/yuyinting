import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../bean/CommonMyIntBean.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../cos/upload_dio.dart';
import '../../cos/upload_httpclient.dart';

/// 实名制上传图片使用
class ShimingzhiImagePage extends StatefulWidget {
  const ShimingzhiImagePage({super.key});

  @override
  State<ShimingzhiImagePage> createState() => _ShimingzhiImagePageState();
}

class _ShimingzhiImagePageState extends State<ShimingzhiImagePage> {
  /// 压缩图片
  void yasuo(String path) async {
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
      "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    }

    _upload(path.toString().contains('.gif') || path.toString().contains('.GIF')
        ? targetPath
        : result!.path, 'image');
  }

  /// 上传  String? _pickFilePath;选择的文件路径
  void _upload(String pickFilePath, String type) async {
    sp.setString('local_path', pickFilePath);
    if (pickFilePath == null) {
      MyToastUtils.showToastBottom('请先选择需要上传的文件');
      return;
    }

    try {
      await UploadHttpClient.upload(pickFilePath!, type, '实名制上传图片使用', (count, total) {
      });
    } catch (e) {
      LogE('上传失败${e.toString()}');
    }
  }

  List<File> imgArray = [];
  var imagesUrl, imagesType;
  String origin_path = '', origin_url = '';

  onTapPickFromGallery() async {
    Navigator.pop(context);
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择照片路径:${image?.path}');

    yasuo(image!.path);
    // doPostPostFileUpload(image!.path);
  }

  onTapPickFromCamera() async {
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    print('照片路径:${imgFile.path}');

    yasuo(imgFile.path);
    // doPostPostFileUpload(imgFile.path);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// 腾讯云上传成功回调
    eventBus.on<TencentBack>().listen((event) {
      if(event.title == '实名制上传图片使用') {
        doPostRoomJoin(event.filePath);
      }
    });
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
        "file": await MultipartFile.fromFile(
          path,
          filename: name,
        )
      },
    );
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token') ?? '';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(MyHttpConfig.fileUpload, data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      if (jsonResponse['code'] == 200) {
        eventBus.fire(
            FileBack(info: path, id: jsonResponse['data'].toString(), type: 0));
        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else if (jsonResponse['code'] == 401) {
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      } else {
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom('上传文件过大！');
    }
  }


  /// 腾讯云id
  Future<void> doPostRoomJoin(String filePath) async {
    String fileType = '';
    if (filePath.contains('.gif') ||
        filePath.contains('.GIF') ||
        filePath.contains('.jpg') ||
        filePath.contains('.JPG') ||
        filePath.contains('.jpeg') ||
        filePath.contains('.GPEG') ||
        filePath.contains('.webp') ||
        filePath.contains('.WEBP') ||
        filePath.contains('.png') ||
        filePath.contains('.png')) {
      fileType = 'image';
    }else if(filePath.contains('.avi') ||
        filePath.contains('.AVI') ||
        filePath.contains('.wmv') ||
        filePath.contains('.WMV') ||
        filePath.contains('.mpeg') ||
        filePath.contains('.MPEG') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4') ||
        filePath.contains('.m4v') ||
        filePath.contains('.M4V')||
        filePath.contains('.mov') ||
        filePath.contains('.MOV') ||
        filePath.contains('.asf') ||
        filePath.contains('.ASF') ||
        filePath.contains('.flv') ||
        filePath.contains('.FLV') ||
        filePath.contains('.f4v') ||
        filePath.contains('.F4V')||
        filePath.contains('.rmvb') ||
        filePath.contains('.RMVB') ||
        filePath.contains('.rm') ||
        filePath.contains('.RM') ||
        filePath.contains('.3gp')||
        filePath.contains('.3GP') ||
        filePath.contains('.vob') ||
        filePath.contains('.VOB')){
      fileType = 'video';
    }else if(filePath.contains('.mp3') ||
        filePath.contains('.MP3') ||
        filePath.contains('.wma') ||
        filePath.contains('.WMA') ||
        filePath.contains('.wav') ||
        filePath.contains('.WAV') ||
        filePath.contains('.flac') ||
        filePath.contains('.FLAC') ||
        filePath.contains('.ogg') ||
        filePath.contains('.OGG')||
        filePath.contains('.aac') ||
        filePath.contains('.AAC') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4') ){
      fileType = 'audio';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'file_type': fileType,
      'file_path': filePath,
    };
    try {
      CommonMyIntBean bean = await DataUtils.postTencentID(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom('上传成功');
          eventBus.fire(FileBack(
              info: sp.getString('local_path').toString(),
              id: bean.data.toString(),
              type: 0));
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
