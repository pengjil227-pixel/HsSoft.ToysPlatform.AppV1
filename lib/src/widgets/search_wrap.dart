import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';

import 'primart_button.dart';

class SearchWrap extends StatelessWidget {
  const SearchWrap({
    super.key,
    this.onSearch,
    this.child,
  });

  final Function()? onSearch;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
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
            child: child ?? SizedBox.shrink(),
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
                onPressed: onSearch,
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
    );
  }
}
