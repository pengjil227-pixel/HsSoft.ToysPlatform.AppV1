import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/layout_constants.dart';
import '../core/providers/cart_provider.dart';
import '../shared/models/paginated_response.dart';
import '../shared/models/product.dart';
import 'products_view.dart';

class GoodsItem extends StatefulWidget {
  const GoodsItem({
    super.key,
    required this.item,
    this.showActionButton = false,
    this.onActionTap,
    this.backgroundColor = Colors.white,
    this.imagePadding = EdgeInsets.zero,
    this.imageOuterPadding = EdgeInsets.zero,
  });

  final ProductItem item;
  final bool showActionButton;
  final VoidCallback? onActionTap;
  final Color backgroundColor;
  final EdgeInsets imagePadding;
  final EdgeInsets imageOuterPadding;

  @override
  State<GoodsItem> createState() => _GoodsItemState();
}

class _GoodsItemState extends State<GoodsItem> {
  bool _adding = false;

  Future<void> _handleAddToCart(BuildContext context) async {
    if (_adding) return;
    setState(() => _adding = true);
    final scaffold = ScaffoldMessenger.of(context);
    scaffold
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('正在加入...'), duration: Duration(milliseconds: 800)));
    await context.read<CartProvider>().addToCart(widget.item);
    scaffold
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('加入成功'), duration: Duration(seconds: 1)));
    if (mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: widget.imageOuterPadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Container(
                      color: Colors.white,
                      padding: widget.imagePadding == EdgeInsets.zero
                          ? const EdgeInsets.symmetric(horizontal: 3, vertical: 3)
                          : widget.imagePadding,
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: widget.item.imgUrl,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding,
                    LayoutConstants.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.prNa,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 2,
                      ),
                    ),
                    Row(
                      children: [
                        Text('¥${widget.item.faPr}', style: TextStyle(fontSize: 15, color: theme.primaryColor)),
                        Text('[${widget.item.productNumber}]',
                            style: const TextStyle(fontSize: 15, color: Color(0xFF929292))),
                      ],
                    ),
                    Text(
                      widget.item.maNa,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF929292),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.showActionButton)
          Positioned(
            right: 8,
            bottom: 8,
            child: GestureDetector(
              onTap: widget.onActionTap ?? () => _handleAddToCart(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: _adding ? Colors.grey : const Color(0xFFF30213),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: _adding
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Icon(Icons.add, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class ProductsBuilder extends StatelessWidget {
  const ProductsBuilder({
    super.key,
    required this.item,
    required this.loadMore,
  });

  final PaginatedResponse<ProductItem> item;

  final Function() loadMore;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: item.rows.length,
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
                products: item.rows, 
                index: index,
                loadmore: () async {
                  loadMore();
                  return true;
                },
              ),
            );
          },
          child: GoodsItem(
            key: ValueKey(item.rows[index].productNumber),
            item: item.rows[index],
          ),
        );
      },
    );
  }
}
