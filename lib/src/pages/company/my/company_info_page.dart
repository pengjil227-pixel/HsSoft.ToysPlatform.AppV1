import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CompanyInfoPage extends StatelessWidget {
  const CompanyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        title: const Text('公司信息', style: TextStyle(color: Color(0xFF333333))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text('修改', style: TextStyle(color: Color(0xFFE53935), fontSize: 16)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  _ImageBox(
                    imageUrl: 'https://dummyimage.com/340x200/F8F8F8/AAAAAA&text=%E8%90%A5%E4%B8%9A%E6%89%A7%E7%85%A7',
                  ),
                  SizedBox(width: 12),
                  _ImageBox(showLogo: true),
                ],
              ),
              SizedBox(height: 16),
              _InfoRow(label: '联系人', value: '某某某'),
              _InfoRow(label: '公司名称', value: '名称'),
              _InfoRow(label: '简称', value: '简称'),
              _InfoRow(label: '电话', value: '123 4567 8910'),
              _InfoRow(label: '传真', value: '123 4567 8910'),
              _InfoRow(label: '电子邮箱', value: '123 4567 8910'),
              _InfoRow(label: '所在城市', value: '广东省****'),
              _InfoRow(label: '详细地址', value: '澄海区*****'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({this.imageUrl, this.showLogo = false});
  final String? imageUrl;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.7,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: showLogo
              ? const Center(
                  child: Text(
                    '玩好牛',
                    style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 16),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Color(0xFFBBBBBB))),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Color(0xFF666666))),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }
}
