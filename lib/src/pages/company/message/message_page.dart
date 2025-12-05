import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.of(context).padding;
    final List<_MessageItem> items = [
      const _MessageItem(
        title: '耀昇玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
      const _MessageItem(
        title: '风新玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
      const _MessageItem(
        title: '金成峰玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
      const _MessageItem(
        title: '千喜玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
      const _MessageItem(
        title: '万隆玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
      const _MessageItem(
        title: '行建玩具展厅',
        subtitle: '玩具贸易风向标：旺季商机 & 新规速看',
        time: '2025-10-22 10:30',
        avatar:
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=100&q=60',
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _MessageHeaderDelegate(paddingTop: mediaPadding.top),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return _MessageTile(
                    item: item,
                    showDivider: index != items.length - 1,
                  );
                },
                childCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  const _GradientHeader({required this.paddingTop, required this.height});

  final double paddingTop;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, paddingTop + 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFEFBEC), Color(0xFFFFF2EC), Color(0xFFFEE9E8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text(
            '消息',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(
                child: _CategoryButton(
                  label: '全部',
                  gradient: [Color(0xFFFCC13E), Color(0xFFFFA90A)],
                  icon: Icons.menu,
                ),
              ),
              Expanded(
                child: _CategoryButton(
                  label: '工厂消息',
                  gradient: [Color(0xFFC589FF), Color(0xFF9A6CFF)],
                  icon: Icons.house_rounded,
                ),
              ),
              Expanded(
                child: _CategoryButton(
                  label: '系统消息',
                  gradient: [Color(0xFF77E370), Color(0xFF57D24B)],
                  icon: Icons.notifications_rounded,
                  badgeText: '8',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.gradient,
    required this.icon,
    this.badgeText,
  });

  final String label;
  final List<Color> gradient;
  final IconData icon;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: gradient),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            if (badgeText != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(9.5),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}

class _MessageItem {
  final String title;
  final String subtitle;
  final String time;
  final String avatar;

  const _MessageItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.avatar,
  });
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({required this.item, this.showDivider = true});

  final _MessageItem item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: showDivider ? const Color(0xFFF1F1F1) : Colors.transparent, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                item.avatar,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    Container(width: 48, height: 48, color: const Color(0xFFECECEC)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB2B2B2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9A9A9A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MessageHeaderDelegate({required this.paddingTop});

  final double paddingTop;

  final double _contentHeight = 180;

  @override
  double get minExtent => paddingTop + _contentHeight;

  @override
  double get maxExtent => paddingTop + _contentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _GradientHeader(
      paddingTop: paddingTop,
      height: maxExtent,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
