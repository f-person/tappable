import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A [GestureDetector] replacement that animates the scale of [child] when tapped.
class Tappable extends StatefulWidget {
  const Tappable({
    required this.child,
    this.onTap,
    this.onTapUp,
    this.enabled = true,
    this.tappedScale = 0.9,
    this.overlayColor = const Color(0x33FFFFFF),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;

  final GestureTapUpCallback? onTapUp;

  /// When `false`, no animation will be played and [onTap] won't be called.
  final bool enabled;

  /// Scale of the button when being pressed.
  final double tappedScale;

  final Color overlayColor;

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
    final tween = ColorTween(
      begin: Colors.transparent,
      end: widget.overlayColor,
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
          scale: _isTapped ? widget.tappedScale : 1,
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
      unawaited(HapticFeedback.lightImpact());
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
