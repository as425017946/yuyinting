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
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../utils/my_utils.dart';
import 'package:video_player/video_player.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      if (imgFile != null) chooseImagesPath.add(imgFile.path);
      setState(() {
        imgArray.add(imgFile!);
      });
    }

    doPostPostFileUpload2(entitys);
    // print('选择照片路径:$chooseImagesPath');
  }

  late VideoPlayerController _videoController;
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
      await _videoController.initialize();
      setState(() {
        videoUrl = pickedFile.path;
        _isVideoSelected = true;
        imgArray.clear();
      });
    }
    doPostPostFileUpload(pickedFile.path);
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
    doPostPostFileUpload(imgFile.path);
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
    _videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                                doPostSendDT();
                                MyUtils.hideKeyboard(context);
                              }
                            }),
                            child: WidgetUtils.myContainer(
                                ScreenUtil().setHeight(55),
                                ScreenUtil().setWidth(120),
                                MyColors.zhouBangBg,
                                MyColors.zhouBangBg,
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
                                 aspectRatio: _videoController.value.aspectRatio,
                                 child: VideoPlayer(_videoController),
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
        ));
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
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.png";
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
        "${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.png";
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
}
