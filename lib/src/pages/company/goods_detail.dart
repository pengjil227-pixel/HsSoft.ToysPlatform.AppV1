import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';

import '../../widgets/custom_swiper.dart';
import '../../widgets/goods_item.dart';

class GoodsDetail extends StatefulWidget {
  const GoodsDetail({super.key});

  @override
  State<GoodsDetail> createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail> {
  final List<String> _actions = ['切换英文', '复制信息', '错误反馈', '加入对比'];
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(theme.appBarTheme.toolbarHeight ?? 44),
        child: _AppBar(scrollController: _controller),
      ),
      body: PageView.builder(
        itemBuilder: (context, index) {
          return Stack(
            children: [
              CustomScrollView(
                controller: _controller,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                      child: CustomSwiper(
                        autoplay: false,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            'https://picsum.photos/300/160?i=$index',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '商品名称商品名称',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '¥50.88',
                            style: TextStyle(fontSize: 24, color: Color(0xFFF30213)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(_actions.length, (index) {
                                return Expanded(
                                  child: Row(
                                    children: [
                                      if (index != 0)
                                        SizedBox(
                                          height: 20,
                                          child: VerticalDivider(
                                            width: 0,
                                            thickness: 0.6,
                                          ),
                                        ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 34,
                                          child: Align(
                                            child: Text(_actions[index]),
                                          ),
                                        ),
                                      ),
                                    ],
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
                    child: Container(
                      margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
                      padding: EdgeInsets.all(LayoutConstants.pagePadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Theme(
                        data: ThemeData(
                          listTileTheme: ListTileThemeData(
                            leadingAndTrailingTextStyle: TextStyle(fontSize: 15, color: Colors.grey),
                            minLeadingWidth: 80,
                            visualDensity: VisualDensity(vertical: -4),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Text(
                                      '产品信息',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.2),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            stops: [0.0, 1.0],
                                            colors: [
                                              Color(0xFFF30213).withAlpha(160),
                                              Colors.white.withAlpha(100),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                PrimartButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Iconfont.fuzhi1,
                                    size: 16,
                                    color: Color(0xFF929292),
                                  ),
                                )
                              ],
                            ),
                            ListTile(leading: Text('出厂货号'), title: Text('1289')),
                            ListTile(leading: Text('来源展厅'), title: Text('天天玩具展厅')),
                            ListTile(leading: Text('包装'), title: Text('彩色')),
                            ListTile(leading: Text('种类名称'), title: Text('软胶类')),
                            ListTile(leading: Text('包装规格'), title: Text('17X17X22(cm)')),
                            ListTile(leading: Text('产品规格'), title: Text('17X17X14(cm)')),
                            ListTile(leading: Text('装箱量'), title: Text('17X17X14(cm)')),
                            ListTile(leading: Text('外箱规格'), title: Text('17X17X14(cm)')),
                            ListTile(leading: Text('毛重/净重'), title: Text('17X17X14(cm)')),
                            ListTile(leading: Text('体积/材积'), title: Text('17X17X14(cm)')),
                            ListTile(leading: Text('更新时间'), title: Text('2028-07-03 10:10:11')),
                            ListTile(leading: Text('上架时间'), title: Text('2028-07-03 10:10:11')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.all(LayoutConstants.pagePadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SizedBox(
                        height: 86,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('耀昇玩具展厅', style: TextStyle(fontSize: 18)),
                                      Row(
                                        children: [
                                          Text(
                                            '产品:',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PrimartButton(
                                    padding: EdgeInsets.zero,
                                    borderRadius: BorderRadius.zero,
                                    sizeStyle: CupertinoButtonSize.small,
                                    onPressed: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: Color(0xFFF30213)),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Iconfont.lianxiwomen, color: Color(0xFFF30213)),
                                          SizedBox(width: 4),
                                          Text(
                                            '关注',
                                            style: TextStyle(color: Color(0xFFF30213)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  PrimartButton(
                                    padding: EdgeInsets.zero,
                                    borderRadius: BorderRadius.zero,
                                    sizeStyle: CupertinoButtonSize.small,
                                    onPressed: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: Color(0xFFFF9700)),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Iconfont.lianxiwomen, color: Color(0xFFFF9700)),
                                          SizedBox(width: 4),
                                          Text(
                                            '联系',
                                            style: TextStyle(color: Color(0xFFFF9700)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Image.network(
                        width: double.infinity,
                        'https://picsum.photos/300/160?i=$index',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 44,
                      child: Align(
                        child: Text(
                          '产品推荐',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding, LayoutConstants.pagePadding * 3 + View.of(context).padding.bottom / View.of(context).devicePixelRatio + 44),
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
              Positioned(
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(4, LayoutConstants.pagePadding, 4, LayoutConstants.pagePadding + View.of(context).padding.bottom / View.of(context).devicePixelRatio),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 44,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Iconfont.dianpu1,
                              color: Color(0xFF929292),
                              size: 18,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '店铺',
                              style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Iconfont.shoucang1,
                              color: Color(0xFF929292),
                              size: 18,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '收藏',
                              style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Iconfont.fenxiang1,
                              color: Color(0xFF929292),
                              size: 18,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '店铺',
                              style: TextStyle(fontSize: 12, color: Color(0xFF929292)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: PrimartButton(
                            color: theme.primaryColor,
                            onPressed: () {},
                            child: Text(
                              '加入购物车',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<_AppBar> createState() => __AppBarState();
}

class __AppBarState extends State<_AppBar> {
  final double _gap = 250;
  double _alpha = 0;

  void _updateAlpha(double value) {}

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_controllerListener);
  }

  void _controllerListener() {
    final offset = widget.scrollController.offset;

    final double alpha = ((offset - 50) / _gap).clamp(0, 1);

    if (alpha == _alpha) return;
    setState(() {
      _alpha = alpha;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_controllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      notificationPredicate: (notification) {
        _updateAlpha(notification.metrics.pixels);
        return notification.depth == 0;
      },
      backgroundColor: Colors.white.withAlpha((_alpha * 255).toInt().clamp(0, 255)),
      shape: Border(bottom: BorderSide.none),
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Align(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(((1 - _alpha) * 130).toInt().clamp(0, 130)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color.lerp(Colors.white, Colors.black, _alpha),
            ),
          ),
        ),
      ),
    );
  }
}
