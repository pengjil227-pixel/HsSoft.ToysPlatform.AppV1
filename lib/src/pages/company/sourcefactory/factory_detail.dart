import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../../core/network/modules/factory_service.dart';
import '../../../core/providers/goods_detail_info.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/source_supplier.dart';
import '../../../widgets/goods_item.dart';
import '../../../widgets/products_view.dart';
import 'widgets/contact_dialog.dart';

class FactoryDetailPage extends StatefulWidget {
  const FactoryDetailPage({super.key, this.supplier});

  final SourceSupplier? supplier;

  @override
  State<FactoryDetailPage> createState() => _FactoryDetailPageState();
}

class _FactoryDetailPageState extends State<FactoryDetailPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  SupplierDetail? _detail;
  SupplierContact? _contact;
  bool _loading = true;
  String? _error;
  bool _contactLoading = false;
  String? _contactError;
  bool _loadingRecommendProducts = true;
  String? _errorRecommendProducts;
  List<ProductItem> _recommendProducts = [];
  bool _loadingLatestProducts = true;
  String? _errorLatestProducts;
  List<ProductItem> _latestProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchContact() async {
    if (_detail?.id == null) return;
    setState(() {
      _contactLoading = true;
      _contactError = null;
    });
    try {
      final res = await FactoryService.getSupplierContact(id: _detail!.id!);
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _contact = res.data;
          _contactLoading = false;
        });
      } else {
        setState(() {
          _contactLoading = false;
          _contactError = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _contactLoading = false;
        _contactError = e.toString();
      });
    }
  }

  Future<void> _fetchDetail() async {
    try {
      final res = await FactoryService.getSupplierDetail(
        id: widget.supplier?.id,
        supplierNumber: widget.supplier?.supplierNumber,
      );
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _detail = res.data;
          _loading = false;
        });
        _loadRecommendProducts();
        _loadLatestProducts();
      } else {
        setState(() {
          _loading = false;
          _error = res.message;
        });
        _loadRecommendProducts();
        _loadLatestProducts();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      _loadRecommendProducts();
      _loadLatestProducts();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bgColor = Color(0xFFF4F4F4);

    const double itemAspectRatio = 176 / 184;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _detail?.companyName ?? widget.supplier?.supplierName ?? '厂商详情',
          style: const TextStyle(color: Color(0xFF333333), fontSize: 17, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconfont.fanhuianniu, color: Colors.black, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(theme, itemAspectRatio),
    );
  }

  Widget _buildBody(ThemeData theme, double itemAspectRatio) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('加载失败：$_error'));
    }
    if (_detail == null) {
      return const Center(child: Text('暂无数据'));
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildFactoryInfoSection()),
        SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 375 / 210,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Image.network(
                (_detail?.bgImg?.isNotEmpty ?? false) ? _detail!.bgImg! : 'https://picsum.photos/750/420',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildNewProductsSection(theme, itemAspectRatio)),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
            child: _buildSectionHeader(theme, '推荐产品'),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverContainer(
            decoration: const BoxDecoration(color: Colors.white),
            sliver: Builder(
              builder: (context) {
                if (_loadingRecommendProducts) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (_errorRecommendProducts != null) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          '加载失败：$_errorRecommendProducts',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }

                if (_recommendProducts.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('暂无推荐产品')),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                  sliver: SliverGrid.builder(
                    itemCount: _recommendProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: itemAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final item = _recommendProducts[index];
                      void openDetail() {
                        context.pushNamed(
                          'goodsDetail',
                          pathParameters: {'index': index.toString()},
                          extra: ProductsParameters(
                            products: _recommendProducts,
                            index: index,
                            loadmore: () async => false,
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: openDetail,
                        child: GoodsItem(
                          item: item,
                          showActionButton: true,
                          onActionTap: openDetail,
                          backgroundColor: const Color(0xFFF4F4F4),
                          imagePadding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                          imageOuterPadding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildFactoryInfoSection() {
    final logo = _detail?.companyLogo ?? widget.supplier?.supplierLogo;
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AspectRatio(
        aspectRatio: 360 / 86,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.pushNamed('factoryName', extra: _detail ?? widget.supplier),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFF0F0F0), width: 0.5),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: logo != null && logo.isNotEmpty
                          ? Image.network(
                              logo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                            )
                          : Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _detail?.companyName ?? widget.supplier?.supplierName ?? '厂商',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '产品: ${_detail?.onCount ?? '--'}   关注: ${_detail?.followCount ?? '--'}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Iconfont.tianjiaguanzhu1, '关注'),
                const SizedBox(height: 10),
                _buildActionButton(Iconfont.dianhua1, '联系', onTap: _showContactDialog),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
    const color = Color(0xFFFF9700);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: color, height: 1.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProductsSection(ThemeData theme, double itemAspectRatio) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: _buildSectionHeader(theme, '最新产品'),
          ),
          if (_loadingLatestProducts)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorLatestProducts != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  '加载失败：$_errorLatestProducts',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else if (_latestProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text('暂无最新产品')),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final itemWidth = (totalWidth - 16 - 8) / 2; // 左右各 8，间距 8
                final itemHeight = itemWidth / itemAspectRatio;
                final pageCount = (_latestProducts.length / 2).ceil();

                return Column(
                  children: [
                    SizedBox(
                      height: itemHeight,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: pageCount,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, pageIndex) {
                          final leftIndex = pageIndex * 2;
                          final rightIndex = leftIndex + 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildGoodsItemCard(_latestProducts[leftIndex], leftIndex),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: rightIndex < _latestProducts.length
                                ? _buildGoodsItemCard(_latestProducts[rightIndex], rightIndex)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                        },
                      ),
                    ),
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(pageCount, (index) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index ? theme.primaryColor : const Color(0xFFCACFD2),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF999999)),
      ],
    );
  }

  Widget _buildGoodsItemCard(ProductItem item, int indexInList) {
    void openDetail() {
      context.pushNamed(
        'goodsDetail',
        pathParameters: {'index': indexInList.toString()},
        extra: ProductsParameters(
          products: _latestProducts,
          index: indexInList,
          loadmore: () async => false,
        ),
      );
    }

    return GestureDetector(
      onTap: openDetail,
      child: GoodsItem(
        item: item,
        showActionButton: true,
        onActionTap: openDetail,
        backgroundColor: const Color(0xFFF4F4F4),
        imagePadding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
        imageOuterPadding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
      ),
    );
  }

  void _showContactDialog() async {
    if (_contact == null && !_contactLoading) {
      await _fetchContact();
    }
    if (!mounted) return;
    showFactoryContactDialog(
      context,
      primaryColor: Theme.of(context).primaryColor,
      detail: _detail,
      contact: _contact,
      loading: _contactLoading,
      error: _contactError,
    );
  }

  String? get _supplierNumber => _detail?.supplierNumber ?? widget.supplier?.supplierNumber;

  Future<void> _loadLatestProducts() async {
    final supplierNumber = _supplierNumber;
    if (supplierNumber == null || supplierNumber.isEmpty) {
      setState(() {
        _loadingLatestProducts = false;
        _latestProducts = [];
      });
      return;
    }

    setState(() {
      _loadingLatestProducts = true;
      _errorLatestProducts = null;
    });

    try {
      final res = await FactoryService.querySupplierDetailProductPage(
        pageNo: 1,
        pageSize: 20,
        searchType: 1, // 1: 最新产品（约定值，如有不同请调整）
        supplierNumber: supplierNumber,
      );
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _latestProducts = res.data!.rows;
          _loadingLatestProducts = false;
        });
      } else {
        setState(() {
          _loadingLatestProducts = false;
          _errorLatestProducts = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingLatestProducts = false;
        _errorLatestProducts = e.toString();
      });
    }
  }

  Future<void> _loadRecommendProducts() async {
    final supplierNumber = _supplierNumber;
    if (supplierNumber == null || supplierNumber.isEmpty) {
      setState(() {
        _loadingRecommendProducts = false;
        _recommendProducts = [];
      });
      return;
    }

    setState(() {
      _loadingRecommendProducts = true;
      _errorRecommendProducts = null;
    });

    try {
      final res = await FactoryService.querySupplierDetailProductPage(
        pageNo: 1,
        pageSize: 20,
        searchType: 2, // 2: 推荐产品（约定值，如有不同请调整）
        supplierNumber: supplierNumber,
      );
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _recommendProducts = res.data!.rows;
          _loadingRecommendProducts = false;
        });
      } else {
        setState(() {
          _loadingRecommendProducts = false;
          _errorRecommendProducts = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingRecommendProducts = false;
        _errorRecommendProducts = e.toString();
      });
    }
  }
}

class SliverContainer extends StatelessWidget {
  final Widget sliver;
  final Decoration decoration;

  const SliverContainer({super.key, required this.sliver, required this.decoration});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: decoration,
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [sliver],
        ),
      ),
    );
  }
}
