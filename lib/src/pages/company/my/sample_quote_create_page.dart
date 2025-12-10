import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/layout_constants.dart';
import 'sample_quote_state.dart';

class SampleQuoteCreatePage extends StatefulWidget {
  const SampleQuoteCreatePage({
    super.key,
    required this.selectedProducts,
  });

  final List<QuoteProductInput> selectedProducts;

  @override
  State<SampleQuoteCreatePage> createState() => _SampleQuoteCreatePageState();
}

class _SampleQuoteCreatePageState extends State<SampleQuoteCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _salesPersonController = TextEditingController();
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _profitRateController = TextEditingController(text: '0.00');
  final TextEditingController _exchangeRateController = TextEditingController(text: '1.0');
  final TextEditingController _decimalPlacesController = TextEditingController(text: '2');

  final ValueNotifier<bool> _isQuickFormulaNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _removeSelectedQuotesNotifier = ValueNotifier<bool>(false);

  double get _selectedProductsTotal =>
      widget.selectedProducts.fold<double>(0, (double sum, QuoteProductInput item) => sum + item.totalPrice);

  @override
  void dispose() {
    _titleController.dispose();
    _salesPersonController.dispose();
    _customerController.dispose();
    _profitRateController.dispose();
    _exchangeRateController.dispose();
    _decimalPlacesController.dispose();
    _isQuickFormulaNotifier.dispose();
    _removeSelectedQuotesNotifier.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  double _calculateAmount() {
    final double profit = double.tryParse(_profitRateController.text) ?? 0;
    final double exchangeRate = double.tryParse(_exchangeRateController.text) ?? 1;
    final int decimalPlaces = int.tryParse(_decimalPlacesController.text) ?? 2;
    final double raw = (_selectedProductsTotal * (1 - profit / 100)) / (exchangeRate == 0 ? 1 : exchangeRate);
    final int safeDecimals = decimalPlaces.clamp(0, 6).toInt();
    return double.parse(raw.toStringAsFixed(safeDecimals));
  }

  void _submit() {
    if (widget.selectedProducts.isEmpty) {
      _showSnack('请选择产品');
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final SampleQuoteRecord record = SampleQuoteRecord(
      id: 'Q${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim().isEmpty ? '采样报价' : _titleController.text.trim(),
      customer: _customerController.text.trim().isEmpty ? '客户未填写' : _customerController.text.trim(),
      salesPerson: _salesPersonController.text.trim().isEmpty ? '业务员' : _salesPersonController.text.trim(),
      amount: _calculateAmount(),
      productCount: widget.selectedProducts.length,
      remark: _isQuickFormulaNotifier.value ? '快速报价公式' : '自定义公式',
      createdAt: DateTime.now(),
      profitRate: double.tryParse(_profitRateController.text) ?? 0,
      currency: 'RMB',
      exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1,
      decimalPlaces: int.tryParse(_decimalPlacesController.text) ?? 2,
      products: widget.selectedProducts,
    );

    SampleQuoteStore.addQuote(record);
    context.goNamed('sampleQuote', extra: record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const _CreateAppBar(),
      body: SampleQuoteCreateForm(
        formKey: _formKey,
        titleController: _titleController,
        salesPersonController: _salesPersonController,
        customerController: _customerController,
        profitRateController: _profitRateController,
        exchangeRateController: _exchangeRateController,
        decimalPlacesController: _decimalPlacesController,
        isQuickFormulaListenable: _isQuickFormulaNotifier,
        removeSelectedListenable: _removeSelectedQuotesNotifier,
        selectedCount: widget.selectedProducts.length,
      ),
      bottomNavigationBar: _CreateSubmitBar(onSubmit: _submit),
    );
  }
}

class _CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CreateAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => context.pop(),
      ),
      title: const Text(
        '新建报价单',
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }
}

class SampleQuoteCreateForm extends StatelessWidget {
  const SampleQuoteCreateForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.salesPersonController,
    required this.customerController,
    required this.profitRateController,
    required this.exchangeRateController,
    required this.decimalPlacesController,
    required this.isQuickFormulaListenable,
    required this.removeSelectedListenable,
    required this.selectedCount,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController salesPersonController;
  final TextEditingController customerController;
  final TextEditingController profitRateController;
  final TextEditingController exchangeRateController;
  final TextEditingController decimalPlacesController;
  final ValueNotifier<bool> isQuickFormulaListenable;
  final ValueNotifier<bool> removeSelectedListenable;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _SectionTitle(title: '基本信息（已选$selectedCount款）'),
          _BasicInfoSection(
            titleController: titleController,
            salesPersonController: salesPersonController,
            customerController: customerController,
          ),
          const SizedBox(height: 12),
          const _SectionTitle(title: '报价公式'),
          _FormulaSection(
            isQuickFormulaListenable: isQuickFormulaListenable,
            profitRateController: profitRateController,
            exchangeRateController: exchangeRateController,
            decimalPlacesController: decimalPlacesController,
          ),
          const SizedBox(height: 12),
          const _SectionTitle(title: '其他设置'),
          _OtherSettingsSection(
            removeSelectedListenable: removeSelectedListenable,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _BasicInfoSection extends StatelessWidget {
  const _BasicInfoSection({
    required this.titleController,
    required this.salesPersonController,
    required this.customerController,
  });

  final TextEditingController titleController;
  final TextEditingController salesPersonController;
  final TextEditingController customerController;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      children: [
        _InputRow(
          label: '报价标题',
          controller: titleController,
          hintText: '请输入报价标题',
        ),
        const _RowDivider(),
        _InputRow(
          label: '业务员',
          controller: salesPersonController,
          hintText: '业务员名称',
        ),
        const _RowDivider(),
        _InputRow(
          label: '客户名称',
          controller: customerController,
          hintText: '客户名称',
        ),
      ],
    );
  }
}

class _FormulaSection extends StatelessWidget {
  const _FormulaSection({
    required this.isQuickFormulaListenable,
    required this.profitRateController,
    required this.exchangeRateController,
    required this.decimalPlacesController,
  });

  final ValueNotifier<bool> isQuickFormulaListenable;
  final TextEditingController profitRateController;
  final TextEditingController exchangeRateController;
  final TextEditingController decimalPlacesController;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isQuickFormulaListenable,
          builder: (BuildContext _, bool isQuick, __) {
            return _FormulaTypeRow(
              isQuickFormula: isQuick,
              onChanged: (bool value) => isQuickFormulaListenable.value = value,
            );
          },
        ),
        const _RowDivider(),
        const _FormulaDescriptionRow(),
        const _RowDivider(),
        _NumberInputRow(
          label: '利润率（%）',
          controller: profitRateController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const _RowDivider(),
        const _ReadonlyRow(label: '币种', value: 'RMB'),
        const _RowDivider(),
        _NumberInputRow(
          label: '汇率',
          controller: exchangeRateController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const _RowDivider(),
        _NumberInputRow(
          label: '小数位数',
          controller: decimalPlacesController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class _OtherSettingsSection extends StatelessWidget {
  const _OtherSettingsSection({
    required this.removeSelectedListenable,
  });

  final ValueNotifier<bool> removeSelectedListenable;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: removeSelectedListenable,
          builder: (BuildContext _, bool removeSelected, __) {
            return _RemoveAfterCreateRow(
              removeSelected: removeSelected,
              onChanged: (bool value) => removeSelectedListenable.value = value,
            );
          },
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: children,
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 1,
      color: const Color(0xFFEEEEEE),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.label,
    required this.controller,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberInputRow extends StatelessWidget {
  const _NumberInputRow({
    required this.label,
    required this.controller,
    required this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadonlyRow extends StatelessWidget {
  const _ReadonlyRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class _FormulaTypeRow extends StatelessWidget {
  const _FormulaTypeRow({
    required this.isQuickFormula,
    required this.onChanged,
  });

  final bool isQuickFormula;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('公式类型', style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RadioOption<bool>(
                label: '快速公式',
                value: true,
                groupValue: isQuickFormula,
                onChanged: (bool value) => onChanged(value),
              ),
              const SizedBox(width: 24),
              _RadioOption<bool>(
                label: '自定义公式',
                value: false,
                groupValue: isQuickFormula,
                onChanged: (bool value) => onChanged(value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadioOption<T> extends StatelessWidget {
  const _RadioOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: (T? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
        ],
      ),
    );
  }
}

class _FormulaDescriptionRow extends StatelessWidget {
  const _FormulaDescriptionRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('计算公式', style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
          Text(
            '出厂价*(1-报价利润%)/汇率',
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}

class _RemoveAfterCreateRow extends StatelessWidget {
  const _RemoveAfterCreateRow({
    required this.removeSelected,
    required this.onChanged,
  });

  final bool removeSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: removeSelected,
            onChanged: (bool? value) {
              if (value != null) {
                onChanged(value);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '生成报价后将择样车中产品删除',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateSubmitBar extends StatelessWidget {
  const _CreateSubmitBar({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LayoutConstants.pagePadding),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '确定',
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
