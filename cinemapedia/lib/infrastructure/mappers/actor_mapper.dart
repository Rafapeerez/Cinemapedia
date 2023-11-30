import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorMapper {
  static Actor castToEntity( Cast cast) =>
    Actor(
      id: cast.id, 
      name: cast.name, 
      profilePath: cast.profilePath != null 
        ? 'https://image.tmdb.org/t/p/w500/${cast.profilePath}'
        : 'https://www.pngkey.com/png/full/988-9886269_blank-person-facebook-no-profile.png', 
      character: cast.character
    );
}
