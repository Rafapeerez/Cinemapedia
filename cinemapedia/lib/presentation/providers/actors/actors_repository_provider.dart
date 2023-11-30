import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//This repository is inmutable ---> only lecture
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl( ActorMovieDBDatasource() );
});
