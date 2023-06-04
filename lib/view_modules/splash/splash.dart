import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yolo_movies_app/constants/app_constants.dart';
import 'package:yolo_movies_app/constants/image_constants.dart';
import 'package:yolo_movies_app/routes/route_names.dart';
import 'package:yolo_movies_app/services/size_config.dart';

// A splash screen to display the logo of the app. Generally used to preload user information
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Completer completer = Completer();
  String? errorMessage =
      AppConstants.isAuthTokenMissing ? AppConstants.missingTokenError : null;

  @override
  void initState() {
    super.initState();
    if (errorMessage == null) {
      Timer(const Duration(milliseconds: 1000), () => completer.complete());
      loadData();
    }
  }

  loadData() async {
    ////
    //// Load User Information
    ////
    if (!completer.isCompleted) {
      await completer.future;
    }
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteNames.moviesList,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth / 6,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImagePathConstants.logo,
                fit: BoxFit.fitWidth,
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
