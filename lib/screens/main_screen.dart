import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_councel/services/auth_service.dart';
import 'package:movie_councel/services/personalize_service.dart';
import 'package:movie_councel/widgets/movie_card.dart';
import 'package:movie_councel/widgets/movie_list.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../services/movie_data.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future? mostPopularMoviesFuture;
  Future? recommendationMoviesFuture;

  String? currentUser;

  @override
  void initState() {
    MovieData _movieData = Provider.of<MovieData>(
      context,
      listen: false,
    );

    PersonalizeService _personalizeService =
        Provider.of<PersonalizeService>(context, listen: false);

    AuthService _authService = Provider.of<AuthService>(
      context,
      listen: false,
    );

    currentUser = _authService.userName;
    super.initState();

    mostPopularMoviesFuture = _movieData.fetchMostPopularMovies();
    recommendationMoviesFuture =
        _personalizeService.getMovieRecomendations(currentUser!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MovieListWidget(
            userId: currentUser,
            title: "Most Popular",
            showRating: true,
            future: mostPopularMoviesFuture,
          ),
          const SizedBox(
            height: 2,
          ),
          MovieListWidget(
            userId: currentUser,
            title: "Recomendation",
            showRating: false,
            future: recommendationMoviesFuture,
          ),
        ],
      ),
    );
  }
}
