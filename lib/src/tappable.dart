import 'dart:async';

import 'package:flutter/material.dart';

import 'tappable_theme.dart';
import 'tappable_theme_data.dart';

/// {@template tappable}
/// A [GestureDetector] replacement that animates the scale of [child] when tapped.
/// {@endtemplate}
class Tappable extends StatefulWidget {
  /// {@macro tappable}
  const Tappable({
    required this.child,
    this.theme,
    this.onTap,
    this.onTapUp,
    this.enabled = true,
    super.key,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  final TappableThemeData? theme;

  final VoidCallback? onTap;

  final GestureTapUpCallback? onTapUp;

  // TODO(f-person): Add more callback from [GestureDetector].

  /// When `false`, no animation will be played and [onTap] won't be called.
  final bool enabled;

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable>
    with SingleTickerProviderStateMixin {
  static const _tapAnimationDuration = Duration(milliseconds: 100);

  late final _controller = AnimationController(
    vsync: this,
    duration: _tapAnimationDuration,
  );

  late TappableThemeData _theme;

  bool _isTapped = false;

  bool get _isEnabled =>
      widget.enabled && (widget.onTap != null || widget.onTapUp != null);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = widget.theme ?? TappableTheme.of(context);

    final tween = ColorTween(
      // TODO(f-person): Test if using `null` for `begin` works fine.
      // begin: Colors.transparent,
      end: _theme.overlayColor,
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _startTapAnimation(),
        onTapUp: _onTapUp,
        onTapCancel: _stopTapAnimation,
        child: AnimatedScale(
          curve: Curves.easeOut,
          scale: _isTapped ? _theme.tappedScale : 1,
          duration: _tapAnimationDuration,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  tween.animate(_controller).value!,
                  BlendMode.srcATop,
                ),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details) {
    if (_isEnabled) {
      widget.onTapUp?.call(details);
      widget.onTap?.call();

      unawaited(_theme.hapticFeedbackType?.generate());
    }

    _stopTapAnimation();
  }

  void _stopTapAnimation() {
    _controller.reverse();
    setState(() => _isTapped = false);
  }

  void _startTapAnimation() {
    if (_isEnabled) {
      _controller.forward();
      setState(() => _isTapped = true);
    }
  }
}
