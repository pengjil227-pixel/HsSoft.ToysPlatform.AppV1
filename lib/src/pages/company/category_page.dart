import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../core/network/modules/product_service.dart';
import '../../shared/models/product_class_model.dart';
import '../../core/network/http_config.dart';
import '../../core/network/modules/product_service.dart'; // 用于拼接图片域名

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int _selectedIndex = 0;
  bool _isClickScrolling = false;
  bool _isLoading = true;

  // 扁平化数据源
  final List<dynamic> _flatItems = [];
  // 左侧一级菜单
  final List<ProductClassModel> _leftCategories = [];
  // 索引映射
  final List<int> _categoryHeaderIndices = [];

  final Color _unselectedColor = const Color(0xFFEEEEEE);
  final Color _backgroundColor = const Color(0xFFF4F4F4);

  @override
  void initState() {
    super.initState();
    _fetchData();
    _itemPositionsListener.itemPositions.addListener(_onRightScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onRightScroll);
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await ProductService.getProductClassList();
      if (response.success && response.data != null) {
        _processData(response.data!);
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _processData(List<ProductClassModel> treeData) {
    _flatItems.clear();
    _categoryHeaderIndices.clear();
    _leftCategories.clear();

    for (int i = 0; i < treeData.length; i++) {
      var level1 = treeData[i];
      _leftCategories.add(level1);

      // 1. 记录标题位置
      _categoryHeaderIndices.add(_flatItems.length);

      // 2. 添加标题
      _flatItems.add(HeaderItem(title: level1.name, categoryIndex: i));

      // 3. 处理子分类 (每3个一行)
      List<ProductClassModel> subCategories = level1.children;
      if (subCategories.isNotEmpty) {
        for (int j = 0; j < subCategories.length; j += 3) {
          int end = (j + 3 < subCategories.length) ? j + 3 : subCategories.length;
          _flatItems.add(ProductRowItem(
            products: subCategories.sublist(j, end),
            categoryIndex: i,
          ));
        }
      } else {
        // 如果没有子分类，可以加个提示或者空行，这里暂时不处理
      }
    }
  }

  void _onRightScroll() {
    if (_isClickScrolling) return;
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    int minIndex = positions
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
    position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;

    if (minIndex < _flatItems.length) {
      var item = _flatItems[minIndex];
      int currentCategoryIndex = 0;
      if (item is HeaderItem) {
        currentCategoryIndex = item.categoryIndex;
      } else if (item is ProductRowItem) {
        currentCategoryIndex = item.categoryIndex;
      }

      if (currentCategoryIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = currentCategoryIndex;
        });
      }
    }
  }

  Future<void> _onLeftTap(int index) async {
    setState(() {
      _selectedIndex = index;
      _isClickScrolling = true;
    });

    if (index < _categoryHeaderIndices.length) {
      await _itemScrollController.scrollTo(
        index: _categoryHeaderIndices[index],
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _isClickScrolling = false;
      }
    });
  }

  // --- 图片处理辅助函数 ---
  String _getImageUrl(String? path) {

    print('图片原始路径: $path');

    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    String fullPath = '${HttpConfig.baseUrl}$path';

    print('图片完整地址: $fullPath');
    // 如果返回的是相对路径，拼接上 baseUrl

    return fullPath;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('产品分类'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 左侧菜单 ---
          Container(
            width: 94,
            color: _unselectedColor,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _leftCategories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onLeftTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    color: isSelected ? _backgroundColor : _unselectedColor,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            _leftCategories[index].name,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? primaryColor : const Color(0xFF333333),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 20,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // --- 右侧内容 ---
          Expanded(
            child: Container(
              color: _backgroundColor,
              child: ScrollablePositionedList.builder(
                itemCount: _flatItems.length,
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final item = _flatItems[index];

                  if (item is HeaderItem) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    );
                  } else if (item is ProductRowItem) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: item.products.map((product) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      _getImageUrl(product.img),
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Image.asset('assets/images/logo.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF666666),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                          ..addAll(List.generate(
                            3 - item.products.length,
                                (index) => const Expanded(child: SizedBox()),
                          )),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderItem {
  final String title;
  final int categoryIndex;
  HeaderItem({required this.title, required this.categoryIndex});
}

class ProductRowItem {
  final List<ProductClassModel> products;
  final int categoryIndex;
  ProductRowItem({required this.products, required this.categoryIndex});
}