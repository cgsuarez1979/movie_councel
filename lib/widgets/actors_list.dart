import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/actor.dart';
import '../services/movie_data.dart';

class ActorsWidget extends StatefulWidget {
  final int movieId;
  const ActorsWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  _ActorsWidgetState createState() => _ActorsWidgetState();
}

class _ActorsWidgetState extends State<ActorsWidget> {
  @override
  Widget build(BuildContext context) {
    MovieData _movieData = Provider.of<MovieData>(
      context,
      listen: false,
    );
    return FutureBuilder(
      future: _movieData.fetchActors(widget.movieId),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final List<Cast> castData = snapshot.data.cast;
          castData.removeWhere((item) => item.profilePath == null);
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: castData.length,
              itemBuilder: (context, index) {
                final String actorImage =
                    castData[index].profilePath ?? "emtpy";
                final String actorName = castData[index].name ?? "name";
                return Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Card(
                    elevation: 5.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loading.gif',
                              image:
                                  'http://image.tmdb.org/t/p/w780/$actorImage'),
                        ),
                        Text(
                          actorName,
                          style: const TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
