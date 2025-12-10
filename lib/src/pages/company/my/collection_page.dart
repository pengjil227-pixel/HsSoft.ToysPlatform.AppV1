import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';

import '../../../core/constants/layout_constants.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isManageMode = false;
  final Set<int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '我的收藏 (12)',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Iconfont.sousuo1, color: Colors.black, size: 20),
            onPressed: () {
              // TODO: 搜索收藏
            },
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isManageMode = !_isManageMode;
                if (!_isManageMode) {
                  _selectedItems.clear();
                }
              });
            },
            child: Text(
              _isManageMode ? '完成' : '管理',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFFF9700),
              unselectedLabelColor: const Color(0xFF666666),
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              indicatorColor: const Color(0xFFFF9700),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: '商品'),
                Tab(text: '店铺'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(),
          _buildShopList(),
        ],
      ),
      bottomNavigationBar: _isManageMode
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: LayoutConstants.pagePadding,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Checkbox(
                      value: _tabController.index == 0
                          ? _selectedItems.length == 5
                          : _selectedItems.length == 9,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            if (_tabController.index == 0) {
                              _selectedItems.addAll([0, 1, 2, 3, 4]);
                            } else {
                              _selectedItems.addAll([0, 1, 2, 3, 4, 5, 6, 7, 8]);
                            }
                          } else {
                            _selectedItems.clear();
                          }
                        });
                      },
                    ),
                    const Text('全选', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _selectedItems.isEmpty
                          ? null
                          : () {
                              // TODO: 删除选中的收藏
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        '取消收藏 (${_selectedItems.length})',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      padding: const EdgeInsets.all(LayoutConstants.pagePadding),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildProductItem(index);
      },
    );
  }

  Widget _buildProductItem(int index) {
    final ThemeData theme = Theme.of(context);
    final isSelected = _selectedItems.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isManageMode)
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 30),
              child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedItems.add(index);
                    } else {
                      _selectedItems.remove(index);
                    }
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '拉布布溜溜球',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '¥15.4',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '5000人收藏',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!_isManageMode)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: theme.primaryColor,
                          size: 28,
                        ),
                        onPressed: () {
                          // TODO: 添加到购物车
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopList() {
    // TODO: 这里应该从服务器获取收藏的店铺数据
    // 暂时使用模拟数据
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 9, // 示例数据：9个店铺
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _buildShopItem(index),
        );
      },
    );
  }

  Widget _buildShopItem(int index) {
    final isSelected = _selectedItems.contains(index);

    return GestureDetector(
      onTap: _isManageMode
          ? null
          : () {
              // TODO: 跳转到店铺详情页面
            },
      child: Column(
        children: [
          // 店铺信息行
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_isManageMode)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.remove(index);
                        } else {
                          _selectedItems.add(index);
                        }
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFCCCCCC),
                          width: 2,
                        ),
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                // 店铺Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 店铺信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '厂商名称',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Text(
                            '产品：',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            '88',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 24),
                          Text(
                            '摊位：',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                          Text(
                            '88',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 箭头图标
                if (!_isManageMode)
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFCCCCCC),
                    size: 24,
                  ),
              ],
            ),
          ),
          // 商品网格 - 只在非管理模式下显示
          if (!_isManageMode) _buildShopProductGrid(),
        ],
      ),
    );
  }

  Widget _buildShopProductGrid() {
    // 计算左边距：管理模式下需要加上圆圈和间距的宽度（20 + 12 = 32）
    final leftPadding = _isManageMode ? 48.0 : 16.0;

    return Container(
      padding: EdgeInsets.fromLTRB(leftPadding, 0, 16, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: 3, // 每个店铺显示3个商品
        itemBuilder: (context, index) {
          return _buildShopProductItem(index);
        },
      ),
    );
  }

  Widget _buildShopProductItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 商品图片 - 完全撑开矩形
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // 商品名称 - 在矩形下面居中
        Text(
          '拉布布溜溜球',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
