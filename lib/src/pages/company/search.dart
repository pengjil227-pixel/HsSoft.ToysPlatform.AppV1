import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:iconfont/iconfont.dart';

import '../../core/network/modules/search.dart';
import '../../shared/models/paginated_response.dart';
import '../../shared/models/product.dart';
import '../../shared/preferences/search_history.dart';
import '../../widgets/goods_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ValueNotifier<List<String>> _searchs = ValueNotifier<List<String>>([]);

  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final ValueNotifier<PaginatedResponse<ProductItem>?> _items = ValueNotifier<PaginatedResponse<ProductItem>?>(null);

  final ValueNotifier<bool> _isSearch = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _getSearchHistory();
  }

  @override
  void dispose() {
    super.dispose();
    _searchs.dispose();
    _items.dispose();
    _isSearch.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  Future<void> _getSearchHistory() async {
    final list = await loadSaveSearchHistory();
    if (list != null) {
      _searchs.value = [...list];
    }
  }

  void _onSearch(String value) async {
    if (value.trim().isNotEmpty) {
      final newValue = {value, ..._searchs.value}.toList();
      if (newValue.length > 20) {
        newValue.removeLast();
      }
      _searchs.value = newValue;
      await saveSearchHistory(_searchs.value);
      _search(value);
    }
  }

  Future<void> _search(String value) async {
    _isSearch.value = true;
    final response = await SearchService.queryPage({
      "pageNo": 1,
      "pageSize": 10,
      "keywords": value,
      "searchType": 1,
    });
    _items.value = response.data;
  }

  Widget _itemBuilder(String value) {
    return GestureDetector(
      onTap: () {
        _controller.text = value;
        _onSearch(value);
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, top: 8),
        padding: EdgeInsets.all(4),
        constraints: BoxConstraints(maxWidth: 120, minWidth: 34),
        decoration: BoxDecoration(
          border: Border.all(width: 0.6, color: Color(0xFFCDCDCD)),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          clipBehavior: Clip.hardEdge,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              width: 0.6,
              color: Color(0xFFF30213),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onTap: () {
                    _isSearch.value = false;
                  },
                  autofocus: true,
                  onSubmitted: _onSearch,
                  focusNode: _focusNode,
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 15, height: 1.2),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                height: 34,
                child: Align(
                  child: Icon(
                    Iconfont.paizhao,
                    size: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  height: 26,
                  child: PrimartButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      _onSearch(_controller.text);
                    },
                    color: Color(0xFFF30213),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    borderRadius: BorderRadius.circular(4.0),
                    child: Text(
                      '搜索',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _isSearch,
        builder: (BuildContext context, bool value, Widget? child) {
          if (value) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding),
                  sliver: ValueListenableBuilder(
                    valueListenable: _items,
                    builder: (context, value, child) {
                      if (value == null) return SliverPadding(padding: EdgeInsets.zero);
                      return ProductsBuilder(
                        item: value,
                        loadmore: () {},
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: SizedBox.expand(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child!,
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 4, 20, 12),
                      child: ValueListenableBuilder(
                        valueListenable: _searchs,
                        builder: (context, value, _) {
                          return Wrap(
                            children: value.map((item) => _itemBuilder(item)).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () async {
            _searchs.value = [];
            await deleteSaveSearchHistory();
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '搜索历史',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Iconfont.shanchu2,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
