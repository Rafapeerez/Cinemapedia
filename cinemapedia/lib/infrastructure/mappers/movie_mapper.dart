import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

/* Take API information and transform it to info to our APP, so that if the API has 
changes, it doesn't affect to our app implementation
 */

class MovieMapper {
  static Movie moviedbToEntity(MovieMovieDB movieDB) => Movie(
    backdropPath: (movieDB.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movieDB.backdropPath}'
      : 'https://ih1.redbubble.net/image.1893341687.8294/poster,504x498,f8f8f8-pad,600x600,f8f8f8.jpg',

    genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
    id: movieDB.id,
    originalLanguage: movieDB.originalLanguage,
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview,
    popularity: movieDB.popularity,
    posterPath: (movieDB.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movieDB.posterPath}'
      : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS_amboXup4y-90QzAhgy8Q_7ZUwTsa-l6Bx11g3dPUz54vtAbwi5SbcFPFVbx6fE8Jig&usqp=CAU',
    releaseDate: movieDB.releaseDate,
    title: movieDB.title,
    video: movieDB.video,
    voteAverage: movieDB.voteAverage,
    voteCount: movieDB.voteCount,
    adult: movieDB.adult
  );

  static Movie movieDetailsToEntity( MovieDetails movieDB) => Movie(
    backdropPath: (movieDB.backdropPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movieDB.backdropPath}'
      : 'https://ih1.redbubble.net/image.1893341687.8294/poster,504x498,f8f8f8-pad,600x600,f8f8f8.jpg',

    genreIds: movieDB.genres.map((e) => e.name).toList(),
    id: movieDB.id,
    originalLanguage: movieDB.originalLanguage,
    originalTitle: movieDB.originalTitle,
    overview: movieDB.overview,
    popularity: movieDB.popularity,
    posterPath: (movieDB.posterPath != '')
      ? 'https://image.tmdb.org/t/p/w500/${movieDB.posterPath}'
      : 'https://ih1.redbubble.net/image.1893341687.8294/poster,504x498,f8f8f8-pad,600x600,f8f8f8.jpg',
    releaseDate: movieDB.releaseDate,
    title: movieDB.title,
    video: movieDB.video,
    voteAverage: movieDB.voteAverage,
    voteCount: movieDB.voteCount,
    adult: movieDB.adult
  );
}



