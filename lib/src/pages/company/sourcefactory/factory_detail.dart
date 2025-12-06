import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';

import '../../../core/network/modules/factory_service.dart';
import '../../../shared/models/source_supplier.dart';
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
      } else {
        setState(() {
          _loading = false;
          _error = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
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
          padding: const EdgeInsets.only(top: 12),
          sliver: SliverContainer(
            decoration: const BoxDecoration(color: Colors.white),
            sliver: SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const _ProductItem();
                  },
                  childCount: 20,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: itemAspectRatio,
                ),
              ),
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
          LayoutBuilder(
            builder: (context, constraints) {
              double totalWidth = constraints.maxWidth;
              double itemWidth = (totalWidth - 24 - 10) / 2;
              double itemHeight = itemWidth / itemAspectRatio;

              return SizedBox(
                height: itemHeight,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: const [
                          Expanded(child: _ProductItem()),
                          SizedBox(width: 10),
                          Expanded(child: _ProductItem()),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
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
}

class _ProductItem extends StatelessWidget {
  const _ProductItem();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const itemBgColor = Color(0xFFF4F4F4);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: itemBgColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
              child: AspectRatio(
                aspectRatio: 170 / 102,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  child: Image.network(
                    'https://picsum.photos/340/204',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300]),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '充气涂鸦充气长颈鹿',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '¥15.4',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            '[出厂货号]',
                            style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'XXX玩具厂',
                            style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
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
