import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../core/providers/home_infos.dart';
import '../../widgets/keep_alive_page.dart';
import '../../widgets/page_screen.dart';
import 'message/message_page.dart';
import 'home.dart';
import 'my.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static final List<Widget> _pages = [
    KeepAlivePage(
      child: ChangeNotifierProvider(create: (_) => HomeInfos(), child: HomePage()),
    ),
    KeepAlivePage(child: CartPage()),
    KeepAlivePage(child: HomePage()),
    KeepAlivePage(child: MessagePage()),
    KeepAlivePage(child: MyPage()),
  ];

  final List<CustomBottomNavigationBarItem> _items = [
    CustomBottomNavigationBarItem(
      label: '工作台',
      icon: Icon(Colorfont.shouye),
      activeIcon: Icon(Colorfont.shouye_selected),
    ),
    CustomBottomNavigationBarItem(
      label: '消息',
      icon: Icon(Colorfont.xiaoxi1),
      activeIcon: Icon(Colorfont.xiaoxi_selected),
    ),
    CustomBottomNavigationBarItem(
      label: '我的',
      icon: Icon(Colorfont.wode),
      activeIcon: Icon(Colorfont.wode_selected),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PageScreen(
      pages: _pages,
      items: _items,
    );
  }
}
