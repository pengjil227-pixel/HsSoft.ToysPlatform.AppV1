import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 引入路由
import '../../../core/constants/layout_constants.dart';
import 'package:iconfont/iconfont.dart';
import '../../../widgets/custom_swiper.dart';
import 'factory_product_card.dart';

class FactoryPage extends StatefulWidget {
  const FactoryPage({super.key});

  @override
  State<FactoryPage> createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  final PageController _newArrivalsController = PageController();
  int _newArrivalsIndex = 0;

  // 模拟数据总量
  final int _dataCount = 20;

  void _goToFactoryListPage() {
    context.pushNamed('factoryList');
  }

  void _goToFactoryNamePage() {
    context.pushNamed('factoryName');
  }

  @override
  void dispose() {
    _newArrivalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: CustomScrollView(
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
                  child: CustomSwiper(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        'https://picsum.photos/300/160?i=$index',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/logo.png', fit: BoxFit.cover),
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

          // --- 3. 全部厂商标题栏 (橙色渐变 Bar) ---
          SliverToBoxAdapter(
            child: _buildAllFactoriesHeader(),
          ),

          // --- 4. 厂商产品列表 (懒加载) ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return const FactoryProductCard();
                },
                childCount: _dataCount,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
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
            onTap: _goToFactoryListPage,
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
                const Text('最新入驻',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: _goToFactoryListPage,
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
            child: PageView.builder(
              controller: _newArrivalsController,
              itemCount: 3,
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
                      return Expanded(
                        child: _buildFactoryItem(),
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
              children: List.generate(3, (index) {
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
                  onTap: _goToFactoryListPage,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            childAspectRatio: 2.6,
            children: List.generate(6, (index) => _buildRecommendedItem()),
          ),
        ],
      ),
    );
  }

  // --- 点击跳转逻辑：最新入驻小图标 ---
  Widget _buildFactoryItem() {
    return GestureDetector(
      onTap: () {
        context.pushNamed('factoryDetail');
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
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '宏升玩具',
            style: TextStyle(fontSize: 12, color: Color(0xFF333333)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 点击跳转逻辑：推荐厂商卡片 ---
  Widget _buildRecommendedItem() {
    return GestureDetector(
      onTap: () {
        context.pushNamed('factoryDetail');
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
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '厂商名称',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '主营：电动玩具...',
                    style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
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
}
