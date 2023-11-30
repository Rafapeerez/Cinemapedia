import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref){
  final movieRepository = ref.watch(moviesRepositoryProvider).getMovieById;

  return MovieMapNotifier(
    getMovie: movieRepository
  );
});

typedef GetMovieCallback = Future<Movie>Function( String movieID );

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  
  final GetMovieCallback getMovie;
  
  MovieMapNotifier({
    required this.getMovie,
  }) : super({});

  Future<void> loadMovie(String movieID) async {
    if (state[movieID] != null) return;

    final movie = await getMovie( movieID );
    state = {...state, movieID: movie};
  }
}
