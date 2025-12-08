import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final String _key = 'search_history';
// 写入数据
Future<void> saveSearchHistory(List<String> info) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(_key, jsonEncode(info));
}

// 读取数据
Future<List<String>?> loadSaveSearchHistory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final list = prefs.getString(_key);
  if (list != null) {
    final List<dynamic> items = jsonDecode(list);
    return items.cast<String>();
  }
  return null;
}

// 删除数据
Future<void> deleteSaveSearchHistory() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(_key);
}
