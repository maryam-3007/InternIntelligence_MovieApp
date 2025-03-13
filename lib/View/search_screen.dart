import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/movie_controller.dart';
import 'package:movie_app/View/movie_detailscreen.dart';

class SearchScreen extends StatelessWidget {
  final MovieController movieController = Get.find();
  final TextEditingController searchController = TextEditingController();

  void _searchMovies(String query) {
    if (query.isNotEmpty) {
      movieController.searchMovies(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search Movies...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _searchMovies,
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        var searchResults = movieController.searchResults;

        if (searchResults.isEmpty) {
          return Center(
            child: Text(
              "Search for a movie...",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            var movie = searchResults[index];

            return ListTile(
              leading: Image.network(
                "https://image.tmdb.org/t/p/w92${movie['poster_path']}",
                fit: BoxFit.cover,
                width: 50,
                height: 75,
              ),
              title: Text(movie['title'], style: TextStyle(color: Colors.white)),
              subtitle: Text("Rating: ${movie['vote_average']}", style: TextStyle(color: Colors.white70)),
              onTap: () {
                Get.to(() => MovieDetailscreen(movie: movie));
              },
            );
          },
        );
      }),
    );
  }
}