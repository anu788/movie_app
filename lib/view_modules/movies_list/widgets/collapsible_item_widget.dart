import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo_movies_app/constants/custom_extensions.dart';
import 'package:yolo_movies_app/models/movie_info.dart';
import 'package:yolo_movies_app/services/size_config.dart';
import 'package:yolo_movies_app/view_modules/movies_list/bloc/bloc.dart';
import 'package:yolo_movies_app/view_modules/movies_list/widgets/paginated_list_widget.dart';

// An expandable tile with paginated list of movies as child.
// It is used in MoviesListView.
// It uses MoviesListBloc to load the data.
// It shows Shimmer widget while loading the list of movies.
// It shows Retry option in case of API failure.
class CollapsibleItemWidget extends StatelessWidget {
  final MovieType movieType;
  final bool initiallyExpanded;

  const CollapsibleItemWidget({
    required this.movieType,
    required this.initiallyExpanded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MoviesListBloc(
        movieType: movieType,
        shouldLoadInitialData: initiallyExpanded,
        bannerUrlCubit: context.read<MovieBannerProvider>(),
      ),
      child: Builder(
        builder: (context) {
          final moviesListBloc = context.watch<MoviesListBloc>();

          return Padding(
            padding: EdgeInsets.only(bottom: 4.withHeightFactor),
            child: ExpansionTile(
              title: Text(
                movieType.name.capitalize(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              controller: moviesListBloc.expansionTileController,
              onExpansionChanged: (isExpanded) {
                if (isExpanded && moviesListBloc.state is IdleMoviesListState) {
                  moviesListBloc.add(const FetchMoviesListEvent());
                }

                if (movieType == MovieType.latest) {
                  if (isExpanded) {
                    moviesListBloc.startPolling();
                  } else {
                    moviesListBloc.stopPolling();
                  }
                }
              },
              children: const [PaginatedListWidget()],
            ),
          );
        },
      ),
    );
  }
}
