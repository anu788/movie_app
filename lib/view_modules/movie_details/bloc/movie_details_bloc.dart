part of 'bloc.dart';

class MoviesDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final int movieId;

  MoviesDetailsBloc({required this.movieId})
      : super(const LoadingMovieDetailsState()) {
    on<FetchMovieDetailsEvent>(_fetchDetails);
  }

  Future<void> _fetchDetails(
    FetchMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    try {
      emit(const LoadingMovieDetailsState());

      final ApiResponse result = await ApiService().get(urlPath: "/$movieId");

      if (result is SuccessResponse) {
        MovieDetails movieDetails = MovieDetails.fromJson(result.data);

        emit(LoadedMovieDetailsState(movieDetails: movieDetails));
      } else if (result is ErrorResponse) {
        throw result.errorMessage;
      }
    } catch (e) {
      emit(ErrorMovieDetailsState(
        errorMessage: e is String ? e.toString() : 'Something went wrong',
      ));
    }
  }
}
