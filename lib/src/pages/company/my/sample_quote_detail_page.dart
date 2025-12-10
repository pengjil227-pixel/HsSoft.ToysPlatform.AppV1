import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/layout_constants.dart';
import 'sample_quote_state.dart';

class SampleQuoteDetailPage extends StatelessWidget {
  const SampleQuoteDetailPage({
    super.key,
    this.quote,
  });

  final SampleQuoteRecord? quote;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<SampleQuoteRecord>>(
      valueListenable: SampleQuoteStore.quotesNotifier,
      builder: (BuildContext _, List<SampleQuoteRecord> quotes, __) {
        final SampleQuoteRecord? current = _resolveQuote(quotes);
        if (current == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: _DetailAppBar(),
            body: Center(child: Text('报价不存在或已被删除')),
          );
        }
        return _QuoteDetailContent(record: current);
      },
    );
  }

  SampleQuoteRecord? _resolveQuote(List<SampleQuoteRecord> quotes) {
    if (quote != null) {
      final SampleQuoteRecord? latest = SampleQuoteStore.findById(quote!.id);
      return latest ?? quote;
    }
    return null;
  }

}

class _QuoteDetailContent extends StatelessWidget {
  const _QuoteDetailContent({required this.record});

  final SampleQuoteRecord record;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const _DetailAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _SectionTitle('报价单详情'),
          _DetailSection(
            children: [
              _DetailRow(label: '报价标题', value: record.title),
              const _SectionDivider(),
              _DetailRow(label: '报价单号', value: record.id),
              const _SectionDivider(),
              const _DetailRow(label: '订单类型', value: '平台产品'),
              const _SectionDivider(),
              _DetailRow(label: '客户名称', value: record.customer),
              const _SectionDivider(),
              _DetailRow(label: '业务员', value: record.salesPerson),
              const _SectionDivider(),
              _DetailRow(label: '报价时间', value: _formatDate(record.createdAt)),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionTitle('报价公式'),
          _DetailSection(
            children: [
              _DetailRow(label: '利润率', value: '${record.profitRate.toStringAsFixed(2)}%'),
              const _SectionDivider(),
              _DetailRow(label: '币种', value: record.currency),
              const _SectionDivider(),
              _DetailRow(label: '汇率', value: record.exchangeRate.toStringAsFixed(2)),
              const _SectionDivider(),
              _DetailRow(label: '小数位数', value: '${record.decimalPlaces}'),
              const _SectionDivider(),
              const _DetailRow(
                label: '报价公式',
                value: '出厂价*(1-报价利润%)/汇率',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SectionTitle('产品信息'),
          _ProductList(products: record.products),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar();

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
        '报价详情',
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

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

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.children});

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

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      height: 1,
      color: const Color(0xFFEEEEEE),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<QuoteProductInput> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(LayoutConstants.pagePadding),
        child: Text('暂无产品'),
      );
    }
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (BuildContext context, int index) {
          final QuoteProductInput product = products[index];
          return _ProductItem(product: product);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({required this.product});

  final QuoteProductInput product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logo.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                _ProductDetailRow(label: '货号', value: product.sku),
                const SizedBox(height: 4),
                _ProductDetailRow(label: '数量', value: '${product.quantity}'),
                const SizedBox(height: 4),
                _ProductDetailRow(label: '金额', value: '¥ ${product.totalPrice.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailRow extends StatelessWidget {
  const _ProductDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
}
