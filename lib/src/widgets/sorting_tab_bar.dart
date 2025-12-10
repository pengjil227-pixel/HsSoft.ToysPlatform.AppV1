import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';

enum SortField {
  refreshTime,
  createdTime,
  // ignore: constant_identifier_names
  fa_Pr,
}

enum SortOrder {
  ascending,
  // ignore: constant_identifier_names
  Dscend,
}

class _Sorting {
  _Sorting({
    required this.text,
    required this.sortField,
    this.reverse = false,
  });
  final String text;
  final SortField sortField;
  final bool? reverse;
}

class SortingParams {
  SortingParams({
    this.sortField = SortField.refreshTime,
    this.sortOrder = SortOrder.Dscend,
    this.keywords = '',
  });

  late SortField sortField;
  late SortOrder sortOrder;
  late String keywords;

  SortingParams copyWith({
    SortField? sortField,
    SortOrder? sortOrder,
    String? keywords,
  }) {
    return SortingParams(
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      keywords: keywords ?? this.keywords,
    );
  }

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sortField'] = sortField.name;
    data['sortOrder'] = sortOrder.name;
    data['keywords'] = keywords;
    return data;
  }
}

class SortingTabBar extends StatefulWidget {
  const SortingTabBar({
    super.key,
    this.onChange,
    required this.params,
  });

  final SortingParams params;

  final Function(SortingParams value)? onChange;

  @override
  State<SortingTabBar> createState() => _SortingTabBarState();
}

class _SortingTabBarState extends State<SortingTabBar> {
  SortingParams get _params => widget.params;
  late SortField _sortField;
  late SortOrder _sortOrder;

  final List<_Sorting> sortings = [
    _Sorting(text: '综合', sortField: SortField.refreshTime),
    _Sorting(text: '时间', sortField: SortField.createdTime, reverse: true),
    _Sorting(text: '价格', sortField: SortField.fa_Pr, reverse: true),
  ];

  @override
  void initState() {
    super.initState();
    _sortField = _params.sortField;
    _sortOrder = _params.sortOrder;
  }

  void _updateType(_Sorting value) {
    SortField sortField = value.sortField;
    SortOrder sortOrder;
    if (value.sortField == _sortField) {
      if (value.reverse != true) return;
      if (_sortOrder == SortOrder.Dscend) {
        sortOrder = SortOrder.ascending;
      } else {
        sortOrder = SortOrder.Dscend;
      }
    } else {
      sortOrder = SortOrder.Dscend;
    }
    widget.onChange?.call(
      _params.copyWith(
        sortField: sortField,
        sortOrder: sortOrder,
      ),
    );

    setState(() {
      _sortField = sortField;
      _sortOrder = sortOrder;
    });
  }

  List<Widget> _sortingsBuilder(Color color) {
    return sortings.map((sorting) {
      Widget child = Text(
        sorting.text,
        style: TextStyle(color: _sortField == sorting.sortField ? color : Color(0xFF666666)),
      );

      if (sorting.reverse ?? false) {
        child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconfont.sanjiao_yuan2,
                    size: 4,
                    color: _sortField == sorting.sortField && _sortOrder == SortOrder.ascending ? color : Color(0xFF666666),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Icon(
                    Iconfont.sanjiao_yuan1,
                    size: 4,
                    color: _sortField == sorting.sortField && _sortOrder == SortOrder.Dscend ? color : Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _updateType(sorting),
          child: Align(
            child: child,
          ),
        ),
      );
      // Color? activeColor = sorting.sortField.contains(_sortField) ? color : null;
      // Widget child = Text(sorting.text, style: TextStyle(fontSize: 15, color: activeColor));

      // SortingType type;

      // if (sorting.sortField.contains(SortingType.comprehensive)) {
      //   type = SortingType.comprehensive;
      //   child = Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       child,
      //       Padding(
      //         padding: EdgeInsets.only(left: 2),
      //         child: Icon(
      //           Iconfont.xiala2,
      //           size: 4,
      //           color: activeColor,
      //         ),
      //       ),
      //     ],
      //   );
      // } else if (sorting.sortField.contains(SortingType.priceUp) || sorting.sortField.contains(SortingType.priceDown)) {
      //   if (_sortField == SortingType.priceDown) {
      //     type = SortingType.priceUp;
      //   } else {
      //     type = SortingType.priceDown;
      //   }
      //   child = Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       child,
      //       Padding(
      //         padding: EdgeInsets.only(left: 2),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Icon(
      //               Iconfont.xiala1,
      //               size: 4,
      //               color: _sortField == SortingType.priceUp ? color : null,
      //             ),
      //             SizedBox(
      //               height: 4,
      //             ),
      //             Icon(
      //               Iconfont.xiala2,
      //               size: 4,
      //               color: _sortField == SortingType.priceDown ? color : null,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   );
      // } else {
      //   type = sorting.sortField.first;
      // }
      // return Expanded(
      //   child: GestureDetector(
      //     behavior: HitTestBehavior.opaque,
      //     onTap: () => _updateType(type),
      //     child: Align(
      //       child: child,
      //     ),
      //   ),
      // );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: _sortingsBuilder(theme.primaryColor),
    );
  }
}
