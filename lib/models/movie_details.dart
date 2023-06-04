import 'package:intl/intl.dart';
import 'package:yolo_movies_app/constants/custom_extensions.dart';

// Deserializers for movies details api response.
class MovieDetails {
  late final int id;
  late final bool adult;
  late final String? backdropPath;
  late final List<Genres> genres;
  late final String? originalLanguage;
  late final String overview;
  late final String? posterPath;
  late final String? releaseDate;
  late final int? runtime;
  late final String? status;
  late final String? tagline;
  late final String title;
  late final String originalTitle;
  late final bool video;
  late final double? voteAverage;
  late final int? voteCount;

  MovieDetails({
    required this.id,
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.title,
    required this.originalTitle,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  DateTime? get _releaseDateLocal =>
      releaseDate != null ? DateTime.parse(releaseDate!).toLocal() : null;

  String? get releaseDateFormatted => releaseDate != null
      ? DateFormat('dd MMM, yyyy').format(_releaseDateLocal!)
      : releaseDate;

  String? get releaseText {
    if (releaseDate == null) return null;

    final DateTime today = DateTime.now();
    final DateTime date = _releaseDateLocal!;

    if (date.isBefore(today)) {
      return 'Released on $releaseDateFormatted';
    } else if (date.isAfter(today)) {
      return 'Releasing on $releaseDateFormatted';
    } else {
      return 'Released Today';
    }
  }

  String? get voteRating => voteAverage == null
      ? null
      : "${voteAverage?.toStringAsFixed(2)} \u2605 ($voteCount)";

  List<String?> get extraDetails => [
        releaseText,
        adult ? "+18 Rated" : "G Rated",
        originalLanguage,
        runtime?.minuteToHours(),
        ...genres.map((e) => e.name).toList()
      ];

  MovieDetails.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    adult = json['adult'] ?? false;
    backdropPath = json['backdrop_path'];
    genres = [];
    if (json['genres'] != null) {
      json['genres'].forEach((v) {
        genres.add(Genres.fromJson(v));
      });
    }
    originalLanguage = json['original_language'];
    overview = json['overview'] ?? "";
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    runtime = json['runtime'];
    status = json['status'];
    tagline = json['tagline'];
    title = json['title'];
    originalTitle = json['original_title'] ?? "";
    video = json['video'] ?? false;
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}

class Genres {
  late final int id;
  late final String name;

  Genres({required this.id, required this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
