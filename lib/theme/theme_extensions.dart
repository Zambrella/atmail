import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}

extension SpacingThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appSpacing;
  SpacingTheme get appSpacing => extension<SpacingTheme>()!;
}

extension ModalThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appModal;
  ModalTheme get appModal => extension<ModalTheme>()!;
}

extension DurationThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appDurations;
  DurationTheme get appDurations => extension<DurationTheme>()!;
}

extension SemanticColorsThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).semanticColors;
  SemanticColorsTheme get semanticColors => extension<SemanticColorsTheme>()!;
}

extension RadiusThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appRadius;
  RadiusTheme get appRadius => extension<RadiusTheme>()!;
}

class ModalTheme extends ThemeExtension<ModalTheme> {
  const ModalTheme({
    this.maxWidth = 800,
    this.minWidth = 500,
  });

  final double maxWidth;
  final double minWidth;

  @override
  ThemeExtension<ModalTheme> copyWith({
    double? maxWidth,
    double? minWidth,
  }) {
    return ModalTheme(
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
    );
  }

  @override
  ThemeExtension<ModalTheme> lerp(
    covariant ThemeExtension<ModalTheme>? other,
    double t,
  ) {
    if (other is! ModalTheme) {
      return this;
    }
    return ModalTheme(
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t)!,
      minWidth: lerpDouble(minWidth, other.minWidth, t)!,
    );
  }
}

@immutable
class SpacingTheme extends ThemeExtension<SpacingTheme> {
  const SpacingTheme({
    this.verySmall = 4.0,
    this.small = 8.0,
    this.medium = 16.0,
    this.large = 24.0,
    this.veryLarge = 32.0,
  });

  final double verySmall;
  final double small;
  final double medium;
  final double large;
  final double veryLarge;

  @override
  SpacingTheme copyWith({
    double? verySmall,
    double? small,
    double? medium,
    double? large,
    double? veryLarge,
  }) {
    return SpacingTheme(
      verySmall: verySmall ?? this.verySmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      veryLarge: veryLarge ?? this.veryLarge,
    );
  }

  @override
  ThemeExtension<SpacingTheme> lerp(covariant ThemeExtension<SpacingTheme>? other, double t) {
    if (other is! SpacingTheme) {
      return this;
    }
    return SpacingTheme(
      verySmall: lerpDouble(verySmall, other.verySmall, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
      veryLarge: lerpDouble(veryLarge, other.veryLarge, t)!,
    );
  }
}

@immutable
class DurationTheme extends ThemeExtension<DurationTheme> {
  const DurationTheme({
    this.veryQuick = const Duration(milliseconds: 50),
    this.quick = const Duration(milliseconds: 150),
    this.regular = const Duration(milliseconds: 300),
    this.slow = const Duration(milliseconds: 500),
    this.verySlow = const Duration(milliseconds: 1000),
  });

  final Duration veryQuick;
  final Duration quick;
  final Duration regular;
  final Duration slow;
  final Duration verySlow;

  @override
  DurationTheme copyWith({
    Duration? veryQuick,
    Duration? quick,
    Duration? regular,
    Duration? slow,
    Duration? verySlow,
  }) {
    return DurationTheme(
      veryQuick: veryQuick ?? this.veryQuick,
      quick: quick ?? this.quick,
      regular: regular ?? this.regular,
      slow: slow ?? this.slow,
      verySlow: verySlow ?? this.verySlow,
    );
  }

  @override
  ThemeExtension<DurationTheme> lerp(covariant ThemeExtension<DurationTheme>? other, double t) {
    if (other is! DurationTheme) {
      return this;
    }
    return DurationTheme(
      veryQuick: lerpDuration(veryQuick, other.veryQuick, t),
      quick: lerpDuration(quick, other.quick, t),
      regular: lerpDuration(regular, other.regular, t),
      slow: lerpDuration(slow, other.slow, t),
      verySlow: lerpDuration(verySlow, other.verySlow, t),
    );
  }
}

class SemanticColorsTheme extends ThemeExtension<SemanticColorsTheme> {
  const SemanticColorsTheme({
    this.error = Colors.red,
    this.success = Colors.green,
    this.warning = Colors.orange,
    this.info = Colors.blue,
  });

  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  @override
  SemanticColorsTheme copyWith({
    Color? error,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return SemanticColorsTheme(
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<SemanticColorsTheme> lerp(covariant ThemeExtension<SemanticColorsTheme>? other, double t) {
    if (other is! SemanticColorsTheme) {
      return this;
    }
    return SemanticColorsTheme(
      error: Color.lerp(error, other.error, t) ?? error,
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}

class RadiusTheme extends ThemeExtension<RadiusTheme> {
  const RadiusTheme({
    this.small = 4.0,
    this.medium = 8.0,
    this.large = 16.0,
  });

  final double small;
  final double medium;
  final double large;

  @override
  RadiusTheme copyWith({
    double? small,
    double? medium,
    double? large,
  }) {
    return RadiusTheme(
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
    );
  }

  @override
  ThemeExtension<RadiusTheme> lerp(covariant ThemeExtension<RadiusTheme>? other, double t) {
    if (other is! RadiusTheme) {
      return this;
    }
    return RadiusTheme(
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(medium, other.medium, t)!,
      large: lerpDouble(large, other.large, t)!,
    );
  }
}
