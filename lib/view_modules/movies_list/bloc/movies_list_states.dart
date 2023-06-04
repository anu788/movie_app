part of 'bloc.dart';

abstract class MoviesListState extends Equatable {
  const MoviesListState();

  @override
  List<Object?> get props => [];
}

class IdleMoviesListState extends MoviesListState {
  const IdleMoviesListState();
}

class LoadingMoviesListState extends MoviesListState {
  const LoadingMoviesListState();
}

class LoadedMoviesListState extends MoviesListState {
  final List<MovieOverview> movies;
  final bool isLoadingNextPage;
  final bool hasReachedMax;
  final String? errorMessage;
  const LoadedMoviesListState({
    required this.movies,
    this.isLoadingNextPage = false,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        movies,
        isLoadingNextPage,
        hasReachedMax,
        errorMessage,
      ];
}

class ErrorMoviesListState extends MoviesListState {
  final String errorMessage;
  const ErrorMoviesListState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
