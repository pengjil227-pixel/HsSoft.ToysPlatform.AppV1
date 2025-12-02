import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:iconfont/iconfont.dart';

import '../../core/constants/layout_constants.dart';
import '../../widgets/custom_swiper.dart';

class SupplyPage extends StatefulWidget {
  const SupplyPage({
    super.key,
    required this.provider,
  });

  final SortingProvider provider;

  @override
  State<SupplyPage> createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage> {
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(LayoutConstants.pagePadding, LayoutConstants.pagePadding, LayoutConstants.pagePadding, 0),
            child: SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CustomSwiper(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      'https://picsum.photos/300/160?i=$index',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            minHeight: 44,
            maxHeight: 44,
            child: Container(
              color: Colors.white,
              child: _SortingWidget(),
            ),
          ),
        )
      ],
    );
  }
}

class _SortingWidget extends StatefulWidget {
  @override
  State<_SortingWidget> createState() => __SortingWidgetState();
}

class __SortingWidgetState extends State<_SortingWidget> {
  final List<_Sorting> sortings = [
    _Sorting(text: '综合', sortingType: [SortingType.comprehensive]),
    _Sorting(text: '热度', sortingType: [SortingType.hot]),
    _Sorting(text: '时间', sortingType: [SortingType.date]),
    _Sorting(text: '价格', sortingType: [SortingType.priceUp, SortingType.priceDown]),
  ];

  SortingType _sortingType = SortingType.comprehensive;

  void _updateType(SortingType value) {
    setState(() {
      _sortingType = value;
    });
  }

  List<Widget> _sortingsBuilder(Color color) {
    return sortings.map((sorting) {
      Color? activeColor = sorting.sortingType.contains(_sortingType) ? color : null;
      Widget child = Text(sorting.text, style: TextStyle(fontSize: 15, color: activeColor));

      SortingType type;

      if (sorting.sortingType.contains(SortingType.comprehensive)) {
        type = SortingType.comprehensive;
        child = Row(
          children: [
            child,
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Icon(
                Iconfont.xiala2,
                size: 4,
                color: activeColor,
              ),
            ),
          ],
        );
      } else if (sorting.sortingType.contains(SortingType.priceUp) || sorting.sortingType.contains(SortingType.priceDown)) {
        if (_sortingType == SortingType.priceDown) {
          type = SortingType.priceUp;
        } else {
          type = SortingType.priceDown;
        }
        child = Row(
          children: [
            child,
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconfont.xiala1,
                    size: 4,
                    color: _sortingType == SortingType.priceUp ? color : null,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Icon(
                    Iconfont.xiala2,
                    size: 4,
                    color: _sortingType == SortingType.priceDown ? color : null,
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        type = sorting.sortingType.first;
      }
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _updateType(type),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: child,
        ),
      );
    }).toList();
  }

  void showRightSlideDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation1),
            child: Padding(
              padding: EdgeInsets.only(top: View.of(context).padding.top / View.of(context).devicePixelRatio),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(8.0)),
                child: SizedBox(
                  width: 300,
                  height: double.infinity,
                  child: _RightDialog(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ..._sortingsBuilder(theme.primaryColor),
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: SizedBox(
            height: 14,
            child: VerticalDivider(
              thickness: 1,
              width: 0,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showRightSlideDialog(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Row(
                  children: [
                    Text('筛选'),
                    Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Icon(
                        Iconfont.shaixuan,
                        size: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Text('品类'),
              Padding(
                padding: EdgeInsets.only(left: 2),
                child: Icon(
                  Iconfont.xiala2,
                  size: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RightDialog extends StatefulWidget {
  const _RightDialog();

  @override
  State<_RightDialog> createState() => __RightDialogState();
}

class __RightDialogState extends State<_RightDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('关键词'),
                SizedBox(height: 8),
                _TextFormField(
                  hintText: '请输入关键词',
                ),
                SizedBox(height: 20),
                Text('关键词范围'),
                _KeywordsWidget(
                  titles: ['产品名称', '产品编号', '产品货号', '产品种类', '产品包装', '产品证书'],
                ),
                SizedBox(height: 8),
                Text('关键词匹配'),
                _KeywordsWidget(
                  titles: ['模糊', '精准'],
                ),
                SizedBox(height: 8),
                Text('多货号搜索'),
                SizedBox(height: 8),
                _TextFormField(
                  hintText: '多货号查询以“，”隔开',
                ),
                SizedBox(height: 20),
                Text('多展厅编号搜索'),
                SizedBox(height: 8),
                _TextFormField(
                  hintText: '多展厅编号查询以“，”隔开',
                ),
                SizedBox(height: 20),
                Text('多展厅编号搜索'),
                SizedBox(height: 8),
                _RegionPricker(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegionPricker extends StatefulWidget {
  const _RegionPricker();

  @override
  State<_RegionPricker> createState() => __RegionPrickerState();
}

class __RegionPrickerState extends State<_RegionPricker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: PrimartButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color(0xFFF7F8FC),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '选择省',
                    style: TextStyle(color: Color(0xFFCACFD2)),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xFFCACFD2),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 34,
            child: PrimartButton(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Color(0xFFF7F8FC),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '选择市',
                    style: TextStyle(color: Color(0xFFCACFD2)),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xFFCACFD2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _KeywordsWidget extends StatefulWidget {
  const _KeywordsWidget({
    required this.titles,
  });

  final List<String> titles;

  @override
  State<_KeywordsWidget> createState() => __KeywordsWidgetState();
}

class __KeywordsWidgetState extends State<_KeywordsWidget> {
  int? _current;

  void _updateCurrent(int value) {
    int? newCurrent;
    if (value != _current) {
      newCurrent = value;
    }
    setState(() {
      _current = newCurrent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 12,
      childAspectRatio: 124 / 44,
      padding: EdgeInsets.all(10),
      children: List.generate(widget.titles.length, (index) {
        return GestureDetector(
          onTap: () => _updateCurrent(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: index == _current ? theme.primaryColor : Color(0xFFF7F8FC)),
              borderRadius: BorderRadius.circular(4.0),
              color: Color(0xFFF7F8FC),
            ),
            child: Center(
              child: Text(
                widget.titles[index],
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TextFormField extends TextFormField {
  _TextFormField({
    super.style = const TextStyle(fontSize: 12, height: 1.5),
    super.onSaved,
    String? hintText,
  }) : super(
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: Color(0xFFF7F8FC),
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Color(0xFFF30213)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
}

class SortingProvider extends ChangeNotifier {
  SortingType _currentSorting = SortingType.priceDown;
  SortingType get currentSorting => _currentSorting;

  set currentSorting(SortingType value) {
    _currentSorting = value;
    notifyListeners();
  }
}

class _Sorting {
  _Sorting({
    required this.text,
    required this.sortingType,
  });
  final String text;
  final List<SortingType> sortingType;
}

enum SortingType {
  comprehensive,
  hot,
  date,
  priceUp,
  priceDown,
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
