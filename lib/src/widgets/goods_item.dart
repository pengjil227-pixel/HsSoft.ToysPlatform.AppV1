import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/core/constants/layout_constants.dart';

class GoodsItem extends StatelessWidget {
  const GoodsItem({super.key});

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
              child: Image.network(
                'https://picsum.photos/300/160',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, 0, LayoutConstants.pagePadding, LayoutConstants.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '商品名称商品名称商品名称商品名称',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    height: 2,
                  ),
                ),
                Row(
                  children: [
                    Text('¥48.00', style: TextStyle(fontSize: 15, color: theme.primaryColor)),
                    Text('[W32532]', style: TextStyle(fontSize: 15, color: Color(0xFF929292))),
                  ],
                ),
                Text(
                  '汕头市莱公司',
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
