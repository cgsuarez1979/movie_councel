import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_councel/models/movie.dart';
import 'package:movie_councel/widgets/actors_list.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../services/movie_data.dart';
import '../services/personalize_service.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;
  final double rating;
  final String userId;
  final bool showRating;

  const MovieDetails({
    Key? key,
    required this.rating,
    required this.userId,
    required this.showRating,
    required this.movie,
  }) : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool loadinState = false;
  int ratingState = 3;

  @override
  void initState() {
    super.initState();
    ratingState = widget.rating.toInt();
  }

  Future<void> updateRating(BuildContext context, double rating) async {
    setState(() {
      loadinState = true;
    });

    PersonalizeService _personalizeService =
        Provider.of<PersonalizeService>(context, listen: false);
    await _personalizeService.sendMovieRating(
        widget.userId, widget.movie.id.toString(), rating.toInt());

    setState(() {
      loadinState = false;
      ratingState = rating.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? _titlePath = widget.movie.backdropPath;
    final Size size = MediaQuery.of(context).size;
    final String? movieOverview = widget.movie.overview;
    final int? movieId = widget.movie.id;
    final String? movieName = widget.movie.title;
    return Scaffold(
        appBar: PreferredSize(
          child: SafeArea(
            child: AppBar(
              flexibleSpace: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: "http://image.tmdb.org/t/p/w780/$_titlePath",
                fit: BoxFit.cover,
              ),
            ),
          ),
          preferredSize: Size.fromHeight(size.height / 3),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              Text(
                movieName ?? "Name",
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                movieOverview ?? "Overview",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10.0),
              if (widget.showRating)
                loadinState
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RatingBar.builder(
                        initialRating: ratingState.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                            FontAwesomeIcons.star,
                            color: Colors.amber),
                        onRatingUpdate: (ratng) {
                          updateRating(context, ratng);
                        },
                      ),
              const SizedBox(height: 10.0),
              const Text(
                'Cast',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              ChangeNotifierProvider(
                create: (BuildContext context) => MovieData(),
                child: ActorsWidget(movieId: movieId ?? 0),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ));
  }
}
