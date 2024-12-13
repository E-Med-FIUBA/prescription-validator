import 'package:flutter/material.dart';
import 'dart:math' as math;

// Utility class to convert HSL to RGB
class HSLColor {
  final double h; // Hue [0-360]
  final double s; // Saturation [0-100]
  final double l; // Lightness [0-100]

  HSLColor(double h, double s, double l)
      : h = h / 360,
        s = s / 100,
        l = l / 100;

  num hueToRgb(num p, num q, num t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1.0 / 6.0) return p + ((q - p) * 6 * t);
    if (t < 1.0 / 2.0) return q;
    if (t < 2.0 / 3.0) return p + ((q - p) * (2.0 / 3.0 - t) * 6);
    return p;
  }

  Color toColor() {
    if (s == 0) {
      return Color.fromRGBO(
          (l * 255).round(), (l * 255).round(), (l * 255).round(), 1);
    } else {
      final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      final p = 2 * l - q;
      final r = hueToRgb(p, q, h + 1.0 / 3.0);
      final g = hueToRgb(p, q, h);
      final b = hueToRgb(p, q, h - 1.0 / 3.0);

      debugPrint('h: $h, s: $s, l: $l');
      debugPrint('r: $r, g: $g, b: $b');
      return Color.fromRGBO(
          (r * 255).round(), (g * 255).round(), (b * 255).round(), 1);
    }
  }
}

// Custom color extension to match shadcn UI theme tokens
class CustomColors extends ThemeExtension<CustomColors> {
  final Color chart1;
  final Color chart2;
  final Color chart3;
  final Color chart4;
  final Color chart5;

  CustomColors({
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
  }) {
    return CustomColors(
      chart1: chart1 ?? this.chart1,
      chart2: chart2 ?? this.chart2,
      chart3: chart3 ?? this.chart3,
      chart4: chart4 ?? this.chart4,
      chart5: chart5 ?? this.chart5,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      chart1: Color.lerp(chart1, other.chart1, t)!,
      chart2: Color.lerp(chart2, other.chart2, t)!,
      chart3: Color.lerp(chart3, other.chart3, t)!,
      chart4: Color.lerp(chart4, other.chart4, t)!,
      chart5: Color.lerp(chart5, other.chart5, t)!,
    );
  }
}

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: HSLColor(0, 0, 100).toColor(),
      onSurface: HSLColor(222.2, 84, 4.9).toColor(),
      primary: HSLColor(221.2, 83.2, 53.3).toColor(),
      onPrimary: HSLColor(210, 40, 98).toColor(),
      secondary: HSLColor(210, 40, 96.1).toColor(),
      onSecondary: HSLColor(222.2, 47.4, 11.2).toColor(),
      error: HSLColor(0, 84.2, 60.2).toColor(),
      onError: HSLColor(210, 40, 98).toColor(),
    ),
    scaffoldBackgroundColor: HSLColor(0, 0, 100).toColor(),
    cardColor: HSLColor(0, 0, 100).toColor(),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        chart1: HSLColor(12, 76, 61).toColor(),
        chart2: HSLColor(173, 58, 39).toColor(),
        chart3: HSLColor(197, 37, 24).toColor(),
        chart4: HSLColor(43, 74, 66).toColor(),
        chart5: HSLColor(27, 87, 67).toColor(),
      ),
    ],
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: HSLColor(214.3, 31.8, 91.4).toColor()),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HSLColor(214.3, 31.8, 91.4).toColor()),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: HSLColor(222.2, 84, 4.9).toColor(),
      onSurface: HSLColor(210, 40, 98).toColor(),
      primary: HSLColor(217.2, 91.2, 59.8).toColor(),
      onPrimary: HSLColor(222.2, 47.4, 11.2).toColor(),
      secondary: HSLColor(217.2, 32.6, 17.5).toColor(),
      onSecondary: HSLColor(210, 40, 98).toColor(),
      error: HSLColor(0, 62.8, 30.6).toColor(),
      onError: HSLColor(210, 40, 98).toColor(),
    ),
    scaffoldBackgroundColor: HSLColor(222.2, 84, 4.9).toColor(),
    cardColor: HSLColor(210, 40, 4.9).toColor(),
    extensions: <ThemeExtension<dynamic>>[
      CustomColors(
        chart1: HSLColor(220, 70, 50).toColor(),
        chart2: HSLColor(160, 60, 45).toColor(),
        chart3: HSLColor(30, 80, 55).toColor(),
        chart4: HSLColor(280, 65, 60).toColor(),
        chart5: HSLColor(340, 75, 55).toColor(),
      ),
    ],
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: HSLColor(217.2, 32.6, 17.5).toColor()),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HSLColor(217.2, 32.6, 17.5).toColor()),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
