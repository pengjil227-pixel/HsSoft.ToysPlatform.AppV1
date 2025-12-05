import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/layout_constants.dart';

class FactoryNamePage extends StatelessWidget {
  const FactoryNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bgColor = Color(0xFFF4F4F4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          '工厂名称',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconfont.fanhuianniu, color: Colors.black, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LayoutConstants.pagePadding),
        child: Column(
          children: [
            _FactoryInfoCard(primaryColor: theme.primaryColor),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 335 / 150,
                child: Image.network(
                  'https://picsum.photos/670/300',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactoryInfoCard extends StatelessWidget {
  const _FactoryInfoCard({required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '厂商信息',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Iconfont.fuzhi1, size: 18, color: Color(0xFF999999)),
              const Spacer(),
              GestureDetector(
                onTap: () => _showContactDialog(context, primaryColor),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Iconfont.dianhua1, size: 18, color: Color(0xFF666666)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _InfoRow(label: '厂商名称', value: '***厂商'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          const _InfoRow(label: '主营业务', value: '电动玩具、遥控类'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          const _InfoRow(label: '地址', value: '广东省汕头市******'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          const _InfoRow(
            label: '工厂介绍',
            value: '耀昇以“玩点有趣的”为品牌主张，秉承好玩、有趣的品牌基因，通过独特的IP孵化、产品开发和服务，在全球范围内持续传递快乐与陪伴。',
            isMultiLine: true,
          ),
        ],
      ),
    );
  }
}

void _showContactDialog(BuildContext context, Color primaryColor) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) {
      return Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                const double cardWidth = 334;
                const double avatarSize = 90;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: cardWidth,
                      padding: const EdgeInsets.fromLTRB(16, 58, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            'XXX厂商',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: QrImageView(
                              data: 'factory-contact-demo',
                              version: QrVersions.auto,
                              size: 180,
                              backgroundColor: Colors.white,
                              gapless: true,
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black87,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '长按二维码，即刻联系',
                            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/lianxibeijing.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ContactLine(label: '联系人：', value: '***'),
                                    SizedBox(height: 6),
                                    _ContactLine(label: '联系电话：', value: '0755-*******'),
                                    SizedBox(height: 6),
                                    _ContactLine(label: '联系手机：', value: '180 **** ****'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -avatarSize / 2,
                      left: (cardWidth - avatarSize) / 2,
                      child: CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundColor: const Color(0xFFF3F3F3),
                        backgroundImage: const AssetImage('assets/images/avatar@2x.png'),
                        // child: Icon(Iconfont.dianhua1, color: primaryColor, size: 26),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label$value',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isMultiLine = false,
  });

  final String label;
  final String value;
  final bool isMultiLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
            maxLines: isMultiLine ? null : 1,
            overflow: isMultiLine ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
