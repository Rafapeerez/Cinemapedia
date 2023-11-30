import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//This repository is inmutable ---> only lecture
final moviesRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl( MovieDBDatasource() );
});
