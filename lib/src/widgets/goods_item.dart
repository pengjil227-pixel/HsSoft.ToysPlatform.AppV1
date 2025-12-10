import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/layout_constants.dart';
import '../shared/models/paginated_response.dart';
import '../shared/models/product.dart';

class GoodsItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: imageOuterPadding,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Container(
                      color: Colors.white,
                      padding: imagePadding == EdgeInsets.zero ? const EdgeInsets.symmetric(horizontal: 3, vertical: 3) : imagePadding,
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: item.imgUrl,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) => Image.asset('assets/images/space.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding, LayoutConstants.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.prNa,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 2,
                      ),
                    ),
                    Row(
                      children: [
                        Text('¥${item.faPr}', style: TextStyle(fontSize: 15, color: theme.primaryColor)),
                        Text('[${item.productNumber}]', style: TextStyle(fontSize: 15, color: Color(0xFF929292))),
                      ],
                    ),
                    Text(
                      item.maNa,
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
        if (showActionButton)
          Positioned(
            right: 8,
            bottom: 8,
            child: GestureDetector(
              onTap: onActionTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFFF30213),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, size: 14, color: Colors.white),
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
    required this.loadmore,
  });

  final PaginatedResponse<ProductItem> item;

  final Function() loadmore;

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
            // final goodsDetailInfo = context.read<GoodsDetailInfo>();
            // goodsDetailInfo.products = item.rows;
            // goodsDetailInfo.currentIndex = index;
            // goodsDetailInfo.loadMore = loadMore;

            context.pushNamed(
              'goodsDetail',
              extra: ProductsParameters(
                products: item.rows,
                index: index,
                loadmore: loadmore,
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

class ProductsParameters {
  ProductsParameters({
    required this.products,
    required this.index,
    required this.loadmore,
  });
  final List<ProductItem> products;
  final int index;
  final Function() loadmore;
}
