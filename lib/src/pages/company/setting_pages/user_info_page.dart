import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/layout_constants.dart';
import '../../../core/providers/login_user.dart';
import 'package:iconfont/iconfont.dart';

// 1. 将页面转换为 StatefulWidget 以管理编辑状态
class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // 2. 添加一个布尔值来跟踪当前的编辑状态
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.watch<LoginUser>().loginUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Iconfont.fanhuianniu, color: Colors.black, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '个人信息',
            style: TextStyle(fontSize: 17, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0.5,
          actions: [
            TextButton(
              onPressed: () {
                // 3. 点击按钮时，切换编辑状态
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(80, 44), // 增加宽度以容纳“确认修改”
              ),
              child: Text(
                // 4. 根据编辑状态显示不同的文本
                _isEditing ? '确认修改' : '修改',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LayoutConstants.pagePadding),
        child: Column(
          children: [
            // --- 卡片一：头像、姓名、手机号 ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      width: 332,
                      height: 1,
                      color: const Color(0xFFF5F5F5),
                    ),
                  ),
                  _buildInfoRow(
                    label: '姓名',
                    value: user?.name ?? '*****',
                  ),
                  Center(
                    child: Container(
                      width: 332,
                      height: 1,
                      color: const Color(0xFFF5F5F5),
                    ),
                  ),
                  _buildInfoRow(
                    label: '手机号',
                    value: user?.mobile ?? '',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // --- 卡片二：绑定微信 ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildInfoRow(
                label: '绑定微信',
                value: user?.mobile ?? '未绑定',
                // 5. 在编辑模式下，显示“解绑”按钮
                trailing: _isEditing
                    ? GestureDetector(
                        onTap: () {
                          // TODO: 在这里处理解绑逻辑, 例如弹窗确认
                        },
                        child: Container(
                          width: 52,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.primaryColor, // 红色背景
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '解绑',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. 使用 Stack 重构，以支持在右侧添加额外小组件，同时保持中间文本的居中
  Widget _buildInfoRow({
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 左侧标签
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ),
          // 中间数值
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
            ),
          ),
          // 右侧额外内容 (如果存在)
          if (trailing != null)
            Align(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
        ],
      ),
    );
  }
}
