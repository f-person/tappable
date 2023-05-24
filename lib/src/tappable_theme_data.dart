import 'package:flutter/widgets.dart';

import 'haptic_feedback.dart';

/// {@template tappable_theme_data}
/// Defines the tap animation behavior of [Tappable].
/// {@endtemplate}
@immutable
class TappableThemeData {
  //// {@macro tappable_theme_data}
  const TappableThemeData({
    required this.tappedScale,
    this.hapticFeedbackType,
    this.overlayColor,
  });

  /// Default properties for [Tappable].
  static const defaults = TappableThemeData(
    tappedScale: 0.96,
    overlayColor: null,
    hapticFeedbackType: HapticFeedbackType.lightImpact,
  );

  /// Scale of the button when being pressed.
  ///
  /// Use `1.0` to disable the animation.
  final double tappedScale;

  /// A color to overlay on top of [Tappable.child] when being pressed.
  final Color? overlayColor;

  /// The type of haptic feedback to trigger when being pressed.
  ///
  /// Use `null` to disable haptic feedback.
  final HapticFeedbackType? hapticFeedbackType;

  // TODO(f-person): Add animation duration (and maybe make the animation explicit)

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TappableThemeData &&
        other.tappedScale == tappedScale &&
        other.overlayColor == overlayColor &&
        other.hapticFeedbackType == hapticFeedbackType;
  }

  @override
  int get hashCode =>
      tappedScale.hashCode ^
      overlayColor.hashCode ^
      hapticFeedbackType.hashCode;
}
