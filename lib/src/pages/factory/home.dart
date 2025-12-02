import 'package:flutter/material.dart';

class FactoryHomePage extends StatefulWidget {
  const FactoryHomePage({super.key});

  @override
  State<FactoryHomePage> createState() => _FactoryHomePageState();
}

class _FactoryHomePageState extends State<FactoryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('工厂首页'),
      ),
    );
  }
}
