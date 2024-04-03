import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../../bean/CommonMyIntBean.dart';
import '../../../http/data_utils.dart';
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
import 'package:path/path.dart' as path;
import '../../cos/upload_httpclient.dart';
/// 照片墙
class EditPhotoPage extends StatefulWidget {
  int length;

  EditPhotoPage({super.key, required this.length});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  // 记录上传次数
  int sum = 0;
  // 记录本次上传多少
  int imgLength = 0;
  List<File> imgArray = [];
  var imagesUrl, imagesType;
  String origin_path = '', origin_url = '';
  List<AssetEntity> selectAss = [];

  onTapPickFromGallery() async {
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
          maxAssets: widget.length,
          requestType: RequestType.image,
          selectedAssets: selectAss),
    );

    selectAss = entitys!;

    if (entitys == null) return;
    yasuo2(entitys);
    // doPostPostFileUpload2(entitys);
  }

  onTapPickFromCamera() async {
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    print('照片路径:${imgFile.path}');

    selectAss.add(entity);

    yasuo(imgFile.path);
    // doPostPostFileUpload(imgFile.path);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// 腾讯云上传成功回调
    eventBus.on<TencentBack>().listen((event) {
      // LogE('头像上传成功***** ${event.filePath}');
      if(event.title == '照片墙'){
        doPostRoomJoin(event.filePath,0);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Loading.dismiss();
        return true;
      },
      child: Scaffold(
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
          )),
    );
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
          "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
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
        "file": await MultipartFile.fromFile(
          path.contains('.gif') || path.toString().contains('.GIF')
              ? targetPath
              : result!.path,
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
        eventBus.fire(PhotoBack(
            selectAss: selectAss, id: jsonResponse['data'].toString()));
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
      if (imgFile!.path.toString().contains('.gif') ||
          imgFile!.path.toString().contains('.GIF')) {
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
            "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      }
      var name = imgFile!.path
          .substring(imgFile!.path.lastIndexOf("/") + 1, imgFile!.path.length);
      FormData formdata = FormData.fromMap(
        {
          'type': 'image',
          "file": await MultipartFile.fromFile(
            imgFile!.path.toString().contains('.gif') ||
                    imgFile!.path.toString().contains('.GIF')
                ? targetPath
                : result!.path,
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

        LogE('上传id$id');
        if (jsonResponse['code'] == 200) {
          if (id.isEmpty) {
            id = jsonResponse['data'].toString();
          } else {
            id = '$id,${jsonResponse['data'].toString()}';
          }
          if (i == lists.length - 1) {
            eventBus.fire(PhotoBack(selectAss: lists, id: id));
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

  Future<void> yasuo2(List<AssetEntity> lists) async {
    // setState(() {
    //   imgLength = lists.length;
    // });
    // Loading.show("上传中...");
    for (int i = 0; i < lists.length; i++) {
      File? imgFile = await lists[i].file;
      var dir = await path_provider.getTemporaryDirectory();
      String targetPath = '';
      var result;
      if (imgFile!.path.toString().contains('.gif') ||
          imgFile!.path.toString().contains('.GIF')) {
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
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
      }

      // 获取直传签名等信息
      String ext = path.extension(imgFile!.path.toString().contains('.gif') ||
          imgFile!.path.toString().contains('.GIF')
          ? targetPath
          : result!.path).substring(1);
      Map<String, dynamic> directTransferData;
      try {
        directTransferData = await _getStsDirectSign(ext);
      } catch (err) {
        throw Exception("getStsDirectSign fail");
      }
      Loading.show('上传中...');
      String cosHost = directTransferData['cosHost'];
      String cosKey = directTransferData['cosKey'];
      String authorization = directTransferData['authorization'];
      String securityToken = directTransferData['sessionToken'];
      String url = 'https://$cosHost/$cosKey';
      File file = File(imgFile!.path.toString().contains('.gif') ||
          imgFile!.path.toString().contains('.GIF')
          ? targetPath
          : result!.path);
      int fileSize = await file.length();
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'application/octet-stream');
      request.headers.set('Content-Length', fileSize.toString());
      request.headers.set('Authorization', authorization);
      request.headers.set('x-cos-security-token', securityToken);
      request.headers.set('Host', cosHost);
      request.contentLength = fileSize;
      Stream<List<int>> stream = file.openRead();
      int bytesSent = 0;
      stream.listen(
            (List<int> chunk) {
          bytesSent += chunk.length;
          double progress = bytesSent / fileSize;
          print('Progress: ${progress.toStringAsFixed(2)}');
          request.add(chunk);
        },
        onDone: () async {
          HttpClientResponse response = await request.close();
          LogE('上传状态 ${response.statusCode}');
          if (response.statusCode == 200) {
            doPostRoomJoin(cosKey,i);
          } else {
            Loading.dismiss();
            throw Exception("上传失败 $response");
          }
        },
        onError: (error) {
          Loading.dismiss();
          throw Exception("上传失败 ${error.toString()}");
        },
        cancelOnError: true,
      );
    }
  }

  /// 上传  String? _pickFilePath;选择的文件路径
  void _upload(String pickFilePath, String type) async {
    sp.setString('local_path', pickFilePath);
    if (pickFilePath == null) {
      MyToastUtils.showToastBottom('请先选择需要上传的文件');
      return;
    }
    try {
      print("使用原生http client库上传");
      await UploadHttpClient.upload(pickFilePath!, type, '照片墙', (count, total) {
      });
    } catch (e) {
      LogE('上传失败${e.toString()}');
    }
  }

  /// 腾讯云id
  String TXid = '';
  Future<void> doPostRoomJoin(String filePath,int i) async {
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
          if (TXid.isEmpty) {
            TXid = bean.data.toString();
          } else {
            TXid = '$TXid,${bean.data.toString()}';
          }
          if (i == selectAss.length - 1) {
            eventBus.fire(PhotoBack(selectAss: selectAss, id: TXid));
            MyToastUtils.showToastBottom('上传成功');
            Loading.dismiss();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
          // MyToastUtils.showToastBottom('头像上传成功');
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

  /// 获取直传的url和签名等
  /// @param ext 文件后缀 直传后端会根据后缀生成cos key
  /// @return 直传url和签名等
  static Future<Map<String, dynamic>> _getStsDirectSign(String ext) async {
    HttpClient httpClient = HttpClient();
    //直传签名业务服务端url（正式环境 请替换成正式的直传签名业务url）
    //直传签名业务服务端代码示例可以参考：https://github.com/tencentyun/cos-demo/blob/main/server/direct-sign/nodejs/app.js
    //10.91.22.16为直传签名业务服务器的地址 例如上述node服务，总之就是访问到直传签名业务服务器的url
    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${MyHttpConfig.baseURL}/upload/uploadCos?type=image&ext=$ext"));
    // 添加 header 头信息
    request.headers.add("Content-Type", "application/json"); // 例如，设置 Content-Type 为 application/json
    request.headers.add("Authorization", sp.getString('user_token') ?? ''); // 例如，设置 Authorization 头
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(responseBody);
      print(json);
      // LogE('上传地址== ${json['data']['cosKey']}');
      // LogE('上传地址request_id== ${json['data']['request_id']}');
      // LogE('上传地址cosHost== ${json['data']['cosHost']}');
      // LogE('上传地址cosKey== ${json['data']['cosKey']}');
      httpClient.close();
      if (json['code'] == 200) {
        return json['data'];
      } else {
        throw Exception(
            'getStsDirectSign error code: ${json['code']}, error message: ${json['message']}');
      }
    } else {
      httpClient.close();
      throw Exception(
          'getStsDirectSign HTTP error code: ${response.statusCode}');
    }
  }
}
