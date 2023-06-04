part of 'bloc.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();

  @override
  List<Object?> get props => [];
}

class LoadingMovieDetailsState extends MovieDetailsState {
  const LoadingMovieDetailsState();
}

class LoadedMovieDetailsState extends MovieDetailsState {
  final MovieDetails movieDetails;
  const LoadedMovieDetailsState({required this.movieDetails});

  @override
  List<Object?> get props => [movieDetails];
}

class ErrorMovieDetailsState extends MovieDetailsState {
  final String errorMessage;
  const ErrorMovieDetailsState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
