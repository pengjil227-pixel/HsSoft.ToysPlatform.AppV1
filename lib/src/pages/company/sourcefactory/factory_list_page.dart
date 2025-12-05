import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/layout_constants.dart';
import 'factory_product_card.dart';

class FactoryListPage extends StatelessWidget {
  const FactoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bgColor = Color(0xFFF4F4F4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: _SearchBar(theme: theme),
        centerTitle: true,
        toolbarHeight: 72,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(LayoutConstants.pagePadding),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FactoryBlock(theme: theme),
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.primaryColor, width: 1.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: Color(0xFFB3B3B3)),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    '搪胶玩具',
                    style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 28,
                  width: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text('搜索', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FactoryBlock extends StatelessWidget {
  const _FactoryBlock({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return const FactoryProductCard();
  }
}
