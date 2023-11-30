import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref){
  final actorsRepository = ref.watch(actorsRepositoryProvider);

  return ActorsByMovieNotifier(
    getActors: actorsRepository.getActorsByMovie
  );
});

typedef GetActorsCallback = Future<List<Actor>>Function( String movieID );

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  
  final GetActorsCallback getActors;
  
  ActorsByMovieNotifier({
    required this.getActors,
  }) : super({});

  Future<void> loadActor(String movieID) async {
    if (state[movieID] != null) return;

    final List<Actor> actors = await getActors( movieID );
    state = {...state, movieID: actors};
  }
}
