import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/primart_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  void _phoneLogin() {
    context.pushNamed('phoneLogin');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SizedBox.expand(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: View.of(context).viewPadding.top / View.of(context).devicePixelRatio),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFEE9E8), Colors.white],
                        ),
                      ),
                      child: SizedBox(
                        height: 340,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     height: 50,
                    //     child: PrimartButton(
                    //       color: theme.primaryColor,
                    //       onPressed: () {},
                    //       child: Text(
                    //         '本机号码一键登录',
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: PrimartButton(
                          color: Color(0xFFEEEEEE),
                          onPressed: _phoneLogin,
                          child: Text(
                            '其他手机号登录',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 12, top: 20),
                    //   child: AgreementCheckbox(
                    //     onChange: _onChecked,
                    //   ),
                    // ),
                  ],
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  shape: Border(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
