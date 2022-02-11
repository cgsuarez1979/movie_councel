import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_councel/screens/movie_detail.dart';
import 'package:movie_councel/services/personalize_service.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final double offset;
  final String userId;
  final bool showRating;

  const MovieCard(
      {Key? key,
      required this.userId,
      required this.movie,
      required this.showRating,
      required this.offset})
      : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool loadinState = false;
  double movieRating = 3;

  Future<void> updateRating(BuildContext context, int rating) async {
    setState(() {
      loadinState = true;
    });

    PersonalizeService _personalizeService =
        Provider.of<PersonalizeService>(context, listen: false);
    await _personalizeService.sendMovieRating(
        widget.userId, widget.movie.id.toString(), rating);

    setState(() {
      loadinState = false;
      movieRating = rating.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((widget.offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * widget.offset.sign, 0),
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 24,
        ),
        elevation: 8,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return MovieDetails(
                    showRating: widget.showRating,
                    movie: widget.movie,
                    userId: widget.userId,
                    rating: movieRating,
                  );
                },
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Image(
                    image: CachedNetworkImageProvider(
                        "https://image.tmdb.org/t/p/w500/${this.widget.movie.posterPath}"),
                    height: MediaQuery.of(context).size.height * 0.3,
                    alignment: Alignment(-widget.offset.abs(), 0),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              MovieSummary(
                movieName: widget.movie.title,
                originalLanguage: widget.movie.originalLanguage,
                offset: gauss,
              ),
              if (widget.showRating)
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: loadinState
                        ? const Center(child: CircularProgressIndicator())
                        : RatingBar.builder(
                            initialRating: movieRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                                FontAwesomeIcons.star,
                                color: Colors.amber),
                            onRatingUpdate: (rating) {
                              updateRating(context, rating.toInt());
                            },
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSummary extends StatelessWidget {
  final String? movieName;
  final String? originalLanguage;
  final double offset;

  const MovieSummary(
      {Key? key,
      required this.movieName,
      required this.originalLanguage,
      required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Transform.translate(
              offset: Offset(8 * offset, 0),
              child: Text(
                movieName ?? "Default movie name",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              originalLanguage ?? "English",
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
