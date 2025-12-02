import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/primart_button.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  State<Role> createState() => _RoleState();
}

class _RoleState extends State<Role> {
  void _onConfirm(BuildContext context) {}

  final ValueNotifier<_Role?> _checkedRole = ValueNotifier<_Role?>(null);

  @override
  void dispose() {
    super.dispose();
    _checkedRole.dispose();
  }

  void _onChange(_Role value) {
    _checkedRole.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final double devicePixelRatio = View.of(context).devicePixelRatio;

    final double paddingBottom = View.of(context).viewPadding.bottom / devicePixelRatio;

    final paddingTop = View.of(context).viewPadding.top / devicePixelRatio;

    final double padding = paddingBottom == 0 ? 20 : paddingBottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: padding + 50),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: paddingTop),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFEE9E8), Color(0xFFFFF2EC)],
                          ),
                        ),
                        child: SizedBox(
                          height: 200,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 42),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello！',
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '欢迎使用玩好牛平台',
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 28),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    height: 72,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '角色选择',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: _Roles(onChange: _onChange),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(20, 20, 20, padding),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ValueListenableBuilder<_Role?>(
                  valueListenable: _checkedRole,
                  builder: (_, _Role? value, Widget? child) {
                    return PrimartButton(
                      color: theme.primaryColor,
                      disabledColor: Color.lerp(theme.primaryColor, Colors.white, 0.5)!,
                      onPressed: value != null ? () => _onConfirm(context) : null,
                      child: child!,
                    );
                  },
                  child: Text('下一步', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              shape: Border(
                bottom: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleDetail {
  _RoleDetail({
    required this.role,
    required this.name,
    required this.logoPath,
  });
  final _Role role;
  final String name;
  final String logoPath;
}

enum _Role {
  supplier,
  company,
  sersonal,
}

class _Roles extends StatefulWidget {
  const _Roles({
    required this.onChange,
  });
  final Function(_Role) onChange;

  @override
  State<_Roles> createState() => __RolesState();
}

class __RolesState extends State<_Roles> {
  final List<_RoleDetail> _roles = [
    _RoleDetail(role: _Role.supplier, name: '我是供应商', logoPath: 'assets/images/logo.png'),
    _RoleDetail(role: _Role.company, name: '我是贸易公司', logoPath: 'assets/images/logo.png'),
    _RoleDetail(role: _Role.sersonal, name: '个人', logoPath: 'assets/images/logo.png'),
  ];

  _Role? _checkedRole;

  Widget _characterBuilder(_RoleDetail item, color) {
    return GestureDetector(
      onTap: () {
        widget.onChange.call(item.role);
        setState(() {
          _checkedRole = item.role;
        });
      },
      child: ListTile(
        leading: Image.asset(
          item.logoPath,
          width: 58,
          height: 58,
        ),
        visualDensity: VisualDensity(vertical: 4),
        title: Text(
          item.name,
          style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _checkedRole == item.role ? color : Color(0xFFCACFD2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _roles.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: _characterBuilder(_roles[index], theme.primaryColor),
        );
      },
    );
  }
}
