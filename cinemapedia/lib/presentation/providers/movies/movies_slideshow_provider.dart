import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'movies_providers.dart';

final moviesSlideshowProvider = Provider<List<Movie>>((ref) {
  
  final nowPlayingMoving = ref.watch(nowPlayingMoviesProvider);

  if (nowPlayingMoving.isEmpty) return [];

  return nowPlayingMoving.sublist(0, 6);
});
