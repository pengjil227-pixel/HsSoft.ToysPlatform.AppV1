import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import '../../../core/constants/layout_constants.dart';

class FactoryDetailPage extends StatefulWidget {
  const FactoryDetailPage({super.key});

  @override
  State<FactoryDetailPage> createState() => _FactoryDetailPageState();
}

class _FactoryDetailPageState extends State<FactoryDetailPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bgColor = Color(0xFFF4F4F4);

    // 商品小组件宽高比 176 : 184
    const double itemAspectRatio = 176 / 184;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          '厂商详情',
          style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconfont.fanhuianniu, color: Colors.black, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // 1. 厂商信息
          SliverToBoxAdapter(
            child: _buildFactoryInfoSection(),
          ),

          // 2. 大图片 Banner (宽高比 375:210)
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 375 / 210,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Image.network(
                  'https://picsum.photos/750/420',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 3. 最新产品
          SliverToBoxAdapter(
            child: _buildNewProductsSection(theme, itemAspectRatio),
          ),

          // 4. 推荐产品标题
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: _buildSectionHeader(theme, '推荐产品'),
            ),
          ),

          // 5. 推荐产品列表
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }

  // --- 组件 1: 厂商信息 ---
  Widget _buildFactoryInfoSection() {
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
            // 头像
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: const Color(0xFFF0F0F0), width: 0.5),
              ),
            ),
            const SizedBox(width: 10),
            // 中间信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '****厂商',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '产品: 88   关注: 88',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 右侧按钮
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(Iconfont.tianjiaguanzhu1, '关注'),
                const SizedBox(height: 10),
                _buildActionButton(Iconfont.dianhua1, '联系'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    const color = Color(0xFFFF9700);
    return Container(
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
    );
  }

  // --- 组件 3: 最新产品 ---
  Widget _buildNewProductsSection(ThemeData theme, double itemAspectRatio) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: _buildSectionHeader(theme, '最新产品'),
          ),

          // 横向滚动列表
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
                        children: [
                          const Expanded(child: _ProductItem()),
                          const SizedBox(width: 10),
                          const Expanded(child: _ProductItem()),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // 底部指示器
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
                    color: _currentIndex == index
                        ? theme.primaryColor
                        : const Color(0xFFCACFD2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // --- 通用标题栏 ---
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
}

// --- 核心商品小组件 ---
class _ProductItem extends StatelessWidget {
  const _ProductItem();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const itemBgColor = Color(0xFFF4F4F4);

    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: itemBgColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 图片区域
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                  child: AspectRatio(
                    aspectRatio: 170 / 102,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      child: Image.network(
                        'https://picsum.photos/340/204',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                  ),
                ),

                // 2. 内容区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 标题
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

                        // 价格与货号
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
                                style:
                                TextStyle(fontSize: 10, color: Color(0xFF999999)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // 厂名与加号
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'XXX玩具厂',
                                style:
                                TextStyle(fontSize: 10, color: Color(0xFF999999)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // 红色实心加号
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 16),
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

// 辅助类
class SliverContainer extends StatelessWidget {
  final Widget sliver;
  final Decoration decoration;

  const SliverContainer(
      {super.key, required this.sliver, required this.decoration});

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
