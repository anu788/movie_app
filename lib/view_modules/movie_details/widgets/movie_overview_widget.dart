import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:yolo_movies_app/models/movie_details.dart';
import 'package:yolo_movies_app/widgets/network_image.dart';

// Widget to display movie poster, title, tagline and overview_text information.
class MovieOverviewWidget extends StatelessWidget {
  final MovieDetails movieDetails;
  const MovieOverviewWidget({required this.movieDetails, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: NetworkImageWidget(
              url: movieDetails.posterPath,
              borderRadius: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (movieDetails.originalTitle.isNotEmpty &&
                  movieDetails.originalTitle != movieDetails.title) ...{
                Text(
                  movieDetails.originalTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
              },
              Text(
                movieDetails.title,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              if ((movieDetails.tagline ?? "").isNotEmpty) ...{
                Text(
                  movieDetails.tagline!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
              },
              ExpandableText(
                movieDetails.overview,
                expandText: 'show more',
                collapseText: 'show less',
                maxLines: 6,
                linkStyle: Theme.of(context).textTheme.displayLarge,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
