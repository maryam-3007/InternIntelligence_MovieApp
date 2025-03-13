import 'package:get/get.dart';
import 'package:movie_app/services/firestore_services.dart';
import 'package:movie_app/services/movie_api.dart';

class MovieController extends GetxController {
  var recommendedMovies = <dynamic>[].obs;
  var trendingMovies = <dynamic>[].obs;
  var popularMovies = <dynamic>[].obs;
  var nowPlayingMovies = <dynamic>[].obs;
  var searchResults = <dynamic>[].obs; 

  final MovieService movieService = MovieService();
  final FirestoreService firestoreService = FirestoreService();

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> loadMovies() async {
    await fetchTrendingMovies();
    await fetchPopularMovies();
    await fetchNowPlayingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    try {
      var movies = await movieService.fetchMovies("trending");
      trendingMovies.assignAll(movies);
    } catch (e) {
      print("🔥 Error fetching trending movies: $e");
    }
  }

  Future<void> fetchPopularMovies() async {
    try {
      var movies = await movieService.fetchMovies("popular");
      popularMovies.assignAll(movies);
    } catch (e) {
      print("🔥 Error fetching popular movies: $e");
    }
  }

  Future<void> fetchNowPlayingMovies() async {
    try {
      var movies = await movieService.fetchMovies("now_playing");
      nowPlayingMovies.assignAll(movies);
    } catch (e) {
      print("🔥 Error fetching now playing movies: $e");
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      var results = await movieService.searchMovies(query); // Fetch search results
      searchResults.assignAll(results);
    } catch (e) {
      print("🔥 Error searching movies: $e");
      searchResults.clear();
    }
  }

  Future<List<dynamic>> getRecommendations(Map<String, double> userRatings) async {
    var popularMoviesList = await movieService.fetchMovies("popular");

    if (userRatings.isEmpty) return popularMoviesList;

    double averageRating = userRatings.values.isNotEmpty
        ? userRatings.values.reduce((a, b) => a + b) / userRatings.length
        : 5.0;

    return popularMoviesList.where((movie) {
      return movie['vote_average'] >= averageRating;
    }).toList();
  }
}