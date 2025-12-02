import 'package:flutter/material.dart';

class CmsTheme {
  // 基础颜色定义
  static const Color _lightPrimary = Color(0xFFF30213); // 蓝色800
  static const Color _lightSecondary = Color(0xFF64B5F6); // 蓝色600
  static const Color _lightBackground = Color(0xFFF4F4F4);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFD32F2F);
  static const Color _lightOnSurface = Color(0xFF000000);
  static const Color _lightOnSurfaceVariant = Color(0xFF848484);
  static const Color _lightDivider = Color(0xFFD7D7D7);

  static const Color _darkPrimary = Color(0xFF90CAF9); // 蓝色200
  static const Color _darkSecondary = Color(0xFF64B5F6); // 蓝色400
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkError = Color(0xFFCF6679);
  static const Color _darkOnSurface = Color(0xFFD9D9D9);
  static const Color _darkDivider = Color(0xFF2A2A2A);

  // 自定义扩展颜色
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFFC107);
  static const Color _infoColor = Color(0xFF2196F3);
  static const Color _disabledColor = Color(0xFF111111);

  static ThemeData get lightTheme {
    final baseTheme = ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      brightness: Brightness.light,
      primaryColor: _lightPrimary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: baseTheme.colorScheme.copyWith(
        // 基础亮度（亮色/暗色模式）
        brightness: Brightness.light,

        // 主品牌色 - 微信绿色
        primary: _lightPrimary,
        // 主品牌色上的内容色（通常是白色或黑色）
        onPrimary: Colors.white,
        // 主品牌色的容器色（比主色浅）
        primaryContainer: Color(0xFFE0F7E0),
        // 主品牌色容器上的内容色
        onPrimaryContainer: Color(0xFF07C160),

        // 次要品牌色 - 微信蓝色
        secondary: _lightSecondary,
        // 次要品牌色上的内容色
        onSecondary: Colors.white,
        // 次要品牌色的容器色
        secondaryContainer: Color(0xFFE0F2FF),
        // 次要品牌色容器上的内容色
        onSecondaryContainer: Color(0xFF10AEFF),

        // 第三品牌色 - 微信红色（用于警告/危险操作）
        tertiary: Color(0xFFFA5151),
        // 第三品牌色上的内容色
        onTertiary: Colors.white,
        // 第三品牌色的容器色
        tertiaryContainer: Color(0xFFFFE0E0),
        // 第三品牌色容器上的内容色
        onTertiaryContainer: Color(0xFFFA5151),

        // 错误色（通常为红色系）
        error: _lightError,
        // 错误色上的内容色
        onError: Colors.white,
        // 错误容器色
        errorContainer: Color(0xFFFFE0E0),
        // 错误容器上的内容色
        onErrorContainer: Color(0xFFFA5151),

        // 表面色 - 微信消息气泡白色
        surface: Colors.white,
        // 表面上的内容色
        onSurface: _lightOnSurface,
        // 暗淡表面色
        surfaceDim: Color(0xFFE5E5E5),
        // 明亮表面色
        surfaceBright: Colors.white,

        // 表面容器色（从最低到最高）
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF7F7F7),
        surfaceContainer: Color(0xFFF2F2F2),
        surfaceContainerHigh: Color(0xFFEDEDED),
        surfaceContainerHighest: Color(0xFFE8E8E8),

        // 表面变体色 - 用于卡片等
        onSurfaceVariant: _lightOnSurfaceVariant,

        // 轮廓色 - 用于分割线
        outline: Color(0xFFE6E6E6),
        // 轮廓变体色 - 更淡的分割线
        outlineVariant: Color(0xFFF0F0F0),

        // 阴影色
        shadow: Colors.black,
        // 遮罩色（用于模态框背景等）
        scrim: Color(0x99000000),

        // 反转表面色（用于暗色模式）
        inverseSurface: Color(0xFF121212),
        // 反转表面上的内容色
        onInverseSurface: Colors.white,
        // 反转主品牌色
        inversePrimary: Color(0xFF07C160),

        // 表面色调（用于浮动按钮等）
        surfaceTint: Color(0xFF07C160),

        // 以下为固定颜色（Material 3新增）
        primaryFixed: Color(0xFFE0F7E0),
        primaryFixedDim: Color(0xFFC0EFC0),
        onPrimaryFixed: Color(0xFF07C160),
        onPrimaryFixedVariant: Color(0xFF05A850),

        secondaryFixed: Color(0xFFE0F2FF),
        secondaryFixedDim: Color(0xFFC0E6FF),
        onSecondaryFixed: Color(0xFF10AEFF),
        onSecondaryFixedVariant: Color(0xFF0D8ECC),

        tertiaryFixed: Color(0xFFFFE0E0),
        tertiaryFixedDim: Color(0xFFFFC0C0),
        onTertiaryFixed: Color(0xFFFA5151),
        onTertiaryFixedVariant: Color(0xFFD84343),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 42,
        backgroundColor: _lightBackground,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            width: 0.3,
            color: _lightDivider,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _lightOnSurface,
        ),
        iconTheme: const IconThemeData(size: 18, color: _lightOnSurfaceVariant),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _lightBackground,
      ),
      listTileTheme: ListTileThemeData(
        visualDensity: VisualDensity(vertical: -2),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: _lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          animationDuration: Duration.zero,
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimary,
          side: BorderSide(color: _lightPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _lightSurface,
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, _lightOnSurface),
      dividerTheme: DividerThemeData(
        thickness: 0.2,
        color: _lightDivider,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(Color(0xFFABABAB)),
        thickness: WidgetStateProperty.all(3.5),
        radius: Radius.circular(8.0),
        crossAxisMargin: 2,
      ),
      tabBarTheme: TabBarThemeData(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
      extensions: <ThemeExtension<dynamic>>[
        _buildCustomColors(_lightPrimary, _lightSecondary),
      ],
    );
  }

  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark(useMaterial3: true);

    return baseTheme.copyWith(
      brightness: Brightness.dark,
      primaryColor: _darkPrimary,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _darkPrimary,
        onPrimary: Color(0xFF191919),
        secondary: _darkSecondary,
        surface: _darkSurface,
        error: _darkError,
        onSurface: _darkOnSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 42,
        backgroundColor: _darkBackground,
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            width: 0.3,
            color: _darkDivider,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _darkOnSurface,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkBackground,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.black,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: BorderSide(color: _darkPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
        color: _darkSurface,
      ),
      textTheme: _buildTextTheme(baseTheme.textTheme, _darkOnSurface),
      dividerTheme: DividerThemeData(
        thickness: 0.4,
        color: _darkDivider,
      ),
      extensions: <ThemeExtension<dynamic>>[
        _buildCustomColors(_darkPrimary, _darkSecondary),
      ],
    );
  }

  // 构建自定义文本主题
  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: base.displayMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      displaySmall: base.displaySmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      headlineLarge: base.headlineLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
      headlineMedium: base.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: base.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: base.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
      titleMedium: base.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
      titleSmall: base.titleSmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 15, height: 1.5, color: textColor),
      bodyMedium: base.bodyMedium?.copyWith(fontSize: 15, height: 1.5, color: textColor),
      bodySmall: base.bodySmall?.copyWith(fontSize: 12, height: 1.5, color: textColor),
      labelLarge: base.labelLarge?.copyWith(fontSize: 14, color: textColor),
      labelMedium: base.labelMedium?.copyWith(fontSize: 12, color: textColor),
      labelSmall: base.labelSmall?.copyWith(fontSize: 10, color: textColor),
    );
  }

  // 构建自定义颜色扩展
  static CustomColors _buildCustomColors(Color primary, Color secondary) {
    return CustomColors(
      primary: primary,
      secondary: secondary,
      success: _successColor,
      warning: _warningColor,
      info: _infoColor,
      disabled: _disabledColor,
      // 可以添加更多自定义颜色
    );
  }
}

// 自定义颜色扩展类
class CustomColors extends ThemeExtension<CustomColors> {
  final Color primary;
  final Color secondary;
  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;
  // 可以添加更多自定义颜色属性

  const CustomColors({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? primary,
    Color? secondary,
    Color? success,
    Color? warning,
    Color? info,
    Color? disabled,
  }) {
    return CustomColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(ThemeExtension<CustomColors> other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }
}

// 使用示例：
// 在Widget中获取自定义颜色
// final customColors = Theme.of(context).extension<CustomColors>()!;
// Container(color: customColors.success);
