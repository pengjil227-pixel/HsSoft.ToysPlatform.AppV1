import 'package:flutter/material.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({
    super.key,
    required this.pages,
    required this.items,
  }) : assert(items.length >= 2 && pages.length == items.length);

  final List<Widget> pages;

  final List<CustomBottomNavigationBarItem> items;

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNavigationBarTap(int index) {
    _controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: widget.pages,
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onChange: _onNavigationBarTap,
        items: widget.items,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    required this.onChange,
    required this.items,
  });

  final Function(int value) onChange;

  final List<CustomBottomNavigationBarItem> items;

  @override
  State<_BottomNavigationBar> createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  int _current = 0;

  void _onChange(int value) {
    if (_current == value) return;
    widget.onChange.call(value);
    setState(() {
      _current = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 0,
          thickness: 0.6,
        ),
        BottomNavigationBar(
          currentIndex: _current,
          onTap: _onChange,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: widget.items,
        ),
      ],
    );
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem({
    required super.icon,
    required super.label,
    super.activeIcon,
  });
}
