import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieID;

  const MovieScreen({super.key, required this.movieID});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieID);
    ref.read(actorsByMovieProvider.notifier).loadActor(widget.movieID);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieID];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: movie),
              childCount: 1, //IMPORTANT TO CHARGE
            ),
          )
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              //Description
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  children: [
                    Text(
                      movie.overview,
                      style: textStyle.bodyLarge,
                    )
                  ],
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: OutlinedButton(
                    child: Text(gender),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),

        //Actores
        _ActorsByMovie(movieID: movie.id.toString()),

        const SizedBox(height: 10)
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieID;

  const _ActorsByMovie({required this.movieID});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieID] == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
    final actors = actorsByMovie[movieID]!;

    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          final actor = actors[index];

          return Container(
            padding: const EdgeInsets.all(8),
            width: 135,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Actor photo
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                //Name
                const SizedBox(height: 5),
                Text(actor.name, maxLines: 2)
              ],
            ),
          );
        },
      ),
    );
  }
}



final isFavouriteProvider = FutureProvider.family.autoDispose((ref, int movieID) { // <-- Family to pass an argument and autosipose to save the state
  
  final localStorageRepository = ref.watch( localStorageRepositoryProvider );
  return localStorageRepository.isMovieFavourite(movieID);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final AsyncValue isFavouriteFuture = ref.watch( isFavouriteProvider(movie.id) );

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: ()  {
            
            ref.read( favouriteMovieProvider.notifier ).toggleFavourite(movie);
            ref.invalidate( isFavouriteProvider(movie.id)); // Invalidate the provider state and return it to the initial state
          }, 
          icon: isFavouriteFuture.when(
            data: (isFavourite) => isFavourite 
              ? const Icon( Icons.favorite_rounded, color: Colors.red )
              : const Icon( Icons.favorite_outline_outlined ), 
            error: (_, __) => throw UnimplementedError(), 
            loading: () => const CircularProgressIndicator(strokeWidth: 2)
          )
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 19),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [

            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              ),
            ),

            //LinearGradient to favourite bottom 
            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft, 
              stops: [0.0, 0.2], 
              colors: [Colors.black54, Colors.transparent]
            ),

            //LinearGradient to Title
            const _CustomGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              stops: [0.8, 1.0], 
              colors: [Colors.transparent, Colors.black54]
            ),

            //LinearGradient to arrow back
            const _CustomGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight, 
              stops: [0.0, 0.3], 
              colors: [Colors.black54, Colors.transparent]
            ),
          ],
        ),
      ),
    );
  }
}


class _CustomGradient extends StatelessWidget {

  final AlignmentGeometry begin, end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient({ 
    required this.begin, 
    required this.end, 
    required this.stops, 
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin,
            end: end,
            stops: stops,
            colors: colors
          )
        )
      ),
    );
  }
}