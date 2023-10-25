import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minggu_05/movies.dart';

class HttpHelper {
  final String _apiKey = "f6f8fc409dd82830067a06388f1da765";
  final String _urlBase = "https://api.themoviedb.org";

  Future<List?> getMovies(String category) async {
    var url = Uri.parse("$_urlBase/3/movie/$category?api_key=$_apiKey");
    http.Response result = await http.get(url);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
