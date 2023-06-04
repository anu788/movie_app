enum MovieType { latest, popular, topRated, upcoming }

// Deserializer for movies list api response.
class MovieOverview {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;

  const MovieOverview({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
  });

  factory MovieOverview.fromJson(Map<String, dynamic> json) {
    return MovieOverview(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
    );
  }
}
