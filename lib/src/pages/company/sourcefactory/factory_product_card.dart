import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 复用的厂商卡片，包含头像、厂商信息与 3 个产品缩略图
class FactoryProductCard extends StatelessWidget {
  const FactoryProductCard({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!.call();
    } else {
      context.pushNamed('factoryDetail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double gap = 10;
            // 根据可用宽度动态计算缩略图尺寸，避免在小屏设备上溢出
            final double imageSize = (constraints.maxWidth - gap * 2) / 3;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '厂家名称',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '主营：电动玩具、益智玩具..',
                            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductItem(imageSize),
                    const SizedBox(width: gap),
                    _buildProductItem(imageSize),
                    const SizedBox(width: gap),
                    _buildProductItem(imageSize),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(double imageSize) {
    return SizedBox(
      width: imageSize,
      child: Column(
        children: [
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                'https://picsum.photos/109/109',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.image, color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '拉布布滋滋球',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
