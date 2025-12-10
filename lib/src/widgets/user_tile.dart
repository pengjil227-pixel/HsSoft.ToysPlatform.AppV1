import 'package:flutter/material.dart';

import '../core/constants/layout_constants.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
  });

  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: LayoutConstants.pagePadding),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 18, color: Color(0xFF111111)),
                      child: title != null ? title! : SizedBox.shrink(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        child: subtitle != null ? subtitle! : SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (trailing != null) trailing!
          ],
        ),
      ),
    );
  }
}
