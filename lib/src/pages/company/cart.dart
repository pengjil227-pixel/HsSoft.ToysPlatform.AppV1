import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';

import 'my/sample_quote_state.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
  });

  final String id;
  final String name;
  final String sku;
  final double price;
  final int quantity;
  final bool isSelected;

  double get totalPrice => price * quantity;

  ProductModel copyWith({int? quantity, bool? isSelected}) {
    return ProductModel(
      id: id,
      name: name,
      sku: sku,
      price: price,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FactoryModel {
  const FactoryModel({
    required this.id,
    required this.name,
    required this.products,
  });

  final String id;
  final String name;
  final List<ProductModel> products;

  bool get isSelected => products.isNotEmpty && products.every((ProductModel p) => p.isSelected);

  FactoryModel copyWith({List<ProductModel>? products}) {
    return FactoryModel(
      id: id,
      name: name,
      products: products ?? this.products,
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const Color _primaryRed = Color(0xFFE02020);

  late List<FactoryModel> _data;
  bool _isManageMode = false;
  String _sortBy = '';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _initMockData();
  }

  void _initMockData() {
    _data = List<FactoryModel>.generate(3, (int fIndex) {
      return FactoryModel(
        id: 'factory_$fIndex',
        name: fIndex == 0 ? '示例玩具厂$fIndex' : '山头市示例玩具厂$fIndex',
        products: List<ProductModel>.generate(3, (int pIndex) {
          return ProductModel(
            id: 'p_${fIndex}_$pIndex',
            name: '充气涂鸦长颈鹿玩偶$fIndex-$pIndex',
            sku: '888-$pIndex',
            price: 10.0 + pIndex,
          );
        }),
      );
    });
  }

  double get _totalAmount {
    double total = 0;
    for (final FactoryModel factory in _data) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) {
          total += product.totalPrice;
        }
      }
    }
    return total;
  }

  int get _selectedCount {
    int count = 0;
    for (final FactoryModel factory in _data) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) count++;
      }
    }
    return count;
  }

  int get _totalPieces => _selectedCount;
  int get _totalBoxes => _selectedCount;

  List<QuoteProductInput> _collectSelectedProducts() {
    final List<QuoteProductInput> selected = <QuoteProductInput>[];
    for (final FactoryModel factory in _data) {
      for (final ProductModel product in factory.products) {
        if (product.isSelected) {
          selected.add(
            QuoteProductInput(
              id: product.id,
              name: product.name,
              sku: product.sku,
              price: product.price,
              quantity: product.quantity,
            ),
          );
        }
      }
    }
    return selected;
  }

  void _showTopTip(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
  }

  void _toggleSelectAll() {
    final bool isAllSelected = _data.isNotEmpty && _data.every((FactoryModel f) => f.isSelected);
    setState(() {
      _data = _data
          .map(
            (FactoryModel factory) => factory.copyWith(
              products: factory.products
                  .map((ProductModel p) => p.copyWith(isSelected: !isAllSelected))
                  .toList(growable: false),
            ),
          )
          .toList(growable: false);
    });
  }

  void _updateProduct(ProductModel product) {
    setState(() {
      _data = _data
          .map((FactoryModel factory) {
            if (factory.products.contains(product)) {
              return factory.copyWith(
                products: factory.products
                    .map((ProductModel p) => p.id == product.id ? product : p)
                    .toList(growable: false),
              );
            }
            return factory;
          })
          .toList(growable: false);
    });
  }

  void _updateFactoryProducts(String factoryId, List<ProductModel> products) {
    setState(() {
      _data = _data
          .map((FactoryModel factory) => factory.id == factoryId ? factory.copyWith(products: products) : factory)
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAllSelected = _data.isNotEmpty && _data.every((FactoryModel f) => f.isSelected);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: GestureDetector(
          onTap: () => context.pushNamed('cartSettings'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '择样车(${_data.length})',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Iconfont.xiala2, color: Colors.black, size: 13),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconfont.sousuo1, color: Color(0xFF666666), size: 18),
            onPressed: () {},
          ),
          if (!_isManageMode)
            IconButton(
              icon: const Icon(Iconfont.shezhi, color: Color(0xFF666666), size: 18),
              onPressed: () => context.pushNamed('cartSettings'),
            ),
          TextButton(
            onPressed: () => setState(() => _isManageMode = !_isManageMode),
            child: Text(
              _isManageMode ? '退出管理' : '管理',
              style: const TextStyle(color: Color(0xFF333333), fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildSortButton('时间', 'time'),
                const SizedBox(width: 24),
                _buildSortButton('价格', 'price'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                final FactoryModel factory = _data[index];
                return FactoryGroupTile(
                  factoryModel: factory,
                  isManageMode: _isManageMode,
                  onChanged: () => setState(() {}),
                  onFactoryProductsChange: (List<ProductModel> updated) =>
                      _updateFactoryProducts(factory.id, updated),
                  onProductChange: _updateProduct,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isAllSelected),
    );
  }

  Widget _buildSortButton(String label, String sortKey) {
    final bool isActive = _sortBy == sortKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_sortBy == sortKey) {
            _sortAscending = !_sortAscending;
          } else {
            _sortBy = sortKey;
            _sortAscending = true;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? const Color(0xFF333333) : const Color(0xFF999999),
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 2),
          Icon(
            isActive ? (_sortAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down) : Icons.unfold_more,
            color: isActive ? const Color(0xFF333333) : const Color(0xFFCCCCCC),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isAllSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isManageMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFFFF3E0),
            child: Row(
              children: [
                Text(
                  '已选$_selectedCount款($_totalBoxes箱/$_totalPieces件)',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                ),
                const Spacer(),
                const Text('总金额：', style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
                Text(
                  '¥ ${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: _primaryRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DIN',
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 44,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleSelectAll,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        CustomCheckbox(isChecked: isAllSelected),
                        const SizedBox(width: 8),
                        const Text('全选', style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (_isManageMode) ...[
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primaryRed),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text('移入收藏', style: TextStyle(color: _primaryRed)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text('删除', style: TextStyle(color: Colors.white)),
                    ),
                  ] else ...[
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0F0),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('加入对比', style: TextStyle(color: _primaryRed, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF0F0),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('导出', style: TextStyle(color: _primaryRed, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final List<QuoteProductInput> selectedProducts = _collectSelectedProducts();
                        if (selectedProducts.isEmpty) {
                          _showTopTip('请选择产品');
                          return;
                        }
                        context.pushNamed('sampleQuoteCreate', extra: selectedProducts);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('生成报价', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FactoryGroupTile extends StatelessWidget {
  const FactoryGroupTile({
    super.key,
    required this.factoryModel,
    required this.onChanged,
    required this.isManageMode,
    required this.onFactoryProductsChange,
    required this.onProductChange,
  });

  final FactoryModel factoryModel;
  final VoidCallback onChanged;
  final bool isManageMode;
  final ValueChanged<List<ProductModel>> onFactoryProductsChange;
  final ValueChanged<ProductModel> onProductChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              final bool newState = !factoryModel.isSelected;
              final List<ProductModel> updated =
                  factoryModel.products.map((ProductModel p) => p.copyWith(isSelected: newState)).toList();
              onFactoryProductsChange(updated);
              onChanged();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  CustomCheckbox(isChecked: factoryModel.isSelected),
                  const SizedBox(width: 10),
                  const Icon(Icons.store, size: 18, color: Color(0xFF666666)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      factoryModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          ...factoryModel.products.map(
            (ProductModel product) => ProductItemTile(
              product: product,
              onChanged: onChanged,
              isManageMode: isManageMode,
              onProductChange: onProductChange,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItemTile extends StatelessWidget {
  const ProductItemTile({
    super.key,
    required this.product,
    required this.onChanged,
    required this.isManageMode,
    required this.onProductChange,
  });

  final ProductModel product;
  final VoidCallback onChanged;
  final bool isManageMode;
  final ValueChanged<ProductModel> onProductChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28, right: 8),
            child: GestureDetector(
              onTap: () {
                onProductChange(product.copyWith(isSelected: !product.isSelected));
                onChanged();
              },
              behavior: HitTestBehavior.opaque,
              child: CustomCheckbox(isChecked: product.isSelected),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 80,
              height: 80,
              color: const Color(0xFFF8F8F8),
              child: const Icon(Icons.image, color: Colors.grey, size: 28),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '出厂货号：${product.sku}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF999999), height: 1.1),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text('出厂价：', style: TextStyle(fontSize: 11, color: Color(0xFF999999), height: 1.1)),
                    Text(
                      '¥${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE02020),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  '装箱量：1/10 (PCS)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF999999), height: 1.1),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text('总金额：', style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
                        Text(
                          '¥${product.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE02020),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    if (!isManageMode)
                      QuantityControl(
                        quantity: product.quantity,
                        onChanged: (int val) {
                          onProductChange(product.copyWith(quantity: val));
                          onChanged();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBtn(Icons.remove, () => quantity > 1 ? onChanged(quantity - 1) : null),
          Container(width: 1, height: 14, color: const Color(0xFFEEEEEE)),
          Container(
            constraints: const BoxConstraints(minWidth: 26),
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
            ),
          ),
          Container(width: 1, height: 14, color: const Color(0xFFEEEEEE)),
          _buildBtn(Icons.add, () => onChanged(quantity + 1)),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 22,
        child: Icon(icon, size: 10, color: const Color(0xFF666666)),
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({super.key, required this.isChecked});

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? const Color(0xFFE02020) : Colors.transparent,
        border: Border.all(
          color: isChecked ? const Color(0xFFE02020) : const Color(0xFFCCCCCC),
          width: 1.5,
        ),
      ),
      child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }
}
