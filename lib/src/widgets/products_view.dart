import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/widgets/goods_item.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/layout_constants.dart';
import '../core/network/api_response.dart';
import '../shared/models/paginated_response.dart';
import '../shared/models/product.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    super.key,
    required this.parameter,
  });

  final SmartRefresherParameter parameter;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  int _page = 1;

  final List<ProductItem> _products = [];

  @override
  void initState() {
    super.initState();
    widget.parameter.loadmore = _loadList;
    _loadList();
  }

  bool? _canload = true;

  Future<bool?> _loadList() async {
    if (_canload == false) return false;
    if (_canload == null) return null;
    _canload = null;
    try {
      final response = await widget.parameter.loadList(_page);
      if (response.success) {
        _products.addAll(response.data!.rows);
        _canload = response.data!.pageNo != response.data!.totalPage;
        _page += 1;

        setState(() {
          /// update
        });
        return _canload;
      }
    } catch (err) {
      _canload = null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) SliverFillRemaining(hasScrollBody: false);
    return SliverGrid.builder(
      itemCount: _products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: LayoutConstants.pagePadding,
        mainAxisSpacing: LayoutConstants.pagePadding,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              'goodsDetail',
              pathParameters: {
                'index': index.toString(),
              },
              extra: ProductsParameters(
                products: _products,
                index: index,
                loadmore: _loadList,
              ),
            );
          },
          child: GoodsItem(
            key: ValueKey(_products[index].productNumber),
            item: _products[index],
          ),
        );
      },
    );
  }
}

class SmartRefresherParameter {
  SmartRefresherParameter({
    required this.loadList,
    this.loadmore,
  });
  final Future<ApiResponse<PaginatedResponse<ProductItem>>> Function(int page) loadList;

  late Function()? loadmore;
}

class ProductsParameters {
  ProductsParameters({
    required this.products,
    required this.index,
    required this.loadmore,
  });

  final List<ProductItem> products;
  final int index;
  final Future<bool?> Function() loadmore;
}
