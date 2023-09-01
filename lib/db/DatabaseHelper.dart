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
    // LogE('路径$databasesPath');
    String dbPath = join(databasesPath, 'lmyyt.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS messageXTTable (id INTEGER PRIMARY KEY, messageID INTEGER, type INTEGER, title TEXT, text TEXT, img INTEGER, url TEXT, add_time TEXT, data_status INTEGER, img_url TEXT)');
        // whoUid 谁发的消息 type 类型设定 1文本2图片3音频4表情5钻石红包6V豆红包   combineID是谁发送的这条消息  nickName 被发送人的昵称 bigImg 发送图片的原图 number发送红包里面的金额  status发送消息的状态1发送成功0发送失败 readStatus 0未读1已读   liveStatus0未直播1直播中 loginStatus0离线1在线
        await db.execute('CREATE TABLE IF NOT EXISTS messageSLTable (id INTEGER PRIMARY KEY, uid TEXT, otherUid TEXT,whoUid TEXT,combineID TEXT, nickName TEXT, content TEXT, bigImg TEXT, headImg TEXT, otherHeadImg TEXT, add_time TEXT, type INTEGER, number INTEGER, status INTEGER, readStatus INTEGER, liveStatus INTEGER, loginStatus INTEGER)');
      },
    );
  }

  Future<int> insertData(String tableName, Map<String,dynamic> params) async {
    final db = await database;
    return await db.insert(tableName, params);
  }

  Future<int> insertDataFirst(String tableName, Map<String,dynamic> params) async {
    final db = await database;
    return await db.insert(tableName, params);
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<int> updateData(String tableName, int id,String columnName, var values) async {
    final db = await database;
    return await db.update(tableName, {columnName: values}, where: 'id = ?', whereArgs: [id]);
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
