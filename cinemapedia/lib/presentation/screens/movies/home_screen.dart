import 'dart:math';

import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/views/views.dart';

class HomeScreen extends StatelessWidget {
  
  static const String name = 'home-screen';
  final int pageIndex;
  
  const HomeScreen({
    super.key, 
    required this.pageIndex
  });

  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(), // <----- Categories
    FavouriteView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // <---- Save movies slides status
        index: pageIndex,
        children: viewRoutes
      ), 
      bottomNavigationBar: CustomBottomNavigationBar( currentIndex: pageIndex )
    );
  }
}

