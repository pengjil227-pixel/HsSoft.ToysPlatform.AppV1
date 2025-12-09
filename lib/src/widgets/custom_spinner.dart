// 核心：自定义旋转动画组件
import 'package:flutter/material.dart';
import 'package:iconfont/iconfont.dart';

class CustomSpinner extends StatefulWidget {
  const CustomSpinner({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

// 必须混入 SingleTickerProviderStateMixin
class _CustomSpinnerState extends State<CustomSpinner> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // 1. 初始化动画控制器
    // duration: 控制旋转速度，数值越小转得越快
    // vsync: this 用于优化性能，避免后台消耗资源
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    // 2. 让动画无限循环播放
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      // 3. 将动画控制器关联到旋转角度上
      // turns: 0.0 到 1.0 对应 0° 到 360°
      turns: _animationController,
      // 4. 这里放置你的自定义图标
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Icon(Colorfont.loading, size: 20),
      ),
    );
  }

  // 5. 非常重要：页面销毁时必须释放控制器，防止内存泄漏
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
