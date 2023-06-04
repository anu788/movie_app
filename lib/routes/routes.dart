import 'package:flutter/material.dart';
import 'package:yolo_movies_app/routes/route_names.dart';
import 'package:yolo_movies_app/view_modules/movies_list/movies_list_view.dart';
import 'package:yolo_movies_app/view_modules/splash/splash.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case RouteNames.moviesList:
        return MaterialPageRoute(builder: (_) => const MoviesListView());

      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
