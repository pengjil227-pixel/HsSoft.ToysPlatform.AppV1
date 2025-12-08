import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/layout_constants.dart';
import '../core/providers/goods_detail_info.dart';
import '../shared/models/paginated_response.dart';
import '../shared/models/product.dart';

class GoodsItem extends StatelessWidget {
  const GoodsItem({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: CachedNetworkImage(
                imageUrl: item.imgUrl,
                errorWidget: (context, url, error) => Icon(Icons.error),
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF929292),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
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
            final goodsDetailInfo = context.read<GoodsDetailInfo>();
            goodsDetailInfo.products = item.rows;
            goodsDetailInfo.currentIndex = index;
            goodsDetailInfo.loadMore = loadMore;

            context.pushNamed(
              'goodsDetail',
              pathParameters: {
                'index': index.toString(),
              },
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
