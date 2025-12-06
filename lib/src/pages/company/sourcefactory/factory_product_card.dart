import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/models/source_supplier.dart';

/// 复用的厂商卡片，包含头像、厂商信息与 3 个产品缩略图
class FactoryProductCard extends StatelessWidget {
  const FactoryProductCard({
    super.key,
    this.onTap,
    this.supplier,
  });

  final VoidCallback? onTap;
  final SourceSupplier? supplier;

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!.call();
    } else {
      context.pushNamed('factoryDetail', extra: supplier);
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
                      child: supplier?.supplierLogo != null && supplier!.supplierLogo!.isNotEmpty
                          ? Image.network(
                              supplier!.supplierLogo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                            )
                          : Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            supplier?.supplierName ?? '厂家名称',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            supplier?.industryNames?.isNotEmpty == true
                                ? '主营：${supplier!.industryNames}'
                                : '主营：电动玩具、益智玩具..',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
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
                    _buildProductItem(
                      imageSize,
                      supplier?.frontProductBasicOutputs.isNotEmpty == true
                          ? supplier!.frontProductBasicOutputs[0]
                          : null,
                    ),
                    const SizedBox(width: gap),
                    _buildProductItem(
                      imageSize,
                      supplier != null && supplier!.frontProductBasicOutputs.length > 1
                          ? supplier!.frontProductBasicOutputs[1]
                          : null,
                    ),
                    const SizedBox(width: gap),
                    _buildProductItem(
                      imageSize,
                      supplier != null && supplier!.frontProductBasicOutputs.length > 2
                          ? supplier!.frontProductBasicOutputs[2]
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(double imageSize, FrontProductBasicOutput? product) {
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
              child: product != null && (product.imgUrl ?? '').isNotEmpty
                  ? Image.network(
                      product.imgUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.image, color: Colors.grey)),
                    )
                  : Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product?.prNa ?? '暂无商品',
            style: const TextStyle(
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
