import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../colors/my_colors.dart';

///发布动态页面
class TrendsSendPage extends StatefulWidget {
  const TrendsSendPage({Key? key}) : super(key: key);

  @override
  State<TrendsSendPage> createState() => _TrendsSendPageState();
}

class _TrendsSendPageState extends State<TrendsSendPage> {
  TextEditingController controller = TextEditingController();
  List<File> imgArray = [];
  // List<AssetEntity>? assets;



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
                    onTap: ((){
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
                    onTap: ((){
                      // selectAssets();
                      onTapPickFromGallery();
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
                    onTap: ((){
                      // selectAssets();
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

  onTapPickFromGallery() async{
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context,pickerConfig: const AssetPickerConfig(
      maxAssets: 6,
      requestType: RequestType.image
    ));
    if(entitys == null) return;

    List<String> chooseImagesPath = [];
    //遍历
    for(var entity in entitys){
      File? imgFile = await entity.file;
      if(imgFile != null) chooseImagesPath.add(imgFile.path);
      setState(() {
        imgArray.add(imgFile!);
      });
    }
    print('选择照片路径:$chooseImagesPath');

  }
  onTapVideoFromGallery() async{
    Navigator.pop(context);
    final List<AssetEntity>? entitys = await AssetPicker.pickAssets(context,pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
        requestType: RequestType.video
    ));
    if(entitys == null) return;

    List<String> chooseImagesPath = [];
    //遍历
    for(var entity in entitys){
      File? imgFile = await entity.file;
      if(imgFile != null) chooseImagesPath.add(imgFile.path);
      setState(() {
        imgArray.add(imgFile!);
      });
    }
    print('选择照片路径:$chooseImagesPath');

  }

  onTapPickFromCamera() async{
    Navigator.pop(context);

    final AssetEntity? entity = await CameraPicker.pickFromCamera(context);
    if(entity == null) return;
    File? imgFile = await entity.file;
    if(imgFile == null) return;
    print('照片路径:${imgFile.path}');
    setState(() {
      imgArray.add(imgFile!);
    });
  }


  Widget _imageItem({required File imagePth}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.file(
            imagePth,
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setHeight(200),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: () {
              //print('点击了删除');
              // List<File> cacheList = [];
              // cacheList.addAll(imgArray);
              // cacheList.remove(imagePth);
              setState(() {
                imgArray.remove(imagePth);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(10),
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
                    child: WidgetUtils.commonTextFieldDT(
                        controller, '记录一下此刻的想法~'),
                  ),
                  WidgetUtils.commonSizedBox(15, 0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (() {
                          _showSheetAction();
                        }),
                        child: Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(200),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.f2,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: BorderRadius.all(Radius.circular(
                                10.0)),
                          ),
                          child: const Text(
                            '+',
                            style: TextStyle(fontSize: 40, color: MyColors.g6),
                          ),
                        ),
                      )
                    ],
                  ),

                  Container(
                    child: imgArray.isNotEmpty
                        ? Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: imgArray
                          .map((item) => _imageItem(imagePth: item))
                          .toList(),
                    )
                        : const Text(''),
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
        )
    );
  }


}
