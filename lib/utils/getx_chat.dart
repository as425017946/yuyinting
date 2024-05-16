
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:sqflite/sqflite.dart';

import '../bean/CommonIntBean.dart';
import '../db/DatabaseHelper.dart';
import '../http/data_utils.dart';
import '../http/my_http_config.dart';
import '../main.dart';
import 'my_utils.dart';

class GetxChat {
  late final DatabaseHelper _helper = DatabaseHelper();
  Database? _db;
  Future<Database> get db async => _db ??= await _helper.database;

  String getCombineID(String id1, String id2) {
    final ids = [id1, id2];
    ids.sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    return ids.join('-');
  }

  Future<String> canSendMsg(String content, String toId) async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': toId,
      'type': '1',
      'content': content,
    };
    CommonIntBean bean = await DataUtils.postCanSendUser(params);
    switch (bean.code) {
      case MyHttpConfig.successCode:
        return bean.data ?? content;
      case MyHttpConfig.errorloginCode:
        final context = Get.context;
        if (context != null) {
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
        }
        throw '';
      default:
        throw bean.msg ?? '';
    }
  }
  Future<EMMessage> sendMsg(String content, String toId, String toName, String toHead) async {
    final textMsg = EMMessage.createTxtSendMessage(
      targetId: toId,
      content: content,
    );
    textMsg.attributes = {
      'nickname': sp.getString('nickname'),
      'avatar': sp.getString('user_headimg'),
      'weight': 50,
    };
    final msg = await EMClient.getInstance.chatManager.sendMessage(textMsg);
    await _insertData(msg, content, toId, toName, toHead);
    return msg;
  }

  // 插入数据
  Future<void> _insertData(EMMessage msg, String content, String toId, String toName, String toHead) async {
    final uid = sp.getString('user_id').toString();
    final combineID = getCombineID(uid, toId);
    Map<String, dynamic> params = <String, dynamic>{
      'uid': uid,
      'otherUid': toId,
      'whoUid': uid,
      'combineID': combineID,
      'nickName': toName,
      'content': content,
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': toHead,
      'add_time': msg.serverTime,
      'type': 1,
      'number': 0,
      'status': 1,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': toId == '1' ? 100 : 50,
      'msgId': '',
      'msgRead': 2,
      'msgJson': msg.msgId,
    };
    await _helper.insertData('messageSLTable', params);
  }
}