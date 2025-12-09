import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'custom_spinner.dart';

class SmartRefresherHeader extends CustomHeader {
  SmartRefresherHeader({
    super.key,
    super.completeDuration = Duration.zero,
  }) : super(
          builder: (context, mode) {
            return Align(
              child: CustomSpinner(),
            );
          },
        );
}

class SmartRefresherFooter extends CustomFooter {
  SmartRefresherFooter({
    super.key,
    super.height = 40,
  }) : super(
          builder: (context, mode) {
            if (mode == LoadStatus.noMore) {
              return Align(
                  child: Text(
                '没有更多了',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ));
            } else if (mode == LoadStatus.failed) {
              return Align(
                  child: Text(
                '加载失败',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ));
            }
            return Align(
                child: Text(
              '正在加载中...',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ));
          },
        );
}
