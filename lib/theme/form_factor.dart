import 'package:flutter/material.dart';

/// The size of the device running the app
enum FormFactor {
  /// Small devices such as mobile phones
  mobile(480),

  /// Medium sized devices such as tablets
  tablet(768),

  /// Large sized devices such as laptops and large tablets in landscape
  laptop(1024),

  /// Biggest sized devices such as desktops
  desktop(1440);

  const FormFactor(this.breakpoint);

  final double breakpoint;
}

extension FormFactorExtension on FormFactor {
  bool get isLarge => this == FormFactor.laptop || this == FormFactor.desktop;
}

class FormFactorWidget extends InheritedWidget {
  const FormFactorWidget({
    required this.formFactor,
    required super.child,
    super.key,
  });

  final FormFactor formFactor;

  static FormFactor? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FormFactorWidget>()
        ?.formFactor;
  }

  static FormFactor of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No Form Factor found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FormFactorWidget oldWidget) =>
      formFactor != oldWidget.formFactor;
}
