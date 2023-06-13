import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 编辑头像显示
class EditHeadPage extends StatefulWidget {
  const EditHeadPage({Key? key}) : super(key: key);

  @override
  State<EditHeadPage> createState() => _EditHeadPageState();
}

class _EditHeadPageState extends State<EditHeadPage> {
  List<File> imgArray = [];

  onTapPickFromGallery() async {
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
            maxAssets: 6, requestType: RequestType.image));
    if (entitys == null) return;

    List<String> chooseImagesPath = [];
    //遍历
    for (var entity in entitys) {
      File? imgFile = await entity.file;
      if (imgFile != null) chooseImagesPath.add(imgFile.path);
      setState(() {
        imgArray.add(imgFile!);
      });
    }
    print('选择照片路径:$chooseImagesPath');
  }

  onTapPickFromCamera() async {
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if (entity == null) return;
    File? imgFile = await entity.file;
    if (imgFile == null) return;
    print('照片路径:${imgFile.path}');
    setState(() {
      imgArray.add(imgFile!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
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
}
