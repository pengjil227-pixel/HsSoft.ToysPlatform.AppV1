import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/layout_constants.dart';
import '../../../core/network/modules/factory_service.dart';
import '../../../core/providers/home_infos.dart';
import '../../../shared/models/sales_ads_list.dart';
import '../../../shared/models/source_supplier.dart';
import '../../../widgets/custom_swiper.dart';
import 'factory_list_page.dart';
import 'factory_product_card.dart';

class FactoryPage extends StatefulWidget {
  const FactoryPage({super.key});

  @override
  State<FactoryPage> createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  final PageController _newArrivalsController = PageController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int _newArrivalsIndex = 0;

  // 最新入驻
  static const int _latestPageSize = 12;
  int _latestPage = 1;
  bool _hasMoreLatest = true;
  bool _loadingLatest = true;
  List<SourceSupplier> _latestSuppliers = [];
  String? _errorLatest;

  // 推荐厂商
  static const int _recommendPageSize = 10;
  int _recommendPage = 1;
  bool _hasMoreRecommend = true;
  bool _loadingRecommend = true;
  List<SourceSupplier> _recommendSuppliers = [];
  String? _errorRecommend;

  // 全部厂商
  static const int _allPageSize = 20;
  int _allPage = 1;
  bool _hasMoreAll = true;
  bool _loadingAll = true;
  List<SourceSupplier> _suppliers = [];
  String? _errorAll;

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await Future.wait([
      _loadLatest(page: 1),
      _loadRecommend(page: 1),
      _loadAllSuppliers(page: 1),
    ]);
  }

  Future<bool> _loadAllSuppliers({required int page, bool append = false}) async {
    if (!append) {
      setState(() {
        _loadingAll = true;
        _errorAll = null;
      });
    }

    try {
      final res = await FactoryService.querySourceSupplierPage(
        pageNo: page,
        pageSize: _allPageSize,
        keywords: '',
      );
      if (!mounted) return false;
      if (res.success && res.data != null) {
        setState(() {
          final rows = res.data!.rows;
          if (append) {
            _suppliers.addAll(rows);
          } else {
            _suppliers = rows;
          }
          _allPage = page;
          _hasMoreAll = rows.length == _allPageSize;
          _loadingAll = false;
          _errorAll = null;
        });
        return true;
      } else {
        setState(() {
          _loadingAll = false;
          _errorAll = res.message;
        });
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _loadingAll = false;
        _errorAll = e.toString();
      });
      return false;
    }
  }

  Future<bool> _loadLatest({required int page, bool append = false}) async {
    if (!append) {
      setState(() {
        _loadingLatest = true;
        _errorLatest = null;
      });
    }

    try {
      final res = await FactoryService.queryLatestSupplierPage(
        pageNo: page,
        pageSize: _latestPageSize,
      );
      if (!mounted) return false;
      if (res.success && res.data != null) {
        setState(() {
          final rows = res.data!.rows;
          if (append) {
            _latestSuppliers.addAll(rows);
          } else {
            _latestSuppliers = rows;
          }
          _latestPage = page;
          _hasMoreLatest = rows.length == _latestPageSize;
          _loadingLatest = false;
          _errorLatest = null;
        });
        return true;
      } else {
        setState(() {
          _loadingLatest = false;
          _errorLatest = res.message;
        });
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _loadingLatest = false;
        _errorLatest = e.toString();
      });
      return false;
    }
  }

  Future<bool> _loadRecommend({required int page, bool append = false}) async {
    if (!append) {
      setState(() {
        _loadingRecommend = true;
        _errorRecommend = null;
      });
    }

    try {
      final res = await FactoryService.queryRecommendSupplierPage(
        pageNo: page,
        pageSize: _recommendPageSize,
      );
      if (!mounted) return false;
      if (res.success && res.data != null) {
        setState(() {
          final rows = res.data!.rows.map((e) => SourceSupplier.fromRecommend(e)).toList();
          if (append) {
            _recommendSuppliers.addAll(rows);
          } else {
            _recommendSuppliers = rows;
          }
          _recommendPage = page;
          _hasMoreRecommend = rows.length == _recommendPageSize;
          _loadingRecommend = false;
          _errorRecommend = null;
        });
        return true;
      } else {
        setState(() {
          _loadingRecommend = false;
          _errorRecommend = res.message;
        });
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _loadingRecommend = false;
        _errorRecommend = e.toString();
      });
      return false;
    }
  }

  Future<void> _onRefresh() async {
    try {
      final results = await Future.wait([
        _loadLatest(page: 1),
        _loadRecommend(page: 1),
        _loadAllSuppliers(page: 1),
      ]);

      if (results.any((e) => e == false)) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.refreshCompleted();
        _refreshController.resetNoData();
      }
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoading() async {
    if (_isLoadingMore) return;
    if (!mounted) return;

    if (!_hasMoreAll && !_hasMoreLatest && !_hasMoreRecommend) {
      _refreshController.loadNoData();
      return;
    }

    _isLoadingMore = true;
    try {
      final results = await Future.wait([
        _hasMoreLatest ? _loadLatest(page: _latestPage + 1, append: true) : Future.value(true),
        _hasMoreRecommend ? _loadRecommend(page: _recommendPage + 1, append: true) : Future.value(true),
        _hasMoreAll ? _loadAllSuppliers(page: _allPage + 1, append: true) : Future.value(true),
      ]);

      if (results.any((e) => e == false)) {
        _refreshController.loadFailed();
      } else if (!_hasMoreAll && !_hasMoreLatest && !_hasMoreRecommend) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    } catch (_) {
      _refreshController.loadFailed();
    } finally {
      _isLoadingMore = false;
    }
  }

  void _goToFactoryListPage([FactoryListType type = FactoryListType.all]) {
    context.pushNamed('factoryList', extra: type);
  }

  @override
  void dispose() {
    _newArrivalsController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: CustomScrollView(
          slivers: [
            // --- 0. 顶部轮播图 ---
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(
                    left: LayoutConstants.pagePadding,
                    right: LayoutConstants.pagePadding,
                    top: 10,
                    bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Selector<HomeInfos, List<SalesAdsList>?>(
                      selector: (_, model) => model.salesAdsList,
                      builder: (context, value, _) {
                        if (value == null || value.isEmpty) {
                          return CustomSwiper(
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.network(
                                'https://picsum.photos/300/160?i=$index',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                              );
                            },
                          );
                        }
                        return CustomSwiper(
                          itemCount: value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              value[index].imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // --- 1. 最新入驻 ---
            SliverToBoxAdapter(
              child: _buildNewArrivals(),
            ),

            // --- 2. 推荐厂商 ---
            SliverToBoxAdapter(
              child: _buildRecommendedFactory(),
            ),

            // --- 3. 全部厂商标题栏 ---
            SliverToBoxAdapter(
              child: _buildAllFactoriesHeader(),
            ),

            // --- 4. 全部厂商列表 ---
            _buildSupplierList(),

            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  // ================= 模块构建方法 =================

  Widget _buildAllFactoriesHeader() {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(
          LayoutConstants.pagePadding, 10, LayoutConstants.pagePadding, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF9000),
            Color(0xFFFFC400),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const Text(
            '全部厂商',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _goToFactoryListPage(FactoryListType.all),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_right, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // --- 模块 1: 最新入驻 ---
  Widget _buildNewArrivals() {
    final theme = Theme.of(context);
    final itemCount = _latestSuppliers.length;
    final pageCount = itemCount == 0 ? 1 : (itemCount / 6).ceil();

    return Container(
      margin: const EdgeInsets.only(
          left: LayoutConstants.pagePadding,
          right: LayoutConstants.pagePadding,
          bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(
              children: [
                Icon(Iconfont.xinpin, size: 18, color: theme.primaryColor),
                const SizedBox(width: 6),
                const Text('最新入驻', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _goToFactoryListPage(FactoryListType.latest),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: _loadingLatest
                ? const Center(child: CircularProgressIndicator())
                : _errorLatest != null
                    ? Center(child: Text('加载失败：$_errorLatest'))
                    : itemCount == 0
                        ? const Center(child: Text('暂无数据'))
                        : PageView.builder(
                            controller: _newArrivalsController,
                            itemCount: pageCount,
                            onPageChanged: (index) {
                              setState(() {
                                _newArrivalsIndex = index;
                              });
                            },
                            itemBuilder: (context, pageIndex) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(6, (index) {
                                    final dataIndex = pageIndex * 6 + index;
                                    final item = dataIndex < itemCount ? _latestSuppliers[dataIndex] : null;
                                    return Expanded(
                                      child: _buildFactoryItem(item),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pageCount, (index) {
                return Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _newArrivalsIndex == index
                        ? const Color(0xFFCACFD2)
                        : const Color(0xFFEEEEEE),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // --- 模块 2: 推荐厂商 ---
  Widget _buildRecommendedFactory() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(
          left: LayoutConstants.pagePadding,
          right: LayoutConstants.pagePadding,
          bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Iconfont.tuijian, size: 18, color: theme.primaryColor),
                const SizedBox(width: 6),
                const Text('推荐厂商',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () => _goToFactoryListPage(FactoryListType.recommend),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ),
                ),
              ],
            ),
          ),
          if (_loadingRecommend)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            )
          else if (_errorRecommend != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('加载失败：$_errorRecommend', style: const TextStyle(color: Colors.red)),
            )
          else if (_recommendSuppliers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('暂无推荐厂商'),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.6,
              ),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              itemCount: _recommendSuppliers.length,
              itemBuilder: (context, index) => _buildRecommendedItem(_recommendSuppliers[index]),
            ),
        ],
      ),
    );
  }

  // --- 点击跳转逻辑：最新入驻小图标 ---
  Widget _buildFactoryItem(SourceSupplier? supplier) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('factoryDetail', extra: supplier);
      },
      behavior: HitTestBehavior.opaque, // 扩大点击区域
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            clipBehavior: Clip.hardEdge,
            child: supplier?.supplierLogo?.isNotEmpty == true
                ? Image.network(
                    supplier!.supplierLogo!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            supplier?.supplierName ?? '厂商',
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 点击跳转逻辑：推荐厂商卡片 ---
  Widget _buildRecommendedItem(SourceSupplier supplier) {
    return GestureDetector(
      onTap: () {
        context.pushNamed('factoryDetail', extra: supplier);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.hardEdge,
              child: supplier.supplierLogo?.isNotEmpty == true
                  ? Image.network(
                      supplier.supplierLogo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                    )
                  : Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    supplier.supplierName ?? '厂商名称',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    supplier.industryNames ?? '主营：--',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierList() {
    if (_loadingAll) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_errorAll != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '加载失败：$_errorAll',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_suppliers.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('暂无厂商数据')),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FactoryProductCard(supplier: _suppliers[index]),
            );
          },
          childCount: _suppliers.length,
        ),
      ),
    );
  }
}
