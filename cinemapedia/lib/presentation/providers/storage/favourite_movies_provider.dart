import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repository/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteMovieProvider =
    StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

/* 
  {
    1234: Movie,
    2432: Movie,
    3242: Movie
  }
 */
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({
    required this.localStorageRepository,
  }) : super({});

  Future<List<Movie>> loadNextPage() async {
    final movies =
        await localStorageRepository.loadMovies(offset: page * 10, limit: 20);
    page++;

    final tempMoviesMap = <int, Movie>{};
    for (final movie in movies) {
      tempMoviesMap[movie.id] = movie;
    }
    state = {...state, ...tempMoviesMap};

    return movies;
  }

  Future<void> toggleFavourite(Movie movie) async {
    final bool isMovieInFavourites =
        await localStorageRepository.isMovieFavourite(movie.id);
    await localStorageRepository.toggleFavourite(movie);

    if (isMovieInFavourites) {
      state.remove(movie.id);
    } else {
      state[movie.id] = movie;
    }
    state = {...state};
  }
}
