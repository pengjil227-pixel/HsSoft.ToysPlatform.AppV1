import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/modules/auth.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/primart_button.dart';
import 'widgets/agreement_checkbox.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final ValueNotifier<bool> _checked = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _canLogin = ValueNotifier<bool>(true);

  String _mobile = '13428994969';
  String _code = '666666';


  @override
  void dispose() {
    super.dispose();
    _checked.dispose();
    _canLogin.dispose();
  }

  void _updateCanLogin() {
    _canLogin.value = _mobile.isNotEmpty && _code.isNotEmpty;
  }

  void _onChecked(bool value) {
    _checked.value = value;
  }

  Future<void> _login(BuildContext context) async {
    if (!_checked.value) {
      await AgreementCheckbox.showPopDialog(
        context,
        onConfirm: () {
          _checked.value = true;
        },
      );

      if (!_checked.value) return;
    }

    final response = await AuthService.loginByMobile({
      "mobile": _mobile,
      "verificationCode": _code,
      "sourceEnum": 0,
      "isAlwayLogin": true,
    });

    if (response.success) {
      final token = response.data?.accessToken ?? '';
      if (token.isNotEmpty) {
        debugPrint('\n========== LOGIN TOKEN ==========\n$token\n=================================\n');
      } else {
        debugPrint('\n========== LOGIN TOKEN ==========\n<empty>\n=================================\n');
      }
      // await saveLoginUserInfo(response.data!.toJson().toString());
      if (!context.mounted) return;
      // context.read<LoginUser>().loginUser = response.data;
      context.pushReplacementNamed(
        'character',
        pathParameters: {'userInfo': jsonEncode(response.data!.toJson())},
      );
    } else {
      showToast(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: View.of(context).viewPadding.top / View.of(context).devicePixelRatio),
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
                    '短信验证码登录',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: _mobile,
                          keyboardType: TextInputType.phone,
                          onChanged: (String? value) {
                            _mobile = value ?? '';
                            _updateCanLogin();
                          },
                          decoration: InputDecoration(
                            hintText: '请输入手机号',
                            fillColor: Color(0xFFEEEEEE),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0), // 圆角大小
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: _code,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          onChanged: (String? value) {
                            _code = value ?? '';
                            _updateCanLogin();
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '请输入验证码',
                            fillColor: Color(0xFFEEEEEE),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0), // 圆角大小
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(4),
                              child: PrimartButton(
                                color: theme.primaryColor,
                                onPressed: () {},
                                child: Text(
                                  '发送验证码',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _canLogin,
                            builder: (_, bool value, Widget? child) {
                              return PrimartButton(
                                color: theme.primaryColor,
                                disabledColor: Color.lerp(theme.primaryColor, Colors.white, 0.5)!,
                                onPressed: value ? () => _login(context) : null,
                                child: child!,
                              );
                            },
                            child: Text(
                              '注册/登录',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12, top: 20),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _checked,
                      builder: (_, bool value, __) {
                        return AgreementCheckbox(
                          value: value,
                          onChange: _onChecked,
                        );
                      },
                    ),
                  ),
                ],
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
