import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';

import 'locations_data.dart';

class Pickers {
  static void pickerProvince(
    BuildContext context, {
    PickerStyle? pickerStyle,
    Function(String value)? onConfirm,
  }) {
    pickerStyle ??= DefaultPickerStyle();
    pickerStyle.context ??= context;

    Navigator.of(context).push(AddressPickerRoute(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pickerStyle: pickerStyle,
      onConfirm: onConfirm,
    ));
  }
}

class AddressPickerRoute<T> extends PopupRoute<T> {
  AddressPickerRoute({
    this.barrierLabel,
    super.settings,
    required this.pickerStyle,
    this.onConfirm,
  });

  final PickerStyle pickerStyle;

  final Function(String value)? onConfirm;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return _PickerContentView(
            route: this,
            pickerStyle: pickerStyle,
            onConfirm: onConfirm,
          );
        },
      ),
    );

    return bottomSheet;
  }
}

class _PickerContentView extends StatefulWidget {
  const _PickerContentView({
    required this.pickerStyle,
    required this.route,
    this.onConfirm,
  });

  final PickerStyle pickerStyle;

  final AddressPickerRoute route;

  final Function(String value)? onConfirm;

  @override
  State<_PickerContentView> createState() => __PickerContentViewState();
}

class __PickerContentViewState extends State<_PickerContentView> {
  String _currentProvince = Address.provinces[0];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CustomSingleChildLayout(
      delegate: _BottomPickerLayout(widget.route.animation!.value, widget.pickerStyle),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimartButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                PrimartButton(
                  onPressed: () {
                    widget.onConfirm?.call(_currentProvince);
                    Navigator.pop(context);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(fontSize: 15, color: theme.primaryColor),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker.builder(
                itemExtent: 44,
                childCount: Address.provinces.length,
                onSelectedItemChanged: (int value) {
                  _currentProvince = Address.provinces[value];
                },
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    child: Text(
                      Address.provinces[index],
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.pickerStyle);

  final double progress;
  final PickerStyle pickerStyle;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = pickerStyle.pickerHeight;
    if (pickerStyle.showTitleBar) {
      maxHeight += pickerStyle.pickerTitleHeight;
    }
    if (pickerStyle.menu != null) {
      maxHeight += pickerStyle.menuHeight;
    }

    return BoxConstraints(minWidth: constraints.maxWidth, maxWidth: constraints.maxWidth, minHeight: 0.0, maxHeight: maxHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

class PickerStyle {
  BuildContext? context;
  final bool showTitleBar;
  final Widget? menu;
  final double pickerHeight;
  final double pickerTitleHeight;
  final double pickerItemHeight;
  final double menuHeight;
  final Widget cancelButton;
  final Widget commitButton;
  final Widget title;
  final Decoration headDecoration;
  final Color backgroundColor;
  final Color textColor;
  final double? textSize;
  final Widget? itemOverlay;

  PickerStyle({
    this.context,
    this.showTitleBar = true,
    this.menu,
    this.pickerHeight = 220.0,
    this.pickerTitleHeight = 44.0,
    this.pickerItemHeight = 40.0,
    this.menuHeight = 36.0,
    Widget? cancelButton,
    Widget? commitButton,
    Widget? title,
    Decoration? headDecoration,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.textSize,
    this.itemOverlay,
  })  : headDecoration = headDecoration ?? BoxDecoration(color: Colors.white),
        title = title ?? const SizedBox(),
        cancelButton = cancelButton ?? _buildDefaultCancelButton(context),
        commitButton = commitButton ?? _buildDefaultCommitButton(context);

  static Widget _buildDefaultCancelButton(BuildContext? context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Text(
        '取消',
        style: TextStyle(
          color: context != null ? Theme.of(context).unselectedWidgetColor : Colors.grey,
          fontSize: 16.0,
        ),
      ),
    );
  }

  static Widget _buildDefaultCommitButton(BuildContext? context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Text(
        '确定',
        style: TextStyle(
          color: context != null ? Theme.of(context).primaryColor : Colors.blue,
          fontSize: 16.0,
        ),
      ),
    );
  }

  PickerStyle copyWith({
    BuildContext? context,
    bool? showTitleBar,
    Widget? menu,
    double? pickerHeight,
    double? pickerTitleHeight,
    double? pickerItemHeight,
    double? menuHeight,
    Widget? cancelButton,
    Widget? commitButton,
    Widget? title,
    Decoration? headDecoration,
    Color? backgroundColor,
    Color? textColor,
    double? textSize,
    Widget? itemOverlay,
  }) {
    return PickerStyle(
      context: context ?? this.context,
      showTitleBar: showTitleBar ?? this.showTitleBar,
      menu: menu ?? this.menu,
      pickerHeight: pickerHeight ?? this.pickerHeight,
      pickerTitleHeight: pickerTitleHeight ?? this.pickerTitleHeight,
      pickerItemHeight: pickerItemHeight ?? this.pickerItemHeight,
      menuHeight: menuHeight ?? this.menuHeight,
      cancelButton: cancelButton ?? this.cancelButton,
      commitButton: commitButton ?? this.commitButton,
      title: title ?? this.title,
      headDecoration: headDecoration ?? this.headDecoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      itemOverlay: itemOverlay ?? this.itemOverlay,
    );
  }
}

class DefaultPickerStyle extends PickerStyle {
  DefaultPickerStyle({
    bool haveRadius = false,
    String? title,
    super.context,
  }) : super(
          headDecoration: haveRadius
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                )
              : BoxDecoration(color: Colors.white),
          title: title != null && title.isNotEmpty
              ? Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                )
              : const SizedBox(),
        );
}

class DarkPickerStyle extends PickerStyle {
  DarkPickerStyle({
    bool haveRadius = false,
    String? title,
    super.context,
  }) : super(
          backgroundColor: Colors.grey[800]!,
          textColor: Colors.white,
          headDecoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: haveRadius
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : null,
          ),
          title: title != null && title.isNotEmpty
              ? Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              : const SizedBox(),
          cancelButton: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: const Text(
              '取消',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          commitButton: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            child: const Text(
              '确定',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        );
}
