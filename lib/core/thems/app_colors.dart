import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primaryDarkBlue;
  final Color lightGreyBlue;
  final Color secondaryText;
  final Color disabledBorder;
  final Color pageBackground;
  final Color subtitleText;
  final Color greenSuccess;
  final Color orangeWarning;
  final Color cardBackground;
  final Color defaultText;
  final Color transparent;
  
  // Newly added semantic colors
  final Color redWarning;
  final Color redWarningDark;
  final Color redWarningLight;
  final Color greenDark;
  final Color greenLight;
  final Color orangeDark;
  final Color orangeLight;
  final Color mapBackground;
  final Color barNotHome;
  final Color barEmpty;
  final Color chartAxis;
  final Color mapPolygonFill;
  final Color trailLine;

  const AppColors({
    required this.primaryDarkBlue,
    required this.lightGreyBlue,
    required this.secondaryText,
    required this.disabledBorder,
    required this.pageBackground,
    required this.subtitleText,
    required this.greenSuccess,
    required this.orangeWarning,
    required this.cardBackground,
    required this.defaultText,
    required this.transparent,
    required this.redWarning,
    required this.redWarningDark,
    required this.redWarningLight,
    required this.greenDark,
    required this.greenLight,
    required this.orangeDark,
    required this.orangeLight,
    required this.mapBackground,
    required this.barNotHome,
    required this.barEmpty,
    required this.chartAxis,
    required this.mapPolygonFill,
    required this.trailLine,
  });

  @override
  AppColors copyWith({
    Color? primaryDarkBlue,
    Color? lightGreyBlue,
    Color? secondaryText,
    Color? disabledBorder,
    Color? pageBackground,
    Color? subtitleText,
    Color? greenSuccess,
    Color? orangeWarning,
    Color? cardBackground,
    Color? defaultText,
    Color? transparent,
    Color? redWarning,
    Color? redWarningDark,
    Color? redWarningLight,
    Color? greenDark,
    Color? greenLight,
    Color? orangeDark,
    Color? orangeLight,
    Color? mapBackground,
    Color? barNotHome,
    Color? barEmpty,
    Color? chartAxis,
    Color? mapPolygonFill,
    Color? trailLine,
  }) {
    return AppColors(
      primaryDarkBlue: primaryDarkBlue ?? this.primaryDarkBlue,
      lightGreyBlue: lightGreyBlue ?? this.lightGreyBlue,
      secondaryText: secondaryText ?? this.secondaryText,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      pageBackground: pageBackground ?? this.pageBackground,
      subtitleText: subtitleText ?? this.subtitleText,
      greenSuccess: greenSuccess ?? this.greenSuccess,
      orangeWarning: orangeWarning ?? this.orangeWarning,
      cardBackground: cardBackground ?? this.cardBackground,
      defaultText: defaultText ?? this.defaultText,
      transparent: transparent ?? this.transparent,
      redWarning: redWarning ?? this.redWarning,
      redWarningDark: redWarningDark ?? this.redWarningDark,
      redWarningLight: redWarningLight ?? this.redWarningLight,
      greenDark: greenDark ?? this.greenDark,
      greenLight: greenLight ?? this.greenLight,
      orangeDark: orangeDark ?? this.orangeDark,
      orangeLight: orangeLight ?? this.orangeLight,
      mapBackground: mapBackground ?? this.mapBackground,
      barNotHome: barNotHome ?? this.barNotHome,
      barEmpty: barEmpty ?? this.barEmpty,
      chartAxis: chartAxis ?? this.chartAxis,
      mapPolygonFill: mapPolygonFill ?? this.mapPolygonFill,
      trailLine: trailLine ?? this.trailLine,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryDarkBlue: Color.lerp(primaryDarkBlue, other.primaryDarkBlue, t)!,
      lightGreyBlue: Color.lerp(lightGreyBlue, other.lightGreyBlue, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      disabledBorder: Color.lerp(disabledBorder, other.disabledBorder, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      subtitleText: Color.lerp(subtitleText, other.subtitleText, t)!,
      greenSuccess: Color.lerp(greenSuccess, other.greenSuccess, t)!,
      orangeWarning: Color.lerp(orangeWarning, other.orangeWarning, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      defaultText: Color.lerp(defaultText, other.defaultText, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      redWarning: Color.lerp(redWarning, other.redWarning, t)!,
      redWarningDark: Color.lerp(redWarningDark, other.redWarningDark, t)!,
      redWarningLight: Color.lerp(redWarningLight, other.redWarningLight, t)!,
      greenDark: Color.lerp(greenDark, other.greenDark, t)!,
      greenLight: Color.lerp(greenLight, other.greenLight, t)!,
      orangeDark: Color.lerp(orangeDark, other.orangeDark, t)!,
      orangeLight: Color.lerp(orangeLight, other.orangeLight, t)!,
      mapBackground: Color.lerp(mapBackground, other.mapBackground, t)!,
      barNotHome: Color.lerp(barNotHome, other.barNotHome, t)!,
      barEmpty: Color.lerp(barEmpty, other.barEmpty, t)!,
      chartAxis: Color.lerp(chartAxis, other.chartAxis, t)!,
      mapPolygonFill: Color.lerp(mapPolygonFill, other.mapPolygonFill, t)!,
      trailLine: Color.lerp(trailLine, other.trailLine, t)!,
    );
  }

  static const AppColors light = AppColors(
    primaryDarkBlue: Color(0xFF16233A),
    lightGreyBlue: Color(0xFFEEF1F6),
    secondaryText: Color(0xFF2C4470),
    disabledBorder: Color(0xFFDCE4EF),
    pageBackground: Color(0xFFF7F9FC),
    subtitleText: Color(0xFF8FA2C0),
    greenSuccess: Color(0xFF1E7A54),
    orangeWarning: Color(0xFFF2A93B),
    cardBackground: Colors.white,
    defaultText: Color(0xFF16233A),
    transparent: Colors.transparent,
    redWarning: Color(0xFF9E2A22),
    redWarningDark: Color(0xFFC4362E),
    redWarningLight: Color(0xFFFBEAEA),
    greenDark: Color(0xFF12603F),
    greenLight: Color(0xFFE4F2EC), // or 0xFFF0FDF4
    orangeDark: Color(0xFF8A5A00),
    orangeLight: Color(0xFFFFF4DE), // or 0xFFFFF8E1
    mapBackground: Color(0xFFE8EEF6),
    barNotHome: Color(0xFFDAE0EA),
    barEmpty: Color(0xFFB1C0D6),
    chartAxis: Color(0xFF93A7C6),
    mapPolygonFill: Color(0x142C4470), // 0xFF2C4470 withOpacity(0.08) => 0x14...
    trailLine: Color(0xFF16233A),
  );

  static const AppColors dark = AppColors(
    primaryDarkBlue: Color(0xFF16233A),
    lightGreyBlue: Color(0xFFEEF1F6),
    secondaryText: Color(0xFF2C4470),
    disabledBorder: Color(0xFFDCE4EF),
    pageBackground: Color(0xFFFFFFFF),
    subtitleText: Color(0xFF8FA2C0),
    greenSuccess: Color(0xFF1E7A54),
    orangeWarning: Color(0xFFF2A93B),
    cardBackground: Colors.white,
    defaultText: Color(0xFF16233A),
    transparent: Colors.transparent,
    redWarning: Color(0xFF9E2A22),
    redWarningDark: Color(0xFFC4362E),
    redWarningLight: Color(0xFFFBEAEA),
    greenDark: Color(0xFF12603F),
    greenLight: Color(0xFFE4F2EC),
    orangeDark: Color(0xFF8A5A00),
    orangeLight: Color(0xFFFFF4DE),
    mapBackground: Color(0xFFE8EEF6),
    barNotHome: Color(0xFFDAE0EA),
    barEmpty: Color(0xFFB1C0D6),
    chartAxis: Color(0xFF93A7C6),
    mapPolygonFill: Color(0x142C4470),
    trailLine: Color(0xFF16233A),
  );
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
