class MyConfig{
  static const String userAccount = 'userAccount';//账户
  static const String userPassword = 'userPassword';//用户密码
  static const String userName = 'userName';//用户名
  static const String userToken = 'userToken';//用户token
  static const String appVersion = 'appVersion';//版本号

  static const String userOneName = 'userOneName';//用户昵称
  static const String userOneID = 'userOneID';//用户id
  static const String userOneHeaderImg = 'userOneHeaderImg';//用户头像
  static const String userOneToken = 'userOneToken';//用户token
  static const String userOneUID = 'userOneUID';//用户uid

  static const String userTwoName = 'userTwoName';//用户昵称
  static const String userTwoID = 'userTwoID';//用户id
  static const String userTwoHeaderImg = 'userTwoHeaderImg';//用户头像
  static const String userTwoToken = 'userTwoToken';//用户token
  static const String userTwoUID = 'userTwoUID';//用户uid

  static const String userThreeName = 'userThreeName';//用户昵称
  static const String userThreeID = 'userThreeID';//用户id
  static const String userThreeHeaderImg = 'userThreeHeaderImg';//用户头像
  static const String userThreeToken = 'userThreeToken';//用户token
  static const String userThreeUID = 'userThreeUID';//用户uid

  // 定义声网 App ID、Token（生成的临时token，声网这个是有效时间24小时） 和 Channel（创建的频道名）
  // static const appId = "6d4c7c47c5c040a2a51829ed564a2697";
  // // 测试声网appid
  // static const appId = "16ad6f01cfd84726848c0c9ab07d5dd8";
  // 正式声网appid
  static const appId = "bd33b13cda0648ef9a8d1caefccc64bc";

  // static const token = "007eJxTYJgsP3eVBhsvl43Yy6oXQbeFhTpaTTM+iPn7TmGdLrVW4IkCg1mKSbJ5sol5smmygYlBolGiqaGFkWVqiqmZSaKRmaX5q1P9qQ2BjAwc714zMzJAIIjPxpBbGZSfn8vAAACIUx3F";
  // static const channel = "myRoom";

  /// 添加账号使用
  static bool issAdd = false;
  /// widget.giftList!点击的是第几个
  static int clickIndex = 1;
  /// 每页显示多少条
  static const int pageSize = 10;

  /// 默认加载中的提示语
  static const String successTitle = '加载中...';
  /// 加载失败的提示语
  static const String errorTitle = '数据请求超时，请检查网络状况!';
  /// 上传文件过大
  static const String errorTitleFile = '上传失败！，请更换上传10M以内的文件！';
  /// 加载失败的提示语
  static const String errorHttpTitle = '网络连接超时，请切换网络重试';
  /// 加载失败的提示语
  static const String errorHttpTitle2 = '网络连接超时，请切换网络重试~';



}