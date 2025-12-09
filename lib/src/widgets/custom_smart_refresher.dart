import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'custom_spinner.dart';

class SmartRefresherHeader extends CustomHeader {
  SmartRefresherHeader({
    super.key,
    super.completeDuration = Duration.zero,
    super.height = 40,
  }) : super(
          builder: (context, mode) {
            return CustomSpinner();
          },
        );
}

class SmartRefresherFooter extends CustomFooter {
  SmartRefresherFooter({
    super.key,
    super.height = 0,
  }) : super(
          builder: (context, mode) {
            String text;
            if (mode == LoadStatus.noMore) {
              text = '没有更多了...';
            } else if (mode == LoadStatus.failed) {
              text = '加载失败';
            } else {
              text = '正在加载中...';
            }

            return SizedBox(
              height: 40,
              child: Align(
                child: Text(text, style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            );
          },
        );
}
