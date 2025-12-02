import 'package:flutter/material.dart';

class AsyncButtonBackground extends StatefulWidget {
  const AsyncButtonBackground({
    super.key,
    this.onTap,
    this.color,
    required this.child,
    this.duration = const Duration(milliseconds: 50),
  });

  final Color? color;
  final Function()? onTap;
  final Widget child;
  final Duration duration;

  @override
  State<AsyncButtonBackground> createState() => _AsyncButtonBackgroundState();
}

class _AsyncButtonBackgroundState extends State<AsyncButtonBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = _animationController.view;
  }

  Future<void> _asyncTask() async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      await widget.onTap?.call();
    } finally {
      if (mounted) {
        await Future.delayed(Duration(milliseconds: 50));
        if (mounted) {
          _isProcessing = false;
          await _animationController.animateBack(0.0);
        }
      }
    }
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.value = 1.0;
  }

  void _handleTapCancel() {
    if (!_isProcessing) {
      _animationController.animateTo(0.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = widget.color ?? theme.scaffoldBackgroundColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapCancel: _handleTapCancel,
      onTap: _asyncTask,
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (_, Widget? child) {
          return Material(
            color: color.withAlpha((_opacityAnimation.value * 255).toInt()),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
