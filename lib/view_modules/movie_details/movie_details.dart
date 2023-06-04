import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo_movies_app/models/movie_details.dart';
import 'package:yolo_movies_app/view_modules/movie_details/widgets/movie_overview_widget.dart';
import 'package:yolo_movies_app/widgets/custom_badge.dart';
import 'package:yolo_movies_app/widgets/network_image.dart';
import 'package:yolo_movies_app/widgets/placeholders/placeholders.dart';
import 'package:yolo_movies_app/widgets/placeholders/shimmer_widget.dart';
import 'package:yolo_movies_app/widgets/retry_widget.dart';
import 'bloc/bloc.dart';

class MovieDetailsView extends StatelessWidget {
  final int movieId;
  const MovieDetailsView({required this.movieId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesDetailsBloc(movieId: movieId)
        ..add(const FetchMovieDetailsEvent()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: BlocBuilder<MoviesDetailsBloc, MovieDetailsState>(
          builder: (_, state) {
            if (state is ErrorMovieDetailsState) {
              return RetryWidget(
                onRetry: () => context
                    .read<MoviesDetailsBloc>()
                    .add(const FetchMovieDetailsEvent()),
                errorMessage: state.errorMessage,
              );
            }

            if (state is LoadedMovieDetailsState) {
              // Precache the network image to avoid flickering
              return NetworkImageWidget(
                url: state.movieDetails.backdropPath,
                imageBuilder: (imageProvider) => _WidgetBuilder(
                  movieDetails: state.movieDetails,
                  imageProvider: imageProvider,
                ), // show full widget after network image is loaded
                placeholder: const ShimmerWidget(child: DetailsPlaceholder()),
                onError: (error) => _WidgetBuilder(
                  movieDetails: state.movieDetails,
                ), // show full widget without background image if network image cannot be loaded
              );
            }

            return const ShimmerWidget(child: DetailsPlaceholder());
          },
        ),
      ),
    );
  }
}

class _WidgetBuilder extends StatelessWidget {
  final MovieDetails movieDetails;
  final ImageProvider? imageProvider;

  const _WidgetBuilder({required this.movieDetails, this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Backdrop image with blurred effect
          if (imageProvider != null) ...{
            Positioned.fill(
              child: ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider!,
                      fit: BoxFit.cover,
                    ),
                  )),
                ),
              ),
            ),
          },

          // movie details content to be displayed on foreground
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              color: imageProvider != null
                  ? Theme.of(context).primaryColor.withOpacity(0.6)
                  : Colors.grey.shade500,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // movie Poster, title, tagline and overview
                      MovieOverviewWidget(movieDetails: movieDetails),
                      const SizedBox(height: 12),

                      // movie vote average, release status, runtime, content rating and genres
                      Wrap(
                        runSpacing: 12,
                        spacing: 8,
                        children: [
                          CustomBadge(
                            label: movieDetails.voteRating,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          ...List.from(
                            movieDetails.extraDetails.map(
                              (e) => CustomBadge(label: e),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Play button if movie has a video
                      if (movieDetails.video) ...{
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(movieDetails.title)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.play_circle_sharp),
                                const SizedBox(width: 4),
                                Text(
                                  "Play Trailer",
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ],
                            ),
                          ),
                        )
                      },
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
