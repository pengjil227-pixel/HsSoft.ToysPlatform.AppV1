import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. 定义数据模型 (Model)
class CartItemModel {
  final int id;
  String name;
  int count;
  bool isDefault;
  bool isSelected;

  CartItemModel({
    required this.id,
    required this.name,
    this.count = 0,
    this.isDefault = false,
    this.isSelected = false,
  });
}

class CartSettingsPage extends StatefulWidget {
  const CartSettingsPage({super.key});

  @override
  State<CartSettingsPage> createState() => _CartSettingsPageState();
}

class _CartSettingsPageState extends State<CartSettingsPage> {
  // 模拟数据源
  final List<CartItemModel> _items = [
    CartItemModel(id: 1, name: '择样车名称1 (常规)', count: 8, isDefault: true),
    CartItemModel(id: 2, name: '这是一个名字非常非常长的择样车名称测试溢出', count: 12, isDefault: false),
    CartItemModel(id: 3, name: '展厅临时车', count: 5, isDefault: false),
  ];
  int _nextId = 4;

  // 全选/取消全选逻辑
  void _toggleSelectAll() {
    setState(() {
      final bool isAllSelected = _items.every((item) => item.isSelected);
      for (var item in _items) {
        item.isSelected = !isAllSelected;
      }
    });
  }

  // 单个选中逻辑
  void _toggleItemSelection(int index) {
    setState(() {
      _items[index].isSelected = !_items[index].isSelected;
    });
  }

  // 设置默认逻辑
  void _setDefault(int index) {
    setState(() {
      for (var item in _items) {
        item.isDefault = false;
      }
      _items[index].isDefault = true;
    });
  }

  Future<void> _editCartName(int index) async {
    if (index < 0 || index >= _items.length || !mounted) return;
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _CartNameDialog(initialName: _items[index].name),
    );

    if (!mounted || result == null || result.isEmpty) return;
    setState(() {
      _items[index].name = result;
    });
  }

  Future<void> _addNewCart() async {
    final newName = '择样车${_items.length + 1}';
    final newItem = CartItemModel(id: _nextId++, name: newName, count: 0);
    setState(() {
      _items.add(newItem);
    });
    await _editCartName(_items.length - 1);
  }

  void _deleteSelected() {
    if (_items.every((i) => !i.isSelected)) return;
    setState(() {
      final bool defaultWillBeRemoved = _items.any((i) => i.isDefault && i.isSelected);
      _items.removeWhere((i) => i.isSelected);
      if (_items.isNotEmpty && defaultWillBeRemoved && !_items.any((i) => i.isDefault)) {
        _items.first.isDefault = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final selectedCount = _items.where((i) => i.isSelected).length;
    final isAllSelected = _items.isNotEmpty && _items.every((i) => i.isSelected);

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
            onPressed: _addNewCart,
            child: const Text(
              '新增',
              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          // 2. 使用独立的 Widget 渲染每一行，性能更好
          return CartItemTile(
            item: _items[index],
            onSelectChanged: () => _toggleItemSelection(index),
            onSetDefault: () => _setDefault(index),
            onEdit: () => _editCartName(index),
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
                onTap: _toggleSelectAll,
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
                onPressed: selectedCount == 0
                    ? null
                    : _deleteSelected,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor, // 这里的红色应该是你主题色
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
  }

  // 提取复选框样式
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
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

// --------------------------------------------------------------------------
// 3. 独立的列表项组件 (解决性能和代码臃肿问题)
// --------------------------------------------------------------------------
class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onSelectChanged;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onSelectChanged,
    required this.onSetDefault,
    required this.onEdit,
  });

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
          // 左侧：选择框
          GestureDetector(
            onTap: onSelectChanged,
            behavior: HitTestBehavior.opaque, // 扩大点击区域
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.isSelected ? theme.primaryColor : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                  color: item.isSelected ? theme.primaryColor : Colors.transparent,
                ),
                child: item.isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ),
          ),

          // 中间：信息区域 (使用 Flexible 防止文字溢出)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 4. 关键修复：使用 Flexible 包裹 Text，并设置 ellipsis
                    Flexible(
                      child: Text(
                        item.name,
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
                  '样品数量：${item.count}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
                ),
                if (item.isDefault) ...[
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

          // 右侧：操作按钮
          // 使用 Row + mainAxisSize: min 紧凑排列
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!item.isDefault)
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
              if (!item.isDefault) const SizedBox(width: 8), // 按钮间距
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
  final String initialName;
  const _CartNameDialog({required this.initialName});

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
