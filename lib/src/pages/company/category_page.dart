import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  // --- 核心变化 1：扁平化数据源 ---
  // 不再存 CategoryModel，而是存每一“行”的数据
  final List<dynamic> _flatItems = [];

  // --- 核心变化 2：索引映射表 ---
  // 记录每个分类的标题在 _flatItems 里的位置（index）
  // 比如：索引 0 的“遥控玩具”在 _flatItems 的第 0 个
  // 索引 1 的“电动玩具”在 _flatItems 的第 5 个（假设遥控玩具有4行商品）
  final List<int> _categoryHeaderIndices = [];

  // 左侧菜单数据
  final List<String> _categories = [
    "遥控玩具", "电动玩具", "变形类", "线控玩具", "拉线类",
    "滑行类", "力控玩具", "回力系列", "惯性玩具", "军警",
    "海盗类", "战具系列", "枪系列", "弹射类", "体育用品",
    "夏日玩具", "礼品精品"
  ];

  // 颜色常量
  final Color _unselectedColor = const Color(0xFFEEEEEE);
  final Color _backgroundColor = const Color(0xFFF4F4F4);

  @override
  void initState() {
    super.initState();
    _initFlattenData();
    _itemPositionsListener.itemPositions.addListener(_onRightScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onRightScroll);
    super.dispose();
  }

  // --- 初始化并“拍平”数据 ---
  void _initFlattenData() {
    _flatItems.clear();
    _categoryHeaderIndices.clear();

    for (int i = 0; i < _categories.length; i++) {
      // 1. 记录当前分类标题在扁平列表中的位置
      _categoryHeaderIndices.add(_flatItems.length);

      // 2. 添加标题行
      _flatItems.add(HeaderItem(title: _categories[i], categoryIndex: i));

      // 3. 生成模拟商品数据
      List<ProductModel> products = List.generate(RandomData.randomInt(6, 15), (j) {
        return ProductModel(
          name: "${_categories[i]}-$j",
          image: "https://picsum.photos/200/200?random=$i$j",
        );
      });

      // 4. 将商品拆分成“行”，每行3个，放入列表
      // 这样就不需要 GridView 了，直接用 Row 渲染，性能极高
      for (int j = 0; j < products.length; j += 3) {
        int end = (j + 3 < products.length) ? j + 3 : products.length;
        _flatItems.add(ProductRowItem(
          products: products.sublist(j, end),
          categoryIndex: i, // 记录这一行属于哪个分类，用于反向高亮左侧
        ));
      }
    }
  }

  void _onRightScroll() {
    if (_isClickScrolling) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // 找到当前屏幕最上面那个 Item
    int minIndex = positions
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
    position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;

    // 获取这个 Item 属于哪个分类索引
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

    // 核心变化 3：跳转时，去查找该分类标题在扁平列表里的真实索引
    int targetIndex = _categoryHeaderIndices[index];

    await _itemScrollController.scrollTo(
      index: targetIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _isClickScrolling = false;
      }
    });
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 左侧菜单栏 (逻辑不变) ---
          Container(
            width: 94,
            color: _unselectedColor,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _categories.length,
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
                            _categories[index],
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
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    topRight: Radius.circular(2),
                                  ),
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

          // --- 右侧内容区 (完全重构) ---
          Expanded(
            child: Container(
              color: _backgroundColor,
              child: ScrollablePositionedList.builder(
                itemCount: _flatItems.length, // 现在的 item 总数变多了
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  final item = _flatItems[index];

                  // --- 渲染标题 ---
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
                  }

                  // --- 渲染商品行 (一行3个) ---
                  else if (item is ProductRowItem) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10), // 行间距
                      child: Row(
                        children: item.products.map((product) {
                          return Expanded(
                            child: Container(
                              // 给每个商品卡片加点间距
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  // 图片
                                  Container(
                                    width: 70, // 这里的宽受 Expanded 约束，主要靠 height 撑
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white, // 图片底色白
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Image.asset('assets/images/logo.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // 名字
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
                        // 如果这一行不足3个，需要补透明占位符保持布局对齐
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

// --- 数据类 ---

// 1. 标题行数据结构
class HeaderItem {
  final String title;
  final int categoryIndex;
  HeaderItem({required this.title, required this.categoryIndex});
}

// 2. 商品行数据结构 (每行3个)
class ProductRowItem {
  final List<ProductModel> products;
  final int categoryIndex;
  ProductRowItem({required this.products, required this.categoryIndex});
}

class ProductModel {
  final String name;
  final String image;
  ProductModel({required this.name, required this.image});
}

class RandomData {
  static int randomInt(int min, int max) {
    return DateTime.now().microsecondsSinceEpoch % (max - min) + min;
  }
}