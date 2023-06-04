import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yolo_movies_app/constants/app_constants.dart';
import 'package:yolo_movies_app/routes/routes.dart';
import 'package:yolo_movies_app/services/size_config.dart';
import 'package:yolo_movies_app/theme/custom_theme.dart';

void main() {
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    // Track Error on something like Sentry or Firebase Crashlytics
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: AppConstants.appName,
      theme: CustomTheme().primary,
      themeMode: ThemeMode.light,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
