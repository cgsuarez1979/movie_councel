import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_councel/exceptions/custom_exception.dart';
import 'package:movie_councel/models/movie.dart';

import '../models/actor.dart';

class MovieData extends ChangeNotifier {
  Future<Movie> fetchMovie(String movieId) async {
    try {
      final String? tmKey = dotenv.env['TBMOVIE_API_KEY'];
      final response = await http.get(
        Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=$tmKey"),
      );
      if (response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      }
      throw FetchDataException('Error loading themoviedb data');
    } catch (e) {
      print(e);
      throw FetchDataException('Error loading themoviedb data');
    }
  }

  Future<Actor> fetchActors(int movieId) async {
    try {
      final String? tmpKey = dotenv.env['TBMOVIE_API_KEY'];
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/casts?api_key=$tmpKey"));
      if (response.statusCode == 200) {
        return Actor.fromJson(json.decode(response.body));
      }
      throw FetchDataException("Error loading actors");
    } catch (e, stacktrace) {
      print(stacktrace);
      throw FetchDataException("Error loading actors");
    }
  }

  Future<List<Movie>> fetchMostPopularMovies() async {
    try {
      final String? tbmkey = dotenv.env['TBMOVIE_API_KEY'];
      final response = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=$tbmkey",
        ),
      );
      print("fetchMostPopularMovies: ${response.statusCode}");
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body)["results"];
        return List<Movie>.from(
          l.map(
            (model) => Movie.fromJson(model),
          ),
        );
      }

      throw FetchDataException("Error loading themoviedata");
    } catch (e) {
      print(e);
      throw FetchDataException("Error loading themoviedata");
    }
  }
}
