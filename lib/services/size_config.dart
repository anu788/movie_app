import 'dart:math';
import 'package:flutter/material.dart';

class SizeConfig {
  static const double stdScreenWidth = 360;
  static const double stdScreenHeight = 640;
  static late double textScaleFactor;
  static late double widthFactor;
  static late double heightFactor;
  static late double screenWidth;
  static late double screenHeight;

  static init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    widthFactor = min(screenWidth / stdScreenWidth, 1.2);
    heightFactor = min(screenHeight / stdScreenHeight, 1.2);

    textScaleFactor = min(heightFactor, widthFactor);
  }
}

extension WithSizeConfig on num {
  double get withHeightFactor => this * SizeConfig.heightFactor;
  double get withWidthFactor => this * SizeConfig.widthFactor;
  double get withTextFactor => this * SizeConfig.textScaleFactor;
}
