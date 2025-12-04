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
  final List<CategoryModel> _allData = [];

  // 定义颜色常量
  final Color _unselectedColor = const Color(0xFFEEEEEE); // 左边未选中（较深灰）
  final Color _backgroundColor = const Color(0xFFF4F4F4); // 右侧背景 & 左边选中（较浅灰）

  @override
  void initState() {
    super.initState();
    _initMockData();
    _itemPositionsListener.itemPositions.addListener(_onRightScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onRightScroll);
    super.dispose();
  }

  void _initMockData() {
    final List<String> categories = [
      "遥控玩具", "电动玩具", "变形类", "线控玩具", "拉线类",
      "滑行类", "力控玩具", "回力系列", "惯性玩具", "军警",
      "海盗类", "战具系列", "枪系列", "弹射类", "体育用品",
      "夏日玩具", "礼品精品"
    ];

    for (var i = 0; i < categories.length; i++) {
      _allData.add(CategoryModel(
        title: categories[i],
        products: List.generate(RandomData.randomInt(6, 15), (j) {
          return ProductModel(
            name: "${categories[i]}-$j",
            image: "https://picsum.photos/200/200?random=$i$j",
          );
        }),
      ));
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

    if (minIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = minIndex;
      });
    }
  }

  Future<void> _onLeftTap(int index) async {
    setState(() {
      _selectedIndex = index;
      _isClickScrolling = true;
    });

    await _itemScrollController.scrollTo(
      index: index,
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
          // --- 左侧菜单栏 ---
          Container(
            width: 94,
            color: _unselectedColor, // 默认背景色 #EEEEEE
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _allData.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => _onLeftTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    // 选中变 #F4F4F4，未选中 #EEEEEE
                    color: isSelected ? _backgroundColor : _unselectedColor,
                    child: Stack(
                      children: [
                        // 文字
                        Center(
                          child: Text(
                            _allData[index].title,
                            style: TextStyle(
                              fontSize: 14,
                              // 选中变主题红，未选中黑色
                              color: isSelected ? primaryColor : const Color(0xFF333333),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),

                        // ✅ 修改处：选中指示器 (底部居中红条)
                        if (isSelected)
                          Positioned(
                            bottom: 0, // 放在底部
                            left: 0,
                            right: 0,
                            child: Center( // 居中
                              child: Container(
                                width: 20, // 红条宽度，可以自己微调
                                height: 3, // 红条高度
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

          // --- 右侧内容区 ---
          Expanded(
            child: Container(
              color: _backgroundColor, // 右侧背景色 #F4F4F4
              child: ScrollablePositionedList.builder(
                itemCount: _allData.length,
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final category = _allData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: category.products.length,
                          itemBuilder: (context, i) {
                            final product = category.products[i];
                            return Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey[200],
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        Image.asset('assets/images/logo.png'),
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryModel {
  final String title;
  final List<ProductModel> products;
  CategoryModel({required this.title, required this.products});
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