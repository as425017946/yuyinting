import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/utils/loading.dart';

import '../../bean/CommonMyIntBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';

enum _UploadType {
  image,
  video,
  audio;
  @override
  String toString() {
    switch (this) {
      case _UploadType.image:
        return 'image';
      case _UploadType.video:
        return 'video';
      case _UploadType.audio:
        return 'audio';
    }
  }
}

typedef ProgressCallback = void Function(int count, int total);
typedef FinishCallback = void Function(bool success, String data);

class CPAssetsPicker {
  void onTapVideoFromGallery(void Function(String id, File file) finish) async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 15),
    );
    if (pickedFile == null) return;
    final filePath = pickedFile.path;
    _upload(filePath, _UploadType.video, (id) { 
      finish(id, File(filePath));
    });
  }

  void onTapPickFromGallery(int maxAssets, void Function(List<String> ids, List<File> files) finish) async {
    final context = Get.context;
    if (context == null) return;
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context, pickerConfig: AssetPickerConfig(maxAssets: maxAssets, requestType: RequestType.image));
    if (entitys == null) return;
    List<File> files = [];
    List<String> pickFilePaths = [];
    for (var entity in entitys) {
      File? imgFile = await entity.file;
      if (imgFile == null) continue;
      try {
        final pickFilePath = await zip(imgFile.path);
        pickFilePaths.add(pickFilePath);
        files.add(imgFile);
      } catch (e) {
        Get.log(e.toString());
      }
    }
    _uploadList(pickFilePaths, _UploadType.image, (ids) {
      if (ids.contains('')) {
        for (var i = 0; i < ids.length; i++) {
          if (ids[i].isEmpty) files[i] = File('');
        }
        ids.removeWhere((element) => element.isEmpty);
        files.removeWhere((element) => element.path.isEmpty);
      }
      finish(ids, files);
    });
  }

  void onTapPickFromCamera(void Function(String id, File file) finish) async {
    final context = Get.context;
    if (context == null) return;
    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    final pickFilePath = await zip(imgFile.path);
    _upload(pickFilePath, _UploadType.image, (id) { 
      finish(id, imgFile);
    });
  }

  Future<String> zip(String path) async {
    var dir = await path_provider.getTemporaryDirectory();

    final String ext;
    final lower = path.toLowerCase();
    if (lower.endsWith('.gif')) {
      return path;
    } else if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp')) {
      ext = lower.split('.').last;
    } else if (lower.endsWith('.svga')) {
      MyToastUtils.showToastBottom('不支持svga格式图片上传');
      throw '不支持svga格式图片上传';
    } else {
      ext = 'jpg';
    }

    final targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.$ext";
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      targetPath,
      quality: 50,
      rotate: 0, // 旋转角度
    );
    if (result == null) {
      MyToastUtils.showToastBottom('图片路径获取失败');
      throw '图片路径获取失败';
    }
    return result.path;
  }

  /// 上传
  void _upload(String pickFilePath, _UploadType type, void Function(String id) finish) {
    if (pickFilePath.isEmpty) {
      MyToastUtils.showToastBottom('请先选择需要上传的文件');
      return;
    }
    try {
      Loading.show("上传中...");
      upload(pickFilePath, type.toString(), (success, data) {
        Loading.dismiss();
        if (success) {
          finish(data);
        } else {
          MyToastUtils.showToastBottom(data);
        }
      });
    } catch (e) {
      Loading.dismiss();
    }
  }
  void _uploadList(List<String> pickFilePaths, _UploadType type, void Function(List<String> ids) finish) {
    if (pickFilePaths.isEmpty) {
      MyToastUtils.showToastBottom('请先选择需要上传的文件');
      return;
    }
    try {
      Loading.show("上传中...");
      List<String> ids = [];
      for (var pickFilePath in pickFilePaths) {
        upload(pickFilePath, type.toString(), (success, data) {
          if (success) {
            ids.add(data);
          } else {
            ids.add('');
            MyToastUtils.showToastBottom(data);
          }
          if (ids.length == pickFilePaths.length) {
            Loading.dismiss();
            finish(ids);
          }
        });
      }
    } catch (e) {
      Loading.dismiss();
    }
  }

  void upload(String filePath, String type, FinishCallback finish, [ProgressCallback? progressCallback]) async {
    // 获取直传签名等信息
    String ext = path.extension(filePath).substring(1);
    Map<String, dynamic> directTransferData;
    try {
      directTransferData = await _getStsDirectSign(ext, type);
    } catch (err) {
      throw Exception("getStsDirectSign fail");
    }
    String cosHost = directTransferData['cosHost'];
    String cosKey = directTransferData['cosKey'];
    String authorization = directTransferData['authorization'];
    String securityToken = directTransferData['sessionToken'];
    String url = 'https://$cosHost/$cosKey';
    File file = File(filePath);
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
        Get.log('Progress: ${progress.toStringAsFixed(2)}');
        if (progressCallback != null) {
          progressCallback(bytesSent, fileSize);
        }
        request.add(chunk);
      },
      onDone: () async {
        try {
          HttpClientResponse response = await request.close();
          Get.log('上传状态 ${response.statusCode}');
          if (response.statusCode == 200) {
            String id = await doPostRoomJoin(cosKey, type);
            finish(true, id);
            Get.log('上传成功');
          } else {
            throw Exception("上传失败 $response");
          }
        } catch (e) {
          finish(false, '上传失败');
        }
      },
      onError: (error) {
        finish(false, '上传失败');
        Get.log('上传失败 ${error.toString()}');
      },
      cancelOnError: true,
    );
  }
  /// 获取直传的url和签名等
  Future<Map<String, dynamic>> _getStsDirectSign(String ext, String type) async {
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse("${MyHttpConfig.baseURL}/upload/uploadCos?type=$type&ext=$ext")); // 添加 header 头信息
    request.headers.add("Content-Type", "application/json"); // 例如，设置 Content-Type 为 application/json
    request.headers.add("Authorization", sp.getString('user_token') ?? ''); // 例如，设置 Authorization 头
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      Get.log(responseBody);
      Map<String, dynamic> json = jsonDecode(responseBody);
      httpClient.close();
      if (json['code'] == 200) {
        return json['data'];
      } else {
        throw Exception('getStsDirectSign error code: ${json['code']}, error message: ${json['message']}');
      }
    } else {
      httpClient.close();
      throw Exception('getStsDirectSign HTTP error code: ${response.statusCode}');
    }
  }

  /// 腾讯云id
  Future<String> doPostRoomJoin(String filePath, String fileType) async {
    Map<String, dynamic> params = <String, dynamic>{
      'file_type': fileType,
      'file_path': filePath,
    };
    CommonMyIntBean bean = await DataUtils.postTencentID(params);
    switch (bean.code) {
      case MyHttpConfig.successCode:
        return bean.data.toString();
      case MyHttpConfig.errorloginCode:
        final context = Get.context;
        if (context != null) {
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
        }
        throw '未登录';
      default:
        MyToastUtils.showToastBottom(bean.msg!);
        throw bean.msg!;
    }
  }
}