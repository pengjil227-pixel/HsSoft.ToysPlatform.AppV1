import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 高颜值 Toast 工具类，基于 flutter_smart_dialog + flutter_animate。
class ToastUtils {
  const ToastUtils._();

  /// 顶部弹入的成功提示 + 右下角 “+1” 气泡。
  static void showSuccess(BuildContext context) {
    const String toastTag = 'toast-success';
    const String bubbleTag = 'toast-success-bubble';

    SmartDialog.dismiss(tag: toastTag);
    SmartDialog.dismiss(tag: bubbleTag);

    SmartDialog.show(
      tag: toastTag,
      alignment: Alignment.topCenter,
      usePenetrate: true,
      maskColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Animate(
            onComplete: (_) => SmartDialog.dismiss(tag: toastTag),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xD9000000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Color(0xFF00C853), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '已加入购物车',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          )
              .slideY(begin: -1.0, end: 0.0, duration: 280.ms, curve: Curves.easeOutCubic)
              .fadeIn(duration: 220.ms)
              .then(delay: 1800.ms)
              .slideY(begin: 0.0, end: -1.0, duration: 240.ms, curve: Curves.easeInCubic)
              .fadeOut(duration: 240.ms),
        );
      },
    );

    SmartDialog.show(
      tag: bubbleTag,
      alignment: Alignment.bottomRight,
      usePenetrate: true,
      maskColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(right: 24, bottom: 32),
          child: Animate(
            onComplete: (_) => SmartDialog.dismiss(tag: bubbleTag),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFF9700),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '+1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ),
          )
              .scale(
                begin: const Offset(0.4, 0.4),
                end: const Offset(1.12, 1.12),
                duration: 200.ms,
                curve: Curves.easeOutBack,
              )
              .then()
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(0.96, 0.96),
                duration: 200.ms,
                curve: Curves.easeInOut,
              )
              .fadeIn(duration: 120.ms)
              .move(
                begin: const Offset(0, 16),
                end: const Offset(0, -36),
                duration: 620.ms,
                curve: Curves.easeOut,
              )
              .fadeOut(duration: 180.ms, delay: 420.ms),
        );
      },
    );
  }

  /// 抖动的警告提示。
  static void showWarning(String message) {
    const String tag = 'toast-warning';
    SmartDialog.dismiss(tag: tag);

    SmartDialog.show(
      tag: tag,
      alignment: Alignment.topCenter,
      usePenetrate: true,
      maskColor: Colors.transparent,
      builder: (BuildContext context) {
        final double topPadding = MediaQuery.of(context).size.height * 0.2;
        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Animate(
            onComplete: (_) => SmartDialog.dismiss(tag: tag),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B30),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33FF3B30),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .shake(
                hz: 4,
                offset: const Offset(10, 0),
                duration: 520.ms,
                curve: Curves.easeOut,
              )
              .then(delay: 1400.ms)
              .fadeOut(duration: 260.ms),
        );
      },
    );
  }
}
