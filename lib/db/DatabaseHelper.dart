import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yuyinting/utils/log_util.dart';

class DatabaseHelper {
  static Database? _database = null;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    LogE('路径$databasesPath');
    String dbPath = join(databasesPath, 'lmyyt2.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS messageXTTable (id INTEGER PRIMARY KEY, messageID INTEGER, type INTEGER, title TEXT, text TEXT, img INTEGER, url TEXT, add_time TEXT, data_status INTEGER, img_url TEXT)');
        // whoUid 谁发的消息 type 类型设定 1文本2图片3音频4表情5钻石红包6V豆红包   combineID是谁发送的这条消息  nickName 被发送人的昵称 bigImg 发送图片的原图 number发送红包里面的金额  status发送消息的状态1发送成功0发送失败 readStatus 0未读1已读   liveStatus0未直播1直播中 loginStatus0离线1在线
        await db.execute(
            'CREATE TABLE IF NOT EXISTS messageSLTable (id INTEGER PRIMARY KEY, uid TEXT, otherUid TEXT,whoUid TEXT,combineID TEXT, nickName TEXT, content TEXT, bigImg TEXT, headImg TEXT, headNetImg TEXT, otherHeadNetImg TEXT, add_time TEXT, type INTEGER, number INTEGER, status INTEGER, readStatus INTEGER, liveStatus INTEGER, loginStatus INTEGER,weight INTEGER,msgRead INTEGER, msgId TEXT, msgJson TEXT,by1 TEXT,by2 TEXT,by3 TEXT)');
        // 搜索房间或者用户列表表 自增id、用户id、添加时间
        await db.execute(
            'CREATE TABLE IF NOT EXISTS searchTable (id INTEGER PRIMARY KEY, text TEXT, uid TEXT,add_time TEXT)');
        // 保存房间信息 (房间id、（info保留房间公告、用户昵称等信息）、用户id、发送的类型、发送的信息、发送的图片、身份、等级、贵族、萌新、是否靓号、新贵、是否点击了欢迎 0未欢迎 1已欢迎、svga动画是否播放完成、新等级标志、预留3个备用字段)
        await db.execute(
            'CREATE TABLE IF NOT EXISTS roomInfoTable (id INTEGER PRIMARY KEY, roomID TEXT, info TEXT, uid TEXT,type TEXT,content TEXT,image TEXT,identity TEXT,lv TEXT,noble_id TEXT,is_new TEXT,is_pretty TEXT,new_noble TEXT,isWelcome TEXT,isOk TEXT,newLv TEXT,by1 TEXT,by2 TEXT,by3 TEXT)');
      },
    );
  }

  Future<int> insertData(String tableName, Map<String, dynamic> params) async {
    final db = await database;
    return await db.insert(tableName, params);
  }

  Future<int> insertDataFirst(
      String tableName, Map<String, dynamic> params) async {
    final db = await database;
    return await db.insert(tableName, params);
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<int> updateData(
      String tableName, int id, String columnName, var values) async {
    final db = await database;
    return await db.update(tableName, {columnName: values},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String tableName, int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDataALl(String tableName) async {
    final db = await database;
    return await db.delete(tableName);
  }

  Future<void> closeDB() async {
    _database?.close();
    _database = null;
  }
}
