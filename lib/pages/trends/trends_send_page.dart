import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/bean/Common_bean.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/CommonMyIntBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../utils/my_utils.dart';
import 'package:video_player/video_player.dart';

import 'package:path/path.dart' as path;
import '../cos/upload_httpclient.dart';
import 'PagePreviewVideo.dart';

///发布动态页面
class TrendsSendPage extends StatefulWidget {
  const TrendsSendPage({Key? key}) : super(key: key);

  @override
  State<TrendsSendPage> createState() => _TrendsSendPageState();
}

class _TrendsSendPageState extends State<TrendsSendPage> {
  TextEditingController controller = TextEditingController();
  List<File> imgArray = [];
  int type = 0; // 0 图片 1 视频
  List<AssetEntity> selectAss = [];
  String imgID = '', videoId = '', videoUrl = '';
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// 腾讯云上传成功回调
    listen = eventBus.on<TencentBack>().listen((event) {
      LogE('头像上传成功***** ${event.filePath}');
      if(event.title == '发布动态页面') {
        doPostRoomJoin(event.filePath, 0);
      }
    });
  }

  _showSheetAction() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
            height: 120,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 0;
                      });
                      onTapPickFromCamera();
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(60),
                      color: Colors.white,
                      child: const Center(
                        child: Text('拍照'),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 5,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 0;
                      });
                      onTapPickFromGallery(6-imgArray.length);
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(60),
                      color: Colors.white,
                      child: const Center(
                        child: Text('相册'),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 5,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        type = 1;
                      });
                      onTapVideoFromGallery();
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(60),
                      color: Colors.white,
                      child: const Center(
                        child: Text('视频'),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  onTapPickFromGallery(int num) async {
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context,
        pickerConfig: AssetPickerConfig(
            maxAssets: num, requestType: RequestType.image));
    if (entitys == null) return;
    setState(() {
      videoId = '';
      selectAss = entitys!;
    });
    List<String> chooseImagesPath = [];
    //遍历
    for (var entity in entitys) {
      File? imgFile = await entity.file;
      print('照片路径****:${imgFile!.path}');
      if (imgFile != null) chooseImagesPath.add(imgFile.path);
      setState(() {
        imgArray.add(imgFile!);
      });
    }

    yasuo2(entitys);
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

  void _removeImage2(int index) {
    setState(() {
      imgArray.removeAt(index);
      List<String> listID = [];
      if(imgID.contains(',')){
        listID = imgID.split(',');
        listID.removeAt(index);
        imgID = '';
        for(int i = 0; i < listID.length; i++){
          if(imgID.isEmpty){
            imgID = listID[i];
          }else{
            imgID = '$imgID,${listID[i]}';
          }
        }
      }else{
        imgID = '';
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    if(_videoController != null){
      _videoController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Loading.dismiss();
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false, // 解决键盘顶起页面
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(20)),
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(35, 0),

                      ///头部信息
                      Container(
                        height: ScreenUtil().setHeight(60),
                        width: double.infinity,
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              color: Colors.black,
                              onPressed: (() {
                                Navigator.of(context).pop();
                              }),
                            ),
                            const Expanded(child: Text('')),
                            Text(
                              '发动态',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(36),
                                  fontWeight: FontWeight.w600),
                            ),
                            const Expanded(child: Text('')),
                            GestureDetector(
                              onTap: (() {
                                if(MyUtils.checkClick()) {
                                  MyUtils.hideKeyboard(context);
                                  doPostSendDT();
                                }
                              }),
                              child: WidgetUtils.myContainer(
                                  ScreenUtil().setHeight(55),
                                  ScreenUtil().setWidth(120),
                                  MyColors.newLoginblue2,
                                  MyColors.newLoginblue2,
                                  '发布',
                                  ScreenUtil().setSp(30),
                                  Colors.white),
                            )
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(15, 0),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child:
                            WidgetUtils.commonTextFieldDT(controller, '记录一下此刻的想法~'),
                      ),
                      WidgetUtils.commonSizedBox(15, 0),
                      videoId.isEmpty ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10.h,
                          runSpacing: 15.h,
                          children: [
                            for (int i = 0; i < imgArray.length; i++)
                              Stack(
                                children: [
                                  Container(
                                    height: 160.h,
                                    width: 160.h,
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setHeight(20)),
                                    ),
                                    child: WidgetUtils.showImages(
                                      imgArray[i].path,
                                      160.h,
                                      160.h,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _removeImage2(i);
                                        });
                                      },
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.white.withOpacity(0.7),
                                          width: 20,
                                          height: 20,
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            imgArray.length < 6
                                ? GestureDetector(
                                    onTap: (() {
                                      _showSheetAction();
                                    }),
                                    child: WidgetUtils.showImages(
                                        'assets/images/images_add.png',
                                        160.h,
                                        160.h),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ) :
                     Row(
                       children: [
                         SizedBox(
                           width: ScreenUtil().setHeight(200),
                           height: ScreenUtil().setHeight(200),
                           child: Stack(
                             alignment: Alignment.center,
                             children: [
                               SizedBox(
                                 width: ScreenUtil().setHeight(200),
                                 height: ScreenUtil().setHeight(200),
                                 child: AspectRatio(
                                   aspectRatio: _videoController!.value.aspectRatio,
                                   child: VideoPlayer(_videoController!),
                                 ),
                               ),
                               GestureDetector(
                                 onTap: () {
                                    MyUtils.goTransparentRFPage(context, PagePreviewVideo(url: videoUrl));
                                 },
                                 child: const Icon(
                                   Icons.play_circle_fill_outlined,
                                   color: Colors.white,
                                   size: 50,
                                 ),
                               ),
                             ],
                           ),
                         ),
                         const Spacer(),
                       ],
                     )
                    ],
                  ),
                )
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Row(
                //     children: [
                //       WidgetUtils.commonSizedBox(0, 10),
                //       WidgetUtils.showImages('assets/images/trends_biaoqing.png', 25, 25),
                //       WidgetUtils.commonSizedBox(0, 10),
                //       WidgetUtils.showImages('assets/images/trends_biaoqing.png', 25, 25),
                //     ],
                //   ),
                // )
              ],
            ),
          )),
    );
  }

  /// 获取文件url
  Future<void> doPostPostFileUpload(path) async {
    Loading.show("上传中...");
    FormData formdata;
    if(type == 0) {
      var dir = await path_provider.getTemporaryDirectory();
      String targetPath = '';
      var result;
      if (path.toString().contains('.gif') || path.toString().contains('.GIF')) {
        targetPath = path;
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              targetPath,
              filename: name,
            ),
          },
        );
      } else if (path.toString().contains('.jpg') ||
          path.toString().contains('.GPG')) {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
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
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
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
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
        );
      } else {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
        var name = path.substring(path.lastIndexOf("/") + 1, path.length);
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
        );
      }
    }else{
      var name = path.substring(path.lastIndexOf("/") + 1, path.length);
      formdata = FormData.fromMap(
        {
          'type': 'video',
          "file": await MultipartFile.fromFile(
            path,
            filename: name,
          )
        },
      );
    }

    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token') ?? '';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(MyHttpConfig.fileUpload, data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      LogE('视频上传  $formdata');
      LogE('视频上传  $jsonResponse');
      if (jsonResponse['code'] == 200) {
        LogE('视频上传  ${jsonResponse['data'].toString()}');
        setState(() {
          if(type == 0){
            if(imgID.isNotEmpty){
              imgID = '$imgID,${jsonResponse['data'].toString()}';
            }else{
              imgID = jsonResponse['data'].toString();
            }
          }else{
            videoId = jsonResponse['data'].toString();
          }
        });

        MyToastUtils.showToastBottom('上传成功');
        Loading.dismiss();
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
      var name = imgFile!.path
          .substring(imgFile!.path.lastIndexOf("/") + 1, imgFile!.path.length);
      FormData formdata;
      String targetPath = '';
      var result;
      if (imgFile!.path.toString().contains('.gif') || imgFile!.path.toString().contains('.GIF')) {
        targetPath = imgFile!.path;
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              targetPath,
              filename: name,
            ),
          },
        );
      } else if (imgFile!.path.toString().contains('.jpg') ||
          imgFile!.path.toString().contains('.GPG')) {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
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
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
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
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
        );
      } else {
        targetPath =
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
        result = await FlutterImageCompress.compressAndGetFile(
          imgFile!.path, targetPath,
          quality: 50,
          rotate: 0, // 旋转角度
        );
        formdata = FormData.fromMap(
          {
            'type': 'image',
            "file": await MultipartFile.fromFile(
              result!.path,
              filename: name,
            ),
          },
        );
      }
      BaseOptions option = BaseOptions(
          contentType: 'multipart/form-data', responseType: ResponseType.plain);
      option.headers["Authorization"] = sp.getString('user_token') ?? '';
      Dio dio = Dio(option);
      //application/json
      try {
        var respone = await dio.post(MyHttpConfig.fileUpload, data: formdata);
        Map jsonResponse = json.decode(respone.data.toString());

        if (jsonResponse['code'] == 200) {
          if (id.isEmpty) {
            id = jsonResponse['data'].toString();
          } else {
            id = '$id,${jsonResponse['data'].toString()}';
          }
          if (i == lists.length - 1) {
            if(imgID.isNotEmpty){
              setState(() {
                imgID = '$imgID,$id';
              });
            }else{
              setState(() {
                imgID = id;
              });
            }
            MyToastUtils.showToastBottom('上传成功');
            Loading.dismiss();
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

  /// 上传动态
  Future<void> doPostSendDT() async {
    if (controller.text.trim().isEmpty) {
      MyToastUtils.showToastBottom("发布文本信息不能为空！");
      return;
    }

    Map<String, dynamic> params = <String, dynamic>{
      'text': controller.text.trim(),
      'img_id': type == 0 ? imgID : videoId,
      'type': type == 0 ? '1' : '2'
    };
    try {
      CommonBean bean = await DataUtils.postSendDT(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          MyToastUtils.showToastBottom("已提交动态发布申请！");
          Navigator.pop(context);
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




  /// 压缩图片
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
        print(err);
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
            print('上传成功');
          } else {
            Loading.dismiss();
            throw Exception("上传失败 $response");
          }
        },
        onError: (error) {
          Loading.dismiss();
          print('Error: $error');
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
      await UploadHttpClient.upload(pickFilePath!, type, '发布动态页面', (count, total) {
      });
    } catch (e) {
      LogE('上传失败${e.toString()}');
    }
  }

  /// 腾讯云id
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
          setState(() {
            if (type == 0) {
              if (imgID.isNotEmpty) {
                imgID = '$imgID,${bean.data.toString()}';
              } else {
                imgID = bean.data.toString();
              }
            } else {
              videoId = bean.data.toString();
            }
            if (i == selectAss.length - 1) {
              Loading.dismiss();
              MyToastUtils.showToastBottom('上传成功');
            }
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
