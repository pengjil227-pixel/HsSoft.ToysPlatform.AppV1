import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/providers/login_user.dart';
import '../../widgets/goods_item.dart';
import '../../widgets/primart_button.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _init();
  }
  _init() async{
    await Future.delayed(Duration.zero);
    print(LoginInfoSingleton.loginUserInfo) ;
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  PreferredSizeWidget _appBarBuilder() {
    return AppBar(
      toolbarHeight: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFEE9E8),
              Color(0xFFFFF2EC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(76),
        child: Padding(
          padding: EdgeInsets.all(LayoutConstants.pagePadding),
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
              child: Consumer<LoginUser>(
                builder: (context, LoginUser loginUser, _) {
                  final Widget avatar;
                  final Widget title;
                  String? detail;
                  if (loginUser.isLogin) {
                    final user = loginUser.loginUser;
                    avatar = GestureDetector(
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    );
                    title = Text(
                      user!.name ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                    detail = user.companyInfos.first.companyName;
                  } else {
                    void goLogin() {
                      context.pushNamed('login');
                    }

                    avatar = GestureDetector(
                      onTap: goLogin,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    );
                    title = GestureDetector(
                      onTap: goLogin,
                      child: Text(
                        '登录',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      avatar,
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              title,
                              if (detail != null)
                                Text(
                                  '宏升玩具厂',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          PrimartButton(
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconfont.saoma,
                                  size: 18,
                                  color: Color(0xFF666666),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Text(
                                    '扫一扫',
                                    style: TextStyle(fontSize: 10, color: Color(0xFF666666), height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PrimartButton(
                            padding: EdgeInsets.all(8.0),
                            onPressed: () {
                              context.pushNamed('setting');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconfont.shezhi,
                                  size: 18,
                                  color: Color(0xFF666666),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Text(
                                    '设置',
                                    style: TextStyle(fontSize: 10, color: Color(0xFF666666), height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBuilder({
    required String text,
    required Widget child,
  }) {
    return Column(
      children: [
        child,
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(text),
        ),
      ],
    );
  }

  final List<_Action> _subActions = [
    _Action(
      text: '浏览记录',
      actionType: _ActionType.information,
    ),
    _Action(
      text: '收藏产品',
      actionType: _ActionType.management,
    ),
    _Action(
      text: '关注厂商',
      actionType: _ActionType.service,
    ),
    _Action(
      text: '择样报价',
      actionType: _ActionType.comparison,
    ),
  ];
  final List<_Action> _actions = [
    _Action(
      text: '公司信息',
      actionType: _ActionType.browse,
    ),
    _Action(
      text: '账号管理',
      actionType: _ActionType.collection,
    ),
    _Action(
      text: '在线客服',
      actionType: _ActionType.follow,
    ),
    _Action(
      text: '产品对比',
      actionType: _ActionType.sample,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: _appBarBuilder(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF2EC), theme.scaffoldBackgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: LayoutConstants.pagePadding),
                    margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _actions.map((action) {
                          return _actionBuilder(
                            text: action.text,
                            child: Text(
                              '1',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _subActions.map((action) {
                        return _actionBuilder(
                          text: action.text,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              Icons.access_time_outlined,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(LayoutConstants.pagePadding),
            sliver: SliverGrid.builder(
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: LayoutConstants.pagePadding,
                mainAxisSpacing: LayoutConstants.pagePadding,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                return GoodsItem();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Action {
  final String text;
  final _ActionType actionType;

  _Action({
    required this.text,
    required this.actionType,
  });
}

enum _ActionType {
  browse,
  collection,
  follow,
  sample,
  information,
  management,
  service,
  comparison,
}
