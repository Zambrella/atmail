import 'package:atmail/theme/page_transitions.dart';
import 'package:atmail/theme/theme_extensions.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorTokens {
  ColorTokens._();
}

class AppTheme {
  AppTheme._();

  static final ThemeData _lightFlexThemeData = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFFF05E3E),
      primaryContainer: Color(0xFFD0E4FF),
      secondary: Color(0xFFAC3306),
      secondaryContainer: Color(0xFFFFDBCF),
      tertiary: Color(0xFF006875),
      tertiaryContainer: Color(0xFF95F0FF),
      appBarColor: Color(0xFFFFDBCF),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    // Convenience direct styling properties.
    appBarStyle: FlexAppBarStyle.scaffoldBackground,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 8.0,
      inputDecoratorSchemeColor: SchemeColor.surface,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputCursorSchemeColor: SchemeColor.primary,
      fabUseShape: true,
      fabSchemeColor: SchemeColor.primary,
      alignedDropdown: true,
      dialogBackgroundSchemeColor: SchemeColor.surface,
      drawerBackgroundSchemeColor: SchemeColor.primary,
      navigationBarBackgroundSchemeColor: SchemeColor.primary,
      navigationRailUseIndicator: true,
      navigationRailBackgroundSchemeColor: SchemeColor.primary,
    ),
    // ColorScheme seed generation configuration for light mode.
    keyColors: const FlexKeyColors(
      keepPrimary: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static final ThemeData _darkFlexThemeData = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF9FC9FF),
      primaryContainer: Color(0xFF00325B),
      primaryLightRef: Color(0xFFF05E3E), // The color of light mode primary
      secondary: Color(0xFFFFB59D),
      secondaryContainer: Color(0xFF872100),
      secondaryLightRef: Color(0xFFAC3306), // The color of light mode secondary
      tertiary: Color(0xFF86D2E1),
      tertiaryContainer: Color(0xFF004E59),
      tertiaryLightRef: Color(0xFF006875), // The color of light mode tertiary
      appBarColor: Color(0xFFFFDBCF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 8.0,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      fabUseShape: true,
      fabSchemeColor: SchemeColor.primary,
      alignedDropdown: true,
      drawerBackgroundSchemeColor: SchemeColor.primary,
      navigationBarBackgroundSchemeColor: SchemeColor.primary,
      navigationRailUseIndicator: true,
      navigationRailBackgroundSchemeColor: SchemeColor.primary,
    ),
    // ColorScheme seed configuration setup for dark mode.
    keyColors: const FlexKeyColors(),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  static final ThemeData lightThemeData = _lightFlexThemeData.copyWith(
    textTheme: _lightFlexThemeData.textTheme.apply(fontFamily: 'Poppins'),
    extensions: <ThemeExtension<dynamic>>[
      const SpacingTheme(),
      const ModalTheme(),
      const DurationTheme(),
      const RadiusTheme(),
      SemanticColorsTheme(
        error: Colors.red.harmonizeWith(_lightFlexThemeData.colorScheme.error),
        warning: Colors.orange.harmonizeWith(_lightFlexThemeData.colorScheme.primary),
        success: Colors.green.harmonizeWith(_lightFlexThemeData.colorScheme.primary),
        info: Colors.blue.harmonizeWith(_lightFlexThemeData.colorScheme.primary),
      ),
    ],
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionBuilder(),
      },
    ),
  );

  static final ThemeData darkThemeData = _darkFlexThemeData.copyWith(
    textTheme: _darkFlexThemeData.textTheme.apply(fontFamily: 'Poppins'),
    extensions: <ThemeExtension<dynamic>>[
      const SpacingTheme(),
      const ModalTheme(),
      const DurationTheme(),
      const RadiusTheme(),
      SemanticColorsTheme(
        error: Colors.red.harmonizeWith(_darkFlexThemeData.colorScheme.error),
        warning: Colors.orange.harmonizeWith(_darkFlexThemeData.colorScheme.primary),
        success: Colors.green.harmonizeWith(_darkFlexThemeData.colorScheme.primary),
        info: Colors.blue.harmonizeWith(_darkFlexThemeData.colorScheme.primary),
      ),
    ],
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionBuilder(),
      },
    ),
  );
}
