import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yolo_movies_app/models/movie_info.dart';
import 'package:yolo_movies_app/services/size_config.dart';
import 'package:yolo_movies_app/view_modules/movie_details/movie_details.dart';
import 'package:yolo_movies_app/view_modules/movies_list/bloc/bloc.dart';
import 'package:yolo_movies_app/widgets/network_image.dart';
import 'package:yolo_movies_app/widgets/placeholders/placeholders.dart';
import 'package:yolo_movies_app/widgets/placeholders/shimmer_widget.dart';
import 'package:yolo_movies_app/widgets/retry_widget.dart';

// Paginated horizontal list of provided movies with lazy loading.
// Opens a bottom sheet of MovieDetailsView on tapping a movie.
// It is used in CollapsibleItemView widget.
// It fetches the next page of movies when the user scrolls to the end of the list.
// It shows a snackbar when there are no more movies to load.
// It shows a shimmer placeholder when the next page is being fetched.
// It shows a placeholder when there are no movies to show.
class PaginatedListWidget extends StatelessWidget {
  const PaginatedListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 5,
      padding: EdgeInsets.only(left: 12.withWidthFactor),
      child: BlocBuilder<MoviesListBloc, MoviesListState>(
        builder: (_, state) {
          if (state is ErrorMoviesListState) {
            return RetryWidget(
              errorMessage: state.errorMessage,
              onRetry: () => context
                  .read<MoviesListBloc>()
                  .add(const FetchMoviesListEvent()),
            );
          }

          if (state is LoadedMoviesListState) {
            if ((state.errorMessage ?? "").isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                    state.errorMessage!,
                    maxLines: 3,
                  )),
                );
              });
            }

            if (state.movies.isEmpty) {
              return const Center(child: Text("No Movies Availabe"));
            }

            return _WidgetBuilder(
              movies: state.movies,
              isLastPage: state.hasReachedMax,
            );
          }

          return ShimmerWidget(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 16 / 9,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, __) => const ListItemPlaceholder(),
            ),
          );
        },
      ),
    );
  }
}

class _WidgetBuilder extends StatefulWidget {
  final List<MovieOverview> movies;
  final bool isLastPage;
  const _WidgetBuilder({required this.movies, required this.isLastPage});

  @override
  State<_WidgetBuilder> createState() => _WidgetBuilderState();
}

class _WidgetBuilderState extends State<_WidgetBuilder> {
  final scrollController = ScrollController();
  late final MoviesListBloc moviesListBloc;

  @override
  void initState() {
    scrollController.addListener(() => onNextPage());
    moviesListBloc = context.read<MoviesListBloc>();
    super.initState();
  }

  void onNextPage() {
    final state = moviesListBloc.state;
    if (state is LoadedMoviesListState) {
      if (state.isLoadingNextPage) return;

      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        if (state.hasReachedMax) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No more movies')),
          );
        } else {
          moviesListBloc.add(const FetchMoviesListEvent());
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 12,
      ),
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.movies.length + (widget.isLastPage ? 0 : 1),
      itemBuilder: (_, int index) {
        if (index == widget.movies.length) {
          return const ShimmerWidget(child: ListItemPlaceholder());
        }

        return InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (_) => MovieDetailsView(movieId: widget.movies[index].id),
          ),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: NetworkImageWidget(
                  borderRadius: 8,
                  url: widget.movies[index].posterPath,
                ),
              ),
              SizedBox(height: 8.withHeightFactor),
              Flexible(
                flex: 1,
                child: Text(
                  widget.movies[index].title,
                  style: Theme.of(context).textTheme.displaySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
