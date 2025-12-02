import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/modules/auth.dart';
import '../../core/providers/login_user.dart';
import '../../shared/models/login_user_info.dart';
import '../../shared/preferences/login_user_info.dart';
import '../../widgets/primart_button.dart';

class Character extends StatefulWidget {
  const Character({
    super.key,
    required this.userInfo,
  });

  final LoginUserInfo userInfo;

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  final ValueNotifier<CompanyInfos?> _checkedCompany = ValueNotifier<CompanyInfos?>(null);

  @override
  void dispose() {
    super.dispose();
    _checkedCompany.dispose();
  }

  Future<void> _onConfirm(BuildContext context) async {
    final response = await AuthService.loginByCompany(
      {
        "companyNumber": _checkedCompany.value!.companyNumber,
        "sourceType": AppConstants.sourceType,
      },
      Options(
        headers: {'Authorization': widget.userInfo.accessToken},
      ),
    );

    if (response.success) {
      await saveLoginUserInfo(jsonEncode(response.data!.toJson()));
      if (!context.mounted) return;
      context.read<LoginUser>().loginUser = response.data;
      context.go(AppConstants.isFactoryUser(LoginInfoSingleton.loginUserInfo) ? '/factoryHome' : '/');
    }
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
                    child: _Characters(
                      userInfo: widget.userInfo,
                      onChange: (value) {
                        _checkedCompany.value = value;
                      },
                    ),
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
                child: ValueListenableBuilder<CompanyInfos?>(
                  valueListenable: _checkedCompany,
                  builder: (_, CompanyInfos? value, Widget? child) {
                    return PrimartButton(
                      color: theme.primaryColor,
                      disabledColor: Color.lerp(theme.primaryColor, Colors.white, 0.5)!,
                      onPressed: value != null ? () => _onConfirm(context) : null,
                      child: child!,
                    );
                  },
                  child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 16)),
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

class _Characters extends StatefulWidget {
  const _Characters({
    required this.userInfo,
    required this.onChange,
  });

  final LoginUserInfo userInfo;

  final Function(CompanyInfos value) onChange;

  @override
  State<_Characters> createState() => __CharactersState();
}

class __CharactersState extends State<_Characters> {
  CompanyInfos? _selected;

  void _addCharacters() {
    context.pushNamed('roles');
  }

  void _onChange(CompanyInfos? value) {
    widget.onChange.call(value!);
    setState(() {
      _selected = value;
    });
  }

  Widget _addBuilder() {
    return GestureDetector(
      onTap: _addCharacters,
      child: ListTile(
        leading: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
        visualDensity: VisualDensity(vertical: 4),
        title: Text(
          '添加身份',
          style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _characterBuilder(CompanyInfos item) {
    return RadioListTile(
      radioSide: BorderSide.none,
      secondary: Image.network(
        item.companyLogo,
        width: 58,
        height: 58,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/logo.png',
            width: 58,
            height: 58,
            fit: BoxFit.cover,
          );
        },
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      value: item,
      visualDensity: VisualDensity(vertical: 4),
      title: Text(
        item.companyName,
        style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xFFCACFD2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup(
      groupValue: _selected,
      onChanged: _onChange,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.userInfo.companyInfos.length + 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Widget item;
          if (index == widget.userInfo.companyInfos.length) {
            item = _addBuilder();
          } else {
            item = _characterBuilder(widget.userInfo.companyInfos[index]);
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: item,
          );
        },
      ),
    );
  }
}
