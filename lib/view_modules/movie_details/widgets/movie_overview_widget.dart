import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:yolo_movies_app/models/movie_details.dart';
import 'package:yolo_movies_app/services/size_config.dart';
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
        SizedBox(width: 12.withWidthFactor),
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
                  maxLines: 2,
                ),
                SizedBox(height: 12.withHeightFactor),
              },
              Text(
                movieDetails.title,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
              ),
              SizedBox(height: 4.withHeightFactor),
              if ((movieDetails.tagline ?? "").isNotEmpty) ...{
                Text(
                  movieDetails.tagline!,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 4.withHeightFactor),
              },
              ExpandableText(
                movieDetails.overview,
                expandText: 'show more',
                collapseText: 'show less',
                maxLines: 5,
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
