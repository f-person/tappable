import 'package:flutter/material.dart';

import 'tappable_theme_data.dart';

/// {@template tappable_theme}
/// Controls the default properties of [Tappable] widgets in a widget subtree.
/// {@endtemplate}
class TappableTheme extends InheritedWidget {
  /// {@macro tappable_theme}
  const TappableTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The set of properties to use for tappable widgets in this subtree.
  final TappableThemeData data;

  /// The data from the closest instance of this class that encloses the given
  /// context, if any.
  ///
  /// If no such instance exists, returns the [TappableThemeData.defaults].
  static TappableThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TappableTheme>()?.data ??
        TappableThemeData.defaults;
  }

  @override
  bool updateShouldNotify(TappableTheme oldWidget) => data != oldWidget.data;
}
