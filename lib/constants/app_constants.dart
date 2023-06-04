class AppConstants {
  //TODO: Add your TMDB authentication token here
  static const String authToken = "YOUR_AUTH_TOKEN_HERE";
  static const String missingTokenError =
      "Please add your TMDB authentication token in lib/constants/app_constants.dart file to access the application.";
  static bool get isAuthTokenMissing => authToken == "YOUR_AUTH_TOKEN_HERE";

  static const String appName = "The Movie App";
  static const String baseUrl = "https://api.themoviedb.org/3/movie";
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/original";
}
