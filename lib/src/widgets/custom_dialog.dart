import 'package:flutter/material.dart';
import 'package:flutter_wanhaoniu/src/widgets/primart_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showToast(String msg) async {
  await Fluttertoast.cancel();
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xFF383B42),
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

Future<T?> showConfirmDialog<T>({
  required BuildContext context,
  String? title,
  String? content,
  Function()? confirm,
}) async {
  final ThemeData thtme = Theme.of(context);
  return showDialog<T?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        constraints: BoxConstraints(
          maxWidth: 240,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (content != null)
                    Text(
                      content,
                      style: TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
            Divider(height: 0, thickness: 0.6),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: PrimartButton(
                      child: Text(
                        '取消',
                        style: TextStyle(color: thtme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  VerticalDivider(width: 0, thickness: 0.6),
                  Expanded(
                    child: PrimartButton(
                      onPressed: confirm,
                      child: Text(
                        '确定',
                        style: TextStyle(color: thtme.primaryColor, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
