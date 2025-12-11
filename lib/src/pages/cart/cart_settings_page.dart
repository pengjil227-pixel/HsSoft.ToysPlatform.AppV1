import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/cart_models.dart';
import '../../core/providers/cart_provider.dart';

class CartSettingsPage extends StatefulWidget {
  const CartSettingsPage({super.key});

  @override
  State<CartSettingsPage> createState() => _CartSettingsPageState();
}

class _CartSettingsPageState extends State<CartSettingsPage> {
  final Set<String> _selectedIds = <String>{};

  void _toggleSelectAll(List<CartInfo> carts) {
    setState(() {
      if (carts.isEmpty) {
        _selectedIds.clear();
        return;
      }
      final bool isAllSelected = _selectedIds.length == carts.length;
      if (isAllSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(carts.map((CartInfo c) => c.id));
      }
    });
  }

  void _toggleItemSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _editCartName(BuildContext context, CartProvider provider, CartInfo cart) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (_) => _CartNameDialog(initialName: cart.name),
    );
    final String? name = result?.trim();
    if (!mounted || name == null || name.isEmpty) return;
    provider.updateCartName(cart.id, name);
  }

  Future<void> _addNewCart(
    BuildContext context,
    CartProvider provider,
    List<CartInfo> carts,
  ) async {
    final String defaultName = '择样车${carts.length + 1}';
    final String? result = await showDialog<String>(
      context: context,
      builder: (_) => _CartNameDialog(initialName: defaultName),
    );
    if (!mounted) return;
    final String name = (result ?? '').trim().isEmpty ? defaultName : result!.trim();
    provider.createNewCart(name);
  }

  void _deleteSelected(CartProvider provider) {
    if (_selectedIds.isEmpty) return;
    provider.removeCarts(_selectedIds.toList());
    setState(() => _selectedIds.clear());
  }

  int _calcProductCount(CartInfo cart) {
    int total = 0;
    for (final FactoryModel factory in cart.items) {
      total += factory.products.length;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Consumer<CartProvider>(
      builder: (BuildContext context, CartProvider cartProvider, _) {
        final List<CartInfo> carts = cartProvider.cartList;
        _selectedIds.removeWhere((String id) => !carts.any((CartInfo c) => c.id == id));
        final int selectedCount = _selectedIds.length;
        final bool isAllSelected = carts.isNotEmpty && selectedCount == carts.length;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
              onPressed: () => context.canPop() ? context.pop() : null,
            ),
            title: const Text(
              '管理择样车',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => _addNewCart(context, cartProvider, carts),
                child: const Text(
                  '新增',
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: carts.length,
            itemBuilder: (BuildContext context, int index) {
              final CartInfo cart = carts[index];
              final bool isDefault = cartProvider.activeCartId == cart.id;
              final bool isSelected = _selectedIds.contains(cart.id);
              final int productCount = _calcProductCount(cart);
              return CartItemTile(
                cart: cart,
                isDefault: isDefault,
                isSelected: isSelected,
                productCount: productCount,
                onSelectChanged: () => _toggleItemSelection(cart.id),
                onSetDefault: () => cartProvider.switchActiveCart(cart.id),
                onEdit: () => _editCartName(context, cartProvider, cart),
              );
            },
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleSelectAll(carts),
                    child: Row(
                      children: [
                        _buildCheckbox(isAllSelected, theme),
                        const SizedBox(width: 8),
                        const Text('全选', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: selectedCount == 0 ? null : () => _deleteSelected(cartProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '批量删除${selectedCount > 0 ? "($selectedCount)" : ""}',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(bool isSelected, ThemeData theme) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? theme.primaryColor : const Color(0xFFCCCCCC),
          width: 2,
        ),
        color: isSelected ? theme.primaryColor : Colors.transparent,
      ),
      child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.cart,
    required this.productCount,
    required this.isDefault,
    required this.isSelected,
    required this.onSelectChanged,
    required this.onSetDefault,
    required this.onEdit,
  });

  final CartInfo cart;
  final int productCount;
  final bool isDefault;
  final bool isSelected;
  final VoidCallback onSelectChanged;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSelectChanged,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? theme.primaryColor : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                  color: isSelected ? theme.primaryColor : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        cart.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '样品数量：$productCount',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
                ),
                if (isDefault) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFFF9700)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '默认',
                      style: TextStyle(fontSize: 10, color: Color(0xFFFF9700)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDefault)
                SizedBox(
                  height: 28,
                  child: OutlinedButton(
                    onPressed: onSetDefault,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9700),
                      side: const BorderSide(color: Color(0xFFFF9700)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('设为默认', style: TextStyle(fontSize: 12)),
                  ),
                ),
              if (!isDefault) const SizedBox(width: 8),
              SizedBox(
                height: 28,
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('编辑', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartNameDialog extends StatefulWidget {
  const _CartNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_CartNameDialog> createState() => _CartNameDialogState();
}

class _CartNameDialogState extends State<_CartNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑择样车名称'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '请输入择样车名称',
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('确定'),
        ),
      ],
    );
  }
}
