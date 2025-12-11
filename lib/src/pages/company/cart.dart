import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:provider/provider.dart';

import '../../core/models/cart_models.dart';
import '../../core/providers/cart_provider.dart';
import 'my/sample_quote_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const Color _primaryRed = Color(0xFFE02020);
  bool _isManageMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().refreshCartList();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = context.watch<CartProvider>();
    final bool isAllSelected =
        cart.factories.isNotEmpty && cart.factories.every((FactoryModel f) => f.isSelected);

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
                '择样车(${cart.factories.length})',
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
              children: const [
                _SortLabel(label: '时间'),
                SizedBox(width: 24),
                _SortLabel(label: '价格'),
              ],
            ),
          ),
          Expanded(
            child: cart.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cart.factories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final FactoryModel factory = cart.factories[index];
                      return FactoryGroupTile(
                        factoryModel: factory,
                        isManageMode: _isManageMode,
                        onFactoryToggle: () => context.read<CartProvider>().toggleFactory(factory.id),
                        onProductToggle: (String productId) =>
                            context.read<CartProvider>().toggleProduct(productId),
                        onQuantityChange: (String productId, int quantity) =>
                            context.read<CartProvider>().updateQuantity(productId, quantity),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(cart, isAllSelected),
    );
  }

  Widget _buildBottomBar(CartProvider cart, bool isAllSelected) {
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
                  '已选${cart.selectedCount}款(${cart.totalBoxes}箱/${cart.totalPieces}件)',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                ),
                const Spacer(),
                const Text('总金额：', style: TextStyle(fontSize: 12, color: Color(0xFF333333))),
                Text(
                  '¥ ${cart.totalAmount.toStringAsFixed(2)}',
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
                    onTap: () => context.read<CartProvider>().toggleSelectAll(),
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

  List<QuoteProductInput> _collectSelectedProducts() {
    final CartProvider cart = context.read<CartProvider>();
    final List<QuoteProductInput> selected = <QuoteProductInput>[];
    for (final FactoryModel factory in cart.factories) {
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
}

class _SortLabel extends StatelessWidget {
  const _SortLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333), fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.unfold_more, size: 16, color: Color(0xFFCCCCCC)),
      ],
    );
  }
}

class FactoryGroupTile extends StatelessWidget {
  const FactoryGroupTile({
    super.key,
    required this.factoryModel,
    required this.isManageMode,
    required this.onFactoryToggle,
    required this.onProductToggle,
    required this.onQuantityChange,
  });

  final FactoryModel factoryModel;
  final bool isManageMode;
  final VoidCallback onFactoryToggle;
  final ValueChanged<String> onProductToggle;
  final void Function(String productId, int quantity) onQuantityChange;

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
            onTap: onFactoryToggle,
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
              isManageMode: isManageMode,
              onToggle: () => onProductToggle(product.id),
              onQuantityChange: (int val) => onQuantityChange(product.id, val),
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
    required this.isManageMode,
    required this.onToggle,
    required this.onQuantityChange,
  });

  final ProductModel product;
  final bool isManageMode;
  final VoidCallback onToggle;
  final ValueChanged<int> onQuantityChange;

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
              onTap: onToggle,
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
              child: product.imageUrl.isNotEmpty
                  ? Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                      return const Icon(Icons.image, color: Colors.grey, size: 28);
                    })
                  : const Icon(Icons.image, color: Colors.grey, size: 28),
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
                        onChanged: onQuantityChange,
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
