part of 'bloc.dart';

class MoviesListBloc extends Bloc<MoviesListEvents, MoviesListState> {
  final MovieType movieType;
  final MovieBannerProvider bannerUrlCubit;
  final expansionTileController = ExpansionTileController();

  List<MovieOverview> _moviesList = [];
  int _page = 1;
  Timer? _pollingTimer;

  bool get shouldStartPolling =>
      movieType == MovieType.latest &&
      expansionTileController.isExpanded &&
      !(_pollingTimer?.isActive ?? false);

  List<String> _bannerUrls(List<MovieOverview> movies) => movies
      .where((e) => e.backdropPath != null)
      .map((e) => e.backdropPath!)
      .toList();

  MoviesListBloc({
    required this.movieType,
    required this.bannerUrlCubit,
    bool shouldLoadInitialData = false,
  }) : super(const IdleMoviesListState()) {
    if (shouldLoadInitialData) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => expansionTileController.expand(),
      );
    }

    on<FetchMoviesListEvent>(_fetchMovies);
    on<FetchNewUpdatesEvent>(_fetchNewUpdates);
  }

  final Map<MovieType, String> _movieTypeUrlPaths = {
    MovieType.latest: "now_playing",
    MovieType.popular: "popular",
    MovieType.topRated: "top_rated",
    MovieType.upcoming: "upcoming",
  };

  Future<void> _fetchMovies(
    FetchMoviesListEvent event,
    Emitter<MoviesListState> emit,
  ) async {
    try {
      if (_moviesList.isEmpty) {
        _page = 1;
        emit(const LoadingMoviesListState());
      } else {
        emit(LoadedMoviesListState(
          movies: _moviesList,
          isLoadingNextPage: true,
        ));
      }

      final ApiResponse result = await ApiService()
          .get(urlPath: "/${_movieTypeUrlPaths[movieType]}?page=$_page");

      if (result is SuccessResponse) {
        var results = result.data['results'];
        if (results is! List) throw "Invalid data";

        List<MovieOverview> movies = [];
        for (var e in results) {
          movies.add(MovieOverview.fromJson(e));
        }

        if (movies.isEmpty) {
          emit(LoadedMoviesListState(movies: _moviesList, hasReachedMax: true));
          return;
        }

        // Update banner urls list to show random banner image.
        bannerUrlCubit.updateBannerUrlsList(_bannerUrls(movies));

        _page++;
        _moviesList = [..._moviesList, ...movies];

        emit(LoadedMoviesListState(movies: _moviesList));

        if (shouldStartPolling) startPolling();
      } else if (result is ErrorResponse) {
        if (_moviesList.isNotEmpty) {
          emit(LoadedMoviesListState(
            movies: _moviesList,
            errorMessage: "Could not fetch Next Page",
          ));
          return;
        }
        throw result.errorMessage;
      }
    } catch (e) {
      emit(ErrorMoviesListState(
        errorMessage: e is String ? e.toString() : 'Something went wrong',
      ));
    }
  }

  // Start polling for new updates every 30 seconds in case of latest movies only.
  // This method is not linked to any bloc_event as it deoesn't change the state directly.
  void startPolling() async {
    if (movieType != MovieType.latest) return;
    _pollingTimer?.cancel();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => add(const FetchNewUpdatesEvent()),
    );
  }

  // This method is not linked to any bloc_event as it deoesn't change the state directly.
  void stopPolling() => _pollingTimer?.cancel();

  Future<void> _fetchNewUpdates(
    FetchNewUpdatesEvent event,
    Emitter<MoviesListState> emit,
  ) async {
    try {
      final hasUpdate = await _fetchListByPage(1);
      if (hasUpdate) {
        emit(LoadedMoviesListState(movies: _moviesList));
      }
    } catch (e) {
      emit(LoadedMoviesListState(
        movies: _moviesList,
        errorMessage: "Could not fetch new updates : $e",
      ));
    }
  }

  // Fetch latest movies by page number.
  // uses recursion to fetch all pages until there is no new update available.
  Future<bool> _fetchListByPage(int p) async {
    if (!expansionTileController.isExpanded) {
      // If expansion tile is collapsed, then stop polling.
      _pollingTimer?.cancel();
      // If this is the first iteration of this request then return false. Otherwise, return true to respect the previous iterations.
      return p != 1;
    }

    final ApiResponse result = await ApiService()
        .get(urlPath: "/${_movieTypeUrlPaths[movieType]}?page=$p");

    if (result is SuccessResponse) {
      var results = result.data['results'];
      if (results is! List) throw "Invalid data";

      List<MovieOverview> movies = [];
      for (var e in results) {
        if (_moviesList.any((element) => element.id == e['id'])) continue;
        movies.add(MovieOverview.fromJson(e));
      }

      // If there is no new update on given page, return false and wait for next polling ticker.
      if (movies.isEmpty) return false;

      // Update banner urls list to show random banner image.
      bannerUrlCubit.updateBannerUrlsList(_bannerUrls(movies));

      // Update the list with new updates.
      _moviesList = [...movies, ..._moviesList];

      // If all movies are new on given page, then fetch next page for more updates
      if (_moviesList.length == 20) {
        return _fetchListByPage(p + 1);
      }

      return true;
    } else {
      throw "";
    }
  }
}
