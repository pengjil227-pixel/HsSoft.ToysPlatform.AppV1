import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/constants/layout_constants.dart';
import '../shared/models/product.dart';

class ProductsCard extends StatelessWidget {
  const ProductsCard({
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
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
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
