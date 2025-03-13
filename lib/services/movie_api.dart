import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String apiKey = "3ac1e61a226df273e868dd0dd0c56dcb";
  static const String baseUrl = "https://api.themoviedb.org/3";

  Future<List<dynamic>> fetchMovies(String category, {int limit = 20}) async {
    List<dynamic> movies = [];
    int page = 1;

    while (movies.length < limit) {
      String url;

      if (category == "trending") {
        url = "$baseUrl/trending/movie/week?api_key=$apiKey&page=$page";
      } else if (category == "popular") {
        url = "$baseUrl/movie/popular?api_key=$apiKey&page=$page";
      } else if (category == "now_playing") {  
        url = "$baseUrl/movie/now_playing?api_key=$apiKey&page=$page";
      } else {
        throw Exception("Invalid movie category: $category");
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        movies.addAll(data["results"]);

        if (data["results"].length < 20) break;
      } else {
        throw Exception("🔥 Failed to load $category movies: ${response.statusCode}");
      }

      page++;
    }

    return movies.take(limit).toList();
  }

  Future<List<dynamic>> searchMovies(String query, {int limit = 20}) async {
    if (query.isEmpty) return [];

    List<dynamic> movies = [];
    int page = 1;

    while (movies.length < limit) {
      String url = "$baseUrl/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}&page=$page";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        movies.addAll(data["results"]);

        if (data["results"].length < 20) break;
      } else {
        throw Exception("🔥 Failed to fetch search results: ${response.statusCode}");
      }

      page++;
    }

    return movies.take(limit).toList();
  }
}