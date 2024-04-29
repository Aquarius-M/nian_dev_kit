// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';



final GlobalKey rootKey = GlobalKey();

const Size dotSize = Size(50.0, 50.0);

const double margin = 10.0;

const double bottomDistance = margin * 4;

const int kMaxTooltipLines = 10;

const double kScreenEdgeMargin = 10.0;

const double kTooltipPadding = 5.0;

const Color kTooltipBackgroundColor = Color.fromARGB(230, 60, 60, 60);

const Color kHighlightedRenderObjectFillColor = Color.fromARGB(128, 128, 128, 255);

const Color kHighlightedRenderObjectBorderColor = Color.fromARGB(128, 64, 64, 128);

const Color kTipTextColor = Color(0xFFFFFFFF);

final double ratio = bindingAmbiguate(WidgetsBinding.instance)!.window.devicePixelRatio;

final Size windowSize = bindingAmbiguate(WidgetsBinding.instance)!.window.physicalSize / ratio;

final ThemeData devThemeData = ThemeData(
  useMaterial3: false,
  primaryColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0.0,
    foregroundColor: Color(0xff000000),
    iconTheme: IconThemeData(
      color: Color(0xff000000),
    ),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: Color(0xff000000),
    ),
  ),
  canvasColor: Colors.white,
);


T? bindingAmbiguate<T>(T? value) => value;
