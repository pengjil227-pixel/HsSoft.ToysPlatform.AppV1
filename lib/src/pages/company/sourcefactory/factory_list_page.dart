import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  static const int _pageSize = 20;

  bool _loading = true;
  String? _error;
  List<SourceSupplier> _suppliers = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _fetch(page: 1);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<bool> _fetch({required int page, bool append = false}) async {
    if (!append) {
      setState(() {
        if (page == 1) {
          _loading = true;
          _error = null;
        }
      });
    }

    List<SourceSupplier> rows = [];

    try {
      switch (widget.type) {
        case FactoryListType.recommend:
          final res = await FactoryService.queryRecommendSupplierPage(pageNo: page, pageSize: _pageSize);
          if (res.success && res.data != null) {
            rows = res.data!.rows.map((e) => SourceSupplier.fromRecommend(e)).toList();
          } else {
            _error = res.message;
            throw Exception(res.message);
          }
          break;
        case FactoryListType.latest:
          final res = await FactoryService.queryLatestSupplierPage(pageNo: page, pageSize: _pageSize);
          if (res.success && res.data != null) {
            rows = res.data!.rows;
          } else {
            _error = res.message;
            throw Exception(res.message);
          }
          break;
        case FactoryListType.all:
          final res = await FactoryService.querySourceSupplierPage(pageNo: page, pageSize: _pageSize, keywords: '');
          if (res.success && res.data != null) {
            rows = res.data!.rows;
          } else {
            _error = res.message;
            throw Exception(res.message);
          }
      }

      if (!mounted) return false;
      setState(() {
        if (append) {
          _suppliers.addAll(rows);
        } else {
          _suppliers = rows;
        }
        _page = page;
        _hasMore = rows.length == _pageSize;
        _loading = false;
        _error = null;
      });
      return true;
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      return false;
    }
  }

  Future<void> _onRefresh() async {
    final ok = await _fetch(page: 1, append: false);
    if (ok) {
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    } else {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoading() async {
    if (_isLoadingMore) return;
    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    _isLoadingMore = true;
    final ok = await _fetch(page: _page + 1, append: true);
    if (ok) {
      if (_hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } else {
      _refreshController.loadFailed();
    }
    _isLoadingMore = false;
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

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        padding: const EdgeInsets.all(LayoutConstants.pagePadding),
        itemCount: _suppliers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FactoryProductCard(supplier: _suppliers[index]),
          );
        },
      ),
    );
  }
}
