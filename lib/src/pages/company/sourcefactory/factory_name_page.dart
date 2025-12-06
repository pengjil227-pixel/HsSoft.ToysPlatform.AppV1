import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconfont/iconfont.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/layout_constants.dart';
import '../../../core/network/modules/factory_service.dart';
import '../../../shared/models/source_supplier.dart';

class FactoryNamePage extends StatefulWidget {
  const FactoryNamePage({super.key, this.supplier, this.detail});

  final SourceSupplier? supplier;
  final SupplierDetail? detail;

  @override
  State<FactoryNamePage> createState() => _FactoryNamePageState();
}

class _FactoryNamePageState extends State<FactoryNamePage> {
  SupplierDetail? _detail;
  SupplierContact? _contact;
  bool _loading = true;
  String? _error;
  bool _contactLoading = false;
  String? _contactError;

  @override
  void initState() {
    super.initState();
    _detail = widget.detail;
    if (_detail == null) {
      _fetchDetail();
    } else {
      _loading = false;
    }
  }

  Future<void> _fetchDetail() async {
    try {
      final res = await FactoryService.getSupplierDetail(
        id: widget.supplier?.id,
        supplierNumber: widget.supplier?.supplierNumber,
      );
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _detail = res.data;
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _error = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _fetchContact() async {
    final id = _detail?.id ?? widget.supplier?.id;
    if (id == null) return;
    setState(() {
      _contactLoading = true;
      _contactError = null;
    });
    try {
      final res = await FactoryService.getSupplierContact(id: id);
      if (!mounted) return;
      if (res.success && res.data != null) {
        setState(() {
          _contact = res.data;
          _contactLoading = false;
        });
      } else {
        setState(() {
          _contactLoading = false;
          _contactError = res.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _contactLoading = false;
        _contactError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bgColor = Color(0xFFF4F4F4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _detail?.companyName ?? widget.supplier?.supplierName ?? '工厂名称',
          style: const TextStyle(
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
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('加载失败：$_error'));
    }
    if (_detail == null) {
      return const Center(child: Text('暂无数据'));
    }

    final addressParts = [
      _detail?.province,
      _detail?.city,
      _detail?.area,
      _detail?.address,
    ].where((e) => e != null && e.isNotEmpty).join('');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(LayoutConstants.pagePadding),
      child: Column(
        children: [
          _FactoryInfoCard(
            detail: _detail!,
            primaryColor: theme.primaryColor,
            address: addressParts,
            onContact: _showContactDialog,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 335 / 150,
              child: Image.network(
                (_detail?.bgImg?.isNotEmpty ?? false) ? _detail!.bgImg! : 'https://picsum.photos/670/300',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/images/logo.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() async {
    if (_contact == null && !_contactLoading) {
      await _fetchContact();
    }
    if (!mounted) return;
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

                  if (_contactLoading) {
                    return const Dialog(
                      child: SizedBox(height: 120, width: 200, child: Center(child: CircularProgressIndicator())),
                    );
                  }
                  if (_contactError != null) {
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
                              child: Text('获取联系方式失败：$_contactError', textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final contact = _contact;
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
                              contact?.supplierName ?? _detail?.companyName ?? '厂商',
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
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: contact?.phoneNumber ?? contact?.supplierNumber ?? 'contact',
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
                                    _contactLine('联系人：', contact?.linkMan ?? '--'),
                                    const SizedBox(height: 6),
                                    _contactLine('联系电话：', contact?.telePhoneNumber ?? '--'),
                                    const SizedBox(height: 6),
                                    _contactLine('联系手机：', contact?.phoneNumber ?? '--'),
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
        );
      },
    );
  }

  Widget _contactLine(String label, String value) {
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

class _FactoryInfoCard extends StatelessWidget {
  const _FactoryInfoCard({
    required this.detail,
    required this.primaryColor,
    required this.address,
    required this.onContact,
  });

  final SupplierDetail detail;
  final Color primaryColor;
  final String address;
  final VoidCallback onContact;

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
                onTap: onContact,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Iconfont.dianhua1, size: 18, color: Color(0xFF666666)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: '厂商名称', value: detail.companyName ?? '暂无'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          _InfoRow(label: '主营业务', value: detail.mainBusiness ?? '暂无'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          _InfoRow(label: '地址', value: address.isNotEmpty ? address : '暂无'),
          const Divider(height: 24, color: Color(0xFFEDEDED), thickness: 0.8),
          _InfoRow(
            label: '工厂介绍',
            value: detail.introduction ?? '暂无',
            isMultiLine: true,
          ),
        ],
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
            maxLines: isMultiLine ? null : 2,
            overflow: isMultiLine ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
