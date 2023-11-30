import 'package:cinemapedia/presentation/providers/storage/favourite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavouriteView extends ConsumerStatefulWidget {
  const FavouriteView({super.key});

  @override
  FavouriteViewState createState() => FavouriteViewState();
}

class FavouriteViewState extends ConsumerState<FavouriteView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies =
        await ref.read(favouriteMovieProvider.notifier).loadNextPage();
    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favouriteMovies = ref.watch(favouriteMovieProvider).values.toList();

    if (favouriteMovies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Icon(Icons.favorite_outline, size: 60, color: colors.primary),
            Text('Ohh no..!!' , style: TextStyle( fontSize: 20, color: colors.primary)),
            Text('No tienes peliculas favoritas' , style: TextStyle( fontSize: 15, color: colors.primary)),
            const SizedBox( height: 30),

            FilledButton.tonal(
              onPressed:() => context.go('/home/0'), 
              child: const Text('Empieza a buscar'),
            )

          ],
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favouriteMovies,
      )
    );
  }
}
