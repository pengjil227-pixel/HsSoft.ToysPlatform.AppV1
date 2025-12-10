import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/providers/home_infos.dart';
import '../../core/providers/login_user.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _appBarBuilder() {
    return AppBar(
      toolbarHeight: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
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
        preferredSize: const Size.fromHeight(76),
        child: Padding(
          padding: const EdgeInsets.all(LayoutConstants.pagePadding),
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
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
                      user?.name ?? '',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                    detail = user?.companyInfos.first.companyName;
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
                      child: const Text(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              title,
                              if (detail != null)
                                Text(
                                  detail,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          PrimartButton(
                            padding: const EdgeInsets.all(8.0),
                            onPressed: () {},
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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
                            padding: const EdgeInsets.all(8.0),
                            onPressed: () {
                              context.pushNamed('setting');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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
          padding: const EdgeInsets.only(top: 8),
          child: Text(text),
        ),
      ],
    );
  }

  final List<_Action> _subActions = const [
    _Action(
      text: '公司信息',
      actionType: _ActionType.information,
    ),
    _Action(
      text: '账号管理',
      actionType: _ActionType.management,
    ),
    _Action(
      text: '在线客服',
      actionType: _ActionType.service,
    ),
    _Action(
      text: '产品对比',
      actionType: _ActionType.comparison,
    ),
  ];
  final List<_Action> _actions = const [
    _Action(
      text: '浏览记录',
      actionType: _ActionType.browse,
    ),
    _Action(
      text: '收藏产品',
      actionType: _ActionType.collection,
    ),
    _Action(
      text: '关注厂商',
      actionType: _ActionType.follow,
    ),
    _Action(
      text: '采样报价',
      actionType: _ActionType.sample,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: _appBarBuilder(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFF2EC), theme.scaffoldBackgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: LayoutConstants.pagePadding),
                    margin: const EdgeInsets.fromLTRB(
                      LayoutConstants.pagePadding,
                      LayoutConstants.pagePadding,
                      LayoutConstants.pagePadding,
                      0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _actions.map((action) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              if (action.routeName != null) {
                                context.pushNamed(action.routeName!);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                              child: _actionBuilder(
                                text: action.text,
                                child: const Text(
                                  '1',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(
                      LayoutConstants.pagePadding,
                      LayoutConstants.pagePadding,
                      LayoutConstants.pagePadding,
                      LayoutConstants.pagePadding,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _subActions.map((action) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            if (action.routeName != null) {
                              context.pushNamed(action.routeName!);
                            }
                          },
                          child: _actionBuilder(
                            text: action.text,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.access_time_outlined,
                                color: Colors.white,
                              ),
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
          SliverToBoxAdapter(
            child: Selector<HomeInfos, PaginatedResponse<ProductItem>?>(
              selector: (_, model) => model.recomendProduct,
              builder: (context, value, __) {
                if (value == null || value.rows.isEmpty) return const SizedBox.shrink();
                return const SizedBox(
                  height: 4,
                  child: Align(
                    // child: Text('推荐产品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              LayoutConstants.pagePadding,
              0,
              LayoutConstants.pagePadding,
              LayoutConstants.pagePadding,
            ),
            sliver: Consumer<HomeInfos>(
              builder: (context, HomeInfos value, __) {
                final data = value.recomendProduct;
                if (data == null) return const SliverToBoxAdapter(child: SizedBox.shrink());
                return ProductsBuilder(
                  item: data,
                  loadMore: () {
                    context.read<HomeInfos>().loadMoreRecomendProduct();
                  },
                );
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

  const _Action({
    required this.text,
    required this.actionType,
  });

  String? get routeName {
    switch (actionType) {
      case _ActionType.information:
        return 'companyInfo';
      case _ActionType.management:
        return 'accountManage';
      case _ActionType.service:
        return 'onlineService';
      case _ActionType.comparison:
        return 'productCompare';
      case _ActionType.browse:
        return 'browseHistory';
      case _ActionType.collection:
        return 'collection';
      case _ActionType.follow:
        return 'followFactory';
      case _ActionType.sample:
        return 'sampleQuote';
    }
  }
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
