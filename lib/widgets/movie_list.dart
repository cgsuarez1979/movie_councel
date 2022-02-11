import 'package:flutter/material.dart';
import 'package:movie_councel/models/movie.dart';
import 'package:movie_councel/services/movie_data.dart';
import 'package:movie_councel/services/personalize_service.dart';
import 'package:provider/provider.dart';

import 'movie_card.dart';

class MovieListWidget extends StatefulWidget {
  final Future? future;
  final String? title;
  final String? userId;
  final bool showRating;

  const MovieListWidget({
    Key? key,
    this.userId,
    this.title,
    this.future,
    required this.showRating,
  }) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  PageController? pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController?.addListener(() {
      setState(() => pageOffset = pageController?.page ?? 0);
    });
    //_future = _personalizeService.getMovieRecomendations(widget.userName!);
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: widget.future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Movie> movies = snapshot.data as List<Movie>;
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: PageView(
                  controller: pageController,
                  children: movies
                      .asMap()
                      .keys
                      .toList()
                      .map((index) => MovieCard(
                            userId: widget.userId!,
                            movie: movies[index],
                            showRating: widget.showRating,
                            offset: pageOffset - index,
                          ))
                      .toList(),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
