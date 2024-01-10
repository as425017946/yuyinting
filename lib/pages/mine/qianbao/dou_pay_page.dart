import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 充值V豆页面
class DouPayPage extends StatefulWidget {
  String shuliang;
  DouPayPage({Key? key, required this.shuliang}) : super(key: key);

  @override
  State<DouPayPage> createState() => _DouPayPageState();
}

class _DouPayPageState extends State<DouPayPage> {
  var appBar;
  TextEditingController controller = TextEditingController();
  var gz = false;
  List<bool> isClick = [true,false,false,false,false,false,false,false,false];
  List<String> listD = ['12','36','68','100','200','500','1000','3000','9000'];
  List<String> listS = ['100','300','580','1000','2000','5000','10000','30000','90000'];
  //支付类型 0 支付宝 1云闪付 2 银行卡
  int type = 0;
  // 是否支持此支付方式
  bool isChoose0 = true, isChoose1 = true, isChoose2 = false;
  ///选择金额使用
  Widget _initlistdata(context, index) {
    return GestureDetector(
      onTap: ((){
        setState(() {
          //选择金额要判断显示的支付方式
          // 3q9q不显示云闪付
          if(listD[index] == '3000' || listD[index] == '9000'){
            isChoose1 = false;
          }else{
            isChoose1 = true;
          }
          // 3q9q不显示云闪付
          if(listD[index] == '12' || listD[index] == '36' || listD[index] == '68' || listD[index] == '9000'){
            isChoose2 = false;
          }else{
            isChoose2 = true;
          }
          isClick[index] = !isClick[index];
          for(int i = 0; i < 9; i++){
            if(i != index){
              isClick[i] = false;
            }
          }
        });
      }),
      child: Container(
        height: ScreenUtil().setHeight(125),
        width: double.infinity,
        alignment: Alignment.center,
        //边框设置
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: const BorderRadius.all(Radius.circular(13.0)),
          //设置四周边框
          border: Border.all(width: 1, color: isClick[index]==true ? MyColors.walletWZBlue : MyColors.g6),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              children: [
                const Expanded(child: Text('')),
                Row(
                  children: [
                    const Expanded(child: Text('')),
                    WidgetUtils.showImages('assets/images/mine_wallet_dd.png', ScreenUtil().setHeight(27), ScreenUtil().setHeight(25)),
                    WidgetUtils.onlyText(listS[index], StyleUtils.getCommonTextStyle(color: isClick[index]==true ? MyColors.walletWZBlue : Colors.black, fontSize: ScreenUtil().setSp(33))),
                    const Expanded(child: Text('')),
                  ],
                ),
                WidgetUtils.onlyTextCenter('￥${listD[index]}', StyleUtils.getCommonTextStyle(color: isClick[index]==true ? MyColors.walletWZBlue : MyColors.g6, fontSize: ScreenUtil().setSp(33))),
                const Expanded(child: Text('')),
              ],
            ),
            isClick[index]==true ? WidgetUtils.showImages('assets/images/mine_wallet_xuanzhong.png', ScreenUtil().setHeight(47), ScreenUtil().setHeight(47)) : const Text('')
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('充值V豆', true, context, false, 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            WidgetUtils.myLine(thickness: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 豆子
                  SizedBox(
                    height: ScreenUtil().setHeight(250),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        WidgetUtils.showImagesFill('assets/images/mine_wallet_dbj.jpg', ScreenUtil().setHeight(250), double.infinity),
                        Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20),
                            Container(
                              height: 100.h,
                              width: 100.h,
                              alignment: Alignment.center,
                              //边框设置
                              decoration: BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius: BorderRadius.all(Radius.circular(50.h)),
                              ),
                              child: WidgetUtils.showImages('assets/images/mine_wallet_dd.png', 650.h, 65.h),
                            ),
                            WidgetUtils.commonSizedBox(0, 15),
                            Expanded(child: Column(
                              children: [
                                const Expanded(child: Text('')),
                                Row(
                                  children: [
                                    WidgetUtils.onlyText(
                                        'V豆',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(38))),
                                    const Spacer(),
                                    WidgetUtils.commonSizedBox(0, 50),
                                    WidgetUtils.onlyText(widget.shuliang, StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(56), fontWeight: FontWeight.w600)),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                const Expanded(child: Text('')),
                              ],
                            )),
                          ],
                        ),
                        // /// 兑换提示
                        // Container(
                        //   margin: const EdgeInsets.only(right: 15,bottom: 15),
                        //   child: Text(
                        //     '10V豆=1元',
                        //     style: TextStyle(fontSize: ScreenUtil().setSp(21), color: Colors.white),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(20, 20),
                  WidgetUtils.onlyText('请选择充值金额', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(33), fontWeight: FontWeight.w600)),
                  WidgetUtils.commonSizedBox(15, 20),
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: 9,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20, //设置列间距
                        mainAxisSpacing: 20, //设置行间距
                        childAspectRatio: 16/9,
                      ),
                      itemBuilder: _initlistdata),
                  WidgetUtils.commonSizedBox(15, 20),
                  Container(
                    height: 1.h,
                    width: double.infinity,
                    color: MyColors.home_hx,
                  ),
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        type = 0;
                      });
                    }),
                    child: Container(
                      height: 80.h,
                      width: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          WidgetUtils.showImages('assets/images/wallet_zfb.png', 40.h, 40.h),
                          WidgetUtils.commonSizedBox(0, 20.w),
                          WidgetUtils.onlyText('支付宝', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: 28.sp, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          type == 0 ? WidgetUtils.showImages('assets/images/wallet_dh.png', 35.h, 35.h) : const Text(''),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1.h,
                    width: double.infinity,
                    color: MyColors.home_hx,
                  ),
                  isChoose1 ? GestureDetector(
                    onTap: ((){
                      setState(() {
                        type = 1;
                      });
                    }),
                    child: Container(
                      height: 80.h,
                      width: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          WidgetUtils.showImages('assets/images/wallet_ysf.png', 40.h, 40.h),
                          WidgetUtils.commonSizedBox(0, 20.w),
                          WidgetUtils.onlyText('云闪付', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: 28.sp, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          type == 1 ? WidgetUtils.showImages('assets/images/wallet_dh.png', 35.h, 35.h) : WidgetUtils.commonSizedBox(0, 0),
                        ],
                      ),
                    ),
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  isChoose1 ? Container(
                    height: 1.h,
                    width: double.infinity,
                    color: MyColors.home_hx,
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  isChoose2 ? GestureDetector(
                    onTap: ((){
                      setState(() {
                        type = 2;
                      });
                    }),
                    child: Container(
                      height: 80.h,
                      width: double.infinity,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          WidgetUtils.showImages('assets/images/wallet_yl.png', 40.h, 40.h),
                          WidgetUtils.commonSizedBox(0, 20.w),
                          WidgetUtils.onlyText('银行卡', StyleUtils.getCommonTextStyle(color: Colors.black,fontSize: 28.sp, fontWeight: FontWeight.w600)),
                          const Spacer(),
                          type == 2 ? WidgetUtils.showImages('assets/images/wallet_dh.png', 35.h, 35.h) : const Text(''),
                        ],
                      ),
                    ),
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  isChoose2 ? Container(
                    height: 1.h,
                    width: double.infinity,
                    color: MyColors.home_hx,
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  // Container(
                  //   height: ScreenUtil().setHeight(80),
                  //   padding: const EdgeInsets.only(left: 10, right: 10),
                  //   //边框设置
                  //   decoration: const BoxDecoration(
                  //     //背景
                  //     color: MyColors.f6,
                  //     //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                  //     borderRadius: BorderRadius.all(Radius.circular(35)),
                  //   ),
                  //   child: WidgetUtils.commonTextFieldNumber(controller: controller, hintText: '请输入需要充值的金额'),
                  // ),
                  WidgetUtils.commonSizedBox(15, 20),
                  WidgetUtils.commonSubmitButton2('确认充值',MyColors.walletWZBlue),
                  WidgetUtils.commonSizedBox(15, 20),
                  // GestureDetector(
                  //   onTap: ((){
                  //     setState(() {
                  //       gz = !gz;
                  //     });
                  //   }),
                  //   child: Row(
                  //     children: [
                  //       const Expanded(child: Text('')),
                  //       WidgetUtils.showImages( gz == false ? 'assets/images/trends_r1.png' : 'assets/images/trends_r2.png', 15, 15),
                  //       WidgetUtils.commonSizedBox(0, 10),
                  //       const Text('充值代表已阅读并同意',style: TextStyle(fontSize: 13,color: MyColors.g9, ),),
                  //       const Text('《充值协议》',style: TextStyle(fontSize: 13,color: MyColors.walletWZBlue, ),),
                  //       const Expanded(child: Text('')),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
