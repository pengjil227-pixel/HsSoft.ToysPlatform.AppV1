import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/network/modules/company.dart';
import '../../core/network/modules/search.dart';
import '../../core/providers/home_infos.dart';
import '../../shared/models/company_origin.dart';
import '../../shared/models/exhibition.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
import '../../shared/models/sales_ads_list.dart';
import '../../widgets/custom_smart_refresher.dart';
import '../../widgets/custom_swiper.dart';
import '../../widgets/keep_alive_page.dart';
import '../../widgets/products_view.dart';
import '../../widgets/sorting_tab_bar.dart';
import 'sourcefactory/factory.dart';

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
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(86),
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
            child: _RecommendedPage(),
          ),
          KeepAlivePage(child: _SupplyPage()),
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
                height: 28,
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

class _RecommendedPage extends StatefulWidget {
  const _RecommendedPage();

  @override
  State<_RecommendedPage> createState() => __RecommendedPageState();
}

class __RecommendedPageState extends State<_RecommendedPage> {
  final RefreshController _refreshController = RefreshController();

  late final SmartRefresherParameter _smartRefresherParameter;

  final double _titleHeight = 20.0;

  @override
  void initState() {
    super.initState();
    _smartRefresherParameter = SmartRefresherParameter(
      loadList: (int page) => CompanyService.getRecomendProduct(page),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<HomeInfos>().updateHomeInfos(),
      Future.delayed(Duration(milliseconds: 500)),
    ]);

    _refreshController.loadComplete();
    _smartRefresherParameter.refresh?.call();

    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    final bool? hasMore = await _smartRefresherParameter.loadmore?.call();
    if (hasMore == false) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Widget _mainItemBuilder({
    required IconData icon,
    required String title,
    required Color color,
    Function()? onTap,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, 0, LayoutConstants.pagePadding),
      margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              visualDensity: VisualDensity(vertical: VisualDensity.minimumDensity, horizontal: VisualDensity.minimumDensity),
              leading: Icon(icon, color: color, size: 16),
              title: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.chevron_right_rounded),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _titleBuilder(String title) {
    return SizedBox(
      height: _titleHeight,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          style: TextStyle(fontSize: 14, height: 1),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: SmartRefresherHeader(),
      footer: SmartRefresherFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
              child: SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Selector<HomeInfos, List<SalesAdsList>?>(
                    selector: (_, model) => model.salesAdsList,
                    builder: (context, List<SalesAdsList>? value, __) {
                      if (value == null) return SizedBox.shrink();
                      return CustomSwiper(
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            imageUrl: value[index].imgUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, List<Exhibition>?>(
              selector: (_, model) => model.onlineExhibitionList,
              builder: (context, List<Exhibition>? value, __) {
                if (value == null || value.isEmpty) return SizedBox.shrink();
                final itemCount = (value.length / 3).ceil();
                return _mainItemBuilder(
                  icon: Iconfont.zhanting,
                  title: '线上展厅',
                  color: theme.primaryColor,
                  onTap: () => context.pushNamed('exhibitionHall'),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final gap = LayoutConstants.pagePadding;
                      final itemWidth = (constraints.maxWidth - gap * 3) / 3;

                      return SizedBox(
                        height: itemWidth * 2 / 3 + _titleHeight,
                        child: CustomSwiper(
                          itemCount: itemCount,
                          autoplay: false,
                          defaultPagination: false,
                          loop: false,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Padding(
                              padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(3, (itemIndex) {
                                  final dataIndex = pageIndex * 3 + itemIndex;
                                  if (dataIndex >= value.length) {
                                    return SizedBox.shrink();
                                  }
                                  final exhibition = value[dataIndex];

                                  return SizedBox(
                                    width: itemWidth,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: exhibition.companyLogo,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                                            ),
                                          ),
                                        ),
                                        _titleBuilder(exhibition.companyName),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, PaginatedResponse<ProductItem>?>(
              selector: (_, model) => model.newProduct,
              builder: (context, PaginatedResponse<ProductItem>? value, __) {
                if (value == null) return SizedBox.shrink();
                return _mainItemBuilder(
                  icon: Iconfont.xinpin,
                  title: '新品推荐',
                  color: theme.primaryColor,
                  child: GridView.builder(
                    padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: math.min(value.rows.length, 3),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: LayoutConstants.pagePadding,
                      mainAxisSpacing: LayoutConstants.pagePadding,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: value.rows[index].imgUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                              ),
                            ),
                          ),
                          _titleBuilder(value.rows[index].prNa),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Selector<HomeInfos, PaginatedResponse<CompanyOrigin>?>(
              selector: (_, model) => model.companyOrigin,
              builder: (context, PaginatedResponse<CompanyOrigin>? value, __) {
                if (value == null || value.rows.isEmpty) return SizedBox.shrink();
                final itemCount = (value.rows.length / 3).ceil();

                return _mainItemBuilder(
                  icon: Iconfont.chandi,
                  title: '玩具产地',
                  color: theme.primaryColor,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final gap = LayoutConstants.pagePadding;
                      final itemWidth = (constraints.maxWidth - gap * 3) / 3;

                      return SizedBox(
                        height: itemWidth * 2 / 3 + _titleHeight,
                        child: CustomSwiper(
                          itemCount: itemCount,
                          defaultPagination: false,
                          autoplayDelay: 5000,
                          itemBuilder: (BuildContext context, int pageIndex) {
                            return Padding(
                              padding: EdgeInsets.only(right: LayoutConstants.pagePadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(3, (itemIndex) {
                                  final dataIndex = pageIndex * 3 + itemIndex;
                                  if (dataIndex >= value.rows.length) {
                                    return SizedBox();
                                  }
                                  final exhibition = value.rows[dataIndex];
                                  return SizedBox(
                                    width: itemWidth,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: exhibition.coverImgUrl,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                                            ),
                                          ),
                                        ),
                                        _titleBuilder(exhibition.title),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
              width: double.infinity,
              height: 160,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CachedNetworkImage(
                imageUrl: 'https://testerp-1303814652.cos.ap-guangzhou.myqcloud.com/Uploads/ProImg/Custom/2063/17642057706011.jpg',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Selector<HomeInfos, PaginatedResponse<ProductItem>?>(
          //     selector: (_, model) => model.recomendProduct,
          //     builder: (context, PaginatedResponse<ProductItem>? value, __) {
          //       if (value == null || value.rows.isEmpty) return SizedBox.shrink();
          //       return SizedBox(
          //         height: 34,
          //         child: Align(
          //           child: Text('推荐产品', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          SliverPadding(
            padding: EdgeInsets.all(LayoutConstants.pagePadding),
            sliver: ProductsView(
              parameter: _smartRefresherParameter,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupplyPage extends StatefulWidget {
  const _SupplyPage();

  @override
  State<_SupplyPage> createState() => __SupplyPageState();
}

class __SupplyPageState extends State<_SupplyPage> {
  final ValueNotifier<List<SalesAdsList>?> _adsList = ValueNotifier<List<SalesAdsList>?>(null);

  final ValueNotifier<SortingParams> _sortingParams = ValueNotifier<SortingParams>(SortingParams());

  late final SmartRefresherParameter _smartRefresherParameter;

  final RefreshController _refreshController = RefreshController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getAdList();
    _initParameter();
  }

  @override
  void dispose() {
    super.dispose();
    _adsList.dispose();
    _sortingParams.dispose();
    _refreshController.dispose();
  }

  void _initParameter() {
    _smartRefresherParameter = SmartRefresherParameter(
      loadList: (int page) => SearchService.queryPage(
        _sortingParams.value.toJson(),
        page: page,
      ),
    );
  }

  Future<void> _getAdList() async {
    final response = await CompanyService.getSalesAdsList({
      "adsType": 0,
      "areaType": 0,
    });
    _adsList.value = response.data;
  }

  void _onTabChange(SortingParams value) {
    if (value != _sortingParams.value) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      Future.delayed(Duration.zero, () {
        _sortingParams.value = value;
      });
    }
  }

  Future<void> _onLoading() async {
    final bool? hasMore = await _smartRefresherParameter.loadmore?.call();
    if (hasMore == false) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<void> _refresh() async {
    _getAdList();
    _sortingParams.value = _sortingParams.value.copyWith();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      _refresh(),
      Future.delayed(Duration(milliseconds: 500)),
    ]);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: SmartRefresherHeader(),
      footer: SmartRefresherFooter(),
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
              child: SizedBox(
                height: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: _adsList,
                    builder: (context, value, child) {
                      if (value == null) return SizedBox.shrink();
                      return CustomSwiper(
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            imageUrl: value[index].imgUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickyHeaderDelegate(
              minHeight: 40.0,
              maxHeight: 40.0,
              child: Container(
                color: Colors.white,
                child: SortingTabBar(
                  params: _sortingParams.value,
                  onChange: _onTabChange,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(LayoutConstants.pagePadding),
            sliver: ValueListenableBuilder(
              valueListenable: _sortingParams,
              builder: (context, SortingParams value, _) {
                return ProductsView(
                  key: ObjectKey(value),
                  parameter: _smartRefresherParameter,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // shrinkOffset：滚动偏移量
    // overlapsContent：是否与其他内容重叠
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
