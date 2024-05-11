import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../utils/my_toast_utils.dart';
import 'makefriends_model.dart';

mixin CPAssetsPicker {
  void zip(String path) async {
    var dir = await path_provider.getTemporaryDirectory();
    
    final String targetPath;
    var result;
    final lower = path.toLowerCase();
    if (lower.endsWith('.gif')) {
      targetPath = path;
    } else if (lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.webp')) {
      targetPath = "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.${lower.split('.').last}";
      result = await FlutterImageCompress.compressAndGetFile(
        path, targetPath,
        quality: 50,
        rotate: 0, // 旋转角度
      );
    } else if (lower.endsWith('.svga')) {
      MyToastUtils.showToastBottom('不支持svga格式图片上传');
      return;
    }

    if(type == 0){
      if (path.toString().contains('.gif') || path.toString().contains('.GIF')) {
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
    }else{
      _upload(path, 'video');
    }
}

class CPPickSheet extends StatelessWidget {
  final MakefriendsController c = Get.find();

  CPPickSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(30.w);
    final line = SizedBox(height: 5.h);
    return Container(
      width: double.infinity,
      height: Get.bottomBarHeight + 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _btn('拍  照', () { }),
          line,
          _btn('相  册', () { }),
          line,
          _btn('视  频', () { }),
        ],
      ),
    );
  }

  Widget _btn(String title, void Function() action) {
    return GestureDetector(
      onTap: () => c.action(action),
      child: Container(
        width: double.infinity,
        height: 60.h,
        color: Colors.white,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26.h,
            ),
          ),
        ),
      ),
    );
  }

    onTapPickFromGallery() async {
      final context = Get.context!;
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context, pickerConfig: const AssetPickerConfig(maxAssets: 1, requestType: RequestType.image));
    if (entitys == null) return;
    // setState(() {
    //   videoId = '';
    //   selectAss = entitys!;
    // });
    List<String> chooseImagesPath = [];
    //遍历
    for (var entity in entitys) {
      File? imgFile = await entity.file;
      print('照片路径****:${imgFile!.path}');
      if (imgFile != null) chooseImagesPath.add(imgFile.path);
      // setState(() {
      //   imgArray.add(imgFile!);
      // });
    }

    yasuo(entitys.first.file);
    // doPostPostFileUpload2(entitys);
    // print('选择照片路径:$chooseImagesPath');
  }

  VideoPlayerController? _videoController;
  bool _isVideoSelected = false;
  onTapVideoFromGallery() async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 15),
    );
    if (pickedFile == null) return;
    if (pickedFile != null) {
      _videoController = VideoPlayerController.file(File(pickedFile.path));
      await _videoController!.initialize();
      setState(() {
        videoUrl = pickedFile.path;
        _isVideoSelected = true;
        imgArray.clear();
      });
    }

    yasuo(pickedFile.path);
    // doPostPostFileUpload(pickedFile.path);
  }

  onTapPickFromCamera() async {
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    setState(() {
      videoId = '';
    });
    print('照片路径:${imgFile.path}');
    setState(() {
      imgArray.add(imgFile!);
      selectAss.add(entity);
    });

    yasuo(imgFile.path);
    // doPostPostFileUpload(imgFile.path);
  }

    void yasuo(String path) async {
    if(type == 0){

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
    }else{
      _upload(path, 'video');
    }
  }
}
