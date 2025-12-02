import 'package:flutter/material.dart';

class WebView extends StatelessWidget {
  const WebView({
    super.key,
    this.title,
    required this.url,
  });

  final String? title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
      ),
      body: Container(),
    );
  }
}
