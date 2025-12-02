import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:go_router/go_router.dart';

class AgreementCheckbox extends StatelessWidget {
  const AgreementCheckbox({
    super.key,
    required this.value,
    required this.onChange,
  });

  final bool? value;

  final Function(bool value) onChange;

  static void goPrivacy(BuildContext context, String title) {
    context.pushNamed('webView', pathParameters: {'title': title, 'url': 'www.baidu.com'});
  }

  static Future<void> showPopDialog(
    BuildContext context, {
    Function()? onConfirm,
  }) async {
    final ThemeData theme = Theme.of(context);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: DefaultTextStyle(
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color, height: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('请阅读并同意'),
                    GestureDetector(
                      onTap: () {
                        goPrivacy(context, '隐私政策');
                      },
                      child: Text('《隐私政策》', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    goPrivacy(context, '服务协议');
                  },
                  child: Text('《服务协议》', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: PrimartButton(
                    color: Color(0xFFEEEEEE),
                    onPressed: context.pop,
                    child: Text('取消'),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: PrimartButton(
                    color: theme.primaryColor,
                    onPressed: () {
                      context.pop();
                      onConfirm?.call();
                    },
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 34,
          height: 34,
          child: Checkbox(
            value: value,
            side: BorderSide(
              color: Color(0xFFCACFD2),
              width: 1,
            ),
            onChanged: (bool? value) {
              onChange.call(value ?? false);
            },
            // 添加视觉样式使其看起来像单选框
            shape: CircleBorder(),
          ),
        ),
        Text(
          '已阅读并同意',
          style: TextStyle(color: Color(0xFFCACFD2)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('用户服务协议'),
        ),
        Text(
          '和',
          style: TextStyle(color: Color(0xFFCACFD2)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('隐私政策'),
        ),
      ],
    );
  }
}
