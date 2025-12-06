import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../shared/models/source_supplier.dart';

/// 通用的工厂联系方式弹层
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
          color: Colors.transparent,
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

                  final displayName = contact?.supplierName ?? detail?.companyName ?? 'XXX厂商';
                  final qrData = contact?.phoneNumber ?? contact?.supplierNumber ?? detail?.supplierNumber ?? 'factory-contact';
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
                              child: _ContactLines(contact: contact),
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

class _ContactLines extends StatelessWidget {
  const _ContactLines({this.contact});

  final SupplierContact? contact;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    void addLine(String label, String? value) {
      if (value == null || value.isEmpty) return;
      if (rows.isNotEmpty) rows.add(const SizedBox(height: 6));
      rows.add(_ContactLine(label: label, value: value));
    }

    addLine('联系人：', contact?.linkMan);
    addLine('联系电话：', contact?.telePhoneNumber);
    addLine('联系手机：', contact?.phoneNumber);

    if (rows.isEmpty) {
      rows.add(const _ContactLine(label: '暂无联系方式', value: ''));
    }

    // Use CrossAxisAlignment.start to align the rows to the left
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Ensures the Row is only as wide as its children.
      children: [
        // Align label text to the left (first column)
        SizedBox(
          width: 100, // Adjust width to fit labels
          child: Align(
            alignment: Alignment.centerLeft, // Align label to the left
            child: Text(
              label,
              textAlign: TextAlign.left, // Align labels for the left side
              style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.2),
            ),
          ),
        ),
        const SizedBox(width: 5), // Small gap between label and value
        // The corresponding value (second column)
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right, // Right-align the value for each row
            style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.2),
          ),
        ),
      ],
    );
  }
}
