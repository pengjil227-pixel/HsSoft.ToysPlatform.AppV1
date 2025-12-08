import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../shared/models/source_supplier.dart';

/// 通用的工厂联系方式弹层，样式与 FactoryName 页面一致。
void showFactoryContactDialog(
  BuildContext context, {
  required Color primaryColor,
  SupplierDetail? detail,
  SupplierContact? contact,
  bool loading = false,
  String? error,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent, // Ensure Material is transparent for correct rendering
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  const double cardWidth = 334;
                  const double avatarSize = 90;

                  if (loading) {
                    return const Dialog(
                      child: SizedBox(height: 120, width: 200, child: Center(child: CircularProgressIndicator())),
                    );
                  }
                  if (error != null) {
                    return Dialog(
                      child: SizedBox(
                        height: 140,
                        width: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('获取联系方式失败：$error', textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final displayName = contact?.supplierName ?? detail?.companyName ?? '厂商';
                  final qrData = contact?.phoneNumber ?? contact?.supplierNumber ?? detail?.supplierNumber ?? 'contact';

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
                            Text(
                              displayName,
                              style: const TextStyle(
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
                                data: qrData,
                                version: QrVersions.auto,
                                size: 180,
                                backgroundColor: Colors.white,
                                gapless: true,
                                eyeStyle: const QrEyeStyle(
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
                              '长按扫码，即刻联系',
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
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _ContactLine(label: '联系人：', value: contact?.linkMan ?? '--'),
                                    const SizedBox(height: 6),
                                    _ContactLine(label: '联系电话：', value: contact?.telePhoneNumber ?? '--'),
                                    const SizedBox(height: 6),
                                    _ContactLine(label: '联系手机：', value: contact?.phoneNumber ?? '--'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -avatarSize / 2,
                        left: (cardWidth - avatarSize) / 2,
                        child: const CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: Color(0xFFF3F3F3),
                          backgroundImage: AssetImage('assets/images/avatar@2x.png'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
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
        color: Color(0xFF333333),
        height: 1.2,
      ),
    );
  }
}
