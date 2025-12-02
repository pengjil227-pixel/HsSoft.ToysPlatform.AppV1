import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum _CupertinoButtonStyle {
  /// No background or border, primary foreground color.
  plain,

  /// Translucent background, primary foreground color.
  tinted,

  /// Solid background, contrasting foreground color.
  filled,
}

final Map<CupertinoButtonSize, BorderRadius> _kCupertinoButtonSizeBorderRadius = <CupertinoButtonSize, BorderRadius>{
  CupertinoButtonSize.small: BorderRadius.circular(8.0),
  CupertinoButtonSize.medium: BorderRadius.circular(8.0),
  CupertinoButtonSize.large: BorderRadius.circular(8.0),
};

class PrimartButton extends StatefulWidget {
  /// Creates an iOS-style button.
  const PrimartButton({
    super.key,
    required this.child,
    this.sizeStyle = CupertinoButtonSize.medium,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    @Deprecated(
      'Use minimumSize instead. '
      'This feature was deprecated after v3.28.0-3.0.pre.',
    )
    this.minSize,
    this.minimumSize,
    this.pressedOpacity = 0.6,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.focusColor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.mouseCursor,
    this.onLongPress,
    required this.onPressed,
    this.animationDuration = const Duration(milliseconds: 120),
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        assert(minimumSize == null || minSize == null),
        _style = _CupertinoButtonStyle.plain;

  /// Creates an iOS-style button with a tinted background.
  const PrimartButton.tinted({
    super.key,
    required this.child,
    this.sizeStyle = CupertinoButtonSize.medium,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.tertiarySystemFill,
    @Deprecated(
      'Use minimumSize instead. '
      'This feature was deprecated after v3.28.0-3.0.pre.',
    )
    this.minSize,
    this.minimumSize,
    this.pressedOpacity = 0.6,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.focusColor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.mouseCursor,
    this.onLongPress,
    required this.onPressed,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : assert(minimumSize == null || minSize == null),
        _style = _CupertinoButtonStyle.tinted;

  /// Creates an iOS-style button with a filled background.
  const PrimartButton.filled({
    super.key,
    required this.child,
    this.sizeStyle = CupertinoButtonSize.medium,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.tertiarySystemFill,
    @Deprecated(
      'Use minimumSize instead. '
      'This feature was deprecated after v3.28.0-3.0.pre.',
    )
    this.minSize,
    this.minimumSize,
    this.pressedOpacity = 0.6,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.focusColor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus = false,
    this.mouseCursor,
    this.onLongPress,
    required this.onPressed,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        assert(minimumSize == null || minSize == null),
        _style = _CupertinoButtonStyle.filled;

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color disabledColor;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  @Deprecated(
    'Use minimumSize instead. '
    'This feature was deprecated after v3.28.0-3.0.pre.',
  )
  final double? minSize;
  final Size? minimumSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final CupertinoButtonSize sizeStyle;
  final AlignmentGeometry alignment;
  final Color? focusColor;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final Duration animationDuration;
  final _CupertinoButtonStyle _style;

  bool get enabled => onPressed != null || onLongPress != null;

  static double tapMoveSlop() {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.android || TargetPlatform.fuchsia => kCupertinoButtonTapMoveSlop,
      TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows => 0.0,
    };
  }

  @override
  State<PrimartButton> createState() => _CupertinoButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _CupertinoButtonState extends State<PrimartButton> with SingleTickerProviderStateMixin {
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late bool isFocused;

  static final WidgetStateProperty<MouseCursor> _defaultCursor = WidgetStateProperty.resolveWith<MouseCursor>((Set<WidgetState> states) {
    return !states.contains(WidgetState.disabled) && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer;
  });

  @override
  void initState() {
    super.initState();
    isFocused = false;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _opacityAnimation = _animationController.drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(PrimartButton old) {
    super.didUpdateWidget(old);
    if (old.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;
  bool _tapInProgress = false;

  void _handleTapDown(TapDownDetails event) {
    _tapInProgress = true;
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animationController.value = 1.0; // Jump to end immediately
      _animationController.forward(); // Start the duration timer
    }
  }

  void _handleTapUp(TapUpDetails event) {
    _tapInProgress = false;
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animationController.reverse(); // Return to normal state
    }
    final RenderBox renderObject = context.findRenderObject()! as RenderBox;
    final Offset localPosition = renderObject.globalToLocal(event.globalPosition);
    if (renderObject.paintBounds.inflate(PrimartButton.tapMoveSlop()).contains(localPosition)) {
      _handleTap();
    }
  }

  void _handleTapCancel() {
    _tapInProgress = false;
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animationController.reverse(); // Return to normal state
    }
  }

  void _handleTapMove(TapMoveDetails event) {
    final RenderBox renderObject = context.findRenderObject()! as RenderBox;
    final Offset localPosition = renderObject.globalToLocal(event.globalPosition);
    final bool buttonShouldHeldDown = renderObject.paintBounds.inflate(PrimartButton.tapMoveSlop()).contains(localPosition);
    if (_tapInProgress && buttonShouldHeldDown != _buttonHeldDown) {
      _buttonHeldDown = buttonShouldHeldDown;
      if (_buttonHeldDown) {
        _animationController.value = 1.0; // Jump to end immediately
        _animationController.forward(); // Start the duration timer
      } else {
        _animationController.reverse(); // Return to normal state
      }
    }
  }

  void _handleTap([Intent? _]) {
    if (widget.onPressed != null) {
      widget.onPressed!();
      context.findRenderObject()!.sendSemanticsEvent(const TapSemanticEvent());
    }
  }

  void _onShowFocusHighlight(bool showHighlight) {
    setState(() {
      isFocused = showHighlight;
    });
  }

  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _handleTap),
  };

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final Size? minimumSize = widget.minimumSize == null
        ? widget.minSize == null
            ? null
            : Size(widget.minSize!, widget.minSize!)
        : widget.minimumSize!;
    final ThemeData themeData = Theme.of(context);
    final Color primaryColor = themeData.primaryColor;
    final Color? backgroundColor = (widget.color == null
            ? widget._style != _CupertinoButtonStyle.plain
                ? primaryColor
                : null
            : CupertinoDynamicColor.maybeResolve(widget.color, context))
        ?.withOpacity(
      widget._style == _CupertinoButtonStyle.tinted
          ? CupertinoTheme.brightnessOf(context) == Brightness.light
              ? kCupertinoButtonTintedOpacityLight
              : kCupertinoButtonTintedOpacityDark
          : widget.color?.opacity ?? 1.0,
    );
    final Color foregroundColor = widget._style == _CupertinoButtonStyle.filled
        ? themeData.colorScheme.primary
        : enabled
            ? primaryColor
            : CupertinoDynamicColor.resolve(CupertinoColors.tertiaryLabel, context);

    final Color effectiveFocusOutlineColor = widget.focusColor ??
        HSLColor.fromColor(
          (backgroundColor ?? CupertinoColors.activeBlue).withOpacity(
            kCupertinoFocusColorOpacity,
          ),
        ).withLightness(kCupertinoFocusColorBrightness).withSaturation(kCupertinoFocusColorSaturation).toColor();

    final TextStyle textStyle = ((widget.sizeStyle == CupertinoButtonSize.small ? themeData.textTheme.titleSmall : themeData.textTheme.titleMedium)) ?? TextStyle().copyWith(color: foregroundColor);
    final IconThemeData iconTheme = IconTheme.of(context).copyWith(
      color: foregroundColor,
      size: textStyle.fontSize != null ? textStyle.fontSize! * 1.2 : kCupertinoButtonDefaultIconSize,
    );

    final DeviceGestureSettings? gestureSettings = MediaQuery.maybeGestureSettingsOf(context);

    final Set<WidgetState> states = <WidgetState>{if (!enabled) WidgetState.disabled};
    final MouseCursor effectiveMouseCursor = WidgetStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ?? _defaultCursor.resolve(states);

    return MouseRegion(
      cursor: effectiveMouseCursor,
      child: FocusableActionDetector(
        actions: _actionMap,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: widget.onFocusChange,
        onShowFocusHighlight: _onShowFocusHighlight,
        enabled: enabled,
        child: RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(postAcceptSlopTolerance: null),
              (TapGestureRecognizer instance) {
                instance.onTapDown = enabled ? _handleTapDown : null;
                instance.onTapUp = enabled ? _handleTapUp : null;
                instance.onTapCancel = enabled ? _handleTapCancel : null;
                instance.onTapMove = enabled ? _handleTapMove : null;
                instance.gestureSettings = gestureSettings;
              },
            ),
            if (widget.onLongPress != null)
              LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
                () => LongPressGestureRecognizer(),
                (LongPressGestureRecognizer instance) {
                  instance.onLongPress = widget.onLongPress;
                  instance.gestureSettings = gestureSettings;
                },
              ),
          },
          child: Semantics(
            button: true,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minimumSize?.width ?? kCupertinoButtonMinSize[widget.sizeStyle] ?? kMinInteractiveDimensionCupertino,
                minHeight: minimumSize?.height ?? kCupertinoButtonMinSize[widget.sizeStyle] ?? kMinInteractiveDimensionCupertino,
              ),
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: enabled && isFocused
                        ? Border.fromBorderSide(
                            BorderSide(
                              color: effectiveFocusOutlineColor,
                              width: 3.5,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          )
                        : null,
                    borderRadius: widget.borderRadius ?? _kCupertinoButtonSizeBorderRadius[widget.sizeStyle],
                    color: backgroundColor != null && !enabled ? CupertinoDynamicColor.resolve(widget.disabledColor, context) : backgroundColor,
                  ),
                  child: Padding(
                    padding: widget.padding ?? kCupertinoButtonPadding[widget.sizeStyle]!,
                    child: Align(
                      alignment: widget.alignment,
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                      child: DefaultTextStyle(
                        style: textStyle,
                        child: IconTheme(data: iconTheme, child: widget.child),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
