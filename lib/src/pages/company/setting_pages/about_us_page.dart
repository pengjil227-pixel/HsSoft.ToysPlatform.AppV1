import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 1. 引入路由库
import 'package:iconfont/iconfont.dart';
import '../../../widgets/custom_dialog.dart'; // 2. 引入Toast工具(用于显示检测更新提示)

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconfont.fanhuianniu, color: Colors.black, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('关于我们'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // --- 顶部 Logo 和 版本号 ---
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '版本号 01.01.01',
                    style: TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 菜单列表 ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildItem(
                    '检测更新',
                    showNewBadge: true,

                    onTap: () {
                      showToast('当前已是最新版本');
                    },
                  ),
                  _buildDivider(),

                  _buildItem(
                    '自动下载玩好牛安装包',
                    trailingText: '仅WiFi网络',

                    onTap: () {
                      showToast('点击了自动下载设置');
                    },
                  ),
                  _buildDivider(),

                  _buildItem(
                    '版权信息',
                    onTap: () {
                      _goWebView(context, '版权信息', 'https://www.baidu.com');
                    },
                  ),
                  _buildDivider(),

                  _buildItem(
                    '服务协议',
                    onTap: () {
                      _goWebView(context, '服务协议', 'https://www.baidu.com');
                    },
                  ),
                  _buildDivider(),

                  _buildItem(
                    '营业执照',
                    onTap: () {
                      _goWebView(context, '营业执照', 'https://www.baidu.com');
                    },
                  ),
                  _buildDivider(),

                  _buildItem(
                    '备案信息',
                    onTap: () {
                      _goWebView(context, '备案信息', 'https://www.baidu.com');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- 封装跳转逻辑 (跳到 WebView) ---
  void _goWebView(BuildContext context, String title, String url) {
    context.pushNamed(
      'webView',
      pathParameters: {
        'title': title,
        'url': url,
      },
    );
  }

  // --- 分割线 ---
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Color(0xFFF0F0F0),
      indent: 16,
      endIndent: 16,
    );
  }

  // --- 列表项组件 (增加了 onTap 参数) ---
  Widget _buildItem(
      String title, {
        bool showNewBadge = false,
        String? trailingText,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),

            if (showNewBadge) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE64545),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'new',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1.1,
                  ),
                ),
              ),
            ],

            const Spacer(),

            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 6),
            ],

            const Icon(
              Iconfont.a_jiantouyou,
              size: 12,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}