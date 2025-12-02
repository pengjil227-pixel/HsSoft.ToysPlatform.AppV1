import 'package:shared_preferences/shared_preferences.dart';

final String _key = 'login_user_info';

// 写入数据
Future<void> saveLoginUserInfo(String info) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_key, info);
}

// 读取数据
Future<String?> loadLoginUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(_key);
}

// 删除数据
Future<void> deleteLoginUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_key);
}
