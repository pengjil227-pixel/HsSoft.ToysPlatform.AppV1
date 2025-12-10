import 'package:flutter/material.dart';

/// 简单的产品输入模型，承载从择样车带过来的商品数据。
class QuoteProductInput {
  const QuoteProductInput({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  final String id;
  final String name;
  final String sku;
  final double price;
  final int quantity;

  double get totalPrice => price * quantity;
}

/// 报价记录模型，包含列表页和详情页展示所需的核心字段。
class SampleQuoteRecord {
  const SampleQuoteRecord({
    required this.id,
    required this.title,
    required this.customer,
    required this.salesPerson,
    required this.amount,
    required this.productCount,
    required this.remark,
    required this.createdAt,
    required this.profitRate,
    required this.currency,
    required this.exchangeRate,
    required this.decimalPlaces,
    required this.products,
  });

  final String id;
  final String title;
  final String customer;
  final String salesPerson;
  final double amount;
  final int productCount;
  final String remark;
  final DateTime createdAt;
  final double profitRate;
  final String currency;
  final double exchangeRate;
  final int decimalPlaces;
  final List<QuoteProductInput> products;
}

/// 全局报价存储，使用 ValueNotifier 做细粒度刷新。
class SampleQuoteStore {
  SampleQuoteStore._();

  static final ValueNotifier<List<SampleQuoteRecord>> quotesNotifier = ValueNotifier<List<SampleQuoteRecord>>(
    _initialQuotes,
  );

  static void addQuote(SampleQuoteRecord record) {
    quotesNotifier.value = <SampleQuoteRecord>[record, ...quotesNotifier.value];
  }

  static SampleQuoteRecord? findById(String id) {
    for (final SampleQuoteRecord record in quotesNotifier.value) {
      if (record.id == id) {
        return record;
      }
    }
    return null;
  }

  static List<SampleQuoteRecord> get _initialQuotes {
    return List<SampleQuoteRecord>.generate(3, (int index) => _buildMockQuote(index + 1));
  }

  static SampleQuoteRecord _buildMockQuote(int index) {
    final List<QuoteProductInput> products = _mockProducts(index);
    final double total = products.fold<double>(0, (double sum, QuoteProductInput item) => sum + item.totalPrice);
    return SampleQuoteRecord(
      id: 'Q20251209${index.toString().padLeft(2, '0')}',
      title: '样品报价$index',
      customer: '示例客户$index',
      salesPerson: '业务员$index',
      amount: total,
      productCount: products.length,
      remark: '快速报价示例$index',
      createdAt: DateTime.parse('2025-12-${(10 - index).toString().padLeft(2, '0')}T15:20:20'),
      profitRate: 8.0 + index.toDouble(),
      currency: 'RMB',
      exchangeRate: 1,
      decimalPlaces: 2,
      products: products,
    );
  }

  static List<QuoteProductInput> _mockProducts(int index) {
    return List<QuoteProductInput>.generate(
      2,
      (int subIndex) => QuoteProductInput(
        id: 'P$index$subIndex',
        name: '充气涂鸦长颈鹿玩偶 $index-$subIndex',
        sku: '888-$index$subIndex',
        price: 56 + subIndex * 3,
        quantity: 1 + subIndex,
      ),
    );
  }
}
