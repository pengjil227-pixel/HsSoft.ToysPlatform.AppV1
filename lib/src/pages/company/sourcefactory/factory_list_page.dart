import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/layout_constants.dart';
import '../../../core/network/modules/factory_service.dart';
import '../../../shared/models/source_supplier.dart';
import 'factory_product_card.dart';

enum FactoryListType { all, recommend, latest }

class FactoryListPage extends StatefulWidget {
  const FactoryListPage({super.key, this.type = FactoryListType.all});

  final FactoryListType type;

  @override
  State<FactoryListPage> createState() => _FactoryListPageState();
}

class _FactoryListPageState extends State<FactoryListPage> {
  bool _loading = true;
  String? _error;
  List<SourceSupplier> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      switch (widget.type) {
        case FactoryListType.recommend:
          final res = await FactoryService.queryRecommendSupplierPage(pageNo: 1, pageSize: 20);
          if (res.success && res.data != null) {
            _suppliers = res.data!.rows.map((e) => SourceSupplier.fromRecommend(e)).toList();
          } else {
            _error = res.message;
          }
          break;
        case FactoryListType.latest:
          final res = await FactoryService.queryLatestSupplierPage(pageNo: 1, pageSize: 20);
          if (res.success && res.data != null) {
            _suppliers = res.data!.rows;
          } else {
            _error = res.message;
          }
          break;
        case FactoryListType.all:
          final res = await FactoryService.querySourceSupplierPage(pageNo: 1, pageSize: 20, keywords: '');
          if (res.success && res.data != null) {
            _suppliers = res.data!.rows;
          } else {
            _error = res.message;
          }
      }
    } catch (e) {
      _error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  String get _title {
    switch (widget.type) {
      case FactoryListType.recommend:
        return '推荐厂商';
      case FactoryListType.latest:
        return '最新入驻';
      case FactoryListType.all:
        return '全部厂商';
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF4F4F4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(_title, style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold)),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('加载失败：$_error', style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    if (_suppliers.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(LayoutConstants.pagePadding),
      itemCount: _suppliers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FactoryProductCard(supplier: _suppliers[index]),
        );
      },
    );
  }
}
