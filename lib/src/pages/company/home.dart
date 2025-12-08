import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/providers/home_infos.dart';
import '../../widgets/keep_alive_page.dart';
import 'sourcefactory/factory.dart';
import 'recommended.dart';
import 'supply.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _TabType {
  recommended,
  supply,
  factory,
}

class _TabValue {
  _TabValue({
    required this.text,
    required this.tabType,
  });
  final String text;
  final _TabType tabType;
}

final List<_TabValue> _tabValues = [
  _TabValue(text: '今日推荐', tabType: _TabType.recommended),
  _TabValue(text: '玩具货源', tabType: _TabType.supply),
  _TabValue(text: '源头工厂', tabType: _TabType.factory),
];

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final SortingProvider _provider = SortingProvider();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabValues.length,
      vsync: this,
    );
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration.zero, () {});
    if (!mounted) return;
    context.read<HomeInfos>().updateHomeInfos();
  }

  @override
  void dispose() {
    super.dispose();
    _provider.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(92),
          child: _AppBar(
            controller: _tabController,
          ),
        ),
      ),
      body: TabBarView(
        physics: BouncingScrollPhysics(),
        controller: _tabController,
        children: [
          KeepAlivePage(
            child: RecommendedPage(),
          ),
          KeepAlivePage(
              child: SupplyPage(
            provider: _provider,
          )),
          KeepAlivePage(child: FactoryPage()),
        ],
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.controller,
  });

  final TabController controller;

  @override
  State<_AppBar> createState() => __AppBarState();
}

class __AppBarState extends State<_AppBar> {
  final ValueNotifier<_SearchTypes> _tabType = ValueNotifier<_SearchTypes>(_SearchTypes.product);

  void _tabTypeChange(_SearchTypes value) {
    _tabType.value = value;
  }

  final Map<_SearchTypes, String> _tabText = {
    _SearchTypes.product: '搜索产品',
    _SearchTypes.factory: '搜索工厂',
  };

  @override
  void dispose() {
    super.dispose();
    _tabType.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 172,
                height: 34,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: ValueListenableBuilder<_SearchTypes>(
                  valueListenable: _tabType,
                  builder: (_, _SearchTypes value, __) {
                    return _SearchTabBar(
                      tabType: value,
                      onChange: _tabTypeChange,
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed('search');
                },
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: Align(
                          child: Icon(
                            Iconfont.saoma,
                            size: 18,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<_SearchTypes>(
                          valueListenable: _tabType,
                          builder: (_, _SearchTypes value, __) {
                            return Text(
                              _tabText[value]!,
                              style: TextStyle(
                                color: Color(0xFFCACFD2),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 34,
                        child: Align(
                          child: Icon(
                            Iconfont.paizhao,
                            size: 18,
                            color: Color(0xFF929292),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                        child: VerticalDivider(
                          width: 0,
                          thickness: 0.5,
                          color: Color(0xFFCACFD2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '搜索',
                          style: TextStyle(color: theme.primaryColor, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 34, vertical: LayoutConstants.pagePadding),
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: TabBar(
              controller: widget.controller,
              labelStyle: TextStyle(color: theme.primaryColor, fontSize: 15),
              unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 15),
              indicatorPadding: EdgeInsets.all(3.0),
              indicator: BoxDecoration(
                color: Colors.white, // 选中时的背景颜色
                borderRadius: BorderRadius.circular(100),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: _tabValues.map((tab) => Tab(text: tab.text)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

enum _SearchTypes {
  product,
  factory,
}

class _SearchTabBar extends StatefulWidget {
  const _SearchTabBar({
    required this.tabType,
    required this.onChange,
  });

  final _SearchTypes tabType;

  final Function(_SearchTypes value) onChange;

  @override
  State<_SearchTabBar> createState() => __SearchTabBarState();
}

class __SearchTabBarState extends State<_SearchTabBar> {
  _SearchTypes get _tabType => widget.tabType;

  void _updateType(_SearchTypes value) {
    if (value != _tabType) {
      widget.onChange.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        Align(
          alignment: _tabType == _SearchTypes.product ? Alignment.topLeft : Alignment.topRight,
          child: Transform.scale(
            scaleX: _tabType == _SearchTypes.product ? 1 : -1,
            child: CustomPaint(
              painter: _RoundedTrapezoidPainter(color: theme.primaryColor),
              size: Size(96, 34),
            ),
          ),
        ),
        DefaultTextStyle(
          style: TextStyle(color: Color(0xFF6C6C6C), fontSize: 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _updateType(_SearchTypes.product),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '找产品',
                      style: _tabType == _SearchTypes.product ? TextStyle(color: Colors.white) : null,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _updateType(_SearchTypes.factory),
                  behavior: HitTestBehavior.opaque,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        '找工厂',
                        style: _tabType == _SearchTypes.factory ? TextStyle(color: Colors.white) : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundedTrapezoidPainter extends CustomPainter {
  final Color color;

  _RoundedTrapezoidPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 定义梯形关键点参数（可根据需要调整）
    final double topWidth = size.width * 0.7; // 顶边宽度为整体宽度的60%
    final double height = size.height;
    final double cornerRadius = 10.0;

    // 创建路径并绘制梯形
    Path path = Path();

    // 移动到左上角起点，并添加圆角
    path.moveTo(cornerRadius, 0);
    // 绘制上边线，右上角圆角
    path.lineTo(topWidth - cornerRadius, 0);
    // 绘制右边线
    path.cubicTo(topWidth + 10, 0, topWidth + 10, 0, size.width, height);
    path.lineTo(0, height);
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
