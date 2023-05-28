import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

double height = Get.height;
double width = Get.width;

const FontWeight bold = FontWeight.bold;

const Color white = Colors.white;
const Color black = Colors.black;

Text text(
  String text, {
  TextStyle? textStyle,
  Color color = black,
  Color? backgroundColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? letterSpacing,
  double? wordSpacing,
  TextBaseline? textBaseline,
  double? height,
  Locale? locale,
  Paint? foreground,
  Paint? background,
  List<Shadow>? shadows,
  List<FontFeature>? fontFeatures,
  TextDecoration? decoration,
  Color? decorationColor,
  TextDecorationStyle? decorationStyle,
  double? decorationThickness,
}) {
  return Text(
    text,
    style: TextStyle(
      background: background,
      backgroundColor: backgroundColor,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontFeatures: fontFeatures,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      foreground: foreground,
      height: height,
      letterSpacing: letterSpacing,
      locale: locale,
      shadows: shadows,
      textBaseline: textBaseline,
      wordSpacing: wordSpacing,
    ),
  );
}

const double kpadding = 20;
BorderRadius kcircular = BorderRadius.circular(20);

String _youtubeUrlRegex =
    r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?([a-zA-Z0-9_-]{11})';
RegExp regex = RegExp(_youtubeUrlRegex);
