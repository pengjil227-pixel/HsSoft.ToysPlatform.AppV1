import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/layout_constants.dart';
import '../../core/providers/login_user.dart';
import '../../shared/preferences/login_user_info.dart';
import '../../widgets/async_button_background.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/primart_button.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final List<_Setting> _settingType = [
    _Setting(text: '个人信息', settingType: _SettingType.info),
    _Setting(text: '关于我们', settingType: _SettingType.about),
  ];
  Future<void> _logout(BuildContext context) async {
    await deleteLoginUserInfo();
    if (!context.mounted) return;
    final loginUserModal = context.read<LoginUser>();
    loginUserModal.loginUser = null;
    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: SizedBox.expand(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(LayoutConstants.pagePadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: _settingType.map((item) {
                            return AsyncButtonBackground(
                              onTap: () {},
                              child: ListTile(
                                title: Text(item.text),
                              ),
                            );
                          }).toList(),
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: math.max(20, View.of(context).viewPadding.bottom / View.of(context).devicePixelRatio)),
                      child: SizedBox(
                        child: PrimartButton(
                          color: Colors.white,
                          onPressed: () {
                            showConfirmDialog(
                              confirm: () => _logout(context),
                              context: context,
                              title: '退出?',
                              content: '@用户11111111',
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48),
                            child: Text(
                              '退出登录',
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Setting {
  _Setting({
    required this.text,
    required this.settingType,
  });
  final String text;
  final _SettingType settingType;
}

enum _SettingType {
  info,
  about,
}
