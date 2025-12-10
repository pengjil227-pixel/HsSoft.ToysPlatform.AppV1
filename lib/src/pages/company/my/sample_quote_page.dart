import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/layout_constants.dart';
import 'sample_quote_state.dart';

class SampleQuotePage extends StatelessWidget {
  const SampleQuotePage({
    super.key,
    this.pendingRecord,
  });

  final SampleQuoteRecord? pendingRecord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const _QuoteListAppBar(),
      body: ValueListenableBuilder<List<SampleQuoteRecord>>(
        valueListenable: SampleQuoteStore.quotesNotifier,
        builder: (BuildContext _, List<SampleQuoteRecord> quotes, __) {
          return _QuoteListView(
            quotes: quotes,
            pendingRecordId: pendingRecord?.id,
          );
        },
      ),
    );
  }
}

class _QuoteListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _QuoteListAppBar();

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
        '采样报价',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _QuoteListView extends StatelessWidget {
  const _QuoteListView({
    required this.quotes,
    required this.pendingRecordId,
  });

  final List<SampleQuoteRecord> quotes;
  final String? pendingRecordId;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return const Center(child: Text('暂无报价'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(LayoutConstants.pagePadding),
      itemCount: quotes.length,
      itemBuilder: (BuildContext context, int index) {
        final SampleQuoteRecord record = quotes[index];
        final bool isNewlyCreated = pendingRecordId != null && pendingRecordId == record.id;
        return _QuoteCardItem(
          record: record,
          isHighlighted: isNewlyCreated,
        );
      },
    );
  }
}

class _QuoteCardItem extends StatelessWidget {
  const _QuoteCardItem({
    required this.record,
    required this.isHighlighted,
  });

  final SampleQuoteRecord record;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('sampleQuoteDetail', extra: record),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isHighlighted ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _QuoteCardHeader(record: record),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _QuoteCardInfo(record: record),
          ],
        ),
      ),
    );
  }

}

class _QuoteCardHeader extends StatelessWidget {
  const _QuoteCardHeader({required this.record});

  final SampleQuoteRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              record.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'ID：${record.id}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }
}

class _QuoteCardInfo extends StatelessWidget {
  const _QuoteCardInfo({required this.record});

  final SampleQuoteRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _InfoRow(label: '业务员：', value: record.salesPerson)),
              Expanded(child: _InfoRow(label: '产品数：', value: '${record.productCount}')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: '金额：', style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
                      TextSpan(
                        text: '¥ ${record.amount.toStringAsFixed(record.decimalPlaces)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE02020),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: _InfoRow(label: '客户：', value: record.customer)),
            ],
          ),
          const SizedBox(height: 8),
          _InfoRow(label: '时间：', value: _formatDate(record.createdAt)),
          const SizedBox(height: 8),
          _InfoRow(label: '备注：', value: record.remark.isEmpty ? '—' : record.remark),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
