import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

import '../exceptions/custom_exception.dart';
import '../models/movie.dart';

class PersonalizeService extends ChangeNotifier {
  final String lambda_endpoint =
      "https://nntnvz8xr2.execute-api.us-west-2.amazonaws.com/test/personalize-operations";

  Future<void> sendMovieRating(
      String userId, String movieId, int rating) async {
    try {
      final response = await http.post(
        Uri.parse(lambda_endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            "eventType": "register",
            "userId": userId,
            "movieId": movieId,
            "rating": rating
          },
        ),
      );
      print("[sendMovieRating] response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("[sendMovieRating] Success");
        return;
      }
      throw FetchDataException('Error loading themoviedb data');
    } catch (e) {
      print(e);
      throw FetchDataException('Error loading themoviedb data');
    }
  }

  Future<List<Movie>> getMovieRecomendations(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(lambda_endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{"eventType": "get", "userId": userId},
        ),
      );
      print("response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body)['movieIds'] as List<dynamic>;
        List<Movie> movies = [];
        for (var movieId in list) {
          Movie movie = await getMovieFromId(movieId["movieId"]);
          movies.add(movie);
        }
        print("Success: ${movies.length} userId: $userId");
        return movies;
      }
      throw FetchDataException('Error loading themoviedb data');
    } catch (e) {
      print(e);
      throw FetchDataException('Error loading themoviedb data');
    }
  }

  Future<Movie> getMovieFromId(String movieId) async {
    final String? tmKey = dotenv.env['TBMOVIE_API_KEY'];
    final response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=$tmKey"),
    );
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      return Movie();
    }
  }
}
