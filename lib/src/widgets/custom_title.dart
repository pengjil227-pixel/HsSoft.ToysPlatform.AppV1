import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.2),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Color(0xFFF30213).withAlpha(160),
                    Colors.white.withAlpha(100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
